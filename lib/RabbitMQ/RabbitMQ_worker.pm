
package RabbitMQ_worker;
use strict;
use warnings;
use Net::RabbitFoot;
use AnyEvent;
$|++;

use InfluxDB_Operations qw(write);
use AWS qw(put_S3);
use Config_Reader qw(getConfigValueByKey);

use base 'Exporter';

our @EXPORT_OK = qw(worker);

use Log_Initializer qw(get_Logger);

sub worker {

    get_Logger()->info("Starting Worker ");

    my	$conn = Net::RabbitFoot->new()->load_xml_spec()->connect(
 								host  => getConfigValueByKey("rabbitMQHost"),
							        port  => getConfigValueByKey("rabbitMQport"),
							        user  => getConfigValueByKey("rabbitMQuser"),
							        pass  => getConfigValueByKey("rabbitMQpass"),
							        vhost => '/',
							        );
    my $ch = $conn->open_channel();

    $ch->declare_queue(
        		queue   => getConfigValueByKey("rabbitMQName_worker"),
		        durable => 1,
    		      );

    print " [*] Waiting for messages. To exit press CTRL-C\n";

    sub callback {
	           get_Logger()->info("Inside worker call-back ");

        	   my $var  = shift;
                   my $body = $var->{body}->{payload};
                   print " [x] Received \n"; #  $body \n";

                   print " [x] Done\n";
                   $ch->ack();

		   get_Logger()->info("Writing the records into InfluxDB ");
	           # write($body);

		   get_Logger()->info("Writing the files into AWS-S3 buckets "); 
                   # put_S3($body);
                 } # end call back

    $ch->qos(prefetch_count => 1,);

    $ch->consume(
    		  on_consume => \&callback,
        	  no_ack     => 0,
                );

    AnyEvent->condvar->recv;

}  # end worker


