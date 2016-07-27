package AWS;
use strict;
use warnings;

use JSON qw( );

## S3 Initialization
use Amazon::S3;

use Json_Parser qw(json_parsing);

use base 'Exporter';

our @EXPORT_OK = qw(put_S3);

sub put_S3 {

    my ($json_text) = @_;

    my $aws_access_key_id     = "";
    my $aws_secret_access_key = "";

    my $s3 = Amazon::S3->new(
        {
            aws_access_key_id     => $aws_access_key_id,
            aws_secret_access_key => $aws_secret_access_key,
            retry                 => 1
        }
    );

    my @email_msg = json_parsing($json_text);

    while (@email_msg) {

        my $Size    = pop @email_msg;
        my $Id      = pop @email_msg;
        my $Subject = pop @email_msg;
        my $To      = pop @email_msg;
        my $From    = pop @email_msg;
        my $Formatted_msg =
            $From . "\n"
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

    }

} # end put_S3

