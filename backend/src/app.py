import json
from flask import Flask, request
from flask_cors import CORS
from datetime import date
import json
import users_dao
from datetime import datetime
from Tables import db, Day, Month, Timeslot, User, Course, Timestamp, TimestampStatus
from gen import month_names, gen_name, gen_netid, gen_course, gen_color
from utils import response, extract_token
import err_msgs as err


# Initialize Flask and CORS
app = Flask(__name__)
CORS(app)

# DB init and config
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
        course = Course(code=gen_course(i), name="Programming", color=gen_color(i))
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
    gen_days()
    gen_courses()
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

@app.route("/dev/next/timestamps/", methods=["GET"])
def get_all_timestamps():
    """
    (DEV ONLY) Endpoint to get all timestamps.
    """
    timestamps = Timestamp.query.all()
    return response(res={"timestamps": [timestamp.serialize() for timestamp in timestamps]}, success=True, code=200)


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
    
    user = User.query.filter_by(id=user_id).first()
    if user is None:
        return response(*err.UserNotFound)
    
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
        return response(*err.MissingCredentials)

    was_successful, user = users_dao.verify_credentials(username, password)

    if not was_successful:
        return response(*err.IncorrectCredentials)
    
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
    except:
        return response(*err.InvalidUpdateToken)
    
    return response(res={
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
        return response(*err.InvalidSessionToken)
    
    user.session_expiration = datetime.now()
    db.session.commit()

    return response(res={"response": "Successfully logged out"}, success=True, code=201)


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
        return response(*err.InvalidSessionToken)
    
    user_info = {
        "user_id": user.id,
        "user_name": user.name,
        "courses_as_instructor": [course.serialize() for course in user.courses_as_instructor],
        "courses_as_student":  [course.serialize() for course in user.courses_as_student]
    }
    return response(res=user_info, success=True, code=200)


@app.route("/next/courses/<string:course_id>/<int:month_id>/<int:day_id>/timeslots/", methods=["GET"])
def get_timeslots_for_course_on_date(course_id, month_id, day_id):
    """
    Get timeslots for a particular course on a particular day
    """
    date = str(month_id) + "-" + str(day_id)

    # Get user from session
    was_successful, session_token = extract_token(request)
    if not was_successful:
        return session_token
    user = users_dao.get_user_by_session_token(session_token)
    if user is None or not user.verify_session_token(session_token):
        return response(*err.InvalidSessionToken)

    course = Course.query.filter_by(id=course_id).first()
    if course is None:
        return response(*err.CourseNotFound)
    
    # Only students or instructors can view the timeslots
    if user not in course.students and user not in course.instructors:
        return response(*err.UnauthorizedAccess)
    
    # Get timeslots by ascending order
    timeslots = Timeslot.query.filter(Timeslot.date==date and Timeslot.course==course_id).order_by(Timeslot.start_time_epoch.asc())
    return response(res={"timeslots": [t.serialize() for t in timeslots]}, success=True, code=200)


@app.route("/next/courses/<string:course_id>/queues/<string:timeslot_id>/", methods=["GET"])
def get_queue_info(course_id, timeslot_id):
    # Tested
    """
    Get queue for timeslot given its id.
    """
    # Get user from session
    was_successful, session_token = extract_token(request)
    if not was_successful:
        return session_token
    user = users_dao.get_user_by_session_token(session_token)
    if user is None or not user.verify_session_token(session_token):
        return response(*err.InvalidSessionToken)

    course = Course.query.filter_by(id=course_id).first()
    if course is None:
        return response(*err.CourseNotFound)
    
    # Only students can get queue info
    if user not in course.students and user not in course.instructors:
        return response(*err.UnauthorizedAccess)
    
    # Check if timeslot exists
    timeslot = Timeslot.query.filter_by(id=timeslot_id).first()
    if timeslot is None:
        return response(*err.TimeslotNotFound)

    timestamps_in_queue = Timestamp.query.filter(Timestamp.status==TimestampStatus.InQueue and Timestamp.timeslot_id==timeslot_id).count()
    timestamps_ongoing = Timestamp.query.filter(Timestamp.status==TimestampStatus.Ongoing and Timestamp.timeslot_id==timeslot_id).count()
    timestamps_completed = Timestamp.query.filter(Timestamp.completed==True and Timestamp.timeslot_id==timeslot_id).count()
    # Student specific info about queue
    if user in course.students:
        return response(res={
            "queue": [],
            "is_student": True,
            "instructor_count": len(timeslot.instructors_in_timeslot),
            "waiting": timestamps_in_queue,
            "ongoing": timestamps_ongoing,
            "completed": timestamps_completed
            }, success=True, code=200)
    else:  # Instructor specific info about queue
        timestamps = Timestamp.query.filter(Timestamp.status==TimestampStatus.InQueue and Timestamp.timeslot_id==timeslot_id).order_by(Timestamp.joined_at.asc())
        return response(res=
        {
            "queue": [t.serialize() for t in timestamps],
            "is_student": False,
            "instructor_count": len(timeslot.instructors_in_timeslot),
            "waiting": timestamps_in_queue,
            "ongoing": timestamps_ongoing,
            "completed": timestamps_completed
        }, success=True, code=200)

@app.route("/next/courses/<string:course_id>/timeslots/<string:timeslot_id>/join/", methods=["POST"])
def join_queue(course_id, timeslot_id):
    """
    Endpoint for adding user to queue for timeslot id.
    """
    # Get user from session
    was_successful, session_token = extract_token(request)
    if not was_successful:
        return session_token
    user = users_dao.get_user_by_session_token(session_token)
    if user is None or not user.verify_session_token(session_token):
        return response(*err.InvalidSessionToken)

    # Get parameters from request body
    course = Course.query.filter_by(id=course_id).first()
    if course is None:
        return response(*err.CourseNotFound)

    timeslot = Timeslot.query.filter(Timeslot.id==timeslot_id and Timeslot.course_id==course_id).first()
    if timeslot is None:
        return response(*err.TimeslotNotFound)
    
    # Check if user is in course
    if user not in course.students:
        return response(*err.StudentNotFound)
    
    # Check if user is not already in queue
    optional_timestamp = Timestamp.query.filter(Timestamp.user_id==user.id).first()
    if optional_timestamp is None:
        # Creating instance in queue
        timestamp = Timestamp(user_id=user.id, user_name=user.name, timeslot_id=timeslot_id)
        db.session.add(timestamp)
        db.session.commit()
        return response({"timestamp": timestamp.serialize()}, success=True, code=201)

    if optional_timestamp.status==TimestampStatus.OutOfQueue:
        # Update status
        optional_timestamp.status = TimestampStatus.InQueue
        db.session.commit()
        return response({"timestamp": optional_timestamp.serialize()}, success=True, code=201)
    else:
        # user is in queue or being helped
        return response(*err.StudentInQueue)


@app.route("/next/courses/<string:course_id>/timeslots/<string:timeslot_id>/leave/", methods=["POST"])
def leave_queue(course_id, timeslot_id):
    """
    Endpoint for user to leave a queue they are already in
    """
    # Get user from session
    was_successful, session_token = extract_token(request)
    if not was_successful:
        return session_token
    user = users_dao.get_user_by_session_token(session_token)
    if user is None or not user.verify_session_token(session_token):
        return response(*err.InvalidSessionToken)

    # Get parameters from request body
    course = Course.query.filter_by(id=course_id).first()
    if course is None:
        return response(*err.CourseNotFound)

    timeslot = Timeslot.query.filter(Timeslot.id==timeslot_id and Timeslot.course_id==course_id).first()
    if timeslot is None:
        return response(*err.TimeslotNotFound)
    
    # Check if user is in course
    if user not in course.students:
        return response(*err.StudentNotFound)

    # Check if user is not already in queue
    optional_timestamp = Timestamp.query.filter(Timestamp.user_id==user.id and Timestamp.id==timeslot_id).first()
    if optional_timestamp is None or optional_timestamp.status==TimestampStatus.OutOfQueue:
        return response(*err.StudentNotFound)

    # Mark as completed if being helped by Instructor
    if optional_timestamp.status == TimestampStatus.Ongoing:
        optional_timestamp.completed = True

    # update status  
    optional_timestamp.status = TimestampStatus.OutOfQueue
    db.session.commit()
    return response({"timestamp": optional_timestamp.serialize()}, success=True, code=200)


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
        return response(*err.InvalidSessionToken)

    body = json.loads(request.data)
    start_time = body.get("start_time")
    end_time = body.get("end_time")
    title = body.get("title")
    if start_time is None or end_time is None:
        return response(*err.MissingTimes) 
    if start_time >= end_time:
        return response(*err.InvalidTimeRange)

    if title is None or title.strip() == "":
        return response(*MissingTitle)

    course = Course.query.filter_by(id=course_id).first()
    if course is None:
        return response(*err.CourseNotFound)

    # Check if user is an instructor for the course
    if user not in course.instructors:
        return response(*err.UnauthorizedAccess)
    
    time_slot = Timeslot(start_time=start_time, end_time=end_time, course_id=course_id, title=title)
    time_slot.instructors_in_timeslot.append(user)
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
        return response(*err.InvalidSessionToken) 

    course = Course.query.filter_by(id=course_id).first()
    if course is None:
        return response(*err.CourseNotFound)

    # Check if user is an instructor for the course
    if user not in course.instructors:
        return response(*err.UnauthorizedAccess)

    timeslot = Timeslot.query.filter_by(id=timeslot_id).first()
    if timeslot is None:
        return response(*err.TimeslotNotFound)
    
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

# @app.before_first_request
# def fill_database():
#     '''
#     Initialize database with dummy data
#     '''
#     gen_days()
#     gen_courses()


if __name__ == '__main__':
    # init_db()
    app.run(host='0.0.0.0', port=5000)
