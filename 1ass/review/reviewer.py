

from sqlalchemy import Table, Column, Integer, String, Float, ForeignKey
from sqlalchemy.dialects.mysql import SMALLINT
import sqlalchemy as db
import os
from sqlalchemy.sql import select
from dotenv import load_dotenv
load_dotenv()
password = os.getenv("MYSQL_ROOT_PASSWORD")
engine = db.create_engine(f'mysql+pymysql://root:{password}@localhost:3306/sakila')
connection = engine.connect()
metadata = db.MetaData(connection)
reviewer: str = 'reviewer'
rating: str = 'rating'
film: str = 'film'
MAX_STRING_LENGTH = 45

# creating the table if it doesn't exist'
if not engine.dialect.has_table(connection, reviewer):
    reviewerTable: Table = Table(reviewer, metadata,
          Column('reviewer_id', Integer, primary_key=True, nullable=False), 
          Column('first_name', String(MAX_STRING_LENGTH), primary_key=False, nullable=False), 
          Column('last_name', String(MAX_STRING_LENGTH), primary_key=False, nullable=False), 
    )
    metadata.create_all()
else:
    # when the table exist save it
    reviewerTable = db.Table(reviewer, metadata, autoload=True, autoload_with=engine)

# getting the film table
filmTable = db.Table(film, metadata, autoload=True, autoload_with=engine)

if not engine.dialect.has_table(connection, rating):
    Table(rating, metadata,
          Column('reviewer_id', Integer, ForeignKey(reviewerTable.columns[0], ondelete='CASCADE'), nullable=False), 
          Column('film_id', SMALLINT(unsigned=True), ForeignKey(filmTable.columns[0], ondelete='CASCADE'), nullable=False), 
          Column('rating', Float, primary_key=False, nullable=False), 
    )
    metadata.create_all()


ratingTable = db.Table(rating, metadata, autoload=True, autoload_with=engine)




# this part will handle getting the details of the table
def get_reviewer_details():
    pass

def get_reviewer_id() -> int:
    reviewer_id_str: str = input("please provide your reviewer id \n") 
    # TODO: fix edge case when the reviewer id is not a number
    try: 
        reviewer_id_int : int = int(reviewer_id_str)
        # check if the reviewer id is in the table
        query = select(reviewerTable.c.reviewer_id).where(reviewerTable.c.reviewer_id == reviewer_id_int)
        rows = connection.execute(query).all()
        if len(rows) == 0:
            # ask the reviewer for his name and create it
            reviewer_name: str = input("please enter your first name to create a new reviewer \n")
            reviewer_last: str = input("please enter your last name to create a new reviewer \n")
            # insert the data into the database and validate it
    except ValueError as e:
        # TODO: handle exception
        pass
    

get_reviewer_id()