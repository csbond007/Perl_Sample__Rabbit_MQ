use strict;
use warnings;
use Test::More qw(no_plan);

use lib './lib/AWS';
use lib './lib/Utils';

 
BEGIN { use_ok('Config_Reader') };
BEGIN { use_ok('Json_Parser') };
BEGIN { use_ok('AWS') };



require_ok ('Config_Reader') ;
require_ok ('Json_Parser') ;
require_ok( 'AWS' );

# Test put_S3
my $putS3 = AWS::put_S3();
is($putS3, "", "put_S3() empty parameter");
