
# NOTE (threejs-gsap-site branch): index.html is a hand-written three.js/GSAP
# page committed directly, NOT generated from index.rst — keep it out of PAGES
# so `make` / `make clean` do not overwrite or delete it.
PAGES=\
demo.html \
support/free.html \
support/fund.html \
support/commercial.html \
releases/index.html \
releases/borg-1.1.html \
releases/borg-1.2.html \
releases/borg-1.4.html \
releases/borg-2.0.html

INCLUDES=\
releases/releases.rst.inc

TEMPLATE=rst_template.txt
STYLESHEET_DIRS=_assets
STYLESHEETS=borg.css

RST_OPTIONS=--template=$(TEMPLATE) \
  --embed-stylesheet --stylesheet-dirs=$(STYLESHEET_DIRS) --stylesheet-path=$(STYLESHEETS)

all: $(PAGES)

clean:
	rm -f $(PAGES)

%.html: %.rst rst_template.txt _assets/* $(INCLUDES)
	rst2html5 $(RST_OPTIONS) $< $@

demo.html: demo.rst rst_template.txt _assets/* $(INCLUDES)
	# The asciinema stylesheet is really big (50K), so only embed it into the demo page,
	# not every page. To do this, we specialize on the pattern rule above.
	rst2html5 $(RST_OPTIONS) --stylesheet-path=$(STYLESHEETS),_assets/asciinema-player-v2.4.1.css $< $@
