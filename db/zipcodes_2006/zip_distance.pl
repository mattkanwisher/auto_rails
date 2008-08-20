#!/usr/bin/perl

#########################################################
# by R. Don Henning                                     #
# zip_distance.pl                                       #
#########################################################

use DBI;

#######################################################
#     PRE: two zipcodes                               #
# PROCESS: validate zipcodes,                         #
#          return error string if invalid             #
#    POST: return mileage between two zipcodes        #
#######################################################

### MAIN ##############################################

	$dbh = DBI->connect('DBI:mysql:zipcodes','YOUR_USERNAME','YOUR_PASSWORD') || die "Error connecting $DBI::errstr\n";

	my $zip1 = $ARGV[0];
	my $zip2 = $ARGV[1];
	my $miles = &zip_to_zip_distance($zip1,$zip2);
	print "$miles miles between zip codes $zip1,$zip2\n";
	
	$dbh->disconnect;

### END MAIN ##########################################

# get the distance in miles between two zipcodes
sub zip_to_zip_distance() {
	my ($zip1,
		$zip2,
		$earth_radius,
		$div,
		$count1,
		$count2,
		$miles,
		$lat1,
		$lon1,
		$lat2,
		$lon2,
		$x
		);

	$zip1 = $_[0];
	$zip2 = $_[1];

	$earth_radius = 3959;
	$div = 57.2958;

	# make sure we have valid zip codes that exist in the database
	($count1) = $dbh->selectrow_array("select count(*) from zipcodes where zipcode = $zip1");
	($count2) = $dbh->selectrow_array("select count(*) from zipcodes where zipcode = $zip2");

	if ($count1 eq '0' || $count2 eq '0') {
		$miles = "Error: Invalid Zipcode";
		$dbh->disconnect;
		exit;
	}
	else {
		# get the latitude and longitude for both zip codes
		($lat1,$lon1) = $dbh->selectrow_array("select latitude,longitude from zipcodes where zipcode = $zip1");
		($lat2,$lon2) = $dbh->selectrow_array("select latitude,longitude from zipcodes where zipcode = $zip2");

		# calculate the distance(miles) between two sets of longitude/latitude coordinates
		$x = (sin($lat1/$div) * sin($lat2/$div)) + (cos($lat1/$div) * cos($lat2/$div) * cos(($lon2/$div) - ($lon1/$div)));
		$miles = $earth_radius * atan2(sqrt(1 - ($x**2)),$x);
	
		# round float to 1 decimal place
		$miles = sprintf("%.1f",$miles);
	}
	return($miles);
}

