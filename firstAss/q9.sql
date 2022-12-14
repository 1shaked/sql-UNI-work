# we have to use two constaints becuase each constaint can affect one table

ALTER TABLE sakila.actor
ADD CONSTRAINT no_last_name_as_both_customer_and_actor
CHECK (last_name NOT IN (SELECT C.last_name FROM sakila.customer as C));


ALTER TABLE sakila.customer
ADD CONSTRAINT no_last_name_as_both_actor_and_customer
CHECK (last_name NOT IN (SELECT A.last_name FROM sakila.actor as A));

