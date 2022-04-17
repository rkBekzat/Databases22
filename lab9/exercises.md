 
Exercise 1 <br>	
	create or replace function retrieve_address() <br>
		returns setof character varying  as  <br>
	$$ <br>
		select address from address where city_id between 400 and 600 and address like '%11%';<br>
	$$<br>
	language sql;<br>
<br>
from xml.etree.ElementTree import tostring <br>
import psycopg2 <br>
from geopy.geocoders import Nominatim <br>
 <br>
conn = psycopg2.connect(user = "postgres", password = "qazqwerty123", host = "127.0.0.1", <br>			port = "5432", database = "test") <br>
<br>
cur = conn.cursor() <br>
cur.execute('alter table address add column latitude VARCHAR(30), add column longitude<br>   VARCHAR(30);')<br>
cur.execute('select retrieve_address();')<br>
<br>
records = cur.fetchall()<br>
<br>
for row in records:<br>
    locator = Nominatim(user_agent='myGeocoder') <br>
    latitude = '' <br>
    longitude = ''<br>
    address = row[0]<br>
    print(address)<br>
    try:<br>
        location = locator.geocode(address)<br>
        latitude = location.latitude<br>
        longitude = location.longitude<br>
    except:<br>
        latitude = '0'<br>
        longitude = '0'<br>
    longitude=str(longitude)<br>
    latitude=str(latitude)<br>
    cur.execute("update address set latitude='" + latitude + "', longitude='" + longitude +"' where address='" + address + "';")<br>
conn.commit()<br>
cur.close<br>
conn.close<br>

<br>
	<br>
Exercise 2<br>

<br>
create or replace function retrieve_customers(start_pos smallint, end_pos smallint)<br>
	returns SETOF record<br>
	language 'plpgsql'<br>
	as $$<br>
	begin	<br>
		if start_pos < 0 OR start_pos > 600 OR end_pos < 0 OR end_pos > 600 then<br>
				select * from customer where address_id between start_pos and end_pos <br>
					order by address_id;<br>
		else<br>
			raise 'ERROR: start or end position is negative number or more than 600';<br>
		end if;<br>
	end<br>
	$$<br>