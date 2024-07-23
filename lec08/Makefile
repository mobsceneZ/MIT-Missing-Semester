.PHONY: clean
paper.pdf: paper.tex plot-data.png
	pdflatex paper.tex
plot-%.png: %.dat plot.py
	./plot.py -i $*.dat -o $@
clean:
	git ls-files -o | xargs rm -f 
