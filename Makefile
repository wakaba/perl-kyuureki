WGET = wget
GIT = git

all: impl
clean:
	rm -fr local/*.json local/*.out

updatenightly: clean impl
	$(GIT) add lib

deps:

impl: lib/Kyuureki.pm lib/Kyuureki/Ryuukyuu.pm deps

lib/Kyuureki.pm: bin/generate.pl local/map.txt
	perl bin/generate.pl kyuureki
	perl -c $@

lib/Kyuureki/Ryuukyuu.pm: bin/generate.pl local/rmap.txt
	perl bin/generate.pl rkyuureki
	perl -c $@

local/map.txt:
	mkdir -p local
	$(WGET) -O $@ https://raw.githubusercontent.com/manakai/data-locale/staging/data/calendar/kyuureki-map.txt
local/rmap.txt:
	mkdir -p local
	$(WGET) -O $@ https://raw.githubusercontent.com/manakai/data-locale/staging/data/calendar/kyuureki-ryuukyuu-map.txt

test: test-deps test-main

test-main:
	perl -Ilib t/test1.t
	perl -Ilib t/test2.t
	perl -Ilib t/test1r.t
	perl -Ilib t/test2r.t

test-deps: impl