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

def gen_color(i):
    colors = ["#DE9FF5", "#F59F9F", "#85DEFC"]
    return colors[i]

def gen_name(i):
    names = ["Joey", "Ana", "C", "D"]
    return names[i]


def gen_netid(i):
    netids = ["jfm325", "ana123", "c9"]
    return netids[i]


def gen_course(i):
    courses = ["CS 1110", "CS 2110", "CS 3110"]
    return courses[i]