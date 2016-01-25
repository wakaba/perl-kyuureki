use strict;
use warnings;

my $type = shift;
my $map_file_name;
if ($type eq 'kyuureki') {
  $map_file_name = "local/map.txt";
} elsif ($type eq 'rkyuureki') {
  $map_file_name = "local/rmap.txt";
} else {
  die "Bad type |$type|";
}

my $FirstYear;
my $LastYear;

my $Data = {};

open my $map_file, '<', $map_file_name or die "$0: $map_file_name: $!";
my $last_seireki_date;
local $/ = undef;
for (split /\x0D?\x0A/, scalar <$map_file>) {
  if (/^([\d'-]+)\t([\d'-]+-01)$/) {
    my $G = $1;
    my $Q = $2;
    if ($Q =~ /^(-?[0-9]+)-01-01$/) {
      $FirstYear //= 0+$1;
      $LastYear = 0+$1;
      $Data->{kyuureki_year_to_gregorian_date}->[$1 - $FirstYear] = $G;
    }
  }
  if (/^([\d'-]+)\t(([\d'-]+)-[0-9]+)$/) {
    $Data->{kyuureki_month_to_day_number}->{$3}++;
    if ($3 =~ /^(-?[0-9]+)-([0-9]+)'$/) {
      $Data->{kyuureki_year_to_leap_month}->[$1 - $FirstYear] = $2;
    }
    $last_seireki_date = $1;
  }
}
if ($last_seireki_date =~ /^(-?\d+)-(\d+)-(\d+)$/) {
  $Data->{kyuureki_year_to_gregorian_date}->[$1 - $FirstYear]
      = sprintf '%04d-%02d-%02d', $1, $2, $3+1;
}

$Data->{kyuureki_year_to_gregorian_date} = join '', map {
  if (/-01-([0-9]{2})$/) {
    pack 'C', $1
  } elsif (/-02-([0-9]{2})$/) {
    pack 'C', 31 + $1;
  } else {
    die $_;
  }
} @{$Data->{kyuureki_year_to_gregorian_date}};

$Data->{kyuureki_year_to_leap_month}->[$LastYear + 1 - $FirstYear] ||= 0;
$Data->{kyuureki_year_to_leap_month} = join '', map { sprintf '%X', ($_ || 0) } @{$Data->{kyuureki_year_to_leap_month}};

for (sort { $a cmp $b } keys %{$Data->{kyuureki_month_to_day_number}}) {
  /^(-?[0-9]+)-/ or die $_;
  my $year = $1;
  my $value = $Data->{kyuureki_month_to_day_number}->{$_};
  my $vector = $Data->{kyuureki_year_to_month_types}->[$year - $FirstYear];
  if ($value == 30) {
    $vector .= '1';
  } elsif ($value == 29) {
    $vector .= '0';
  } else {
    die "$_ has $value days";
  }
  $Data->{kyuureki_year_to_month_types}->[$year - $FirstYear] = $vector;
}
delete $Data->{kyuureki_month_to_day_number};

for (@{$Data->{kyuureki_year_to_month_types}}) {
  $_ = (pack 'B8', '0'.substr $_, 0, 7) . (pack 'B8', '0'.substr $_.'000000', 7, 7);
}
$Data->{kyuureki_year_to_month_types} = join '', @{$Data->{kyuureki_year_to_month_types}};

$Data->{year_range} = [$FirstYear, $LastYear];

$Data->{gregorian_month_to_offset} = [
  undef,
  0,
  31,
  31+28,
  31+28+31,
  31+28+31+30,
  31+28+31+30+31,
  31+28+31+30+31+30,
  31+28+31+30+31+30+31,
  31+28+31+30+31+30+31+31,
  31+28+31+30+31+30+31+31+30,
  31+28+31+30+31+30+31+31+30+31,
  31+28+31+30+31+30+31+31+30+31+30,
  31+28+31+30+31+30+31+31+30+31+30+31,
];

my $perl_code = q{
package %%MOD%%;
use strict;
use warnings;
our $VERSION = '2.0';
use Carp qw(croak);

our @EXPORT = qw(gregorian_to_%%NAME%% %%NAME%%_to_gregorian);

sub import ($;@) {
  my $from_class = shift;
  my ($to_class, $file, $line) = caller;
  no strict 'refs';
  for (@_ ? @_ : @{$from_class . '::EXPORT'}) {
    my $code = $from_class->can ($_)
        or croak qq{"$_" is not exported by the $from_class module at $file line $line};
    *{$to_class . '::' . $_} = $code;
  }
} # import

use constant MONTH_TO_OFFSET => $Data->{gregorian_month_to_offset};
use constant FIRST_GREGORIAN_DAY => $Data->{kyuureki_year_to_gregorian_date};
use constant MONTH_TYPES => $Data->{kyuureki_year_to_month_types};
use constant LEAP_MONTH => $Data->{kyuureki_year_to_leap_month};
use constant MIN_YEAR => $Data->{year_range}->[0];
use constant MAX_YEAR => $Data->{year_range}->[1];

sub gregorian_to_%%NAME%% ($$$) {
  my ($y, $m, $d) = @_;
  return (undef, undef, undef, undef)
      if $y < MIN_YEAR or MAX_YEAR + 1 < $y or ($y == MAX_YEAR + 1 and $m > 2);

  my $day = $d + MONTH_TO_OFFSET->[$m];
  my $is_leap_year = (($y % 4) == 0 and
                      not (($y % 100 == 0) and not ($y % 400 == 0)));
  $day++ if $is_leap_year and $m > 2;

  my $offset = MIN_YEAR;
  my $first_day = unpack 'C', substr FIRST_GREGORIAN_DAY,
      $y - $offset, 1;

  if ($day < $first_day) {
    $y--;
    $day += 365;
    $is_leap_year = (($y % 4) == 0 and
                     not (($y % 100 == 0) and not ($y % 400 == 0)));
    $day++ if $is_leap_year;
    $first_day = unpack 'C', substr FIRST_GREGORIAN_DAY,
        $y - $offset, 1;
  }
  $day -= $first_day - 1;

  my $mt = substr MONTH_TYPES,
      2*($y - $offset), 2;
  $mt = (substr unpack ('B8', (substr $mt, 0, 1)), 1).
        (substr unpack ('B8', (substr $mt, 1, 1)), 1);

  my $leap_month = hex substr LEAP_MONTH,
      $y - $offset, 1;

  my $month = 1;
  {
    my $days = (substr $mt, $month-1, 1) ? 30 : 29;
    if ($day <= $days or $month == 13) {
      last;
    } else {
      $day -= $days;
      $month++;
    }
    redo;
  }
  if (not $leap_month) {
    return ($y, $month, 0, $day);
  } elsif ($month == $leap_month + 1) {
    return ($y, $month-1, 1, $day);
  } elsif ($leap_month < $month) {
    return ($y, $month-1, 0, $day);
  } else {
    return ($y, $month, 0, $day);
  }
} # gregorian_to_%%NAME%%

sub %%NAME%%_to_gregorian ($$$$) {
  my ($y, $m, $l, $d) = @_;
  return (undef, undef, undef)
      if $y < MIN_YEAR or
         MAX_YEAR < $y;

  my $offset = MIN_YEAR;
  my $first_day = unpack 'C', substr FIRST_GREGORIAN_DAY,
      $y - $offset, 1;
  my $leap_month = hex substr LEAP_MONTH,
      $y - $offset, 1;
  my $mt = substr MONTH_TYPES,
      2*($y - $offset), 2;
  $mt = (substr unpack ('B8', (substr $mt, 0, 1)), 1).
        (substr unpack ('B8', (substr $mt, 1, 1)), 1);

  $m++ if $leap_month and $leap_month < $m;
  $m++ if $l;

  $d += 29 + $_ for split //, substr $mt, 0, $m-1;
  $d += $first_day - 1;

  my $is_leap_year = (($y % 4) == 0 and
                      not (($y % 100 == 0) and not ($y % 400 == 0))) ? 1 : 0;
  if (MONTH_TO_OFFSET->[13] + $is_leap_year < $d) {
    $d -= MONTH_TO_OFFSET->[13] + $is_leap_year;
    if ($d > 31) {
      return ($y+1, 2, $d-31);
    } else {
      return ($y+1, 1, $d);
    }
  }

  for (reverse 3..12) {
    if (MONTH_TO_OFFSET->[$_] + $is_leap_year < $d) {
      return ($y, $_, $d - MONTH_TO_OFFSET->[$_] - $is_leap_year);
    }
  }
  for (2, 1) {
    if (MONTH_TO_OFFSET->[$_] < $d) {
      return ($y, $_, $d - MONTH_TO_OFFSET->[$_]);
    }
  }

  return (undef, undef, undef);
} # %%NAME%%_to_gregorian

1;

## License: Public Domain.
};

my $module_file_name;
if ($type eq 'kyuureki') {
  $module_file_name = 'lib/Kyuureki.pm';
  $perl_code =~ s/%%MOD%%/Kyuureki/g;
} elsif ($type eq 'rkyuureki') {
  $module_file_name = 'lib/Kyuureki/Ryuukyuu.pm';
  $perl_code =~ s/%%MOD%%/Kyuureki::Ryuukyuu/g;
}
$perl_code =~ s/%%NAME%%/$type/g;

use Data::Dumper;
$Data::Dumper::Sortkeys = 1;
$perl_code =~ s{\$Data->\{(\w+)\}->\[(\d+)\]}{
  $Data->{$1}->[$2];
}ge;
$perl_code =~ s{\$Data->\{(\w+)\}}{
  my $value = $Data->{$1};
  if (ref $value) {
    my $dumped = Dumper $value;
    $dumped =~ s/\$VAR1 = //;
    $dumped =~ s/;$//;
    $dumped;
  } else {
    $value =~ s/([\x00-\x20\x22\x24\x40\x5C\x7F-\x80])/sprintf '\x%02X', ord $1/ge;
    '"' . $value . '"';
  }
}ge;

open my $module_file, '>', $module_file_name or die "$0: $module_file_name: $!";
print $module_file $perl_code;

## License: Public Domain.
