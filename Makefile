# Not a real makefile.

.PHONY: default generate show fastcoll clean test

default: generate

generate:
	./generate.sh

show:
	md5sum $(wildcard bin/program-*)
	@find bin -type f -name 'program-*' -exec sh -c 'echo ./{}: && {}' \;

fastcoll:
	curl "http://www.win.tue.nl/hashclash/fastcoll_v1.0.0.5_source.zip" -Lo fastcoll.zip
	# unzip shit
	unzip fastcoll.zip -d fastcoll-src
	rm fastcoll.zip
	patch -s fastcoll-src/main.cpp main.cpp.patch
	g++ -o fastcoll \
	  fastcoll-src/block1stevens01.cpp \
	  fastcoll-src/block1stevens11.cpp \
	  fastcoll-src/block1wang.cpp \
	  fastcoll-src/block1stevens00.cpp \
	  fastcoll-src/block1stevens10.cpp \
	  fastcoll-src/block0.cpp \
	  fastcoll-src/main.cpp \
	  fastcoll-src/md5.cpp \
	  fastcoll-src/block1.cpp \
	  -lboost_system -lboost_filesystem -lboost_timer -lboost_program_options \
	  -O3 -march=native
	rm -r fastcoll-src

clean:
	rm -rf bin out fastcoll

