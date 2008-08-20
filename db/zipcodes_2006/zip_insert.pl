#!/usr/bin/perl

#########################################################
# by R. Don Henning                                     #
# zip_insert.pl                                         #
# Assuming you've created the database and table for    #
# zipcodes, you can now insert the data from the source #
#########################################################

use DBI;

### MAIN ################################################

	$dbh = DBI->connect('DBI:mysql:zipcodes','YOUR_USERNAME','YOUR_PASSWORD') || die "Error connecting $DBI::errstr\n";
	
	open (IN, "< zipcodes_2006.txt");
	@ZIPS = <IN>;
	close(IN);

	foreach (@ZIPS) {
		($Zipcode,$Latitude,$Longitude,$State,$City,$County) = split(/\|\|/,$_);
		chomp($County); # kill the trailing newline
		
		### INSERT
		$query = "INSERT INTO zipcodes VALUES ($Zipcode,$Latitude,$Longitude,'$State','$City','$County')";
		$sth = $dbh->prepare($query);
		$sth->execute();
	}
	
	print "Database populated.\n";
	
	$dbh->disconnect;

### END #################################################
