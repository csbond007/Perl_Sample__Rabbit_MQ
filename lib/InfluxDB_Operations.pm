
package InfluxDB_Operations;
use strict;
use warnings;

use InfluxDB;
use AnyEvent::InfluxDB;
use JSON qw( );


use base 'Exporter';

our@ EXPORT_OK = qw(write);


sub write {
print "i am write" ;
my ($json_text) = @_;

my $db = AnyEvent::InfluxDB->new(
    server => 'http://localhost:8086',
);

my $json = JSON->new;
my $data = $json->decode($json_text);

my $cv = AE::cv;

for ( @{$data->{alerts}} )
  {
        $cv = AE::cv;

        my $From = $_->{From} ;
        my $To = $_->{To} ;
        my $Subject = $_->{Subject} ;
        my $Size = $_->{Size} ;

## Writing Data to InfluxDB
 $db->write(
                database => 'Integrated_demo_3',
                consistency => 'quorum',

                data => [
                                {
                                    measurement => 'Alerts',
                                           tags => {
                                                    From    => $From,
                                                    To      => $To,
                                                    Subject => $Subject,
                                                   },
                                         fields => {
                                                    Size => $Size
                                                   },
                                 }
                        ],

                on_success => $cv,
                on_error => sub {
                                $cv->croak("Failed to write data: @_");
                                }
                ); # end-write

        $cv->recv;
  }  # end for 

}
