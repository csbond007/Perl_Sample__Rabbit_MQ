
package RabbitMQ_Receive;
use strict;
use warnings;
use Net::RabbitFoot;
use AnyEvent;
$|++;

use InfluxDB_Operations qw(write);
use Config_Reader qw(getConfigValueByKey);
use AWS qw(put_S3);


use base 'Exporter';

our @EXPORT_OK = qw(receive);

sub receive {

    my $conn = Net::RabbitFoot->new()->load_xml_spec()->connect(
        host  => getConfigValueByKey("rabbitMQHost"),
        port  => getConfigValueByKey("rabbitMQport"),
        user  => getConfigValueByKey("rabbitMQuser"),
        pass  => getConfigValueByKey("rabbitMQpass"),
        vhost => '/',
    );

    my $ch = $conn->open_channel();

    $ch->declare_queue(
        queue   => getConfigValueByKey("rabbitMQName"),
        durable => 1,
    );

    print " [*] Waiting for messages. To exit press CTRL-C\n";

    sub callback {
        my $var  = shift;
        my $body = $var->{body}->{payload};
        print " [x] Received \n";
        
        #Write the records into InfluxDB
        write($body);
 	
	#Write the files into AWS-S3 buckets
        #put_S3($body);
    }

    $ch->consume(
        on_consume => \&callback,
        no_ack     => 1,
    );

    AnyEvent->condvar->recv;

}  # end receive


