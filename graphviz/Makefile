template.png template.pdf: template.gv
	dot -Tpng template.gv > template.png
	dot -Tpdf template.gv > template.pdf

big-template.png big-template.pdf: big-template.gv
	dot -Tpng big-template.gv > big-template.png
	dot -Tpdf big-template.gv > big-template.pdf

clean:
	rm -f *.png *.pdf
