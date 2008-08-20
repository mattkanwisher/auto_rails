#!/usr/bin/perl

#########################################################
# by R. Don Henning                                     #
# zip_range.pl                                          #
#########################################################

use DBI;

### MAIN ################################################

	$dbh   = DBI->connect('DBI:mysql:zipcodes','YOUR_USERNAME','YOUR_PASSWORD') || die "Error connecting $DBI::errstr\n";

	$zip   = $ARGV[0]; # on the command line, enter zip code as first arg
	$range = $ARGV[1]; # on the command line, enter mile range as second arg
	
	($lat,$lon) = $dbh->selectrow_array("select latitude,longitude from zipcodes where zipcode = '$zip'");

	$lat_range = ($range/69.172);
	$lon_range = abs($range/(cos($lon) * 69.172));

	$min_lat   = $lat - $lat_range;
	$max_lat   = $lat + $lat_range;
	$min_lon   = $lon - $lon_range;
	$max_lon   = $lon + $lon_range;

	$query     = "select zipcode from zipcodes where latitude BETWEEN $min_lat AND $max_lat AND longitude BETWEEN $min_lon AND $max_lon";
	$sth       = $dbh->prepare($query);
	$sth->execute();
	while ( @row = $sth->fetchrow_array(  ) ) {
		push(@zip_in_range,$row[0]);
	}
	
	foreach (@zip_in_range) {
		print $_ . "\n";
	}

	$dbh->disconnect;

	exit;

### END #################################################

