from Tables import Day, db
from datetime import datetime
from calendar import isleap

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

