from flask import Flask
from Tables import db, Day, Month, Timeslot, User, Course
from gen import month_names, gen_name, gen_netid, gen_course
from utils import response, Debug
from flask_cors import CORS
from datetime import date

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
    months = month_names()

    i = 1
    for month_name, num_days in months.items():

        month = Month(name=month_name, number = i, num_days = num_days, active= True)

        db.session.add(month)
        db.session.commit()
        i += 1

def gen_days():
    gen_months()
    months = Month.query.all()

    for month in months:
        for i in range(month.num_days):
            day = Day(number=i+1, month_id=month.id, month_name=month.name, active=True)
            db.session.add(day)
            month.days.append(day)
            db.session.commit()


def gen_users():
    for i in range(3):
        user = User(name=gen_name(), netid=gen_netid())
        db.session.add(user)
        db.session.commit()


def gen_courses():

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
            


# Routes
@app.route("/", methods=["GET"])
def fill_database():
    try:
        gen_days()
        gen_courses()
        
        return "Done"
    except Exception as e:
        return e



@app.route("/next/months/", methods=["GET"])
def get_months():
    months = Month.query.all()
    this_month = date.today().month

    for month in months:
        if month.id < this_month:
            month.active = False
            db.session.commit()

    return response(res={"months": [month.serialize() for month in months]})


@app.route("/next/<int:month_id>/days/", methods=["GET"])
def get_active_days(month_id):
    month = Month.query.filter_by(id=month_id).first()
    today = date.today()

    for day in month.days:
        if month.number < today.month or month.number <= today.month and day.number < today.day:
            day.active = False
            db.session.commit()
        
    return response(res={"days": [day.serialize() for day in month.days]})



@app.route("/next/<int:course_id>/<int:month_id>/<int:day_id>/timeslots", methods=["POST"])
def get_timeslots(course_id, month_id, day_id):
    date = str(month_id) + "-" + str(day_id)
    timeslots = Timeslot.query.filter(Timeslot.date==date & Timeslot.course==course_id)


@app.route("/next/users/", methods=["GET"])
def get_users():
    users = User.query.all()

    return response(res={"users": [user.serialize() for user in users]})


@app.route("/next/courses/", methods=["GET"])
def get_courses():
    courses = Course.query.all()

    return response(res={"courses": [course.serialize(include_users=True) for course in courses]})


# @app.route("/next/<int:course_id>/users", methods=["GET"])
# def get_courses():
    
#     return response(res={"courses": [course.serialize() for course in courses]})


# Added for testing purposes. Drop all tables
@app.route("/next/drop/", methods=["POST"])
def drop_table():
    db.drop_all(bind=None)

    return response(res=[], success=True, code=201)




if __name__ == '__main__':
    app.run(host='0.0.0.0', port=4500)
