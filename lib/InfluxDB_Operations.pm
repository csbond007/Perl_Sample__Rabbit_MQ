package InfluxDB_Operations;
use strict;
use warnings;

use InfluxDB;
use AnyEvent::InfluxDB;
use JSON qw( );

use Json_Parser qw(json_parsing);

use base 'Exporter';

our @EXPORT_OK = qw(write);

sub write {

    my ($json_text) = @_;

    my $db = AnyEvent::InfluxDB->new( server => 'http://localhost:8086', );

    my @email_msg = json_parsing($json_text);

    my $cv = AE::cv;

    while (@email_msg) {

        my $Size    = pop @email_msg;
        my $Id      = pop @email_msg;
        my $Subject = pop @email_msg;
        my $To      = pop @email_msg;
        my $From    = pop @email_msg;

        $cv->begin;

        $db->write(
            database    => 'Demo',
            consistency => 'quorum',

            data => [
                {
                    measurement => 'Alerts',
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
                $cv->croak("Failed to write data: @_");
            }
        );    # end-write
        $cv->end;

    } # end-while
    $cv->recv;
}    # end write

