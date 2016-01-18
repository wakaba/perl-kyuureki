use strict;
use warnings;
use Kyuureki;

my $map_file_name = 'local/map.txt';
open my $map_file, '<', $map_file_name
    or die "$0: $map_file_name: $!";

my $result_file_name = 'local/test2.out';
open my $result_file, '>', $result_file_name
    or die "$0: $result_file_name: $!";

local $/ = undef;
for (split /\x0D?\x0A/, scalar <$map_file>) {
  if (/^(-?\d+)-(\d+)-(\d+)\t/) {
    my @result = gregorian_to_kyuureki (0+$1, 0+$2, 0+$3);
    my $x = sprintf "$1-$2-$3\t%04d-%02d%s-%02d\n",
        $result[0], $result[1], $result[2] ? "'" : '', $result[3];
    $x =~ s/\t-([0-9]{3})-/\t-0$1-/;
    print $result_file $x;
  }
}

close $result_file;

exec 'diff', '-u', $map_file_name, $result_file_name;
