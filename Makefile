
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

commit-rebuild: clean all
	git add $(PAGES)
	git commit -m "ran make commit-rebuild"

%.html: %.rst rst_template.txt _assets/* $(INCLUDES)
	rst2html5 $(RST_OPTIONS) $< $@
