from flask_sqlalchemy import SQLAlchemy
db = SQLAlchemy()




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


class Course(db.Model):
    __tablename__ = "courses" 
    id = db.Column(db.Integer, primary_key=True, autoincrement=True)
