from flask_sqlalchemy import SQLAlchemy
db = SQLAlchemy()


class Day(db.Model):
    __tablename__ = "days"
    id = db.Column(db.Integer, primary_key=True)
    month_id = db.Column(db.Integer, db.ForeignKey("months.id"))
    month_name = db.Column(db.String, nullable=False)
    day = db.Column(db.Integer, nullable=False)
    active = db.Column(db.Boolean, nullable=False)
    # timeslots = db.relationship("Timeslot", cascade="delete")
   
    def serialize_for_day(self):
        return {
            "id": self.id,
            "month": self.month_name,
            "day": self.day,
            "active": self.active,
             # "timeslots": [slot.serialize_for_day() for slot in self.timeslots]
        }

    def serialize_for_month(self):

        return {
            "day": self.day,
            "active": self.active
        }


class Month(db.Model):
    __tablename__ = "months"
    id = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.String, nullable=False)
    num_days = db.Column(db.Integer, nullable=False)
    active = db.Column(db.Boolean, nullable=False)
    days = db.relationship("Day", cascade="delete")

    def serialize_for_month(self):
        return {
            "id": self.id,
            "name": self.name,
            "active": self.active,
            "days": [day.serialize_for_month() for day in self.days]
        }

