
package RabbitMQ_new_task;
use strict;
use warnings;
use 5.010;
use Net::RabbitFoot;
$ | ++;

use base 'Exporter';

our@ EXPORT_OK = qw(new_task);


sub new_task {

	    ### extracting json ###

	    my $filename = '/home/kaustav/EmailAlertsAnalyzer/data/sample.json';

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
				  queue => 'task_queue',
				  durable => 1,
				 );  

	     my $msg = join(' ', @ARGV) || "Hello World!";

	     $chan->publish(
   			    exchange => '',
                            routing_key => 'task_queue',
                            body => $msg,
			   );

	     print " [x] Sent $msg'\n";

	     $conn->close();

} # end new_task
