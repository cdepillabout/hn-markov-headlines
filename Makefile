.PHONY: create-headlines download-headlines install

all:
	$(MAKE) download-headlines
	$(MAKE) create-headlines

.cabal-sandbox:
	cabal sandbox init

.cabal-sandbox/bin/hn-download-headlines:
	$(MAKE) install

storyTitles:
	$(MAKE) download-headlines

download-headlines: .cabal-sandbox/bin/hn-download-headlines
	$(MAKE) install
	.cabal-sandbox/bin/hn-download-headlines > storyTitles

create-headlines: .cabal-sandbox/bin/hn-create-markov-headlines storyTitles

install: .cabal-sandbox
	cabal install
