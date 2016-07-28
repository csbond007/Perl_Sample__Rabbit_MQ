package Json_Parser;
use strict;
use warnings;
use JSON qw( );

use base 'Exporter';

our @EXPORT_OK = qw(json_parsing);

sub json_parsing {

    my ($json_text) = @_;

    my $json = JSON->new;
    my $data = $json->decode($json_text);

    my $From;
    my $To;
    my $Subject;
    my $Id;
    my $Size;

    my @email_msg;

    for ( @{ $data->{alerts} } ) {

        $From    = $_->{From};
        $To      = $_->{To};
        $Subject = $_->{Subject};
        $Id      = $_->{Id};
        $Size    = $_->{Size};

        my @part_msg;

        push @part_msg, $From, $To, $Subject, $Id, $Size;

        push( @email_msg, @part_msg );

    }

    return @email_msg;
}    # end json_parsing

