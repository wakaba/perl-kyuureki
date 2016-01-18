use strict;
use warnings;
use Kyuureki;

my $map_file_name = 'local/map.txt';
open my $map_file, '<', $map_file_name
    or die "$0: $map_file_name: $!";

my $result_file_name = 'local/test1.out';
open my $result_file, '>', $result_file_name
    or die "$0: $result_file_name: $!";

local $/ = undef;
for (split /\x0D?\x0A/, scalar <$map_file>) {
  if (/\t(-?\d+)-(\d+)('|)-(\d+)$/) {
    my @result = kyuureki_to_gregorian ($1, $2, $3, $4);
    my $x = sprintf "%04d-%02d-%02d\t$1-$2$3-$4\n",
        $result[0], $result[1], $result[2];
    $x =~ s/^-([0-9]{3})-/-0$1-/;
    print $result_file $x;
  }
}

close $result_file;

exec 'diff', '-u', $map_file_name, $result_file_name;
