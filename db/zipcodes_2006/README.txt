ZIP CODE DATABASE


CREDITS:
	Downloaded from one of the following websites (all the same):
	
	http://www.free-zipcodes.com
	http://www.free-zipcode.com
	http://www.free-zip-codes.com
	http://www.free-zip-code.com


TESTING YOUR DATA:

	Requirements:
		Most any version of MySQL. I tested on 3.23.54 (kind of old)
		Perl 5.8 with DBI


	1. Open each (3) .pl file and define your database/user/pass. You will see this line:
		$dbh = DBI->connect('DBI:mysql:zipcodes','YOUR_USERNAME','YOUR_PASSWORD') || die "Error connecting $DBI::errstr\n";


	2. From your command line, connect to mysql and run the 
	   SQL commands found in 'zipcode_sql.txt', then exit mysql.


	3. create a working directory like 'zipcodes' or whatever you choose


	4. install the following files into your working directory:
		- zipcodes_2006.txt
		- zip_insert.pl
		- zip_distance.pl
		- zip_range.pl


	5. Set permissions with unix command:
		> chmod 755 *.pl


	6. Execute zip_insert.pl
		> ./zip_insert.pl
		
		Now your mysql database is populated with zipcode data. Validate this
		with the SQL command:
		mysql> SELECT count(*) from zipcodes;
		
		There should be 41700 records found.


	7. Find the distance in miles between two zip codes. From the command line do the following:
		> ./zip_distance.pl 32801 32750
		
		Try it with zipcodes you are familiar with and see if it makes sense.


	8. Find all the zip codes with a certain radius (in miles)
		> ./zip_range.pl 32801 5
		
		This will show all the zip codes within 5 mile radius of 32750
		

That's all folks! Enjoy.
