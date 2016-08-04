package KairosDB_REST_Operations;
use strict;
use warnings;
use REST::Client;

use Config_Reader qw(getConfigValueByKey);
use Json_Parser qw(json_parsing);
use JSON qw( decode_json );
use Time::HiRes qw(gettimeofday);
use Log_Initializer qw(get_Logger);

use base 'Exporter';

our @EXPORT_OK = qw(addDataPoints);

my $client = REST::Client->new();
$client->setHost( getConfigValueByKey("kairosDBRestUrl") );


sub addDataPoints {
         
	 get_Logger()->info( "Starting to write to KairosDB" );

	 my ($json_text) = @_;

         if( defined $json_text) {
		 my $data = "[";
		 my @email_msg = json_parsing($json_text);

		 while (@email_msg) {

        		my $Size    ;
        		my $Id      ;
        		my $Subject ;
        		my $To      ;
        		my $From    ;

        		if (@email_msg > 0) { $Size       = pop @email_msg; } else { get_Logger()->info( "Size field missing - Empty field in msg" ); }
        		if (@email_msg > 0) { $Id         = pop @email_msg; } else { get_Logger()->info( "Id field missing - Empty field in msg" ); }
        		if (@email_msg > 0) { $Subject    = pop @email_msg; } else { get_Logger()->info( "Subject field missing -Empty field in msg" ); }
        		if (@email_msg > 0) { $To         = pop @email_msg; } else { get_Logger()->info( "To field missing - Empty field in msg" ); }
      			if (@email_msg > 0) { $From       = pop @email_msg; } else { get_Logger()->info( "From field missing -Empty field in msg" ); }

		        my $timestamp = int (gettimeofday * 1000);
			my $metricName = getConfigValueByKey("kairosDBMetricName");

		        my $tempdata = "{
				\"name\": \"$metricName\",
				\"timestamp\": \"$timestamp\",
				\"type\":\"long\",
				\"value\":\"$Size\",
				\"tags\": {
					\"Size\":\"$Size\",
					\"Id\": \"$Id\",
					\"Subject\": \"$Subject\",
					\"To\": \"$To\",
					\"From\":\"$From\"
			       	        }
			      }";
		       $data .= $tempdata .",";
		 } # end while

		chop($data);
		$data .= "]";
		$client->POST( '/api/v1/datapoints', $data,{ "Content-type" => 'application/json' } );

		if( $client->responseCode() eq '204' )
		 {
		   get_Logger()->info( " Successfully posted to client in KairosDB Operations" );
 		 }
                else
                 {
		   get_Logger()->error( " Error while posting to client in KairosDB Operations" );
		   get_Logger()->error( " Error Response Content : $client->responseContent()");
		 }
        } # end if

   get_Logger()->info( "End of KairosDB Operations" );

} # addDataPoints

