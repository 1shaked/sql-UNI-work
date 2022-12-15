# we have to use two constaints becuase each constaint can affect one table

ALTER TABLE sakila.actor
ADD CONSTRAINT no_last_name_as_both_customer_and_actor
CHECK (last_name NOT IN (SELECT C.last_name FROM sakila.customer as C));


ALTER TABLE sakila.customer
ADD CONSTRAINT no_last_name_as_both_actor_and_customer
CHECK (last_name NOT IN (SELECT A.last_name FROM sakila.actor as A));
/*
 # We can create the same thing with a trigger but what I understod that you want that to be using a CONSTRAINT
CREATE TRIGGER preventDuplicateNameForActor
BEFORE INSERT ON actor
FOR EACH ROW
BEGIN
  DECLARE duplicate_name INT;
  SELECT COUNT(*) INTO duplicate_name
  FROM 
    customer
  WHERE 
    last_name = NEW.last_name;
  IF duplicate_name > 0 THEN
    # this will raise an exception
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'Duplicate first name not allowed in actor table.';
  END IF;
END;

*/
