#!/usr/bin/perl
use strict;
use warnings;
use lib './lib/InfluxDB';
use lib './lib/RabbitMQ';
use lib './lib/AWS';
use lib './lib/Utils';

#use RabbitMQ_Send qw(send);
#use RabbitMQ_Receive qw(receive);
use RabbitMQ_worker qw(worker);

use Log_Initializer qw(get_Logger);

get_Logger()->info("Starting Application.pl ");

#send();
#receive();
worker();

