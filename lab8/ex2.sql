
--- 2.1
select film.title
from film, film_category, category 
where (film.film_id = film_category.film_id and film_category.category_id = category.category_id and 
	   (category.name = 'Horror' or category.name = 'Sci-fi') and (film.rating = 'R' or film.rating = 'PG-13') and 
	  not exists (select * from inventory, rental 
				 where film.film_id = inventory.film_id and inventory.inventory_id = rental.inventory_id)) 
