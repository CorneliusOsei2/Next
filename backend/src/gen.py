from Tables import Day, db
from datetime import datetime
from calendar import isleap
from random import randint

def month_names():
    
    return {
     "January": 31,
     "February": 29 if isleap(datetime.now().year) else 28,
     "March": 31,
     "April": 30,
     "May": 31,
     "June": 30,
     "July": 31,
     "August": 31,
     "September": 30,
     "October": 31,
     "November": 30,
     "December": 31
    }


def gen_name():
    names = ["A", "B", "C", "D"]
    return names[randint(0, 3)]


def gen_netid(i):
    netids = ["a3", "b5", "c9"]
    return netids[i]


def gen_course():
    courses = ["CS 1110", "CS 2110", "CS 3110"]
    return courses[randint(0,2)]