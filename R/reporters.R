

reporter_NESTS <- function(species) {

# DATA
n = NESTS()
n = n[, .(nest, state = nest_state, lastCheck, iniClutch, clutch, MSR, IN, m_sure, f_sure)]


# REPORT
xtab = xtable(n, auto = TRUE, caption = NULL, floating = TRUE, floating.environment = "sidewaystable", 
	latex.environments = "" )
xtab = print(xtab, hline.after = 0:nrow(xtab))


latex = glue("
	\\documentclass[12pt]{{standalone}}
	\\usepackage{{caption}}
	\\begin{{document}}
	\\minipage{{\\textwidth}}
		{xtab}
	\\captionof{{table}}{{My caption}}
	\\endminipage,
	\\end{{document}}
	")


ofile = tempfile(fileext = '.pdf')
infile = str_replace(ofile, 'pdf$', 'tex$')

cat(latex, file =  infile) 

tools::texi2pdf(infile, clean = TRUE)

	
}