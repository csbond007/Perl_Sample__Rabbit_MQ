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

sub getConfigValueByKey {
    my ($key) = @_;
    my $value = $cfg->[0]{$cfgFile}{$key};

    if ( defined $value ) {
        return $value;
    }
    return "";
}


