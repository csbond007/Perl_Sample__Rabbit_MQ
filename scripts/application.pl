

use strict;
use warnings;
use 5.010;

use RabbitMQ_Send qw(send);
use RabbitMQ_Receive qw(receive);
use InfluxDB_Operations qw(write);

#send();
receive();

#print $bod;
my $filename = '/home/kaustav/Integration/sample.json';

my $json_text = do {
   open(my $json_fh, "<:encoding(UTF-8)", $filename)
      or die("Can't open \$filename\": $!\n");
   local $/;
   <$json_fh>
};

#write($json_text);
