

import os
from dotenv import load_dotenv
import mysql.connector
load_dotenv()
REVIEWER_TABLE_NAME: str = 'reviewer'
RATING_TABLE_NAME: str = 'rating'
FIRST_NAME_COLUMN: str = 'first_name'
LAST_NAME_COLUMN: str = 'last_name'
REVIEWER_ID_COLUMN: str = 'reviewer_id'
FILM_ID_COLUMN: str = 'film_id'
RATING_COLUMN: str = 'rating'
RELEASE_YEAR_COLUMN: str = 'release_year'
TITLE_COLUMN: str = 'title'
FULL_NAME_COLUMN: str = 'full_name'
film: str = 'film'
MAX_STRING_LENGTH: int = 45


def zip_columns_to_row(columns: list[str], row: tuple[any]) -> dict[str, any]:
    '''
    This function will take columns and row that has the same length! 
    And join them together to create a dict of column names as keys and values as row values
    * note that is on you to send columns and row with the same length
    ** if you do not supply with the same length you may get error name list index is out of range for row
    '''
    json_res = {}
    for index, column in enumerate(columns):
        json_res[column] = row[index]
    return json_res

cnx = mysql.connector.connect(
    user='root',
    password=os.getenv('MYSQL_ROOT_PASSWORD'),
    host='127.0.0.1',
    database='sakila'
)
cnx.autocommit = True

# Create a cursor
cursor = cnx.cursor()
def create_tables_if_needed() -> None:
    f'''
    This function will create tables {REVIEWER_TABLE_NAME} and {RATING_TABLE_NAME}
    if they do not already exist, 
    * note the script will only create them if necessary, but not change theme if necessary. 
    '''
    # note I can use the f literal in the function definition and that will give better intellisense
    # creating the table if it doesn't exist'
    # there is no problem with sql injection because the input for this function in constant and the user can not control it
    cursor.execute(f'''
        CREATE TABLE IF NOT EXISTS {REVIEWER_TABLE_NAME} (
            `{REVIEWER_ID_COLUMN}` int NOT NULL AUTO_INCREMENT,
            `{FIRST_NAME_COLUMN}` varchar(45) NOT NULL,
            `{LAST_NAME_COLUMN}` varchar(45) NOT NULL, 
            PRIMARY KEY (`{REVIEWER_ID_COLUMN}`) 
        );''')
    # cnx.commit()
    cursor.execute(f'''
        CREATE TABLE IF NOT EXISTS {RATING_TABLE_NAME} (
            `{REVIEWER_ID_COLUMN}` int NOT NULL
            ,`{FILM_ID_COLUMN}` smallint unsigned NOT NULL
            ,`{RATING_COLUMN}` DECIMAL(2,1) NOT NULL
            ,UNIQUE KEY ({REVIEWER_ID_COLUMN}, {FILM_ID_COLUMN})
            #,KEY `{REVIEWER_ID_COLUMN}` (`{REVIEWER_ID_COLUMN}`)
            #,KEY `{FILM_ID_COLUMN}` (`{FILM_ID_COLUMN}`)
            ,CONSTRAINT `rating_ibfk_1` FOREIGN KEY (`{REVIEWER_ID_COLUMN}`) REFERENCES `{REVIEWER_TABLE_NAME}` (`{REVIEWER_ID_COLUMN}`) ON DELETE CASCADE
            ,CONSTRAINT `rating_ibfk_2` FOREIGN KEY (`{FILM_ID_COLUMN}`) REFERENCES `film` (`{FILM_ID_COLUMN}`) ON DELETE CASCADE
        );''')
        # KEY `{REVIEWER_ID_COLUMN}` (`{REVIEWER_ID_COLUMN}`),
        # KEY `{REVIEWER_ID_COLUMN}` (`{REVIEWER_ID_COLUMN}`),
            
    # cnx.commit()

def get_reviewer_details() -> dict[str: str]:
    '''
    Returns the dict with 3 parameters { reviewer_id: str, FIRST_NAME_COLUMN: str, last_name: str}
    * note: the reviewer_id is string just to make it easier to get the data from the dict
    '''
    while True:
        reviewer_id_str: str = input("please provide your reviewer id \n") 
        try: 
            
            reviewer_id_int : int = int(reviewer_id_str)
            
        except:
            print("Invalid value to be parsed as Integer please provide a valid integer value")
            continue

        # validate the actual user
        while True:
            try:
                # check if the reviewer id is in the table
                # the reason I am not using the constant define is because it could open us here 
                # to a security because we are using the f string literal 
                query_select_where_reviewer_id = '''
                    SELECT 
                        reviewer_id
                        ,first_name
                        ,last_name 
                    FROM 
                        sakila.reviewer
                    WHERE 
                        reviewer_id = %s;'''
                cursor.execute(query_select_where_reviewer_id , [reviewer_id_int])
                rows: list[dict[str: any]] = cursor.fetchall()
                # is empty check 
                if len(rows) == 0:
                    # ask the reviewer for his name and create it
                    reviewer_name: str = input("please enter your first name to create a new reviewer \n")
                    reviewer_last: str = input("please enter your last name to create a new reviewer \n")

                    insert_stmt = "INSERT INTO reviewer (reviewer_id, first_name, last_name) VALUES (%s, %s, %s)"

                    # Execute the INSERT statement
                    cursor.execute(insert_stmt, (reviewer_id_str,reviewer_name, reviewer_last))
                    # insert the data into the database and validate it
                    # cnx.commit()
                    # break the loop only when the user inserted valid details
                    return {REVIEWER_ID_COLUMN: str(reviewer_id_int), FIRST_NAME_COLUMN :reviewer_name, LAST_NAME_COLUMN: reviewer_last}

                # we can break here because there must be only one reviewer and we already check if 
                # the reviewer doesn't exist, then we just left to return his details
                break

            except Exception as e:
                print("ha ha ha you inserted invalid details to the database please try again! nob")

        # handle when the reviewer id is valid and in the database
        # we know it has only one result because the reviewer_id is a primary key
         
        row: dict[str: any] = zip_columns_to_row(cursor.column_names, rows[0])
        return row
      
def select_film_by_info(film_name: str) -> dict[str: any]:
    while True:
        cursor.execute('''
            SELECT 
                film_id
                ,release_year
            FROM 
                sakila.film
            WHERE 
                title = %s;
        ''' , [film_name])
        rows: list[tuple(any)] = cursor.fetchall() 
        # handle the 3 cases 
        # 1) the film does not exists
        # 2) the film appears in the database once!
        # 3) the film appears in the database more than once! 
        
        if (cursor.rowcount == 1): # 2) the film exists in the database once
            row = zip_columns_to_row(cursor.column_names ,rows[0])
            return row
        
        if (cursor.rowcount == 0): # 1) the film does not exist in the database
            film_name = input(f"No film with the name of {film_name}\nPlease provide a new one.\t")
            continue
        # 3) the film appears in the database more than once
        print(f"there is {len(rows)} films with the name of {film_name}\nPlease select a new one.")
        for film in rows:
            print(f'{film[FILM_ID_COLUMN]} - {film[RELEASE_YEAR_COLUMN]}')
        film_id = input('What is the film id the you want to select?')
        try:
            # handle when the user input invalid film id that is not a number
            film_id_int: int = int(film_id)
            # search for the film id and return it when found
            for film in rows:
                if film[FILM_ID_COLUMN] == film_id_int:
                    return film
            # when we did not find the film id raise an error
            raise ValueError(f"Could not find film id number {film_id}")
        except Exception as e:
            print(e)
            film_name = input("Please select a new film by his title")

def review_film(film_id: int, reviewer_id: int) -> None:
    '''
    This function will review a film by its film_id and the reviewer_id.
    The function will ask the user for the rating which is a number between 0 and 10
    With only one decimal point exactly
    With only two decimal places for example: 
    valid: 1.1, 1.2, 1.5, 8.75
    not valid: 1.11 (two float) , -1.2 (no in range) , 6 (no float number)
    '''
    while True:
        # get and validate the input 
        # there are some conditions
        rating_input: str = input("What is your rating for that movie?\t")
        
        try: 
            # validate you get a number between 0 and 9.9 with one decimal point
            if float(rating_input) :
                # this statement insert the ratting to the database but if there a review then will update
                query_update_if_not_existing = '''
                INSERT INTO sakila.rating 
                    (reviewer_id, film_id, rating)
                VALUES (%s, %s, %s)
                ON DUPLICATE KEY UPDATE 
                    reviewer_id = %s
                    ,film_id = %s
                    ,rating = %s;'''
                cursor.execute(query_update_if_not_existing, 
                    [reviewer_id, film_id, float(rating_input), reviewer_id, film_id, float(rating_input)]
                )
                # cnx.commit()
                print("Thanks for the review")
                return 
                
            
        except:
            print("your input is invalid please try again")
    
def print_reviewer_top_comments(reviewer_id) -> None:
    '''
    This function prints the top comments for a given reviewer
    takes the reviewer id and get the film title and the reviewer full name (varchar(90)) and the rating (float .1 one decimal)
    '''
    query_select_top_rating = '''
    SELECT 
        CONCAT(r.first_name, ' ' , r.last_name) as full_name
        ,f.title
        ,c.rating
    FROM 
        # stand for comment cause I will use the r for the reviewer
        sakila.rating as c 
    INNER JOIN sakila.reviewer as r ON
        r.reviewer_id = c.reviewer_id
    INNER JOIN sakila.film as f ON
	    f.film_id = c.film_id
    LIMIT 100'''
    cursor.execute(query_select_top_rating)
    rows = cursor.fetchall()
    for row in rows:
        # join it into a json so it is easier to print out
        row_json: dict[str, any] = zip_columns_to_row(cursor.column_names, row)
        print(f'For the movie {row_json[TITLE_COLUMN]} reviewer {row_json[FULL_NAME_COLUMN]} and the rating {row_json[RATING_COLUMN]}')

def main():
    
    # init the tables for the database if needed 
    create_tables_if_needed()
    # getting the reviewer and if he does not exist create him
    reviewer: dict[str: str] = get_reviewer_details()
    # greetings the reviewer
    print(f'Hello {reviewer[FIRST_NAME_COLUMN]} {reviewer[LAST_NAME_COLUMN]}')
    # asks for the film name
    film_name_input: str = input("What is the film name you want to rate\t")
    # check if the film exist and if so how many times 
    # you get dict with keys {RELEASE_YEAR_COLUMN , FILM_ID_COLUMN}
    film_data: dict[str: any] = select_film_by_info(film_name_input)
    review_film(film_data[FILM_ID_COLUMN], reviewer[REVIEWER_ID_COLUMN])
    # print the top 100 review
    print_reviewer_top_comments(reviewer[REVIEWER_ID_COLUMN])


# run only if you run this script but you can import this function with our running the file 
if __name__ == '__main__':
    
    main()

    
    

