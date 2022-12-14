ALTER TABLE sakila.customer  ADD CONSTRAINT CK_Last_Name_CUS
    CHECK (last_name <> (
		SELECT DISTINCT(A.last_name) FROM sakila.actor as A
	)
);
/**
ALTER TABLE sakila.actor  ADD CONSTRAINT CK_Last_Name_AC
    CHECK (last_name NOT IN (
		SELECT DISTINCT(C.last_name) FROM sakila.actor as C
	)
);
**/