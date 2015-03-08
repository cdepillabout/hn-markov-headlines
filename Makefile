.PHONY: create-headlines download-headlines install

all:
	$(MAKE) create-headlines

.cabal-sandbox:
	cabal sandbox init

.cabal-sandbox/bin/hn-download-headlines: src/DownloadMain.hs
	$(MAKE) install

.cabal-sandbox/bin/hn-create-markov-headlines: src/CreateMain.hs
	$(MAKE) install

storiesList:
	$(MAKE) download-headlines

download-headlines: .cabal-sandbox/bin/hn-download-headlines
	.cabal-sandbox/bin/hn-download-headlines > storiesList

create-headlines: .cabal-sandbox/bin/hn-create-markov-headlines storiesList
	.cabal-sandbox/bin/hn-create-markov-headlines < storiesList

install: .cabal-sandbox
	cabal install
