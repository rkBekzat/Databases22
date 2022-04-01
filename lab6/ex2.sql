create table Author (
	author_id int not null primary key,
	first_name varchar(255),
	last_name varchar(255)
);

create table Book (
	book_id int not null primary key,
	book_title varchar(255),
	month varchar(255), 
	year int,
	editor int,
	foreign key (editor) references Author(author_id)
);

create table Pub (
	pub_id int not null primary key,
	title varchar(255),
	book_id int,
	foreign key (book_id) references Book(book_id)
);

create table AuthorPub (
	author_id int,
	foreign key (author_id) references Author(author_id),
	pub_id int,
	foreign key (pub_id) references Pub(pub_id),
	author_position int
);



insert into Author(author_id, first_name, last_name) VALUES
(1, 'John', 'McCarthy'),
(2, 'Dennis', 'Ritchie'),
(3, 'Ken', 'Thompson'),
(4, 'Claude', 'Shannon'),
(5, 'Alan', 'Turing'),
(6, 'Alonzo', 'Church'),
(7, 'Perry', 'White'),
(8, 'Moshe', 'Vardi'),
(9, 'Roy', 'Batty');

insert into Book(book_id, book_title, month, year, editor) values
(1, 'CACM', 'April', 1960, 8),
(2, 'CACM', 'July', 1974, 8),
(3, 'BTS' , 'July', 1936, 2),
(4, 'MLS' , 'November', 1936, 7),
(5, 'Mind', 'October', 1950, NULL),
(6, 'AMS' , 'Month', 1941, NULL),
(7, 'AAAI', 'July', 2012, 9),
(8, 'NIPS', 'July', 2012, 9);

insert into Pub(pub_id, title, book_id) values
(1, 'LISP', 1),
(2, 'Unix', 2),
(3, 'Info Theory', 3),
(4, 'Turing Machines', 4),
(5, 'Turing Test', 5),
(6, 'Lambda Calculus', 6);

insert into AuthorPub(author_id, pub_id, author_position) values
(1, 1, 1),
(2, 2, 1),
(3, 2, 2),
(4, 3, 1),
(5, 4, 1),
(5, 5, 1),
(6, 6, 1);

-- 1
select * from Author inner join Book on Author.author_id=Book.editor;

-- 2
select first_name, last_name from Author where author_id not in (select author_id from Author where author_id in (select editor from Book));

-- 3
select author_id from Author where author_id not in 
(select author_id from Author where author_id in (select editor from Book));

