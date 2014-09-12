WGET = wget
GIT = git

all: impl
clean:
	rm -fr local/*.json local/*.out

updatenightly: clean impl
	$(GIT) add lib

deps:

impl: lib/Kyuureki.pm deps

lib/Kyuureki.pm: bin/generate.pl local/map.txt
	perl bin/generate.pl
	perl -c $@

local/map.txt:
	mkdir -p local
	$(WGET) -O $@ https://raw.githubusercontent.com/manakai/data-locale/staging/data/calendar/kyuureki-map.txt

test: test-deps
	perl -Ilib t/test1.t
	perl -Ilib t/test2.t

test-deps: impl