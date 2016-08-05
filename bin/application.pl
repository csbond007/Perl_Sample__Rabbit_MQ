#!/usr/bin/perl
use strict;
use warnings;
use lib './lib/InfluxDB';
use lib './lib/RabbitMQ';
use lib './lib/AWS';
use lib './lib/Utils';
use lib './lib/KairosDB';


use RabbitMQ_Processer qw(processEmails);

processEmails();
