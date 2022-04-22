 create table accounts(
id int primary key,
name varchar(32) not null unique,
credit int not null,
currency varchar(32) not null 
);


insert into accounts values 
	(0, 'Alex', 1000, 'RUB'),
	(1,  'Roman', 1000, 'RUB'),
	(2, 'Vova', 1000, 'RUB');


begin;
UPDATE accounts SET credit = credit - 500.00 where id = 0;
UPDATE accounts SET credit = credit + 500.00 where id = 2;
savepoint t1; -- We can call rollback to t1 and we comback to this state when credits tranfered from account 1 to 2   
UPDATE accounts SET credit = credit - 700.00 where id = 1;
UPDATE accounts SET credit = credit + 700.00 where id = 0;
savepoint t2; -- 
UPDATE accounts SET credit = credit - 100.00 where id = 1;
UPDATE accounts SET credit = credit + 100.00 where id = 2;
savepoint t3; --

rollback; -- to Return Credit for all Account 


alter table accounts add column bankname varchar(32);

update accounts set bankname = 'SberBank' where id in (0, 2);
update accounts set bankname = 'Tinkoff' where id = 1;


begin;
update accounts set credit = credit - 500.00 where id = 0;
update accounts set credit = credit - 30 where id = 0 and bankname != (select bankname from accounts where id = 2);
update accounts set credit = credit + 500.00 where id = 2;
savepoint t1; -- We can call rollback to t1 and we comback to this state when credits tranfered from account 1 to 2   
update accounts set credit = credit - 700.00 where id = 1;
update accounts set credit = credit - 30 where id = 1 and bankname != (select bankname from accounts where id = 0);
update accounts set credit = credit + 700.00 where id = 0;
savepoint t2; -- 
update accounts set credit = credit - 100.00 where id = 1;
update accounts set credit = credit - 30 where id = 1 and bankname != (select bankname from accounts where id = 2);
update accounts set credit = credit + 100.00 where id = 2;
savepoint t3; --

rollback; -- to Return Credit for all Account 


create table transactions(
	id int primary key,
	from_id int references accounts(id),
	to_id int references accounts(id),
	fee int ,
	amount int not null,
	date  timestamp ,
);


create function calc_fee(id1 integer, id2 integer)
	returns integer as $$
	begin
		if (select bankname from accounts where id = id1) != (select bankname from accounts where id = id2) then
			return 30;
		else 
			return 0;
		end if;
	end;
	$$
	language plpgsql;
	

--- after modification 


begin;
update accounts set credit = credit - 500.00 where id = 0;
update accounts set credit = credit - 30 where id = 0 and bankname != (select bankname from accounts where id = 2);
insert into transactions values (0, 0, 2, calc_fee(0, 2), 500, now());
update accounts set credit = credit + 500.00 where id = 2;
savepoint t1; -- We can call rollback to t1 and we comback to this state when credits tranfered from account 1 to 2   
update accounts set credit = credit - 700.00 where id = 1;
update accounts set credit = credit - 30 where id = 1 and bankname != (select bankname from accounts where id = 0);
insert into transactions values (1, 1, 0, calc_fee(1, 0), 700, now());
update accounts set credit = credit + 700.00 where id = 0;
savepoint t2; -- 
update accounts set credit = credit - 100.00 where id = 1;
update accounts set credit = credit - 30 where id = 1 and bankname != (select bankname from accounts where id = 2);
insert into transactions values (2, 1, 2, calc_fee(1, 2), 100, now());
update accounts set credit = credit + 100.00 where id = 2;
savepoint t3; --

commit; -- to Return Credit for all Account 


