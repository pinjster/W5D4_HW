-- functions
--CREATE FUNCTION <function_name> (<params> <param datatype>)
--REPLACE FUNCTION <function_name> ()
--RETURNS <return data type>
--LANGUAGE plpgsql AS $$
--BEGIN 
--	<functionbody>;
--END;
--$$

--Call function:
-- SELECT <name of function>(<required args>)

create function doubleNumber(num integer)
returns integer
language plpgsql as $$
	begin
		return num * 2;
	end
$$

select doubleNumber(10);

create or replace function lengthOfVarChar(word varchar)
returns integer
language plpgsql as $$
	begin
		return length(word);
	end
$$

select lengthOfVarChar(first_name)
from actor;
	
select * from rental where return_date is null;
drop function if exists payLateFee;
create function payLateFee(
	_rental_id integer, 
	_customer_id integer, 
	_staff_id integer
)
returns integer
language plpgsql as $$
	begin
		insert into payment(
			customer_id,
			staff_id,
			rental_id,
			amount,
			payment_date
		)values(
			_customer_id,
			_staff_id,
			_rental_id,
			3.00,
			now()
		);
	return _customer_id;
	end
$$
select * from rental where return_date is null;
select * from payment;

select * from customer
where customer_id = (select payLateFee(11496, 155, 1));

select * from payment where customer_id = 155 and rental_id = 11496;


-- procedures

-- create procedure <name of procedure>(<params> <datatype>)
-- as $$
-- begin
--<procedure body>;
--commit;
--end 
--$$
--language as pgsql

create or replace procedure updateReturnDate(
	rentalId integer, 
	customerId integer
) as $$
begin 
	update rental
	set return_date = current_timestamp
	where rental_id = rentalId 
	and customer_id = customerId;
	commit;
end
$$
language plpgsql;

call updateReturnDate (11496, 155);

select * from rental
where customer_id = 155 and rental_id = 11496;

create procedure updateEmail(
	newEmail varchar,
	customerId integer
) as $$
begin
	update customer 
	set email = newEmail
	where customer_id = customerId;
	commit;
end
$$
language plpgsql;

--mary.smith@sakilacustomer.org

call updateEmail('mary.smith@sakilacustomer.org', 1);

select * from customer
where customer_id = 1;

create procedure addActor(
	firstName varchar,
	lastName varchar
) language plpgsql as $$
begin
	insert into actor(
		first_name,
		last_name,
		last_update 
	)values(
		firstName,
		lastName,
		NOW()
	);
	commit;
end
$$

call addActor('Sean', 'Currie');

select *
from actor
where first_name = 'Sean' and last_name = 'Currie';

select *
from actor 
where first_name = 'Tom' and last_name = 'Hardy';

call addActor('Tom', 'Hardy');