# -*- mode: Makefile -*-
all: arch.png arch.pdf

clean:
	-rm -f arch.jpg arch.pdf

arch.ps: arch.dot
	dot -Tps2 -l DatabaseShape.ps arch.dot -o $@

arch.pdf: arch.ps
	ps2pdf $<

arch.jpg: arch.ps
	gs -sDEVICE=jpeg -r60 -sPAPERSIZE=a4 -dBATCH -dNOPAUSE -sOutputFile=$@ $<

arch.png: arch.ps
	gs -sDEVICE=png256 -r150 -sPAPERSIZE=a4 -dBATCH -dNOPAUSE -sOutputFile=$@ $<

# Generate from prolog
arch.dot:
	swipl -q -l arch.pro -t "make_dot_file()" | tee arch.dot

.PHONY:
