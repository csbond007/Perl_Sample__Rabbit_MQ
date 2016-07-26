
#! /usr/bin/perl

use strict;
use warnings;

use InfluxDB;
use AnyEvent::InfluxDB;
use JSON qw( );

## S3 Initialization
use Amazon::S3;

my $aws_access_key_id     = "";
my $aws_secret_access_key = "";

my $s3 = Amazon::S3->new(
    {   aws_access_key_id     => $aws_access_key_id,
        aws_secret_access_key => $aws_secret_access_key,
        retry                 => 1
    }
);
#####


my $db = AnyEvent::InfluxDB->new(
    server => 'http://localhost:8086',
);


my $filename = '/home/kaustav/Integration/sample.json';

my $json_text = do {
   open(my $json_fh, "<:encoding(UTF-8)", $filename)
      or die("Can't open \$filename\": $!\n");
   local $/;
   <$json_fh>
};

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
    		database => 'Integrated_demo_1',
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

## Dumping to S3

# create a bucket
my $bucket_name = $aws_access_key_id . 'new_json_2';
my $bucket = $s3->add_bucket( { bucket => $bucket_name } )
    or die $s3->err . ": " . $s3->errstr;

$bucket->add_key(
        'my_json1.json', $json_text,
        { content_type => 'text/plain' },
);

