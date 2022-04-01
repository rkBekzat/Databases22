
create table Suppliers(
	sid int not null primary key,
	sname varchar(255),
	address varchar(255)
);

create table Parts(
	pid int not null primary key,
	pname varchar(255),
	color varchar(255)
);

create table Catalog(
	sid int not null foreign key(sid) references Suppliers(sid),
	pid int not null foreign key(pid) references Parts(pid),
	cost real
);

insert into Suppliers (sid, sname, address)
values (1, 'Yosemite Sham',     E'Devil\'s canyon, AZ'),
       (2, 'Wiley E.Coyote',    'RR Asylum, NV'),
       (3, 'Elmer Fudd',        'Carrot Patch, MN');

insert into Parts (pid, pname, color)
values (1, 'Red1',      'Red'),
       (2, 'Red2',      'Red'),
       (3, 'Green1',    'Green'),
       (4, 'Blue1',     'Blue'),
       (5, 'Red3',      'Red');

insert into Catalog (sid, pid, cost)
values (1, 1, 10), 
	   (1, 2, 20), 
	   (1, 3, 30), 
	   (1, 4, 40), 
	   (1, 5, 50), 
	   (2, 1, 9), 
	   (2, 3, 34), 
	   (2, 5, 48);

--1
select distinct Suppliers.sname from Suppliers, Catalog, Parts 
where Suppliers.sid = Catalog.sid and Catalog.pid = Parts.pid and Parts.color = 'Red'

-- 2
select distinct Catalog.sid from Catalog, Parts 
where Catalog.pid = Parts.pid and (Parts.color = 'Red' or Parts.color = 'Green')

--3 
select distinct Suppliers.sid from Suppliers, Catalog, Parts 
where (Suppliers.sid = Catalog.sid and Catalog.pid = Parts.pid and Parts.color = 'Red') or Suppliers.address = '221 Packer Street'


-- 4
select distinct C.sid 
from Catalog C 
where not exists (
    select P.pid from Parts P where 
      (P.color = 'Red' or P.color = 'Green') 
      and (not exists (select 
      	C1.sid from Catalog C1 
          where C1.sid = C.sid and C1.pid = P.pid
        )
      )
);

-- 5
select distinct C.sid from Catalog C 
where (not exists (select P.pid from Parts P where P.color = 'Red' and (not exists (
            select C1.sid from Catalog C1 
            where C1.sid = C.sid and C1.pid = P.pid)))) 
  or (not exists (select P1.pid 
      from Parts P1 
      where P1.color = 'Green' and (not exists (select C2.sid from Catalog C2 where C2.sid = C.sid and C2.pid = P1.pid))));
      
select distinct C1.sid, C2.sid 
from Catalog C1, Catalog C2 
where C1.pid = C2.pid and C1.sid != C2.sid and C1.cost > C2.cost;

-- 6
select distinct C.pid 
from Catalog C 
where exists (select C1.sid 
    from Catalog C1 
    where C1.pid = C.pid and C1.sid != C.sid);
    
-- 7
select F.sid, F.color, avg(F.cost) as avg_cost 
from (
select p.color, C.cost, C.sid 
from Catalog C inner join parts p on p.pid = C.pid 
    where p.color = 'Red' or p.color = 'Green'
) as F 
group by F.sid, F.color;

-- 8
select distinct C1.sid from Catalog C1 where (C1.cost >= 50);