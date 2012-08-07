all: slides.html

slides.html: slides.md
	pandoc --self-contained -s -t slidy -o $@ $<

clean:
	-rm -f slides.html