package KairosDB_REST_Operations;
use strict;
use warnings;
use REST::Client;

use Config_Reader qw(getConfigValueByKey);
use Json_Parser qw(json_parsing);
use JSON qw( decode_json );
use Time::HiRes qw(gettimeofday);
use base 'Exporter';

our @EXPORT_OK = qw(addDataPoints);

my $client = REST::Client->new();
$client->setHost( getConfigValueByKey("kairosDBRestUrl") );


sub addDataPoints {
	 my ($json_text) = @_;
         my $data = "[";
         my @email_msg = json_parsing($json_text);

         while (@email_msg) {

		my $Size    = pop @email_msg;
		my $Id      = pop @email_msg;
		my $Subject = pop @email_msg;
		my $To      = pop @email_msg;
		my $From    = pop @email_msg;
                my $timestamp = int (gettimeofday * 1000);

                my $tempdata = "{
			\"name\": \"EmailAlerts\",
			\"timestamp\": \"$timestamp\",
			\"type\":\"string\",
			\"value\":\"$Subject\",
			\"tags\": {
				\"Size\":\"$Size\",
				\"Id\": \"$Id\",
				\"Subject\": \"$Subject\",
				\"To\": \"$To\",
				\"From\":\"$From\"
		       	        }
		      }";
               $data .= $tempdata .",";
         }

        chop($data);
        $data .= "]";
	$client->POST( '/api/v1/datapoints', $data,{ "Content-type" => 'application/json' } );
}

