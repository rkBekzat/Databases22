create table exercise1 (
	orderId int not null,
	date date,
	customerId int not null,
	customerName varchar(255),
	city varchar(255),
	itemId int not null,
	itemName varchar(255),
	quant int,
	price real,
	
	primary key (orderId, customerId, itemId)
);

insert into exercise1 (orderId, date, customerId, customerName, city, itemId, itemName, quant, price)
values 
(2301, TO_DATE('23/02/2011', 'DD/MM/YYYY'), 101, 'Martin', 'Prague', 3786, 'Net', 3, 35.00),
(2301, TO_DATE('23/02/2011', 'DD/MM/YYYY'), 101, 'Martin', 'Prague', 4011, 'Racket', 6, 65.00),
(2301, TO_DATE('23/02/2011', 'DD/MM/YYYY'), 101, 'Martin', 'Prague', 9132, 'Pack-3', 8, 4.75),
(2302, TO_DATE('25/02/2011', 'DD/MM/YYYY'), 107, 'Herman', 'Madrid', 5794, 'Pack-6', 4, 5.00),
(2303, TO_DATE('27/02/2011', 'DD/MM/YYYY'), 110, 'Pedro', 'Moscow', 4011, 'Racket', 2, 65.00),
(2303, TO_DATE('27/02/2011', 'DD/MM/YYYY'), 110, 'Pedro', 'Moscow', 3141, 'Cover', 2, 10.00);

--1NF already
select * from exercise1;

--2NF
create table orders as (select orderId, customerId, itemId, date, quant, price from exercise1);
create table customers as (select customerId, customerName, city from exercise1);
create table items as (select itemId, itemName from exercise1);

create table customersCounted as (
	select 
		customerId,
		customerName,
		city,
		ROW_NUMBER() OVER (
			PARTITION BY
				customerName,
				city
			order by
				customerName,
				city
		) row_num
	from 
		customers
);

create table customersUnique as (select customerId, customerName, city from customersCounted where row_num=1);

create table itemsCounted as (
	select 
		itemId,
		itemName,
		ROW_NUMBER() OVER (
			PARTITION BY
				itemId,
				itemName
			order by
				itemId,
				itemName
		) row_num
	from 
		items
);

create table itemsUnique as (select itemId, itemName from itemsCounted where row_num=1);

--NF2 base:
--orders, customersUnique, itemsUnique.

--NF3 - isolating cities

create table cities as (select city from customers);

create table citiesCounted as (
	select city, ROW_NUMBER() OVER (
		PARTITION BY city
		order by city
	) row_num from cities
);

create table citiesUnique as (
	select city, ROW_NUMBER() OVER (
		order by city asc
	) as cityID from citiesCounted where row_num=1
);


create table customersUniqueCities as ( 
	select customerId, customerName, citiesUnique.cityId from customersUnique
	inner join citiesUnique
	on customersUnique.city=citiesUnique.city
);
--NF3 complete
--Tables in: orders, citiesUnique, itemsUnique, customersUniqueCities

--Task 1.1
select sum(quant) from orders where orderId=2302; --Quantity of items
select sum(price) from orders where orderId=2302; --Total price for order

--Task 1.2 Look at the ID of top spender customer.
create table topSpenders as (
	select customerId, sum(price) as totalSpent from orders
	group by customerId
	order by totalSpent
);
select * from topSpenders;

