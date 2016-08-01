#!/usr/bin/perl
use strict;
use warnings;
use lib './lib/InfluxDB';
use lib './lib/kairosDB';
use lib './lib/RabbitMQ';
use lib './lib/AWS';
use lib './lib/Utils';

#use RabbitMQ_Send qw(send);
#use RabbitMQ_Receive qw(receive);
use RabbitMQ_worker qw(worker);


#send();
#receive();
worker();

