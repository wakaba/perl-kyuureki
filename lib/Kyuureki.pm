
package Kyuureki;
use strict;
use warnings;
our $VERSION = '2.0';
use Carp qw(croak);

our @EXPORT = qw(gregorian_to_kyuureki kyuureki_to_gregorian);

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

use constant MONTH_TO_OFFSET => [
          undef,
          0,
          31,
          59,
          90,
          120,
          151,
          181,
          212,
          243,
          273,
          304,
          334,
          365
        ]
;
use constant FIRST_GREGORIAN_DAY => "\x1E\x14&\x1B.#\x18*\x20\x15(\x1C/%\x1A,!\x17)\x1E\x13&\x1B-#\x18+\x1F\x15(\x1D/\x24\x1A-!\x16)\x1F0&\x1B.\x22\x18+\x20\x14'\x1D0\x24\x19,\x22\x16)\x1E\x14%\x1B.#\x17*\x20\x15(\x1D0&\x1A-\x22\x18*\x1F\x14'\x1C.\x24\x19+\x20\x16)\x1D0%\x1B-\x22\x17*\x1F\x14'\x1C.\x24\x19,\x20\x16(\x1E0%\x1A-\x22\x17*\x1F\x14'\x1C/#\x19+!\x15(\x1D0%\x1A-\x22\x17*\x1F\x14&\x1C/\x24\x18+!\x16(\x1D0%\x1A-\x22\x17)\x1F\x14'\x1B.\x24\x19+\x20\x16(\x1D0%\x1A-#\x18+\x1F\x15(\x1D/\x24\x1A-!\x16)\x1F0&\x1B.\x22\x18+\x20\x14'\x1D0\x24\x19,\x22\x16)\x1E1%\x1B.#\x17*\x20\x15'\x1C/%\x19,!\x17)\x1E1&\x1B-#\x18*\x1F\x15(\x1C/\x24\x1A,!\x16)\x1E1&\x1B-#\x18+\x1F\x14'\x1D/\x24\x19,!\x16)\x1E0&\x1B.\x22\x18*\x20\x14'\x1C/\x24\x19,!\x16)\x1E1%\x1B.#\x17*\x20\x15'\x1C/\x24\x19,!\x16(\x1E1&\x1A-#\x18*\x1F\x15'\x1C/\x24\x19+!\x16)\x1D0&\x1B-\x22\x18+\x1F\x14'\x1D.\x24\x19,\x20\x16)\x1E0%\x1B.\x22\x17*\x20\x14'\x1C/#\x19,!\x15(\x1E1%\x1A-#\x17*\x1F\x15'\x1C/\x24\x1A,\x22\x17)\x1E1'\x1B.#\x19+\x20\x15(\x1D/%\x1A,!\x17*\x1E1&\x1C.#\x18+\x20\x15(\x1D/%\x1A-!\x17)\x1F1&\x1B.#\x18+\x20\x15(\x1D0\x24\x1A-\x22\x16)\x1F1&\x1B.#\x18+\x20\x15'\x1D0%\x19,\x22\x17)\x1E1&\x1B.#\x18*\x20\x15(\x1C/%\x1A,!\x17*\x1F2'\x1D.\x24\x19,\x20\x16)\x1E0%\x1B.\x22\x17*\x201'\x1C/#\x19,!\x15(\x1E1%\x1A-#\x17*\x1F2'\x1C/\x24\x19+!\x16(\x1D0&\x1A-\x22\x18*\x1F2'\x1C.\x24\x19+\x20\x16)\x1D0%\x1B-\x22\x17*\x1F\x14'\x1C.\x24\x19,\x20\x16(\x1E0%\x1A-\x22\x17*\x1F1'\x1C/\x24\x1A-\x22\x16)\x1E1&\x1B.#\x18+\x20\x15'\x1D0%\x19,\x22\x17)\x1E1&\x1B.#\x18*\x20\x15(\x1C/%\x1A,!\x17*\x1E1&\x1C-#\x18+\x1F2(\x1D/\x24\x1A-!\x16)\x1F0&\x1B.\x22\x18+\x20\x14'\x1D0\x24\x19,\x22\x16)\x1E1&\x1B.#\x18*\x20\x15'\x1C/%\x19,!\x17)\x1E1&\x1B-#\x18*\x1F2(\x1C/\x24\x1A,!\x16)\x1E1&\x1B-#\x18+\x1F\x15'\x1D/\x24\x19,!\x16)\x1E0&\x1B.\x22\x18*\x20\x14'\x1C/\x24\x19,!\x16)\x1E1%\x1B.#\x17*\x202'\x1C/\x24\x19,!\x16(\x1E1&\x1A-#\x18*\x1F\x15(\x1C/\x24\x1A+!\x16)\x1D0&\x1B.#\x19,\x20\x15(\x1E/%\x1A-!\x17*\x1F1&\x1C/#\x18+!\x15(\x1D0%\x1A-\x22\x17)\x1F2&\x1B.\x24\x18+\x20\x16(\x1D0%\x1A,\x22\x17)\x1E1'\x1B.#\x19+\x20\x15(\x1D0%\x1A,\x22\x17*\x1E1&\x1C.#\x18+\x20\x15(\x1D/%\x1A-!\x17)\x1F1&\x1B.#\x18+\x20\x16)\x1E1%\x1B.#\x17*\x202'\x1C/\x24\x19,!\x16(\x1E1&\x1A-#\x18*\x1F2'\x1C/\x24\x19+!\x16)\x1D0&\x1B-\x22\x18+\x1F2'\x1D.\x24\x19,\x20\x16)\x1E0%\x1B.\x22\x17*\x202'\x1C/\x24\x19,!\x16(\x1E1%\x1A-#\x17*\x1F2'\x1C/\x24\x19+!\x16(\x1D0&\x1B.#\x19+\x203(\x1D0%\x1A,\x22\x17*\x1E1&\x1C.#\x18+\x203(\x1D/%\x1A-!\x17)\x1F1&\x1B.#\x18+\x202(\x1D0\x24\x1A-\x22\x16)\x1F1&\x1B.#\x18+\x203'\x1D0%\x19,\x22\x17)\x1E1&\x1B.#\x18*\x203(\x1C/%\x1A,!\x17*\x1E1&\x1C-#\x18+\x1F2(\x1D/\x24\x1A-!\x16)\x1F1&\x1B.#\x18+\x202'\x1D0\x24\x19,\x22\x16)\x1E1&\x1B.#\x18*\x203'\x1C/%\x19,!\x17)\x1E1&\x1B.#\x18*\x202(\x1C/\x24\x1A,!\x16)\x1E1&\x1B-#\x18+\x1F2'\x1D/\x24\x19,!\x16)\x1E0&\x1B.\x22\x18+\x202'\x1D/%\x1A-\x22\x17*\x1F2&\x1C/\x24\x18+!4(\x1D0%\x1A-\x22\x17)\x1F2'\x1B.\x24\x19+\x203)\x1D0%\x1B,\x22\x17*\x1E1'\x1C.#\x19,\x203(\x1E0%\x1A-\x22\x17*\x1F1&\x1C/#\x18+!3(\x1D0%\x1A-\x22\x17)\x1F2&\x1B.\x24\x18+\x203(\x1D0%\x1A-\x22\x17*\x202(\x1C/\x24\x1A,!4)\x1E1&\x1B-#\x18+\x1F2'\x1D/\x24\x19,!4)\x1E0&\x1B.\x22\x18+\x202'\x1D/\x24\x19,!3)\x1E1%\x1B.#\x17*\x202'\x1C/\x24\x19,!4(\x1E1&\x1A-#\x18*\x1F2(\x1C/\x24\x1A+!4)\x1D0&\x1B-\x22\x18+\x1F2(\x1D0%\x1A-\x22\x17*\x201&\x1B.#\x19,!3(\x1D0\x24\x1A-#\x17*\x1F2&\x1B.\x24\x19+!3'\x1D0%\x1A-\x22\x18)\x1E1'\x1B.\x24\x19+\x203(\x1D0%\x1B-!4*\x1E1'\x1C.\x24\x19+\x203(\x1E0%\x1A.\x22\x16)\x1F1'\x1C/#\x18+\x202(\x1E1%\x1A-\x22\x16)\x1F2&\x1C/#\x18+\x203(\x1D0%\x19,\x22\x17)\x1F2'\x1B-#\x19+\x203)\x1D/%\x1A,\x22\x17*\x1E1&\x1B-#\x19,\x203(\x1D/\x24\x1B-\x22\x17*\x1F1&\x1B.#\x19,!2(\x1D0%\x1B-\x22\x16)\x1E1&\x1B.\x24\x18+\x203'\x1D/&\x1A-\x22\x17)\x1E1'\x1C/%\x1A+!3)\x1E1&\x1B-\x22\x17*\x1F2(\x1D/\x24\x19,\x203)\x1F1&\x1B-\x22\x17*\x201&\x1C/#\x19,!3)\x1E1%\x1A-#\x17*\x203'\x1C/\x24\x19,!4(\x1E0&\x1A-#\x18*\x1F2'\x1B.\x24\x1A,!4)\x1D0%\x1B-#\x18+\x1F1'\x1C.\x24\x19,!4)\x1F1&\x1C/#\x18+\x202(\x1D0%\x1A-\x224)\x1F2&\x1C/\x24\x18+\x203(\x1D0%\x19,!4)\x1F2'\x1B.#\x18*\x203)\x1D0%\x1A,!4*\x1E1&\x1B-#\x18+\x203(\x1D/\x24\x1A-!4*\x1F1&\x1B.#\x18+!2(\x1D/\x24\x19,\x22\x16)\x1E1&\x1C/%\x19,!4(\x1D0&\x1B.#\x18*\x1F2'\x1C/\x24\x1A+\x203)\x1D0&\x1B-\x225*\x1E1'\x1D/\x24\x19,\x203(\x1E0&\x1B.\x224*\x1F1'\x1C/#\x18+!3)\x1E1%\x1A-\x224*\x1F2'\x1C/\x24\x18+!4(\x1E0%\x1A-\x225*\x1F2'\x1B.#\x19+!4)\x1D0%\x1A,\x22\x18+\x1F2'\x1C.#\x19,\x203(\x1D/%\x1A-\x22\x17*\x1F1&\x1C/#\x19,!3(\x1D0%\x1A-#4)\x1F2&\x1C/\x24\x18+\x203'\x1D0&\x1A-\x22\x17)\x1E1'\x1C/\x24\x19+\x203(\x1D0%\x1B,!4*\x1E1'\x1C.#\x18+\x203(\x1E1&\x1B.\x225+\x202(\x1D/\x24\x19,\x223)\x1E1%\x1A-#\x18+\x203'\x1C/\x24\x19,\x224)\x1E1&\x1A-#\x18*\x202'\x1C/\x24\x1A,!4)\x1D0&\x1B-#\x18+\x1F2'\x1D/\x24\x1A-!3)\x1E0&\x1B.\x22\x17*\x1F1'\x1D0\x24\x19,!3(\x1E1&\x1B.#\x18+\x203(\x1D0&\x1A,\x225)\x1F2'\x1B.#\x19+\x203)\x1D0%\x1A,\x225*\x1F1'\x1C.#\x19,\x203(\x1D/\x24\x1A-\x224*\x1F1&\x1B.#\x19,!3(\x1D0\x24\x1A-\x224*\x1E1&\x1B.\x24\x18+\x203'\x1D0%\x1A-\x225)\x1E1'\x1B.\x24\x19+\x202(\x1D1&\x1C-\x225*\x1F2(\x1D/\x24\x19,\x203)\x1F1&\x1B.\x225*\x202'\x1D/#\x19,!3)\x1E1%\x1A-\x225*\x203'\x1C/\x24\x18+!4)\x1E1&\x1A-\x226*\x202'\x1B.\x24\x19,!4)\x1D0%\x1B-\x22\x18+\x1F2'\x1C.\x24\x19,!3(\x1E0%\x1B.\x225*\x1F1&\x1C/\x24\x19,!3(\x1D0%\x1B.#5*\x1F2&\x1C/\x24\x19+\x203(\x1D1&\x1A-\x225)\x1F2'\x1C/\x24\x19+\x203)\x1D0&\x1B,\x225*\x1F2'\x1C.#\x18+\x203)\x1E0%\x1A-!4*\x202'\x1C/#\x18+!\x15(\x1D0\x24\x19,\x22\x17*\x1F2'\x1C/\x24\x19,\x22\x17)\x1E0&\x1A.#\x19*\x1F2'\x1C/\x24\x1A,!\x16)\x1D0&\x1B-#\x18+\x1F2'\x1D/\x24\x1A-\x203)\x1E0&\x1B.\x22\x17*\x1F1'\x1D0\x24\x19,!3(\x1E1&\x1B.#\x17*\x1F2'\x1C/\x24\x18+!\x16(\x1E1&\x1A-\x22\x18*\x1F2(\x1C/\x24\x19,\x22\x17*\x1F1&\x1C-#\x19,\x203(\x1D/\x24\x1A-\x22\x17*\x1F1&\x1B.#\x19,!3(\x1D0\x24\x1A-\x22\x17)\x1E1&\x1B.\x24\x18+\x20\x15'\x1D0%\x1A-\x22\x17)\x1E1'\x1B.\x24\x19*\x202(\x1D0%\x1A,!\x16)\x1E1'\x1C.#\x18+\x1F2(\x1E0%\x1A-!\x16)\x1F2'\x1D/#\x19,!\x16)\x1E1%\x1A-#\x17*\x203'\x1C/\x24\x18,!\x17)\x1E0%\x1A-#\x18*\x1F2'\x1B.\x24\x1A,!\x16)\x1D0%\x1B-#\x18+\x1F2'\x1C.\x24\x19,!\x16(\x1E0%\x1B.\x22\x17*\x1F1&\x1C/\x24\x19,!3(\x1D1%\x1B.#\x17)\x1F2'\x1C/\x24\x18+\x20\x16(\x1D1&\x1A-\x22\x17)\x1F2'\x1C/\x24\x19+\x20\x16)\x1D0&\x1B,\x22\x17*\x1F2'\x1C.#\x18+\x20\x16)\x1E0%\x1A-!\x17*\x202'\x1C.#\x18+!\x16(\x1D0\x24\x1A-\x22\x17*\x1F2&\x1B.\x24\x18+!\x16(\x1D0%\x1A-\x22\x18*\x1E1'\x1B.\x24\x19+\x20\x15(\x1D";
use constant MONTH_TYPES => "U,*TZT+**XU(ZTVT*XU*5(VTU4*T5*-(U4*TjT-(U4U(jTZT*hU*U(ZT*j*TU*-(UT*V*T-(UTU,*TZT+(U,U(ZT+**XU(ZTVT*Z*T5(VTU4*T5*-(U4*TjT-**hU(jTZT*hU*U(ZTUT*TU*5(UT*V*T5(UTU,*TjT+(U,U(jT+**XU*U(VT*Z*TU(VTU4*TU*-(U4U,*T-**hU,*TZT*j*XU(ZTUT*XU*5(UT*Z*T5*+(U4*TjT+(U4U(jTVT*hU*U(VT*j*TU(VTUT*V*T-(U4U,*T-**hU,U(ZT*j*XU(ZTUT*XU*5(UTU4*T5*+(U4*TjT+**hU(jTVT*hU*U(VT*j*TU*-(UT*V*T-(UTU,*TZT+(U,U(ZT+**XU(ZTVT*Z*T5(VTU4*T5*-(U4U(jT-**hU(jTZT*hU*U(ZTUT*TU*5(UT*V*T5*+(U,*TjT+(U,U(jT+**XU*U(VT*Z*TU(VTU4*V*T-(U4U,*T-**hU(jTZT*j*TU(ZTUT*TU*5(UTU,*T5*+(U,*TjT+(U,U(jTVT*XU*U(VT*Z*TU*-(U4*V*T-(U4U,*T-**hU,U(ZT*j*XU(ZTUT*Z*T5(UTU4*T5*+(U4*TjT+**hU(jTVT*hU*U(VTUT*TU*-(UT*V*T-(UTU,*TZT+(U,U(ZT+**XU*5(VT*Z*T5(VTU4*T5*-(U4U(jT-**hU(jTZT*j*TU(VTUT*TU*-(UT*V*T-*+(U,*TZT+(U,U(ZTVT*XU*5(VT*Z*T5(VTU4*TjT-(U4U(jT-**hU*U(ZT*j*TU(ZTUT*TU*5(UTU,*T5*+(U,*TjT+**XU(jTVT*XU*U(VT*Z*TU*-(U4*V*T-(U4U,*TZT*hU,U(ZT*j*XU(ZTUT*Z*T5(UTU4*T5*+(U4U(jT+**hU(jTVT*hU*U(VTUT*TU*-(U4*V*T-**hU,*TZT*hU,U(ZT*j*XU*5(UT*Z*T5(UTU4*TjT+(U4U(jT+**hU(jTVT*j*TU(VTUT*TU*-(UTU,*T-*+(U,*TZT+(U,U(ZTVT*XU*5(VT*Z*T5*-(U4*TjT-(U4U(jT-**hU*U(ZT*j*TU(ZTUT*TU*5(UTU,*T5*+(U,*TjT+**XU(jTVT*XU*U(VTU4*TU*-(U4*V*T-(U4U(jTZT*hU*U(ZT*j*TU(ZTUT*V*T5(UTU,*T5*+(U,U(jT+**XU(jTVT*XU*U(VTU4*TU*-(U4*V*T-**hU,*TZT*hU,U(ZTUT*XU*5(UT*Z*T5(UTU4*TjT+(U4U(jT+**hU(jTVT*j*TU(VTUT*TU*-(UTU,*T-*+(U,*TZT+(U,U(ZTVT*XU*5(VT*Z*T5*-(U4*TjT-(U4U0jTZT*hU*U(VT*j*TU(VTUT*V*T-(UTU,*T-*+(U,*TZT+**XU(ZTVT*XU*5(VTU4*T5*-(U4*TjT-(U4U(jTZT*hU*U(ZT*j*TU*5(UT*V*T5(UTU,*TjT+(U,U(jT+**XU(jTVT*Z*TU(VTU4*TU*-(U4*V*T-**hU,*TZT*hU,U(ZTUT*XU*5(UT*Z*T5(UTU4*TjT+(U4U(jT+**hU*U(VT*j*TU(VTU4*TU*-(U4U,*T-**hU,*TZT*j*XU(ZTUT*XU*5(UT*Z*T5*+(U4*TjT+(U4U(jTVT*hU*U(VT*j*TU(VTUT*V*T-(UTU,*T-*+(U,U(ZT+**XU(ZTVT*XU*5(VTU4*T5*-(U4*TjT-**hU(jTZT*hU*U(ZT*j*TU*5(UT*V*T5(UTU,*TjT+(U,U(jT+**XU(jTVT*Z*TU(VTU4*TU*-(U4U(jT-**hU(jTZT*hU*U(ZTUT*TU*5(UT*V*T5*+(U,*TjT+(U,U(jT+**XU*U(VT*Z*TU(VTU4*V*T-(U4U,*T-**hU,*TZT*j*XU(ZTUT*XU*5(UTU4*T5*+(U4*TjT+(U4U(jTVT*hU*U(VT*j*TU*-(UT*V*T-(UTU,*T-*+(U,U(ZT+**XU(ZTVT*Z*T5(VTU4*T5*-(U4*TjT-**hU(jTVT*hU*U(VTUT*TU*-(UT*V*T-(UTU,*TZT+(U,U(ZT+**XU*5(VT*Z*T5(VTU4*T5*-(U4U(jT-**hU(jTZT*j*TU(ZTUT*TU*5(UT*V*T5*+(U,*TjT+(U,U(jTVT*XU*U(VT*Z*TU(VTU4*V*T-(U4U,*T-**hU,U(ZT*j*XU(ZTUT*XU*5(UTU4*T5*+(U4*TjT+**hU(jTVT*hU*U(ZT*j*TU*5(UT*V*T5(UTU,*TZT+(U,U(ZT+**XU(ZTVT*Z*T5(VTU4*T5*-(U4U(jT-**hU(jTZT*hU*U(ZTUT*TU*5(UT*V*T5*+(U,*TjT+(U,U(jT+**XU*U(VT*Z*TU(VTU4*V*T-(U4U(jT-**hU(jTZT*j*TU(ZTUT*TU*5(UTU,*T5*+(U,*TjT+(U,U(jTVT*XU*U(VT*Z*TU*-(U4*V*T-(U4U,*T-**hU,U(ZT*j*XU(ZTUT*Z*T5(UTU4*T5*+(U,*TjT+**XU(jTVT*XU*U(VTU4*TU*-(U4*V*T-(U4U,*TZT*hU,U(ZT*j*XU*5(UT*Z*T5(UTU4*T5*+(U4U(jT+**hU(jTVT*j*TU(VTUT*TU*-(UT*V*T-**hU,*TZT*hU,U(ZTUT*XU*5(UT*Z*T5(UTU4*TjT+(U4U(jT+**hU*U(VT*j*TU(VTUT*TU*-(UTU,*T-*+(U,*TZT+**XU(ZTVT*XU&5(VT*Z*X,lJ\x5C\x24lR.2,5\x24VR5T\x15XJlI\x5C\x24\x5CdXj(u\x24m\x24-4\x15Z\x158I:I4dTj*Z(Zd+4*l\x12tI6ILTV4TV(ZTUT&l\x22lR\x5C),i(tT5*-(UT%Z%8Rl)\x1Ai\x18lTZT+(M4Jt%4R6R4i\x16U\x14ZT+*\x16hJl\x24n%(r,r,5\x146R5T\x15XJ\x5CI<\x24\x5C2,j,-&+\x24-T\x15Z\x24tX8h^\x24\x5C*(m\x14k\x24+,*t\x14lQ.),TTjJ:(fhUT%\x5C\x12n\x12\x5C),TN4T5(UTMT%Z%8R<)\x1E)(lL-*+0K4Jt%4R6R,Y\x18ZRZT*hc4JlDn\x24l2,U\x14u\x145TFj\x15XL\x5CI\x5CD\x5C2,j,-\x14-R+4\x15XI\x5CI8dZdXj(m\x24Zh+4\x15:\x12tI6I,TTZ*6(V\x5C\x0Al%l\x12lI.),TZ4TVHZXUXJl\x22n\x22\x5C1,j,5\x145*-,\x15\x5C\x09ZE8bXi*i(lTZT+(U4Rt%4TVT4i*U(VT*hel\x12l).\x24lT,Y&5(VTUT\x15XR\x5CQ\x5C(\x5C4,jL-\x24k(+4\x15:%8Q8hZdTjHm\x24Zh+4*l\x22tQ6Q,TTZ*6(VXUX)l\x22n\x22\x5C),4TtT5(VTUT%Xe0rXi*i(lT-&+(S4Jt%4R6R4Y\x18ZTZT*hJtJl\x24n\x24lR,U\x165\x24VT\x16j\x15XJ\x5CI8d\x5C2,j,-\x245T+4\x158I\x5CI8dZT4j(m\x14Zh+4\x156\x12tI6),TTZ*5(VT*l%l\x12lI.),4TjT5(UTKT%XR\x5CRXi\x1Ci\x18jT-*+(K4%:%4R4i\x1AY\x18ZTVT\x1AhJtJl\x24lR6R,U\x165\x24VT\x16j\x15XJ\x5C\x24n\x24\x5C2,5\x16-\x245T+4\x158I\x5CI8dXr*j(k\x14Zh+,\x156\x12tI4TVTTZ(ZTVT*f%l\x12l).),4T6*5(UTUT%XR\x5CRXi(tLjT-(UTK4%6%4R4i\x1AY\x18ZT+*\x1AhJtJl\x24lR.2,Y\x14ZR5T\x16hJlI\x5C\x24\x5Cd\x5C2,5\x14m\x14-0UXU8I8d\x5CdXj*j(k\x14-*+,\x134I:I4TVTTZ(ZTVT*l\x12v\x12\x5C),TV4T5*-(UT%j%XR\x5C)\x1Ci\x18tLjT-(U4K4%8R:R4i\x1AU\x14ZPk(VhJt%6\x24lR,Y\x165\x14ZJ5PVXJlI\x5C\x24\x5C2.*,5\x14m\x14-0UTU8I8d\x5CdXj(m\x14jT+&*l\x134I:I,TTj*Y(ZTVT*hRlR\x5C),TV4T5(VTUT%V%XR\x5C)\x1ChXrL5*-(MTK4%8R:Q4i\x18jJZHk(+4Jt\x24v\x22lQ,Y\x165\x14ZHZhUXJl\x24n\x22\x5C2.*,5\x146J-0UXI\x5CI8dVTXj(m\x14jT+(U4RtI8TVTTj*Y(ZT+*&hRl).),T.2L5(V4UT%XR\x5CR\x5C(\x5ChXjL5&+(-4%Z%8Q8hZhXjFZHk(+4*t\x24tQ6Q,TTZJVHZdUX*l\x22n\x22\x5C1,TV5\x145&-(UX)\x5CE8b\x5C),i(lTZT+(U4RtE8RVT4i(jTZT+&&hJl).(lT,Y&5(VTUT\x15XJVQ\x5C(\x5C2,jL5\x245T+4\x15FU8Q8hZdXj(m\x24Zh+4\x156\x22tQ6Q,TTZ*VHVX*l*l\x22fR\x5C),T64T5(VTUX%Xb\x5CR\x5C),i(lT-*+(S4%:%8R6R4i\x18j4ZT*hK4Jl%,R6R,Y\x165\x24VT\x16j\x15XJ\x5C\x24n\x24\x5C2&Z,5\x2454+4\x15XI\x5CI8dXj*j(m\x24Zh+4\x156\x12tQ4dVTTZ&5(VT*:)l\x12lI.),4TZ*5(VTUT%XR\x5CR\x5C),4TjT-&+(K4%:%8R4i\x1AY\x18jT+**hJtJl\x24lR6R,U\x14ZRVT\x16j\x15XJ\x5C\x24\x5Cd\x5C2,5\x16-\x245T\x15Z\x158IVI8dXj*j(m\x14-4+4\x15&RtI4dVTTZ(ZTVT*l\x12v\x12lI.),4T:*5(UT*j%XRVR\x5C)\x18tLjT.(UTK4%8RZR4i\x16Y\x18ZT+*\x1AhJt%6\x24lR6R,U\x14ZRVT\x16hJlI\x5C\x24\x5CR.2,5\x14m\x145PUZ\x158I\x5C\x24\x5CdXj*j(k\x14-*+,\x134I:I4TTj*Z(ZTVT*l\x12v\x12l),TV4T5*5(UT&j%XR\x5C),i\x18tL5*-(UTK4%8RZR4i\x18jLZPk*\x16hJt%6\x24lR,Y\x16U\x14ZHZhVhJfI\x5C\x24\x5CR.*,5\x146J-0UZ\x158I<\x24\x5CdXj(u\x14jT-(UV\x134I:I4TTj*Z(ZT+**hRtI6),TV4T5(VTUT%hRlR\x5C)\x1Ci\x18rL5*-(UT%Z%8R:Q4i\x18jJZHk(+4Jt%4Q6Q,Y\x16U\x14ZHZhVXJl\x24n\x22\x5C2.*,5\x146J-0UXI\x5CI8d\x5C*,j(u\x14jT+(U6\x134I8dZTTj*Y(ZT+*&hRt)6),T4Y*5(VTUT%XRlR\x5C(\x5C4,rL5&-(MT%Z%8Q8hZhXjHm\x24k(+4*t\x24tQ6Q,TTZJZHZhUX*l\x22n\x22\x5C1,TV5\x14-(UTK4%8R\x5CR4i\x1AY\x14jHm(ZhK4%6\x24lR.R,U\x14ZJ6PVhJlI\x5C\x24\x5CR.2,5\x14u\x145PUZ\x15XI\x5C\x24\x5CdXj*j(m\x14-*+(S4I:I4TTj*Z(ZTVT*hRtRl),TV4L:*5(VT&j%XR\x5C)\x1E)\x18tLjL-(5TK4%8RZR4i\x18lJjHk(ZhJt%6\x24lR,i\x16U\x14ZJ6PVh*lI\x5C\x24\x5CR.*,5\x146J5(UXU8I8d\x5CdXj(u\x14jT-(UTS4):I4TTj*Z(ZT+**hRtRl),T.4L9\x24ZTUT%hRlR\x5C(\x5ChXtL5\x24m(-T\x15Z%8Q:Q4hTjJZHk\x24+4*t%4Q6Q,dVU\x14ZHZdVX*l\x14n\x22\x5CQ.),4T6*-(UT)Z%8b\x5C),i(tTjT-(UTS4%8RZRTi(lTZT+*&hJt%6\x24lR,Y\x165\x24ZT5T\x15hJlQ\x5C(\x5C2,r,5\x24m\x24-T\x15Z\x158Q8hZdTj(m\x24k\x24+4*t\x14tQ6Q,TTj*Z(ZTVX*l\x12n\x12\x5C),TV4T6(VTUT%Z%8R\x5C),i(tT5*-(U4%Z%8R:R4i\x14lRZT+(K4Jt%6\x24lR,Y\x165\x24VPZj\x15XJl\x24n\x24\x5C2,r(u\x146R-T\x15XJ\x5CI8dZdTj(m\x14[\x24+4\x156\x12tI4dVTTj*Z(ZT+*&l\x12lI.),TV4T5(VTUT%XR\x5CR\x5C)\x1C4LlT5*+(M4%:%8R8i\x1Ai\x14jRZPk(K4Jl\x24lR6R,Y\x165\x146PZj\x15XJl\x24n\x24\x5C2,5\x14u\x146R-4\x15XI\x5CI8dXr*j(m\x14-*+0U6\x12tI4dVTTZ(]\x14ZT*j%hRl).),TTZ*5(VT*j%XR\x5CR\x5C)\x1C4LlL-(UTK4%:%8R4i\x1Ai\x14jHm([(K4%6\x24lR.R,Y\x14ZJ6PVhJlJ\x5C\x24n\x24\x5C2,5\x14u\x145HVXUXI\x5C\x24\x5CdXj*j(m\x14-*+(U4I:I4dVTTZ(ZTVT*hRtRl),TVTL:*5(VT&j%XR\x5C)\x1E)\x18tLjL-(UTK4%8R\x5CR4i\x18tJjH";
use constant LEAP_MONTH => "01090060030B0080040010A0060020B0080040C0090070030B008005001090060030C0080040010A0060020B0080040010A0070030B008005001090060030C0080040010A0060020C0090050010A0070030B008005001090060030C0080040010A0060030C0090050010A0070030B0080050020A0060030C0080050020A0060030C0090050010A0070030B0080050020A0060040C0080050020A0060030C0090050010A0070030B0080060020A0070040C0080050020B0070030C0090050010A0070030B0090060020A0070040C0080050020B0070030C0090050010B0080040C0090060020A0070040C0080050020B0070030C0090050020B0080040C0090060020A0070040C0090050020B007004001090050020B0080040C0090060020A007004001090050030B007004001090050020B0080040C0090060020A007004001090060030B0070040010A0060020B0080040C0090060020A008005001090060030B0070040010A0060020B0080040C0090060030B008005001090060030B0070040010A0060020B0080040010A0070030B008005001090060030B0070040010A0060020C0080040010A0070030B008005001090060030C0080040020A0060030C0080040010A0070030B008005001090060030C0080050020A0060030C0080050010A0070030B008005001090070040C0080050020A0060030C0090050010A0070030B0080050010A0070040C0080050020A0060030C0090050010A0070030C0090060020A0070040C0080050020A0060030C0090050010B0070030C0090050010A0070040C0080050020A0060030C0090050020B0070030C0090050010A0070040C0080050020A0060040C0080050020B0070030C0090050010A0070030B0080050020A0070040C0080050020B0070030C0090050010A0070030B0090060020A0070040C0080050020C007004001080060020B007004001090060030B007003001090050030A0080040C00A0060030B008005001090050030B0070050010A0060020C007004001090070030C007005001090070030C0080040020A0060030C0080040020A0070030B0090050010A0060030C0080050020A0060040C0080050010B0070030C007005001090070030C0080050020A0070030C0080050020A0070030C0090050020A0060040C0090050020A0060040C0090050010A0070030C0080050010A0070040C0080060020A007003001090050020A007003001090050020A0070040C0090050020A0060040C0090050020A0070040C0090060020A0070040C0080060020A007004001090060020A007003001090060020A0070040C0090050030A007004001090050030A0070040C00A0060020A0070040C0080060030A007005001090060020A007004002090060020A007004001090060030A007004001090050030A0070040010A0060030A0070050010A0060030B007005001090060020A008004001090060020A008005001090070030B0080040020A0060030B0080040020A0060030B0090050010A0060030B0070050010A0060030C0080050010B00700300108005001090070030B0080040020A0060030C0080040020A0070030B0090050010A0060040C0080050020A0060040C0080050030010800500209008004001080050020A007004001090050030B0070040C00A0060020B0070040C0090060030C0070050010A0060020B007004001080060020B008004001080060030B0070040010900500400207005003080050040A006005003070050040C0060050030800500400206005002070050040020600500307006004003070050030800600400307005004080060040A006005003080050040020700500309005004002060050030B00600500207005003080060040030700500408006004003070050040800600400300";
use constant MIN_YEAR => -666;
use constant MAX_YEAR => 2100;

sub gregorian_to_kyuureki ($$$) {
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
} # gregorian_to_kyuureki

sub kyuureki_to_gregorian ($$$$) {
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
} # kyuureki_to_gregorian

1;

## License: Public Domain.
