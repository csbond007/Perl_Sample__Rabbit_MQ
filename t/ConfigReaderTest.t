use strict;
use warnings;
use Test::More qw(no_plan);
use Config_Reader qw(getConfigValueByKey);

use lib './lib/Utils';

BEGIN {
 use_ok('Config_Reader');
};

require_ok ('Config_Reader') ;

# Test getConfigValueByKey() with empty values.
ok( getConfigValueByKey("") eq "" ,"Empty Check");


#InfluxDB Configurations

# Test getConfigValueByKey() with influxDBUrl parameter.
ok( getConfigValueByKey("influxDBUrl") ne "","InfluxDBUrl Configuration");

# Test getConfigValueByKey() with influxDBUserName parameter.
ok( getConfigValueByKey("influxDBUserName") ne "","InfluxDBUserName Configuration");

# Test getConfigValueByKey() with influxDBUserPassword parameter.
ok( getConfigValueByKey("influxDBUserPassword") ne "","InfluxDB User Password Configuration");

# Test getConfigValueByKey() with influxDB_Name parameter.
ok( getConfigValueByKey("influxDB_Name") ne "","InfluxDB Name Configuration");

# Test getConfigValueByKey() with influxDBUserPassword parameter.
ok( getConfigValueByKey("influxDB_TableName") ne "","InfluxDB TableName Configuration");


#AWS S3 

# Test getConfigValueByKey() with awsS3Enable parameter.
#ok( getConfigValueByKey("awsS3Enable") eq true,"awsS3Enable Configuration");

# Test getConfigValueByKey() with awsAccessKeyId parameter.
ok( getConfigValueByKey("awsAccessKeyId") ne "","awsAccessKeyId Configuration");

# Test getConfigValueByKey() with awsSecretAccessKey parameter.
ok( getConfigValueByKey("awsSecretAccessKey") ne "","awsSecretAccessKey Configuration");


#RabbitMQ

# Test getConfigValueByKey() with rabbitMQHost parameter.
ok( getConfigValueByKey("rabbitMQHost") ne "","RabbitMQ Host Configuration");

# Test getConfigValueByKey() with rabbitMQport parameter.
ok( getConfigValueByKey("rabbitMQport") ne "","RabbitMQ port Configuration");

# Test getConfigValueByKey() with rabbitMQuser parameter.
ok( getConfigValueByKey("rabbitMQuser") ne "","RabbitMQ user Configuration");

# Test getConfigValueByKey() with rabbitMQpass parameter.
ok( getConfigValueByKey("rabbitMQpass") ne "","RabbitMQ password Configuration");

# Test getConfigValueByKey() with rabbitMQName parameter.
ok( getConfigValueByKey("rabbitMQName") ne "","RabbitMQ Name Configuration");



#KairosDB

# Test getConfigValueByKey() with rabbitMQHost parameter.
ok( getConfigValueByKey("kairosDBRestUrl") ne "","kairosDB Rest Url  Configuration");

# Test getConfigValueByKey() with kairosDBMetricName parameter.
ok( getConfigValueByKey("kairosDBMetricName") ne "","kairosDB Metric Name  Configuration");











