import queue
from flask import Flask
from requests import request
from Tables import db, Day, Month, Timeslot, User, Course, Queue
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
        user = User(name=gen_name(), netid=gen_netid())
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

        for user in users:
            if user.id == 1: course.instructors.append(user)
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
    '''
    Get all users: students and instructors
    '''
    users = User.query.all()
    return response(res={"users": [user.serialize() for user in users]})

@app.route("/next/<string:course_id>/users/", methods=["GET"])
def get_course_users(course_id):
    '''
    Get all users: students and instructors
    '''
    # Artist.query.filter(Artist.albums.any(genre_id=genre.id)).all()
    instructors = User.query.filter(User.courses_as_instructor.any(id=course_id)).all()
    students = User.query.filter(User.courses_as_student.any(id=course_id)).all()
    res = {
        "instructors": [instructor.serialize() for instructor in instructors],
        "students": [student.serialize() for student in students]
    }
    return response(res=res)

@app.route("/next/courses/", methods=["GET"])
def get_courses():
    '''
    Get all courses
    '''
    courses = Course.query.all()
    return response(res={"courses": [course.serialize(include_users=True) for course in courses]})


@app.route("/next/<int:course_id>/<int:month_id>/<int:day_id>/timeslots", methods=["GET"])
def get_timeslots(course_id, month_id, day_id):
    '''
    Get timeslots for a particular course on a particular day
    '''
    date = str(month_id) + "-" + str(day_id)
    
    if requests.method == "GET":
        timeslots = Timeslot.query.filter(Timeslot.date==date & Timeslot.course==course_id)
        return response(res={"queue": queue}, success=True, code=200)
    


@app.route("/next/<int:user_id>/<int:course_id>/<int:month_id>/<int:day_id>/<int:timeslot_id>/", methods=["GET", "POST"])
def get_queue(user_id, course_id, month_id, day_id, timeslot_id):
    '''
    Get / Join queue for particular course on a particular day
    '''
    date = str(month_id) + "-" + str(day_id)
    queue = Queue.query.filter(Queue.date==date & Queue.course_id==course_id & Queue.timeslot_id==timeslot_id)

    if requests.method == "GET":
        return response(res={"queue": queue}, success=True, code=200)
    else:
        user = User.query_by(id=user_id)
        queue.students_joined.append()


@app.route("/next/<string:course_id>/add/")
def add_timeslot(course_id):
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

@app.route("/next/timeslots/<string:timeslot_id>/")
def get_all_timeslots():
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
