package Config_Reader;
use strict;
use warnings;
use Config::Any;

use base 'Exporter';
our @EXPORT_OK = qw(getConfigValueByKey);

my $CONFIGFILE  = './config/config.yml';
my $cfgFile     = qq{$CONFIGFILE};
my @cfgFileList = ($cfgFile);
my $cfg = Config::Any->load_files( { files => \@cfgFileList, use_ext => 1 } );

use Log_Initializer qw(get_Logger);

sub getConfigValueByKey {

   my ($key) = @_;

   if( defined $key)
   {
    my $value = $cfg->[0]{$cfgFile}{$key};
     if ( defined $value ) 
      {
       get_Logger()->info("getConfigValueByKey(): $key -> $value");
       return $value;
      }
     else
      {
	get_Logger()->error("getConfigValueByKey(): value is not present");
      }

   }
   else
   {
    get_Logger()->error("getConfigValueByKey(): key is not present");
   }

    return "";
}


