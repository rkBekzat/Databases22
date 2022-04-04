--Making NF3 Tables
create table publisher (
    id serial not null primary key,
    name text not null
);

create table room (
    id serial not null primary key,
    name text not null
);

create table school (
    id serial not null primary key,
    name text not null
);


create table course (
    id serial not null primary key,
    name text not null
);

create table book (
    id serial not null primary key,
    name text not null,
    publisherId integer not null references publisher(id)
);

create table teacher (
    id serial not null primary key,
    name text not null,
    schoolId integer not null references school(id),
    roomId integer not null references room(id),
    grade smallint not null
);


create table loan (
    id serial not null primary key,
    teacherId integer not null references teacher(id),
    courseId integer not null references course(id),
    bookId integer not null references book(id),
    loanDate date not null
);

-- Fill data
insert into publisher (name)
values 
('BOA Editions'),
('Taylor & Francis Publishing'),
('Prentice Hall'),
('McGraw Hill');
insert into book (name, publisherId)
values 
('Learning and teaching in early childhood', 1),
('Preschool,N56', 2),
('Early Childhood Education N9', 3),
('Know how to educate: guide for Parents', 4);
insert into school (name)
values 
('Horizon Education Institute'),
('Bright Institution');
insert into room (name)
values 
('1.A01'),
('1.B01'),
('2.B01');
insert into teacher (name, schoolId, roomId, grade)
values 
('Chad Russell', 1, 1, 1),
('E.F.Codd', 1, 2, 1),
('Jones Smith', 1, 1, 2),
('Adam Baker', 2, 3, 1);
insert into course (name)
values
('Logical thinking'),
('Wrtting'),
('Numerical Thinking'),
('Spatial, Temporal and Causal Thinking'),
('English');
insert into loan (teacherId, courseId, bookId, loanDate)
values
(1, 1, 1, '09/09/2010'),
(1, 2, 2, '05/05/2010'),
(1, 3, 1, '05/05/2010'),
(2, 4, 3, '06/05/2010'),
(2, 3, 1, '06/05/2010'),
(3, 2, 1, '09/09/2010'),
(3, 5, 4, '05/05/2010'),
(4, 1, 4, '05/05/2010'),
(4, 3, 1, '05/05/2010');

-- 2.1
select _school.name as school, _publisher.name as publisher, COUNT(*) from loan as _loan
    join teacher as _teacher on _teacher.id = _loan.teacherId
    join school as _school on _school.id = _teacher.schoolId
    join book as _book on _book.id = _loan.bookId
    join publisher as _publisher on _publisher.id = _book.publisherId
group by (_school.id, _publisher.id);
-- 2.2
select _school.name as school, _book.name as book, _teacher.name as teacher from loan as _loan
    join teacher as _teacher on _teacher.id = _loan.teacherId
    join school as _school on _school.id = _teacher.schoolId
    join book as _book on _book.id = _loan.bookId
    join publisher as _publisher on _publisher.id = _book.publisherId
    join (select _school.id, min(_loan.loanDate) from loan as _loan 
			join teacher as _teacher on _teacher.id = _loan.teacherId
            join school as _school on _school.id = _teacher.schoolId
        group by _school.id
    ) as m on m.id = _school.id where _loan.loanDate = m.min;