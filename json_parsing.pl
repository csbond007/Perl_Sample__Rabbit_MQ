
use strict;
use warnings;

use JSON qw( );


my $filename = '/home/kaustav/Integration/sample.json';

my $json_text = do {
   open(my $json_fh, "<:encoding(UTF-8)", $filename)
      or die("Can't open \$filename\": $!\n");
   local $/;
   <$json_fh>
};

my $json = JSON->new;
my $data = $json->decode($json_text);

for ( @{$data->{alerts}} ) {
my $From = $_->{From} ;
my $To = $_->{To} ;
my $Subject = $_->{Subject} ;
my $Size = $_->{Size} ;

print $From;
print "\n";
print $To;
print  "\n";
print $Subject;
print "\n";
print $Size;
print  "\n";

}

