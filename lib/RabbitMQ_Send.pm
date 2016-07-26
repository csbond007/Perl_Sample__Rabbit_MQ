
package RabbitMQ_Send;
use strict;
use warnings;
use 5.010;
use Net::RabbitFoot;
$ | ++;

use base 'Exporter';

our@ EXPORT_OK = qw(send);


sub send {

### extracting json ###

my $filename = '/home/kaustav/Integration/sample.json';

my $json_text = do {
   open(my $json_fh, "<:encoding(UTF-8)", $filename)
      or die("Can't open \$filename\": $!\n");
   local $/;
   <$json_fh>
};

my $conn = Net::RabbitFoot->new()->load_xml_spec()->connect(
    host => 'localhost',
    port => 5672,
    user => 'guest',
    pass => 'guest',
    vhost => '/',
);

    
my $chan = $conn->open_channel();

$chan->declare_queue(
    queue => 'hello1',
    durable => 1,
);  


$chan->publish(
    exchange => '',
    routing_key => 'hello1',
    body => $json_text,
);

#print " [x] Sent $json_text'\n";

$conn->close();

}
