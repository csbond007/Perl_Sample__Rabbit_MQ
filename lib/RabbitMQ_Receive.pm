
package RabbitMQ_Receive;
use strict;
use warnings;
use 5.010;
use Net::RabbitFoot;
use AnyEvent;
$|++; 

use InfluxDB_Operations qw(write);
use AWS qw(put_S3);

use base 'Exporter';

our@ EXPORT_OK = qw(receive);

sub receive {

		my $conn = Net::RabbitFoot->new()->load_xml_spec()->connect(
									    host => 'localhost',
    									    port => 5672,
    									    user => 'guest',
    									    pass => 'guest',
    									    vhost => '/',
									   );

		my $ch = $conn->open_channel();
    
		$ch->declare_queue(
    				    queue => 'hello1',
    				    durable => 1, 
				  );

		print " [*] Waiting for messages. To exit press CTRL-C\n";

		sub callback {
    				my $var = shift;
			        my $body = $var->{body}->{payload};
    				print " [x] Received \n"; # $body \n";
    				write($body);
    				put_S3($body);
			     }

		$ch->consume(
			    on_consume => \&callback,
    			    no_ack => 1,
			    );

		# Wait forever
		AnyEvent->condvar->recv;

		} # end receive

