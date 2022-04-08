CREATE INDEX index_id ON CUSTOMER USING btree(name);
CREATE INDEX index_name ON CUSTOMER USING hash(id);

--- before creating index Query plan give: "Index Only Scan using customer_pkey on customer  (cost=0.42..21.75 rows=4 width=4)"
--- after creating inxed Index Only Scan using customer_pkey on customer  (cost=0.42..21.75 rows=4 width=4)
explain select ID from CUSTOMER where ID in (12345, 24353, 65473, 13253);

--- before creating index Query plan give: "Seq Scan on customer  (cost=0.00..8565.29 rows=17972 width=4)"
--- after creating inxed Seq Scan on customer  (cost=0.00..8565.00 rows=17970 width=4)
explain select ID from CUSTOMER where Name like 'A%';

--- before creating index Query plan give: "Gather  (cost=1000.00..8108.79 rows=20 width=4);   ->  Parallel Seq Scan on customer  (cost=0.00..7106.79 rows=8 width=4)"
--- after creating inxed Gather  (cost=1000.00..8108.67 rows=20 width=4)     ->  Parallel Seq Scan on customer  (cost=0.00..7106.67 rows=8 width=4)
explain select ID from CUSTOMER where Name like '%A%[tg]';


--- In first query not change even genereted 200000 rows, but in second and third query little bit optimized