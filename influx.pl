#! /usr/bin/perl
use InfluxDB;
use AnyEvent::InfluxDB;

my $db = AnyEvent::InfluxDB->new(
    server => 'http://localhost:8086',
#    username => 'admin',
#    password => 'admin',
);


#Show the databases
$cv = AE::cv;
$db->show_databases(
    on_success => $cv,
    on_error => sub {
        $cv->croak("Failed to list databases: @_");
    }
);
my @db_names = $cv->recv;
print "$_\n" for @db_names;

## Writing Data to InfluxDB

$cv = AE::cv;
$db->write(
    database => 'Integrated_demo_1',
    consistency => 'quorum',

    data => [
        {
            measurement => 'Alerts',
            tags => {
		From    => 'kaustav.edu@gmail.com',
		To      => 'kaustav.saha@objectfrontier.com',
                Subject => 'Back_Up_Failed',
            },
            fields => {
                Size => '1.912'
            },
        }
    ],

    on_success => $cv,
    on_error => sub {
        $cv->croak("Failed to write data: @_");
    }
);

$cv->recv;

