package Log_Initializer;
use strict;
use warnings;
use Config::Any;

use Log::Log4perl;

# Initialize Logger
my $log_conf = "./config/log4perl.conf";
Log::Log4perl::init($log_conf);
my $logger = Log::Log4perl->get_logger();

use base 'Exporter';
our @EXPORT_OK = qw(get_Logger);

sub get_Logger {
    return $logger;
}

