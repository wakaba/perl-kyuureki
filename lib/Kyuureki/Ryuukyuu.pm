
package Kyuureki::Ryuukyuu;
use strict;
use warnings;
our $VERSION = '2.0';
use Carp qw(croak);

our @EXPORT = qw(gregorian_to_rkyuureki rkyuureki_to_gregorian);

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
use constant FIRST_GREGORIAN_DAY => "\x1E\x14&\x1B.#\x18*\x20\x15(\x1C/%\x1A,!\x17)\x1E\x13&\x1B-#\x18+\x1F\x15(\x1D/\x24\x1A-!\x16)\x1F0&\x1B.\x22\x18+\x20\x14'\x1D0\x24\x19,\x22\x16)\x1E\x14%\x1B.#\x17*\x20\x15(\x1D0&\x1A-\x22\x18*\x1F\x14'\x1C.\x24\x19+\x20\x16)\x1D0%\x1B-\x22\x17*\x1F\x14'\x1C.\x24\x19,\x20\x16(\x1E0%\x1A-\x22\x17*\x1F\x14'\x1C/#\x19+!\x15(\x1D0%\x1A-\x22\x17*\x1F\x14&\x1C/\x24\x18+!\x16(\x1D0%\x1A-\x22\x17)\x1F\x14'\x1B.\x24\x19+\x20\x16(\x1D0%\x1A-#\x18+\x1F\x15(\x1D/\x24\x1A-!\x16)\x1F0&\x1B.\x22\x18+\x20\x14'\x1D0\x24\x19,\x22\x16)\x1E1%\x1B.#\x17*\x20\x15'\x1C/%\x19,!\x17)\x1E1&\x1B-#\x18*\x1F\x15(\x1C/\x24\x1A,!\x16)\x1E1&\x1B-#\x18+\x1F\x14'\x1D/\x24\x19,!\x16)\x1E0&\x1B.\x22\x18*\x20\x14'\x1C/\x24\x19,!\x16)\x1E1%\x1B.#\x17*\x20\x15'\x1C/\x24\x19,!\x16(\x1E1&\x1A-#\x18*\x1F\x15'\x1C/\x24\x19+!\x16)\x1D0&\x1B-\x22\x18+\x1F\x14'\x1D.\x24\x19,\x20\x16)\x1E0%\x1B.\x22\x17*\x20\x14'\x1C/#\x19,!\x15(\x1E1%\x1A-#\x17*\x1F\x15'\x1C/\x24\x1A,\x22\x17)\x1E1'\x1B.#\x19+\x20\x15(\x1D/%\x1A,!\x17*\x1E1&\x1C.#\x18+\x20\x15(\x1D/%\x1A-!\x17)\x1F1&\x1B.#\x18+\x20\x15(\x1D0\x24\x1A-\x22\x16)\x1F1&\x1B.#\x18+\x20\x15'\x1D0%\x19,\x22\x17)\x1E1&\x1B.#\x18*\x20\x15(\x1C/%\x1A,!\x17*\x1F2'\x1D.\x24\x19,\x20\x16)\x1E0%\x1B.\x22\x17*\x201'\x1C/#\x19,!\x15(\x1E1%\x1A-#\x17*\x1F2'\x1C/\x24\x19+!\x16(\x1D0&\x1A-\x22\x18*\x1F2'\x1C.\x24\x19+\x20\x16)\x1D0%\x1B-\x22\x17*\x1F\x14'\x1C.\x24\x19,\x20\x16(\x1E0%\x1A-\x22\x17*\x1F1'\x1C/\x24\x1A-\x22\x16)\x1E1&\x1B.#\x18+\x20\x15'\x1D0%\x19,\x22\x17)\x1E1&\x1B.#\x18*\x20\x15(\x1C/%\x1A,!\x17*\x1E1&\x1C-#\x18+\x1F2(\x1D/\x24\x1A-!\x16)\x1F0&\x1B.\x22\x18+\x20\x14'\x1D0\x24\x19,\x22\x16)\x1E1&\x1B.#\x18*\x20\x15'\x1C/%\x19,!\x17)\x1E1&\x1B-#\x18*\x1F2(\x1C/\x24\x1A,!\x16)\x1E1&\x1B-#\x18+\x1F\x15'\x1D/\x24\x19,!\x16)\x1E0&\x1B.\x22\x18*\x20\x14'\x1C/\x24\x19,!\x16)\x1E1%\x1B.#\x17*\x202'\x1C/\x24\x19,!\x16(\x1E1&\x1A-#\x18*\x1F\x15(\x1C/\x24\x1A+!\x16)\x1D0&\x1B.#\x19,\x20\x15(\x1E/%\x1A-!\x17*\x1F1&\x1C/#\x18+!\x15(\x1D0%\x1A-\x22\x17)\x1F2&\x1B.\x24\x18+\x20\x16(\x1D0%\x1A,\x22\x17)\x1E1'\x1B.#\x19+\x20\x15(\x1D0%\x1A,\x22\x17*\x1E1&\x1C.#\x18+\x20\x15(\x1D/%\x1A-!\x17)\x1F1&\x1B.#\x18+\x20\x16)\x1E1%\x1B.#\x17*\x202'\x1C/\x24\x19,!\x16(\x1E1&\x1A-#\x18*\x1F2'\x1C/\x24\x19+!\x16)\x1D0&\x1B-\x22\x18+\x1F2'\x1D.\x24\x19,\x20\x16)\x1E0%\x1B.\x22\x17*\x202'\x1C/\x24\x19,!\x16(\x1E1%\x1A-#\x17*\x1F2'\x1C/\x24\x19+!\x16(\x1D0&\x1B.#\x19+\x203(\x1D0%\x1A,\x22\x17*\x1E1&\x1C.#\x18+\x203(\x1D/%\x1A-!\x17)\x1F1&\x1B.#\x18+\x202(\x1D0\x24\x1A-\x22\x16)\x1F1&\x1B.#\x18+\x203'\x1D0%\x19,\x22\x17)\x1E1&\x1B.#\x18*\x203(\x1C/%\x1A,!\x17*\x1E1&\x1C-#\x18+\x1F2(\x1D/\x24\x1A-!\x16)\x1F1&\x1B.#\x18+\x202'\x1D0\x24\x19,\x22\x16)\x1E1&\x1B.#\x18*\x203'\x1C/%\x19,!\x17)\x1E1&\x1B.#\x18*\x202(\x1C/\x24\x1A,!\x16)\x1E1&\x1B-#\x18+\x1F2'\x1D/\x24\x19,!\x16)\x1E0&\x1B.\x22\x18+\x202'\x1D/%\x1A-\x22\x17*\x1F2&\x1C/\x24\x18+!4(\x1D0%\x1A-\x22\x17)\x1F2'\x1B.\x24\x19+\x203)\x1D0%\x1B,\x22\x17*\x1E1'\x1C.#\x19,\x203(\x1E0%\x1A-\x22\x17*\x1F1&\x1C/#\x18+!3(\x1D0%\x1A-\x22\x17)\x1F2&\x1B.\x24\x18+\x203(\x1D0%\x1A-\x22\x17*\x202(\x1C/\x24\x1A,!4)\x1E1&\x1B-#\x18+\x1F2'\x1D/\x24\x19,!4)\x1E0&\x1B.\x22\x18+\x202'\x1D/\x24\x19,!3)\x1E1%\x1B.#\x17*\x202'\x1C/\x24\x19,!4(\x1E1&\x1A-#\x18*\x1F2(\x1C/\x24\x1A+!4)\x1D0&\x1B-\x22\x18+\x1F2(\x1D0%\x1A-\x22\x17*\x201&\x1B.#\x19,!3(\x1D0\x24\x1A-#\x17*\x1F2&\x1B.\x24\x19+!3'\x1D0%\x1A-\x22\x18)\x1E1'\x1B.\x24\x19+\x203(\x1D0%\x1B-!4*\x1E1'\x1C.\x24\x19+\x203(\x1E0%\x1A.\x22\x16)\x1F1'\x1C/#\x18+\x202(\x1E1%\x1A-\x22\x16)\x1F2&\x1C/#\x18+\x203(\x1D0%\x19,\x22\x17)\x1F2'\x1B-#\x19+\x203)\x1D/%\x1A,\x22\x17*\x1E1&\x1B-#\x19,\x203(\x1D/\x24\x1B-\x22\x17*\x1F1&\x1B.#\x19,!2(\x1D0%\x1B-\x22\x16)\x1E1&\x1B.\x24\x18+\x203'\x1D/&\x1A-\x22\x17)\x1E1'\x1C/%\x1A+!3)\x1E1&\x1B-\x22\x17*\x1F2(\x1D/\x24\x19,\x203)\x1F1&\x1B-\x22\x17*\x201&\x1C/#\x19,!3)\x1E1%\x1A-#\x17*\x203'\x1C/\x24\x19,!4(\x1E0&\x1A-#\x18*\x1F2'\x1B.\x24\x1A,!4)\x1D0%\x1B-#\x18+\x1F1'\x1C.\x24\x19,!4)\x1F1&\x1C/#\x18+\x202(\x1D0%\x1A-\x224)\x1F2&\x1C/\x24\x18+\x203(\x1D0%\x19,!4)\x1F2'\x1B.#\x18*\x203)\x1D0%\x1A,!4*\x1E1&\x1B-#\x18+\x203(\x1D/\x24\x1A-!4*\x1F1&\x1B.#\x18+!2(\x1D/\x24\x19,\x22\x16)\x1E1&\x1C/%\x19,!4(\x1D0&\x1B.#\x18*\x1F2'\x1C/\x24\x1A+\x203)\x1D0&\x1B-\x225*\x1E1'\x1D/\x24\x19,\x203(\x1E0&\x1B.\x224*\x1F1'\x1C/#\x18+!3)\x1E1%\x1A-\x224*\x1F2'\x1C/\x24\x18+!4(\x1E0%\x1A-\x22\x18*\x1F2'\x1B.#\x19+!4)\x1D0%\x1A,\x22\x18+\x1F2'\x1C.#\x19,\x203(\x1D/%\x1A.\x22\x17*\x1F1&\x1C/#\x19,!3(\x1D0%\x1A-#\x17)\x1F2&\x1C/\x24\x18+\x203'\x1D0&\x1A-\x22\x17)\x1E1'\x1C/\x24\x19+\x203(\x1D0%\x1A,!\x16)\x1E1'\x1C.#\x18+\x1F2(\x1E1&\x1B-\x22\x17*\x202'\x1C/#\x19,!\x16)\x1E1%\x1A-#\x17*\x203'\x1C/\x24\x19,!4(\x1D0%\x1A-#\x18*\x1F2'\x1B.\x24\x1A,!\x16)\x1D0%\x1B-#\x18+\x1F1'\x1C.\x24\x19,\x203(\x1E0%\x1B.\x22\x17*\x1F1'\x1C/\x24\x19,!3(\x1E1%\x1B-\x22\x18*\x203(\x1D0%\x19,!4)\x1F2'\x1B.#\x18*\x203)\x1D0%\x1A,!4*\x1E1&\x1B-#\x18+\x203(\x1D/\x24\x1A-!\x17*\x1F1&\x1B.#\x18+!2'\x1D/\x24\x1A-\x22\x16)\x1E1%\x1B.\x24\x18+\x203'\x1C/%\x1A-\x22\x17)\x1E1&\x1B.#\x19*\x1F2(\x1D0&\x1B-\x22\x17*\x1F2'\x1D/\x24\x19,\x203)\x1E0&\x1B-!4*\x202'\x1C/#\x18+!3)\x1E1%\x1A-\x22\x17*\x203'\x1C.\x24\x18+!4(\x1E0%\x1A-\x22\x18*\x1F2'\x1B.\x24\x19+!4)\x1D0%\x1A-\x22\x18+\x1F1&\x1C.\x24\x19,\x203(\x1D/%\x1B-\x22\x17*\x1F1&\x1C/#\x19,!2(\x1D0%\x1A-#\x16)\x1F2&\x1C/\x24\x18+\x203'\x1D0&\x1A-\x22\x17)\x1E2'\x1C/\x24\x19*\x20\x15(\x1D0%\x1A,!\x17*\x1E1'\x1C.#\x18+\x20\x15(\x1E0%\x1A-!\x17*\x1F1&\x1B.\x22\x18+!\x15(\x1D0\x24\x19,\x22\x17*\x1F2'\x1C/\x24\x19,\x22\x17)\x1E0&\x1A-#\x18*\x1F2'\x1C/\x24\x1A,!\x16)\x1D0&\x1B-#\x18+\x1F2'\x1D/\x24\x1A,\x20\x16(\x1E0&\x1B.\x22\x17*\x1F1'\x1D0\x24\x19,!\x15(\x1E1&\x1B.#\x17*\x1F2'\x1C/\x24\x18+!\x16(\x1E1&\x1A-\x22\x18*\x1F\x15(\x1C/\x24\x19,\x22\x17*\x1F1&\x1C-#\x19,\x20\x15(\x1D/\x24\x1A-\x22\x17*\x1F1&\x1B.#\x19,!3(\x1D0\x24\x1A-\x22\x17)\x1E1&\x1B.\x24\x18+\x203'\x1D0%\x1A-\x22\x17)\x1E1'\x1B.\x24\x19*\x1F2(\x1D0%\x1A,!\x16)\x1E1'\x1C.#\x18+\x1F2(\x1E0%\x1A-!\x16)\x1F2'\x1D/#\x19,!\x16)\x1E1%\x1A-#\x17*\x203'\x1C/\x24\x18,!\x17)\x1E0%\x1A-#\x18*\x1F2'\x1B.\x24\x1A,!\x16)\x1D0%\x1B-#\x18+\x1F2'\x1C.\x24\x19,!\x16(\x1E0%\x1B.\x22\x17*\x1F1&\x1C/\x24\x19,!3(\x1D1%\x1B.#\x17)\x1F2'\x1C/\x24\x18+\x20\x16(\x1D1&\x1A-\x22\x17)\x1F2'\x1C/\x24\x19+\x20\x16)\x1D0&\x1B,\x22\x17*\x1F2'\x1C.#\x18+\x20\x16)\x1E0%\x1A-!\x17*\x202'\x1C.#\x18+!\x16(\x1D0\x24\x1A-\x22\x17*\x1F2&\x1B.\x24\x18+!\x16(\x1D0%\x1A-\x22\x18*\x1E1'\x1B.\x24\x19+\x20\x15(\x1D";
use constant MONTH_TYPES => "U,*TZT+**XU(ZTVT*XU*5(VTU4*T5*-(U4*TjT-(U4U(jTZT*hU*U(ZT*j*TU*-(UT*V*T-(UTU,*TZT+(U,U(ZT+**XU(ZTVT*Z*T5(VTU4*T5*-(U4*TjT-**hU(jTZT*hU*U(ZTUT*TU*5(UT*V*T5(UTU,*TjT+(U,U(jT+**XU*U(VT*Z*TU(VTU4*TU*-(U4U,*T-**hU,*TZT*j*XU(ZTUT*XU*5(UT*Z*T5*+(U4*TjT+(U4U(jTVT*hU*U(VT*j*TU(VTUT*V*T-(U4U,*T-**hU,U(ZT*j*XU(ZTUT*XU*5(UTU4*T5*+(U4*TjT+**hU(jTVT*hU*U(VT*j*TU*-(UT*V*T-(UTU,*TZT+(U,U(ZT+**XU(ZTVT*Z*T5(VTU4*T5*-(U4U(jT-**hU(jTZT*hU*U(ZTUT*TU*5(UT*V*T5*+(U,*TjT+(U,U(jT+**XU*U(VT*Z*TU(VTU4*V*T-(U4U,*T-**hU(jTZT*j*TU(ZTUT*TU*5(UTU,*T5*+(U,*TjT+(U,U(jTVT*XU*U(VT*Z*TU*-(U4*V*T-(U4U,*T-**hU,U(ZT*j*XU(ZTUT*Z*T5(UTU4*T5*+(U4*TjT+**hU(jTVT*hU*U(VTUT*TU*-(UT*V*T-(UTU,*TZT+(U,U(ZT+**XU*5(VT*Z*T5(VTU4*T5*-(U4U(jT-**hU(jTZT*j*TU(VTUT*TU*-(UT*V*T-*+(U,*TZT+(U,U(ZTVT*XU*5(VT*Z*T5(VTU4*TjT-(U4U(jT-**hU*U(ZT*j*TU(ZTUT*TU*5(UTU,*T5*+(U,*TjT+**XU(jTVT*XU*U(VT*Z*TU*-(U4*V*T-(U4U,*TZT*hU,U(ZT*j*XU(ZTUT*Z*T5(UTU4*T5*+(U4U(jT+**hU(jTVT*hU*U(VTUT*TU*-(U4*V*T-**hU,*TZT*hU,U(ZT*j*XU*5(UT*Z*T5(UTU4*TjT+(U4U(jT+**hU(jTVT*j*TU(VTUT*TU*-(UTU,*T-*+(U,*TZT+(U,U(ZTVT*XU*5(VT*Z*T5*-(U4*TjT-(U4U(jT-**hU*U(ZT*j*TU(ZTUT*TU*5(UTU,*T5*+(U,*TjT+**XU(jTVT*XU*U(VTU4*TU*-(U4*V*T-(U4U(jTZT*hU*U(ZT*j*TU(ZTUT*V*T5(UTU,*T5*+(U,U(jT+**XU(jTVT*XU*U(VTU4*TU*-(U4*V*T-**hU,*TZT*hU,U(ZTUT*XU*5(UT*Z*T5(UTU4*TjT+(U4U(jT+**hU(jTVT*j*TU(VTUT*TU*-(UTU,*T-*+(U,*TZT+(U,U(ZTVT*XU*5(VT*Z*T5*-(U4*TjT-(U4U0jTZT*hU*U(VT*j*TU(VTUT*V*T-(UTU,*T-*+(U,*TZT+**XU(ZTVT*XU*5(VTU4*T5*-(U4*TjT-(U4U(jTZT*hU*U(ZT*j*TU*5(UT*V*T5(UTU,*TjT+(U,U(jT+**XU(jTVT*Z*TU(VTU4*TU*-(U4*V*T-**hU,*TZT*hU,U(ZTUT*XU*5(UT*Z*T5(UTU4*TjT+(U4U(jT+**hU*U(VT*j*TU(VTU4*TU*-(U4U,*T-**hU,*TZT*j*XU(ZTUT*XU*5(UT*Z*T5*+(U4*TjT+(U4U(jTVT*hU*U(VT*j*TU(VTUT*V*T-(UTU,*T-*+(U,U(ZT+**XU(ZTVT*XU*5(VTU4*T5*-(U4*TjT-**hU(jTZT*hU*U(ZT*j*TU*5(UT*V*T5(UTU,*TjT+(U,U(jT+**XU(jTVT*Z*TU(VTU4*TU*-(U4U(jT-**hU(jTZT*hU*U(ZTUT*TU*5(UT*V*T5*+(U,*TjT+(U,U(jT+**XU*U(VT*Z*TU(VTU4*V*T-(U4U,*T-**hU,*TZT*j*XU(ZTUT*XU*5(UTU4*T5*+(U4*TjT+(U4U(jTVT*hU*U(VT*j*TU*-(UT*V*T-(UTU,*T-*+(U,U(ZT+**XU(ZTVT*Z*T5(VTU4*T5*-(U4*TjT-**hU(jTVT*hU*U(VTUT*TU*-(UT*V*T-(UTU,*TZT+(U,U(ZT+**XU*5(VT*Z*T5(VTU4*T5*-(U4U(jT-**hU(jTZT*j*TU(ZTUT*TU*5(UT*V*T5*+(U,*TjT+(U,U(jTVT*XU*U(VT*Z*TU(VTU4*V*T-(U4U,*T-**hU,U(ZT*j*XU(ZTUT*XU*5(UTU4*T5*+(U4*TjT+**hU(jTVT*hU*U(ZT*j*TU*5(UT*V*T5(UTU,*TZT+(U,U(ZT+**XU(ZTVT*Z*T5(VTU4*T5*-(U4U(jT-**hU(jTZT*hU*U(ZTUT*TU*5(UT*V*T5*+(U,*TjT+(U,U(jT+**XU*U(VT*Z*TU(VTU4*V*T-(U4U(jT-**hU(jTZT*j*TU(ZTUT*TU*5(UTU,*T5*+(U,*TjT+(U,U(jTVT*XU*U(VT*Z*TU*-(U4*V*T-(U4U,*T-**hU,U(ZT*j*XU(ZTUT*Z*T5(UTU4*T5*+(U,*TjT+**XU(jTVT*XU*U(VTU4*TU*-(U4*V*T-(U4U,*TZT*hU,U(ZT*j*XU*5(UT*Z*T5(UTU4*T5*+(U4U(jT+**hU(jTVT*j*TU(VTUT*TU*-(UT*V*T-**hU,*TZT*hU,U(ZTUT*XU*5(UT*Z*T5(UTU4*TjT+(U4U(jT+**hU*U(VT*j*TU(VTUT*TU*-(UTU,*T-*+(U,*TZT+**XU(ZTVT*XU&5(VT*Z*X,lJ\x5C\x24lR.2,5\x24VR5T\x15XJlI\x5C\x24\x5CdXj(u\x24m\x24-4\x15Z\x158I:I4dTj*Z(Zd+4*l\x12tI6ILTV4TV(ZTUT&l\x22lR\x5C),i(tT5*-(UT%Z%8Rl)\x1Ai\x18lTZT+(M4Jt%4R6R4i\x16U\x14ZT+*\x16hJl\x24n%(r,r,5\x146R5T\x15XJ\x5CI<\x24\x5C2,j,-&+\x24-T\x15Z\x24tX8h^\x24\x5C*(m\x14k\x24+,*t\x14lQ.),TTjJ:(fhUT%\x5C\x12n\x12\x5C),TN4T5(UTMT%Z%8R<)\x1E)(lL-*+0K4Jt%4R6R,Y\x18ZRZT*hc4JlDn\x24l2,U\x14u\x145TFj\x15XL\x5CI\x5CD\x5C2,j,-\x14-R+4\x15XI\x5CI8dZdXj(m\x24Zh+4\x15:\x12tI6I,TTZ*6(V\x5C\x0Al%l\x12lI.),TZ4TVHZXUXJl\x22n\x22\x5C1,j,5\x145*-,\x15\x5C\x09ZE8bXi*i(lTZT+(U4Rt%4TVT4i*U(VT*hel\x12l).\x24lT,Y&5(VTUT\x15XR\x5CQ\x5C(\x5C4,jL-\x24k(+4\x15:%8Q8hZdTjHm\x24Zh+4*l\x22tQ6Q,TTZ*6(VXUX)l\x22n\x22\x5C),4TtT5(VTUT%Xe0rXi*i(lT-&+(S4Jt%4R6R4Y\x18ZTZT*hJtJl\x24n\x24lR,U\x165\x24VT\x16j\x15XJ\x5CI8d\x5C2,j,-\x245T+4\x158I\x5CI8dZT4j(m\x14Zh+4\x156\x12tI6),TTZ*5(VT*l%l\x12lI.),4TjT5(UTKT%XR\x5CRXi\x1Ci\x18jT-*+(K4%:%4R4i\x1AY\x18ZTVT\x1AhJtJl\x24lR6R,U\x165\x24VT\x16j\x15XJ\x5C\x24n\x24\x5C2,5\x16-\x245T+4\x158I\x5CI8dXr*j(k\x14Zh+,\x156\x12tI4TVTTZ(ZTVT*f%l\x12l).),4T6*5(UTUT%XR\x5CRXi(tLjT-(UTK4%6%4R4i\x1AY\x18ZT+*\x1AhJtJl\x24lR.2,Y\x14ZR5T\x16hJlI\x5C\x24\x5Cd\x5C2,5\x14m\x14-0UXU8I8d\x5CdXj*j(k\x14-*+,\x134I:I4TVTTZ(ZTVT*l\x12v\x12\x5C),TV4T5*-(UT%j%XR\x5C)\x1Ci\x18tLjT-(U4K4%8R:R4i\x1AU\x14ZPk(VhJt%6\x24lR,Y\x165\x14ZJ5PVXJlI\x5C\x24\x5C2.*,5\x14m\x14-0UTU8I8d\x5CdXj(m\x14jT+&*l\x134I:I,TTj*Y(ZTVT*hRlR\x5C),TV4T5(VTUT%V%XR\x5C)\x1Ci\x18tL5*-(MT%Z%8R:R4i\x18jJZHk(+4Jt\x24v\x24lR,U\x165\x14ZPZhUXJl\x24n\x24\x5C2.*,5\x146J-0UXI\x5CI8d\x5CdXj(m\x14ZT+(U6\x12tI8dVTTj*Y(ZT+*&hRl).),TN4L5(VTUT%XR\x5CR\x5C)\x1C4LrL6&+(-T%Z%8R8i\x1Ai\x18jJZH[(+4*\x5C\x24tR6R,U\x14ZJZHZdUXJl\x22n\x24\x5C2,5\x165\x145J-0UX\x15:\x24xR4i\x16Y\x14ZHm\x24ZhJtJl\x24lR.R,U\x14ZJ6PVXUXI\x5C\x24v\x24\x5C2,5\x14m\x14-(UXS8I:I8dXj*j(jT-*+(S4I:I,RVTTY(ZTVT&hRtR\x5C).)\x1C4L5&5(UT%j%XS\x1CQ8hXtLj(m(-T+4%8Q:Q4hVU\x14ZHk(Vh*t\x24v\x22lQ,hVU\x14ZJ5HVX*lI\x5C\x22\x5CQ.),5\x14lT-(UXS8)8b\x5CRXi*i(jT-*+(S4):),T4i*Y(ZTVT&hRtR\x5C(lT.2L5&-(UT\x15j\x15XQ\x5C(\x5ChXr,5\x24m(-T+4\x158Q:Q4hTj*ZH[\x24Vh*t\x12v\x22lQ,TVTTZHZTUX*l%\x5C\x22\x5C).),4T6*-(UTS8%8R\x5CRXi(tTjT+(U4Jt%:\x24lR4i\x1AY(ZT+*\x16hJl%.\x24lR.2,5\x24VT5T\x15XJ\x5CI\x5C\x24\x5CdXr45\x24m(-4\x15Z\x138I8dZdTj*Z([\x24+4*l\x12tI6I,TV4T:(ZTUX)l\x12n\x12\x5C),TV4T5*-(UT%Z%8Q\x5C)\x1Ci(lTZT+(K4Jt%8R6R4i\x14jTZT+*\x16hJl\x24n\x24\x5CR,Y\x165\x24VT-T\x15XJ\x5CI<\x24\x5C2,j(u\x14k\x24+4\x15Z\x138I8dZdTj(m\x14Zd+4*l\x12tI6I,TTZ*6(VT*l%l\x12n\x12\x5C),TTtT5(VTUT%Z%8R\x5C)\x1Ai\x18lT-*+(K4%:%8R6R4i\x14jRZT\x1AhJtJl\x24n\x24\x5CR,Y\x165\x146PVj\x15hI\x5C\x24^\x24\x5C2,j(u\x14\x1DT+4\x15XI<I8dZTTj(m\x14ZT+,\x134RtI4dVTTZ*5(VT*j%hRl).),TTtT5(VTMT%XR\x5CR<)\x18tLjT-*+(K4%:\x24xR4i\x1Ai\x14jJZPZhJtJl\x24lR.R,U\x14ZJ6PVj\x15XI\x5C\x24^\x24\x5C2,5\x14m\x145HUXUXIZI8dXj*j(m\x14-*+(S4RtI4TVTTZ(ZTVT*hRtRl).),4L:*5(VT&j%XR\x5CR8i\x18tLjHm(5T+4%8R:R4i\x16Y\x14jHk(Zh*t%6\x24lR.R,U\x14ZJ6HVh*lI\x5C\x24\x5C2.2,5\x14m\x14-(UXU8I8d\x5CdXj*j(jT-*+(S4):)4TTj*Z(ZTVT*hRtRl),T.4L5&5(UT&j%XR\x5C(\x5ChXtL5\x24m(-T+4%8R:Q4hTjJZHk\x24Vh*t\x156\x22lQ,XVTTZHZdVX*l)\x5C\x22\x5C1.),4T6*-(UTS4%8R\x5CRXi(tTjT-(UTS4%:%,T4i*Y(ZT+*&hJt%.\x24lT.2,5\x24ZT5T\x15hJlI\x5C(\x5ChXr,5\x24m\x24-T\x15Z\x158Q8hZdTj*ZH[\x24+4*t\x12tQ6Q,TVTTZ(ZTVT*l\x12n\x12\x5C).),4T6*-(UT)Z%8R\x5C)*i(tTjT-(U4Jt%8RVR4i\x16Y\x24ZT+*\x16hJt%.\x24lR,Y\x165\x24VR5T\x15XJlI\x5C\x24\x5C2,r(u\x14m\x24-4\x15Z\x158I8dZdTj(m\x24k\x24+4*t\x14tQ6Q,TTj*Z(ZTVX*l\x12n\x12\x5C),TV4T6(VTUT%Z%8R\x5C),i(tT5*-(U4%Z%8R:R4i\x14lRZT+(K4Jt%6\x24lR,Y\x165\x24VPZj\x15XJl\x24n\x24\x5C2,r(u\x146R-T\x15XJ\x5CI8dZdTj(m\x14[\x24+4\x156\x12tI4dVTTj*Z(ZT+*&l\x12lI.),TV4T5(VTUT%XR\x5CR\x5C)\x1C4LlT5*+(M4%:%8R8i\x1Ai\x14jRZPk(K4Jl\x24lR6R,Y\x165\x146PZj\x15XJl\x24n\x24\x5C2,5\x14u\x146R-4\x15XI\x5CI8dXr*j(m\x14-*+0U6\x12tI4dVTTZ(]\x14ZT*j%hRl).),TTZ*5(VT*j%XR\x5CR\x5C)\x1C4LlL-(UTK4%:%8R4i\x1Ai\x14jHm([(K4%6\x24lR.R,Y\x14ZJ6PVhJlJ\x5C\x24n\x24\x5C2,5\x14u\x145HVXUXI\x5C\x24\x5CdXj*j(m\x14-*+(U4I:I4dVTTZ(ZTVT*hRtRl),TVTL:*5(VT&j%XR\x5C)\x1E)\x18tLjL-(UTK4%8R\x5CR4i\x18tJjH";
use constant LEAP_MONTH => "01090060030B0080040010A0060020B0080040C0090070030B008005001090060030C0080040010A0060020B0080040010A0070030B008005001090060030C0080040010A0060020C0090050010A0070030B008005001090060030C0080040010A0060030C0090050010A0070030B0080050020A0060030C0080050020A0060030C0090050010A0070030B0080050020A0060040C0080050020A0060030C0090050010A0070030B0080060020A0070040C0080050020B0070030C0090050010A0070030B0090060020A0070040C0080050020B0070030C0090050010B0080040C0090060020A0070040C0080050020B0070030C0090050020B0080040C0090060020A0070040C0090050020B007004001090050020B0080040C0090060020A007004001090050030B007004001090050020B0080040C0090060020A007004001090060030B0070040010A0060020B0080040C0090060020A008005001090060030B0070040010A0060020B0080040C0090060030B008005001090060030B0070040010A0060020B0080040010A0070030B008005001090060030B0070040010A0060020C0080040010A0070030B008005001090060030C0080040020A0060030C0080040010A0070030B008005001090060030C0080050020A0060030C0080050010A0070030B008005001090070040C0080050020A0060030C0090050010A0070030B0080050010A0070040C0080050020A0060030C0090050010A0070030C0090060020A0070040C0080050020A0060030C0090050010B0070030C0090050010A0070040C0080050020A0060030C0090050020B0070030C0090050010A0070040C0080050020A0060040C0080050020B0070030C0090050010A0070030B0080050020A0070040C0080050020B0070030C0090050010A0070030B0090060020A0070040C0080050020C007004001080060020B007004001090060030B007003001090050030A0080040C00A0060030B008005001090050030B0070050010A0060020C007004001090070030C007005001090070030C0080040020A0060030C0080040020A0070030B0090050010A0060030C0080050020A0060040C0080050010B0070030C007005001090070030C0080050020A0070030C0080050020A0070030C0090050020A0060040C0090050020A0060040C0090050010A0070030C0080050010A0070040C0080060020A007003001090050020A007003001090050020A0070040C0090050020A0060040C0090050020A0070040C0090060020A0070050020A0060020C008004002090070030C008005002090070040C0080040020A0060040B0090050010A0060030B0080050020A0060040C0080050010B00700300108005001090070030C0080050020A007003001090050030A0070030B0090050020A0060040C0090050030B0070040C0090050010C0070040C0080060020B007004001090060020B007003002090060020A008004001090050030B007004001090050040C0080040C00A0060020C007005001090060030B0070050020A0060020C008004002090060030B008004002090060030B0080040020A0060040B0080040010B006004002060050030700600400207005003080060040030700500307006004003070050030800600400307005004090060040030700500409006005002070050030A0060050030700500400206004002060050030020600400307005004090060040030700500408007005003080050040A006005003070050040C0060050030800500400206005002070050040020600500307006004003070050030800600400307005004080060040A006005003080050040020700500309005004002060050030B00600500207005003080060040030700500408006004003070050040800600400300";
use constant MIN_YEAR => -666;
use constant MAX_YEAR => 2100;

sub gregorian_to_rkyuureki ($$$) {
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
} # gregorian_to_rkyuureki

sub rkyuureki_to_gregorian ($$$$) {
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
} # rkyuureki_to_gregorian

1;

## License: Public Domain.
