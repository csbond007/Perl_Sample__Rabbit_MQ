package AWS;
use strict;
use warnings;

use Amazon::S3;
use JSON qw( );
use Config_Reader qw(getConfigValueByKey);
use Json_Parser qw(json_parsing);
use Log_Initializer qw(get_Logger);

use base 'Exporter';

our @EXPORT_OK = qw(put_S3);

sub put_S3 {
	
    get_Logger()->info( "Starting to write to AWS" );

    my ($json_text) = @_;

    my $aws_access_key_id     = getConfigValueByKey("awsAccessKeyId");;
    my $aws_secret_access_key = getConfigValueByKey("awsSecretAccessKey");;

    my $s3 = Amazon::S3->new(
        {
            aws_access_key_id     => $aws_access_key_id,
            aws_secret_access_key => $aws_secret_access_key,
            retry                 => 1
        }
    );

    if( defined $json_text) {

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

		my $Formatted_msg = $From . "\n"
				  . $To . "\n"
		  		  . $Subject . "\n"
		                  . $Id . "\n"
		                  . $Size . "\n";

		my $bucket_name = $Subject;
		my $bucket = $s3->add_bucket( { bucket => $bucket_name } )
		  or die $s3->err . ": " . $s3->errstr;

		my $json_filename = $Id . '.json';
		$bucket->add_key( $json_filename, $Formatted_msg,
		    { content_type => 'text/plain' },
		);

	    } # end while
    } # end if

    get_Logger()->info( "Finished writing to AWS" );

} # end put_S3

