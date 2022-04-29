from flask_sqlalchemy import SQLAlchemy
from sqlalchemy import ForeignKey
db = SQLAlchemy()

# Association Tables
instructor_course_association = db.Table(
  "instructor_course_association",
    db.Model.metadata,
  db.Column("user_id", db.Integer, db.ForeignKey("users.id")),
  db.Column("course_id", db.Integer, db.ForeignKey("courses.id"))
)

student_course_association = db.Table(
  "student_course_association",
  db.Model.metadata,
  db.Column("user_id", db.Integer, db.ForeignKey("users.id")),
  db.Column("course_id", db.Integer, db.ForeignKey("courses.id"))
)

student_timeslot_association = db.Table(
  "student_timeslot_association",
  db.Model.metadata,
  db.Column("user_id", db.Integer, db.ForeignKey("users.id")),
  db.Column("course_id", db.Integer, db.ForeignKey("timeslots.id"))
)

instructor_timeslot_association = db.Table(
  "instructor_timeslot_association",
  db.Model.metadata,
  db.Column("user_id", db.Integer, db.ForeignKey("users.id")),
  db.Column("course_id", db.Integer, db.ForeignKey("timeslots.id"))
)

student_joined_queue_association = db.Table(
"student_joined_queue_association",
  db.Model.metadata,
  db.Column("user_id", db.Integer, db.ForeignKey("users.id")),
  db.Column("queue_id", db.Integer, db.ForeignKey("queue.id"))
)

student_completed_queue_association = db.Table(
"student_completed_queue_association",
  db.Model.metadata,
  db.Column("user_id", db.Integer, db.ForeignKey("users.id")),
  db.Column("queue_id", db.Integer, db.ForeignKey("queue.id"))
)

class Month(db.Model):
    __tablename__ = "months"
    id = db.Column(db.Integer, primary_key=True, autoincrement=True)
    name = db.Column(db.String, nullable=False)
    number = db.Column(db.Integer, nullable=False)
    num_days = db.Column(db.Integer, nullable=False)
    active = db.Column(db.Boolean, nullable=False)
    days = db.relationship("Day", cascade="delete")

    def __init__(self, **kwargs):
        self.name = kwargs.get("name")
        self.number = kwargs.get("number")
        self.num_days = kwargs.get("num_days")
        self.active = kwargs.get("active")

    def serialize(self):
        return {
            "id": self.id,
            "name": self.name,
            "active": self.active,
            "days": [day.serialize() for day in self.days]
        }

class Day(db.Model):
    __tablename__ = "days"
    id = db.Column(db.Integer, primary_key=True)
    month_id = db.Column(db.Integer, db.ForeignKey("months.id"))
    month_name = db.Column(db.String, nullable=False)
    number = db.Column(db.Integer, nullable=False)
    active = db.Column(db.Boolean, nullable=False)
   
    def __init__(self, **kwargs):
        self.month_id = kwargs.get("month_id")
        self.month_name = kwargs.get("month_name")
        self.number = kwargs.get("number")
        self.active = kwargs.get("active")
        

    def serialize(self):
        return {
            "id": self.id,
            "month": self.month_name,
            "number": self.number,
            "active": self.active,
        }



class Timeslot(db.Model):
    __tablename__ = "timeslots"
    id = db.Column(db.Integer, primary_key=True, autoincrement=True)
    date = db.Column(db.String, nullable=False)
    start_time = db.Column(db.Integer, nullable=False)
    end_time = db.Column(db.Integer, nullable=False)
    course_id = db.Column(db.Integer, db.ForeignKey("courses.id"), nullable=False)
    course = db.relationship("Course", cascade="delete")

    # Many-to-many relationship
    students_in_timeslot = db.relationship("User", secondary=student_timeslot_association, back_populates="timeslots_as_student")
    instructors_in_timeslot = db.relationship("User", secondary=instructor_timeslot_association, back_populates="timeslots_as_instructor")

    def __init__(self, **kwargs):
        """
        Initialize Timeslot object
        """
        self.date = kwargs.get("date")
        self.start_time = kwargs.get("start_time")
        self.end_time = kwargs.get("end_time")
        self.course = kwargs.get("course")

    def serialize(self):
        """
        Serialize Timeslot object
        """
        return {
            "id": self.id,
            "date": self.date,
            "start_time": self.start_time,
            "end_time": self.end_time
        }



class Queue(db.Model):
    __tablename___ = "queue"
    id = db.Column(db.Integer, primary_key=True, autoincrement=True)
    course_id = db.Column(db.Integer, db.ForeignKey("courses.id"), nullable=False)
    date = db.Column(db.String)
    students_joined = db.relationship("User", secondary=student_joined_queue_association, back_populates="queues_joined")
    students_completed = db.relationship("User", secondary=student_completed_queue_association)
    
    def __init__(self, **kwargs) -> None:
        self.course_id = kwargs.get("course_id")
        self.day_id = kwargs.get("day_id")
        self.month_id = kwargs.get("month_id")
    
    def serialize(self):
        return {
            "date": self.date,
            "course_id": self.course_id,
            "joined_students": self.joined_students,
            "completed_students": self.completed_students
        }

class Course(db.Model):
    __tablename__ = "courses"
    id = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.String, nullable=False)
    code = db.Column(db.String, nullable=False)

    # Many-to-many relationship
    students = db.relationship("User", secondary=student_course_association, back_populates="courses_as_student")
    instructors = db.relationship("User", secondary=instructor_course_association, back_populates="courses_as_instructor")

    def __init__(self, **kwargs):
        """
        Initialize Course object
        """
        self.code = kwargs.get("code")
        self.name = kwargs.get("name")

    def serialize(self, include_users=False):
        """
        Serialize Course object
        """
        if include_users:
            return {
                "id":self.id,
                "code":self.code,
                "name":self.name,
                "instructors": [i.serialize() for i in self.instructors],
                "students": [s.serialize() for s in self.students]
            }
        else:
            return {
                "id":self.id,
                "code":self.code,
                "name":self.name
            }


class User(db.Model):
    __tablename__ = "users"
    id = db.Column(db.Integer, primary_key=True, autoincrement=True)
    name = db.Column(db.String, nullable=False)
    netid = db.Column(db.String, nullable=False, unique=False)

    # Many-to-many Relationships
    courses_as_student = db.relationship("Course", secondary=student_course_association, back_populates="students")
    courses_as_instructor = db.relationship("Course", secondary=instructor_course_association, back_populates="instructors")
    timeslots_as_student = db.relationship("Timeslot", secondary=student_timeslot_association, back_populates="students_in_timeslot")
    timeslots_as_instructor = db.relationship("Timeslot", secondary=instructor_timeslot_association, back_populates="instructors_in_timeslot")
    queues_joined = db.relationship("Queue", secondary=student_queue_association, back_populates="students_joined")

    def __init__(self, **kwargs):
        """
        Initialize User object
        """
        self.name = kwargs.get("name")
        self.netid = kwargs.get("netid")
    
    def serialize(self, include_courses=False, include_timeslots=False):
        """
        Serialize User object
        """

        if include_courses and include_timeslots:
            return {
                "id": self.id,
                "name": self.name,
                "netid": self.netid,
                "courses_as_student": [c.serialize() for c in self.courses_as_student],
                "courses_as_instructor": [c.serialize() for c in self.courses_as_instructor],
                "timeslots_as_student": [t.serialize() for t in self.timeslots_as_student],
                "timeslots_as_instructor": [t.serialize() for t in self.timeslots_as_instructor],
            }
        elif include_courses:
            return {
                "id": self.id,
                "name": self.name,
                "netid": self.netid,
                "courses_as_student": [c.serialize() for c in self.courses_as_student],
                "courses_as_instructor": [c.serialize() for c in self.courses_as_instructor]
            }
        elif include_timeslots:
            return {
                "id": self.id,
                "name": self.name,
                "netid": self.netid,
                "timeslots_as_student": [t.serialize() for t in self.timeslots_as_student],
                "timeslots_as_instructor": [t.serialize() for t in self.timeslots_as_instructor],
            }
        else:
            return {
                "id": self.id,
                "name": self.name,
                "netid": self.netid,
            }
