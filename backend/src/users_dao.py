"""
DAO (Data Access Object) file

Helper file containing functions for accessing data in our database.
"""

from Tables import db
from Tables import User

def get_user_by_username(username):
  """
  Returns a User object from the DB given a username
  """
  return User.query.filter(User.username == username).first()

def get_user_by_session_token(session_token):
  """
  Returns a User object from the DB given a session token.
  """
  return User.query.filter(User.session_token == session_token).first()

def get_user_by_update_token(update_token):
  """
  Returns a User object from the DB given an update token.
  """
  return User.query.filter(User.update_token == update_token).first()

def verify_credentials(username, password):
  """
  Returns true if credentials match, otherwise returns false.
  """
  optional_user = get_user_by_username(username)
  if optional_user is None:
    return False, None
  
  return optional_user.verify_password(password), optional_user

def renew_session(update_token):
  """
  Renews a user's session token.

  Returns the User object.
  """
  user = get_user_by_update_token(update_token)
  if user is None:
    raise Exception("Invalid update token")
  
  user.renew_session()
  db.session.commit()

  