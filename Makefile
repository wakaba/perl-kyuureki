WGET = wget
GIT = git

all: impl
clean:
	rm -fr local/*.json local/*.out

updatenightly: clean impl
	$(GIT) add lib

impl: lib/Kyuureki.pm

lib/Kyuureki.pm: bin/generate.pl local/map.txt
	perl bin/generate.pl
	perl -c $@

local/map.txt:
	mkdir -p local
	$(WGET) -O $@ https://raw.githubusercontent.com/manakai/data-locale/staging/data/calendar/kyuureki-map.txt

test: impl
	perl -Ilib t/test1.t
	perl -Ilib t/test2.t
