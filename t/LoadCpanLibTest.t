use strict;
use warnings;
use Test::More 'no_plan';

use_ok('REST::Client');
use_ok('Config::Any');
use_ok('Log::Log4perl');
use_ok('JSON');
use_ok('Time::HiRes');
use_ok('AnyEvent');
use_ok('AnyEvent::InfluxDB');
use_ok('Net::RabbitFoot');
use_ok('Amazon::S3');

