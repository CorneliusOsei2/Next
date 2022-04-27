
from flask import Flask
from Tables import db, Day, Month
from gen import month_names
from utils import response
from flask_cors import CORS

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

    for month_name, num_days in months.items():
        month = Month(name=month_name, num_days = num_days, active=False)
        db.session.add(month)
        db.session.commit()


# Routes
@app.route("/next/days/", methods=["GET"])
def gen_days():

    gen_months()
    months = Month.query.all()

    for month in months:
        for i in range(month.num_days):
            day = Day(day=i+1, month_id=month.id, month_name=month.name, active=False)
            db.session.add(day)
            month.days.append(day)
            db.session.commit()
    
    res = Day.query.all()
    return response(res= {"days": [day.serialize_for_day() for day in res]}, success=True, code=200)


@app.route("/next/months/", methods=["GET"])
def get_months():
    months = Month.query.all()
    
    return response(res={"months": [month.serialize_for_month() for month in months]})



# Added for testing purposes. Drop all tables
@app.route("/next/drop/", methods=["POST"])
def drop_table():
    db.drop_all(bind=None)

    return response(res=[], success=True, code=201)




if __name__ == '__main__':
    app.run(host='0.0.0.0', port=4500)
