import enum
import json
from time import time
from flask import Flask, request
from Tables import db, Day, Month, Timeslot, User, Course, Timestamp
from gen import month_names, gen_name, gen_netid, gen_course
from utils import response, Debug
from flask_cors import CORS
from datetime import date
import requests
import json

# Initialize Flask and CORS
app = Flask(__name__)
CORS(app)

# DB config
db_filename = "next.db"
app.config["SQLALCHEMY_DATABASE_URI"] = "sqlite:///%s" % db_filename
app.config["SQLALCHEMY_TRACK_MODIFICATIONS"] = False
app.config["SQLALCHEMY_ECHO"] = True
db.init_app(app)
with app.app_context():
    db.create_all()

# Helpers
def gen_months():
    '''
    Auto-generate months
    '''
    months = month_names()

    i = 1
    for month_name, num_days in months.items():
        month = Month(name=month_name, number = i, num_days = num_days, active= True)
        db.session.add(month)
        db.session.commit()
        i += 1

def gen_days():
    '''
    Autogenerate days for the months
    '''
    gen_months()
    months = Month.query.all()

    for month in months:
        for i in range(month.num_days):
            day = Day(number=i+1, month_id=month.id, month_name=month.name, active=True)
            db.session.add(day)
            month.days.append(day)
            db.session.commit()

def gen_users():
    '''
    Auto-generate users
    '''
    for i in range(3):
        user = User(name=gen_name(), username=gen_netid(i), password="123")
        db.session.add(user)
        db.session.commit()

def gen_courses():
    '''
    Auto-generate users
    '''
    gen_users()
    users = User.query.all()

    for i in range(3):
        course = Course(code=gen_course(), name="Programming")
        db.session.add(course)
        db.session.commit()

        for j, user in enumerate(users):
            if j == 1: course.instructors.append(user)
            else: course.students.append(user)

            db.session.add(course)
            db.session.commit()

def gen_timeslots():
    pass


# Routes
@app.route("/", methods=["GET"])
def fill_database():
    '''
    Generate data for our database
    '''
    try:
        gen_days()
        gen_courses()
        
        return "Done"
    except Exception as e:
        return e

@app.route("/next/months/", methods=["GET"])
def get_months():
    '''
    Get days of a month
    '''
    months = Month.query.all()
    return response(res={"months": [month.serialize() for month in months]})


@app.route("/next/<string:month_number>/days/", methods=["GET"])
def get_days(month_number):
    '''
    Get days of a month
    '''
    month = Month.query.filter_by(number=month_number).first()
    today = date.today()

    for day in month.days:
        if month.number < today.month or month.number <= today.month and day.number < today.day:
            day.active = False
            db.session.commit()
        
    return response(res={"days": [day.serialize() for day in month.days]})


@app.route("/next/users/", methods=["GET"])
def get_all_users():
    """
    (DEV ONLY) Endpoint to get all users.
    """
    users = User.query.all()
    return response(res={"users": [user.serialize() for user in users]})

@app.route("/next/<string:course_id>/users/", methods=["GET"])
def get_course_users(course_id):
    """
    Endpoint for gettting all users (students and instructors) for a course id.
    """
    instructors = User.query.filter(User.courses_as_instructor.any(id=course_id)).all()
    students = User.query.filter(User.courses_as_student.any(id=course_id)).all()
    res = {
        "instructors": [instructor.serialize() for instructor in instructors],
        "students": [student.serialize() for student in students]
    }
    return response(res=res)

@app.route("/next/courses/", methods=["GET"])
def get_courses():
    """
    (DEV ONLY) Endpoint to get all courses.
    """
    courses = Course.query.all()
    return response(res={"courses": [course.serialize(include_users=True) for course in courses]})

@app.route("/next/<string:user_id>/courses/", methods=["GET"])
def get_courses_for_user(user_id):
    """
    Endpoint for getting all courses (as instructor and student) for a user.
    """
    # TODO: Need to add user authentication, should not be able to access if given only user_id
    user = User.query.filter_by(id=user_id)
    courses = {
        "courses_as_instructor": [course.serialize() for course in user.courses_as_instructor],
        "courses_as_student":  [course.serialize() for course in user.courses_as_student]
    }
    return response(res={courses})


@app.route("/next/<string:course_id>/<int:month_id>/<int:day_id>/timeslots/", methods=["GET"])
def get_timeslots_for_course_on_date(course_id, month_id, day_id):
    # TESTED
    """
    Get timeslots for a particular course on a particular day
    """
    date = str(month_id) + "-" + str(day_id)
    
    timeslots = Timeslot.query.filter(Timeslot.date==date and Timeslot.course==course_id)
    return response(res={"timeslots": [t.serialize() for t in timeslots]}, success=True, code=200)


@app.route("/next/queues/<string:timeslot_id>/", methods=["GET"])
def get_queue(timeslot_id):
    '''
    Get / Join queue for particular course on a particular day
    '''
    timeslot = Timeslot.query.filter_by(id=timeslot_id)

    return response(res={"queue": [student.serialize() for student in timeslot.students_joined]}, success=True, code=200)
   
@app.route("/next/<string:user_id>/<string:timeslot_id>/", methods=["POST"])
def join_queue(user_id, timeslot_id):
    # TESTED
    """
    Endpoint for adding user to queue for timeslot id.
    """
    # TODO: needs user authentication
    user = User.query.filter_by(id=user_id).first()
    if user is None:
        return response("user not found", success=False, code=400)
    timeslot = Timeslot.query.filter_by(id=timeslot_id).first()
    if timeslot is None:
        return response("timeslot not found", success=False, code=400)

    # Creating instance in queue
    timestamp = Timestamp(user_id=user.id, timeslot_id=timeslot.id)
    db.session.add(timestamp)
    db.session.commit()

    return response({"timestamp": timestamp.serialize()}, code=201)

@app.route("/next/<string:course_id>/add/", methods=["POST"])
def add_timeslot(course_id):
    # TESTED
    """
    Add timeslot for course, given:
    1) start_time (in epoch seconds)
    2) end_time (in epoch seconds)
    """
    body = json.loads(request.data)
    start_time = body.get("start_time")
    end_time = body.get("end_time")

    if start_time >= end_time:
        return response({"error": "Invalid time range. "}, success=False, code=404)

    course = Course.query.filter_by(id=course_id).first()

    if course is None:
        return response({"error": "course not found. "}, success=False, code=404)
    
    time_slot = Timeslot(start_time=start_time, end_time=end_time, course_id=course_id)
    db.session.add(time_slot)
    db.session.commit()
    
    return response({"timeslot": time_slot.serialize()}, code=201)

@app.route("/next/timeslots/<string:timeslot_id>/", methods=["DELETE"])
def delete_timeslot(timeslot_id):
    # Tested
    timeslot = Timeslot.query.filter_by(id=timeslot_id).first()
    if timeslot is None:
        return response("timeslot not found", success=False, code=404)
    
    db.session.delete(timeslot)
    db.session.commit()
    return response({"timeslot": timeslot.serialize()})


@app.route("/next/timeslots/<string:timeslot_id>/")
def get_course_timeslots(timeslot_id):
    # TODO: update to get course for timeslot_id
    timeslots = Timeslot.query.all()

    return response(res=[timeslot.serialize() for timeslot in timeslots])
    

# Added for testing purposes. Drop all tables
@app.route("/next/drop/", methods=["POST"])
def drop_table():
    '''
    Drop tables
    '''
    db.drop_all(bind=None)

    return response(res=[], success=True, code=201)




if __name__ == '__main__':
    app.run(host='0.0.0.0', port=4500)
