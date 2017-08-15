
PAGES=\
index.html\
demo.html\
releases/index.html

INCLUDES=\
releases/releases.rst.inc

TEMPLATE=rst_template.txt
STYLESHEET_DIRS=_assets
STYLESHEETS=minimal.css,plain.css,borg.css

RST_OPTIONS=--template=$(TEMPLATE) \
  --embed-stylesheet --stylesheet-dirs=$(STYLESHEET_DIRS) --stylesheet-path=$(STYLESHEETS)

all: $(PAGES)

clean:
	rm -f $(PAGES)

%.html: %.rst rst_template.txt _assets/* $(INCLUDES)
	rst2html5.py $(RST_OPTIONS) $< $@

demo.html: demo.rst rst_template.txt _assets/* $(INCLUDES)
	# The asciinema stylesheet is really big (50K), so only embed it into the demo page,
	# not every page. To do this, we specialize on the pattern rule above.
	rst2html5.py $(RST_OPTIONS) --stylesheet-path=$(STYLESHEETS),_assets/asciinema-player-v2.4.1.css $< $@
