import enum
from flask_sqlalchemy import SQLAlchemy
import bcrypt
import uuid
import hashlib
import os
import datetime
import enum

# Initialization
db = SQLAlchemy()

class TimestampStatus(enum.IntEnum):
    InQueue: int = 1
    Ongoing: int = 2
    OutOfQueue: int = 3

############################################# ASSOCIATION TABLES  ##############################################################

InstructorCourse = db.Table(
  "instructor_course_association",
    db.Model.metadata,
  db.Column("user_id", db.String, db.ForeignKey("users.id")),
  db.Column("course_id", db.String, db.ForeignKey("courses.id"))
)

StudentCourse = db.Table(
  "student_course_association",
  db.Model.metadata,
  db.Column("user_id", db.String, db.ForeignKey("users.id")),
  db.Column("course_id", db.String, db.ForeignKey("courses.id"))
)

InstructorTimeslot = db.Table(
  "instructor_timeslot_association",
  db.Model.metadata,
  db.Column("user_id", db.String, db.ForeignKey("users.id")),
  db.Column("course_id", db.String, db.ForeignKey("timeslots.id"))
)

StudentJoinedTimeslot = db.Table(
"student_joined_timeslot_association",
  db.Model.metadata,
  db.Column("user_id", db.String, db.ForeignKey("users.id")),
  db.Column("timeslot_id", db.String, db.ForeignKey("timeslots.id"))
)

StudentCompletedTimeslot = db.Table(
"student_completed_timeslot_association",
  db.Model.metadata,
  db.Column("user_id", db.String, db.ForeignKey("users.id")),
  db.Column("timeslot_id", db.String, db.ForeignKey("timeslots.id"))
)

############################################# MODEL TABLES  ##############################################################

class Month(db.Model):
    __tablename__ = "months"
    id = db.Column('id', db.String, default=lambda: str(uuid.uuid4()), primary_key=True)
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
    id = db.Column('id', db.String, default=lambda: str(uuid.uuid4()), primary_key=True)
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
    id = db.Column('id', db.String, default=lambda: str(uuid.uuid4()), primary_key=True)
    date = db.Column(db.String, nullable=False)
    start_time = db.Column(db.String, nullable=False)
    end_time = db.Column(db.String, nullable=False)
    start_time_epoch = db.Column(db.Integer, nullable=False)
    end_time_epoch = db.Column(db.Integer, nullable=False)
    course_id = db.Column(db.String, db.ForeignKey("courses.id"), nullable=False)
    course = db.relationship("Course", cascade="delete")

    # Many-to-many relationship
    instructors_in_timeslot = db.relationship("User", secondary=InstructorTimeslot, back_populates="timeslots_as_instructor")

    def __init__(self, **kwargs):
        """
        Initialize Timeslot object
        """
        # Parameters
        start_time_epoch = kwargs.get("start_time")
        end_time_epoch = kwargs.get("end_time")

        # Getting datetime values
        dt_start_time = datetime.datetime.fromtimestamp(start_time_epoch)
        start_time_str = f"{dt_start_time.hour}:{dt_start_time.minute}"
        dt_start_time_hm = datetime.datetime.strptime(start_time_str, "%H:%M")
        dt_end_time = datetime.datetime.fromtimestamp(end_time_epoch)
        end_time_str = f"{dt_end_time.hour}:{dt_end_time.minute}"
        dt_end_time_hm = datetime.datetime.strptime(end_time_str, "%H:%M")

        self.start_time_epoch = start_time_epoch
        self.end_time_epoch = end_time_epoch
        self.start_time = dt_start_time_hm.strftime("%I:%M %p")
        self.end_time = dt_end_time_hm.strftime("%I:%M %p")
        self.course_id = kwargs.get("course_id")
        self.date = f"{dt_start_time.month}-{dt_start_time.day}"
        self.instructors_in_timeslot = []

    def serialize(self):
        """
        Serialize Timeslot object
        """
        return {
            "id": self.id,
            "course_id": self.course_id,
            "date": self.date,
            "start_time": self.start_time,
            "end_time": self.end_time,
            "instructors": [i.serialize() for i in self.instructors_in_timeslot]
        }


class Timestamp(db.Model):
    __tablename___ = "timestamps"
    id = db.Column('id', db.String, default=lambda: str(uuid.uuid4()), primary_key=True)
    user_id = db.Column(db.String, db.ForeignKey("users.id"))
    user_name = db.Column(db.String, db.ForeignKey("users.name"))
    timeslot_id = db.Column(db.String, nullable=False)
    joined_at = db.Column(db.DateTime, nullable=False)
    status = db.Column(db.Integer, nullable=False)
    completed = db.Column(db.Boolean, nullable=False)
   

    def __init__(self, **kwargs) -> None:
        self.user_id = kwargs.get("user_id")
        self.user_name = kwargs.get("user_name")
        self.timeslot_id = kwargs.get("timeslot_id")
        self.joined_at = datetime.datetime.now()
        self.status = TimestampStatus.InQueue 
        self.completed = False

    def serialize(self):
        return {
            "user_id": self.timeslot_id,
            "user_name": self.user_name,
            "timeslot_id": self.timeslot_id,
            "joined_at": str(self.joined_at),
            "status": TimestampStatus(self.status).name,
            "completed": self.completed
        }

class Course(db.Model):
    __tablename__ = "courses"
    id = db.Column('id', db.String, default=lambda: str(uuid.uuid4()), primary_key=True)
    name = db.Column(db.String, nullable=False)
    code = db.Column(db.String, nullable=False)
    color = db.Column(db.String, nullable=False)

    # Many-to-many relationship
    students = db.relationship("User", secondary=StudentCourse, back_populates="courses_as_student")
    instructors = db.relationship("User", secondary=InstructorCourse, back_populates="courses_as_instructor")


    def __init__(self, **kwargs):
        """
        Initialize Course object
        """
        self.code = kwargs.get("code")
        self.name = kwargs.get("name")
        self.color = kwargs.get("color", "#FFFFFF")


    def serialize(self, include_users=False):
        """
        Serialize Course object
        """
        out = {
            "id":self.id,
            "code":self.code,
            "name":self.name,
            "color": self.color
        }
        if include_users:
            out["instructors"] = [i.serialize() for i in self.instructors]
            out["students"] = [s.serialize() for s in self.students]
        
        return out
                

class User(db.Model):
    __tablename__ = "users"
    id = db.Column('id', db.String, default=lambda: str(uuid.uuid4()), primary_key=True)
    name = db.Column(db.String, nullable=False)

    # User Information
    username = db.Column(db.String, nullable=False, unique=True)
    password_digest = db.Column(db.String, nullable=False)

    # Session Information
    session_token = db.Column(db.String, nullable=False, unique=True)
    session_expiration = db.Column(db.DateTime, nullable=False)
    update_token = db.Column(db.String, nullable=False, unique=True)
    
    # Many-to-many Relationships
    courses_as_student = db.relationship("Course", secondary=StudentCourse, back_populates="students")
    courses_as_instructor = db.relationship("Course", secondary=InstructorCourse, back_populates="instructors")
    timeslots_as_instructor = db.relationship("Timeslot", secondary=InstructorTimeslot, back_populates="instructors_in_timeslot")

    def __init__(self, **kwargs):
        """
        Initialize User object
        """
        self.name = kwargs.get("name")
        self.username = kwargs.get("username")
        # Storing pasword
        self.password_digest = bcrypt.hashpw(kwargs.get("password").encode("utf8"), bcrypt.gensalt(rounds=13))
        self.renew_session()


    def _urlsafe_base_64(self):
        """
        Randomly generates hashed tokens (for session/update tokens)
        """
        return hashlib.sha1(os.urandom(64)).hexdigest()


    def renew_session(self):
        """
        Renews sessions:
        1) creates new session token 
        2) sets expiration time of new session to a day from now
        3) creates a new update token
        """
        self.session_token = self._urlsafe_base_64()
        self.session_expiration = datetime.datetime.now() + datetime.timedelta(days=1)
        self.update_token = self._urlsafe_base_64()


    def verify_password(self, password):
        """
        Verifies password for a user.
        """
        return bcrypt.checkpw(password.encode("utf8"), self.password_digest)


    def verify_session_token(self, session_token):
        """
        Verifies session token of a user.
        """
        return session_token == self.session_token and datetime.datetime.now() < self.session_expiration


    def verify_update_token(self, update_token):
        """
        Verifies update token of a user.
        """
        return update_token == self.update_token

    
    def serialize(self, include_courses=False, include_timeslots=False):
        """
        Serialize User object
        """
        out = {
                "id": self.id,
                "name": self.name,
                "username": self.username
            }
            
        if include_courses:
            out["courses_as_student"] = [c.serialize() for c in self.courses_as_student]
            out["courses_as_instructor"] = [c.serialize() for c in self.courses_as_instructor]
            
        if include_timeslots:
            out["timeslots_as_instructor"] = [t.serialize() for t in self.timeslots_as_instructor]
        
        return out
            
        
