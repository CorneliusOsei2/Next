import json
from flask import Flask, request
from flask_cors import CORS
from datetime import date
import json
import users_dao
from datetime import datetime
from Tables import db, Day, Month, Timeslot, User, Course, Timestamp
from gen import month_names, gen_name, gen_netid, gen_course
from utils import response, extract_token

# Initialize Flask and CORS
app = Flask(__name__)
CORS(app)

def init_db():
    '''
    DB init and config
    '''
    db_filename = "next.db"
    app.config["SQLALCHEMY_DATABASE_URI"] = "sqlite:///%s" % db_filename
    app.config["SQLALCHEMY_TRACK_MODIFICATIONS"] = False
    app.config["SQLALCHEMY_ECHO"] = True
    db.init_app(app)
    with app.app_context():
        db.create_all()
    
   
############################################# HELPERS FOR INTITIALIZATION #############################################

def gen_months():
    """
    Helper for auto-generateing months.
    """
    months = month_names()
    i = 1

    for month_name, num_days in months.items():
        month = Month(name=month_name, number = i, num_days = num_days, active= True)
        db.session.add(month)
        db.session.commit()
        i += 1

def gen_days():
    """
    Helper for autogenerating days for the months.
    """
    gen_months()
    months = Month.query.all()

    for month in months:
        for i in range(month.num_days):
            day = Day(number=i+1, month_id=month.id, month_name=month.name, active=True)
            db.session.add(day)
            month.days.append(day)
            db.session.commit()

def gen_users():
    """
    Helper for auto-generating users.
    """
    for i in range(3):
        user = User(name=gen_name(i), username=gen_netid(i), password="123")
        db.session.add(user)
        db.session.commit()

def gen_courses():
    """
    Helper for auto-generating users.
    """
    gen_users()
    users = User.query.all()

    for i in range(3):
        course = Course(code=gen_course(i), name="Programming")
        db.session.add(course)
        db.session.commit()

        for j, user in enumerate(users):
            if j == 1: course.instructors.append(user)
            else: course.students.append(user)

            db.session.add(course)
            db.session.commit()


############################################# DEV-ONLY ENDPOINTS ######################################################

@app.route("/", methods=["GET"])
def fill_database():
    """
    Base endpoint
    """
    return response(res="Bienvenue Mon Ami(e)!", success=True, code=200)
   

@app.route("/dev/next/users/", methods=["GET"])
def get_all_users():
    """
    (DEV ONLY) Endpoint to get all users.
    """
    users = User.query.all()
    return response(res={"users": [user.serialize() for user in users]}, success=True, code=200)


@app.route("/dev/next/courses/all/", methods=["GET"])
def get_courses():
    """
    (DEV ONLY) Endpoint to get all courses.
    """
    courses = Course.query.all()
    return response(res={"courses": [course.serialize(include_users=True) for course in courses]}, success=True, code=200)


@app.route("/dev/next/timeslots/", methods=["GET"])
def get_all_timeslots():
    """
    (DEV ONLY) Endpoint to get all timeslots.
    """
    timeslots = Timeslot.query.all()
    return response(res={"timeslots": [timeslot.serialize() for timeslot in timeslots]}, success=True, code=200)


@app.route("/next/<string:course_id>/users/", methods=["GET"])
def get_course_users(course_id):
    """
    (DEV ONLY) Endpoint for gettting all users (students and instructors) for a course id.
    """
    instructors = User.query.filter(User.courses_as_instructor.any(id=course_id)).all()
    students = User.query.filter(User.courses_as_student.any(id=course_id)).all()
    res = {
        "instructors": [instructor.serialize() for instructor in instructors],
        "students": [student.serialize() for student in students]
    }
    return response(res=res, success=True, code=200)


# TESTING GETTING COURSES BY USER ID (unitl we get session token in frontend)
@app.route("/dev/next/courses/<string:user_id>/", methods=["GET"])
def get_courses_for_user_id(user_id):
    """
    (DEV ONLY) To display courses for user without session token.
    """
    # body = json.loads(request.data)
    # user_id = body.get("user_id")

    user = User.query.filter_by(id=user_id).first()
    if user is None:
        return response("user not found", success=False, code=404)
    
    user_info = {
        "user_id": user.id,
        "courses_as_instructor": [course.serialize() for course in user.courses_as_instructor],
        "courses_as_student":  [course.serialize() for course in user.courses_as_student]
    }
    return response(res=user_info, success=True, code=200)
    

################################################## PUBLIC ROUTES ##############################################

@app.route("/next/login/", methods=["POST"])
def login():
    """
    Endpoint for logging in a user.
    """
    body = json.loads(request.data)
    username = body.get("username")
    password = body.get("password")
    
    if username is None or password is None:
        return response("Credentials missing, username and/or password. ", success=False, code=404)

    was_successful, user = users_dao.verify_credentials(username, password)

    if not was_successful:
        return response("Incorrect username or password", success=False, code=401)
    
    user = users_dao.renew_session(user.update_token)
    return response(
        res={
            "user_id": user.id,
            "session_token": user.session_token,
            "session_expiration": str(user.session_expiration),
            "update_token": user.update_token

        }, success=True, code=201)


@app.route("/next/session/", methods=["POST"])
def update_session():
    """
    Endpoint for updating a user's session.
    """
    was_successful, update_token = extract_token(request)
    if not was_successful:
        return update_token
    
    try: 
        user = users_dao.renew_session(update_token)
    except Exception as e:
        return response(f"Invalid update token: {str(e)}")
    
    return response(
        {
            "session_token": user.session_token,
            "session_expiration": str(user.session_expiration),
            "update_token": user.update_token
        }, success=True, code=201
    )


@app.route("/next/logout/", methods=["POST"])
def logout():
    """
    Endpoint to log out a user.
    """
    was_successful, session_token = extract_token(request)
    if not was_successful:
        return session_token
    
    user = users_dao.get_user_by_session_token(session_token)
    if not user or not user.verify_session_token(session_token):
        return response("Invalid session token", success=False, code=404)
    
    user.session_expiration = datetime.now()
    db.session.commit()

    return response({"response": "Successfully logged out"}, success=True, code=201)


@app.route("/next/months/", methods=["GET"])
def get_months():
    """
    Endpoint to get months.
    """
    months = Month.query.all()
    return response(res={"months": [month.serialize() for month in months]}, success=True, code=200)


@app.route("/next/<string:month_number>/days/", methods=["GET"])
def get_days(month_number):
    """
    Endpoint to get days of a month.
    """
    month = Month.query.filter_by(number=month_number).first()
    today = date.today()

    for day in month.days:
        if month.number < today.month or month.number <= today.month and day.number < today.day:
            day.active = False
            db.session.commit()
        
    return response(res={"days": [day.serialize() for day in month.days]}, success=True, code=200)

@app.route("/next/courses/", methods=["GET"])
def get_courses_for_user():
    """
    Endpoint for getting all courses (as instructor and student) for a user.
    """
    was_successful, session_token = extract_token(request)

    if not was_successful:
        return session_token
    
    user = users_dao.get_user_by_session_token(session_token)
    if user is None or not user.verify_session_token(session_token):
        return response("Invalid session token.", success=False, code=404)
    
    user_info = {
        "user_id": user.id,
        "courses_as_instructor": [course.serialize() for course in user.courses_as_instructor],
        "courses_as_student":  [course.serialize() for course in user.courses_as_student]
    }
    return response(res=user_info, success=True, code=200)

@app.route("/next/courses/<string:course_id>/<int:month_id>/<int:day_id>/timeslots/", methods=["GET"])
def get_timeslots_for_course_on_date(course_id, month_id, day_id):
    # TODO: add authorization; reformat date in url maybe?
    """
    Get timeslots for a particular course on a particular day
    """
    date = str(month_id) + "-" + str(day_id)
    
    # Get timeslots by ascending order
    timeslots = Timeslot.query.filter(Timeslot.date==date and Timeslot.course==course_id).order_by(Timeslot.start_time_epoch.asc())
    return response(res={"timeslots": [t.serialize() for t in timeslots]}, success=True, code=200)

@app.route("/next/queues/<string:timeslot_id>/", methods=["GET"])
def get_queue(timeslot_id):
    # TODO: add authorization; add course_id to url to verify if user is able to get queue
    # Tested
    """
    Get queue for timeslot given its id.
    """
    timeslot = Timeslot.query.filter_by(id=timeslot_id).first()
    if timeslot is None:
        return response("timeslot not found", success=False, code=400)
    
    # Retrieve timestamps in ascending time order
    timestamps = Timestamp.query.filter_by(timeslot_id=timeslot_id).order_by(Timestamp.joined_at.asc())
    return response(res={"queue": [t.serialize() for t in timestamps]}, success=True, code=200)
   
@app.route("/next/courses/<string:course_id>/timeslots/<string:timeslot_id>/", methods=["POST"])
def join_queue(course_id, timeslot_id):
    # TESTED
    """
    Endpoint for adding user to queue for timeslot id.
    """
    # Get user from session
    was_successful, session_token = extract_token(request)
    if not was_successful:
        return session_token
    user = users_dao.get_user_by_session_token(session_token)
    if user is None or not user.verify_session_token(session_token):
        return response("Invalid session token.", success=False, code=401)

    # Get parameters from request body
    course = Course.query.filter_by(id=course_id).first()
    if course is None:
        return response("course not found", success=False, code=404)

    timeslot = Timeslot.query.filter_by(id=timeslot_id).first()
    if timeslot is None:
        return response("timeslot not found", success=False, code=404)
    
    # Check if user is in course
    if user not in course.students:
        return response("not a student for this course", success=False, code=401)
    
    # Check if user is not already in queue
    optional_timestamp = Timestamp.query.filter(Timestamp.user_id==user.id).first()
    if optional_timestamp is not None:
        if optional_timestamp.status != "":
            return response("already in queue", success=False, code=400)

    # Creating instance in queue
    timestamp = Timestamp(user_id=user.id, timeslot_id=timeslot.id)
    db.session.add(timestamp)
    db.session.commit()

    return response({"timestamp": timestamp.serialize()}, success=True, code=201)

@app.route("/next/courses/<string:course_id>/timeslots/add/", methods=["POST"])
def add_timeslot(course_id):
    """
    Add timeslot for course, given:
    1) start_time (in epoch seconds)
    2) end_time (in epoch seconds)
    """
    # Get user from session
    was_successful, session_token = extract_token(request)
    if not was_successful:
        return session_token

    user = users_dao.get_user_by_session_token(session_token)
    if user is None or not user.verify_session_token(session_token):
        return response("Invalid session token.", success=False, code=401)

    body = json.loads(request.data)
    start_time = body.get("start_time")
    end_time = body.get("end_time")

    if start_time is None or end_time is None:
        return response("Must provide both [start_time] and [end_time]. ", success=False, code=404) 
    if start_time >= end_time:
        return response("Invalid time range. ", success=False, code=404)

    course = Course.query.filter_by(id=course_id).first()
    if course is None:
        return response("course not found. ", success=False, code=404)

    # Check if user is an instructor for the course
    if user not in course.instructors:
        return response("user is not authorized to add a timeslot ", success=False, code=401)
    
    time_slot = Timeslot(start_time=start_time, end_time=end_time, course_id=course_id)
    db.session.add(time_slot)
    db.session.commit()
    
    return response({"timeslot": time_slot.serialize()}, success=True, code=201)

@app.route("/next/courses/<string:course_id>/timeslots/<string:timeslot_id>/", methods=["DELETE"])
def delete_timeslot(course_id, timeslot_id):
    # Tested
    """
    Endpoint for instructor to delete a timeslot for a course.
    """
    # Get user from session
    was_successful, session_token = extract_token(request)
    if not was_successful:
        return session_token

    user = users_dao.get_user_by_session_token(session_token)
    if user is None or not user.verify_session_token(session_token):
        return response("Invalid session token.", success=False, code=401) 

    course = Course.query.filter_by(id=course_id).first()
    if course is None:
        return response("course not found. ", success=False, code=404)

    # Check if user is an instructor for the course
    if user not in course.instructors:
        return response("user is not authorized to delete a timeslot ", success=False, code=401)

    timeslot = Timeslot.query.filter_by(id=timeslot_id).first()
    if timeslot is None:
        return response("timeslot not found", success=False, code=404)
    
    db.session.delete(timeslot)
    db.session.commit()
    return response({"timeslot": timeslot.serialize()}, success=True, code=200)

######################################## Added for testing purposes. Drop all tables #############################################
@app.route("/next/drop/", methods=["POST"])
def drop_tables():
    """
    Drop all tables
    """
    db.drop_all(bind=None)
    return response(res=[], success=True, code=201)


########################################## Fill our database! #######################################################

@app.before_first_request
def fill_database():
    '''
    Initialize database with dummy data
    '''
    gen_days()
    gen_courses()


if __name__ == '__main__':
    init_db()
    app.run(host='0.0.0.0', port=4500)

    
