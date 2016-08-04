package InfluxDB_Operations;
use strict;
use warnings;

use InfluxDB;
use AnyEvent::InfluxDB;
use JSON qw( );
use Config_Reader qw(getConfigValueByKey);
use Log_Initializer qw(get_Logger);

use Json_Parser qw(json_parsing);

use base 'Exporter';

our @EXPORT_OK = qw(write);

sub write {

    get_Logger()->info( "Starting to write to InfluxDB" );

    my ($json_text) = @_;
   
    my $influxDBUrl = getConfigValueByKey("influxDBUrl");

    my $db = AnyEvent::InfluxDB->new( server => $influxDBUrl, );

    my @email_msg = json_parsing($json_text);

    my $cv = AE::cv;

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

        $cv->begin;

        $db->write(
            database    => getConfigValueByKey("influxDB_Name"),
            consistency => 'quorum',

            data => [
                {
                    measurement => getConfigValueByKey("influxDB_TableName"),
                    tags        => {
                        From    => $From,
                        To      => $To,
                        Subject => $Subject,
                        Id      => $Id,
                    },
                    fields => {
                        Size => $Size
                    },
                }
            ],

            on_success => $cv,
            on_error   => sub {
				get_Logger()->info( "Error in writing to InfluxDB" );
            		      }
        );    # end-write
        $cv->end;

    } # end-while
    $cv->recv;

	get_Logger()->info( "Successfully written to InfluxDB" );

}    # end write

