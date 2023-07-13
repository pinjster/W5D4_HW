--USED ON DVD RENTAL
-- Function
CREATE FUNCTION fullNameLength(fname varchar, lname varchar)
RETURNS integer
LANGUAGE plpgsql AS $$
BEGIN 
	RETURN length(fname) + length(lname); 
END
$$

SELECT fullNameLength(first_name, last_name)
FROM actor;
-- (15, 12, 7, 13, 18, 14 ..)

-- Procedure
CREATE OR REPLACE PROCEDURE updateCustomerPhoneNo(fname varchar, lname varchar, newNo varchar)
AS $$
BEGIN
	UPDATE address 
	SET phone = newNo
	WHERE address_id IN (
		SELECT address_id
		FROM customer
		WHERE customer.first_name = fname 
		AND customer.last_name = lname
	);
	COMMIT;
END
$$
LANGUAGE plpgsql;

CALL updateCustomerPhoneNo('Mary','Smith','1234567890');

SELECT first_name, last_name, phone
FROM customer
JOIN address
ON address.address_id = customer.address_id
WHERE first_name = 'Mary' AND last_name = 'Smith';
-- Output: Mary | Smith | 1234567890


