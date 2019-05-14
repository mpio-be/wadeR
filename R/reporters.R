#' @title        pdf reports
#' @param        Species  species
#' @description  reporter_TABLENAME exports the TABLENAME summary as pdf
#' @return       a path to the pdf file
#' @export
#' @examples
#' reporter_NESTS('PESA')



reporter_NESTS <- function(Species) {

	# DATA
	n = NESTS()
	n = n[species == Species, .(nest, state = nest_state, lastCheck, iniClutch, clutch, MSR, IN, m_sure, f_sure)]

	# TODO: prepare n to show optimal output


	# REPORT
	xtab = xtable(n, auto = TRUE, 
		caption = glue(' {Species} , { format(Sys.time(), "%a, %d %b %Y %H h" )}')%>%as.character ) %>% print( 
		print.results = FALSE,
		latex.environments = "flushleft", 
		tabular.environment="longtable",
		caption.placement = 'top', 
		floating = FALSE, 
		hline.after = 0:nrow(.)
		) 

	latex = glue("
		\\documentclass[letterpaper]{{article}}
		\\usepackage[left=1cm,top=1cm,right=1cm,bottom=1cm]{{geometry}}
		\\usepackage{{caption}}
		\\captionsetup{{labelformat=empty}}
		\\usepackage[utf8]{{inputenc}}
		\\usepackage{{longtable}}

		\\begin{{document}}

				{xtab}

		\\end{{document}}
		")


	ofile = tempfile(fileext = '.pdf')
	infile = str_replace(ofile, 'pdf$', 'tex')

	cat(latex, file =  infile) 

	wd = tempdir() %>% setwd

	tools::texi2pdf(infile, clean = TRUE)

	setwd(wd)

	Sys.chmod(ofile)
	ofile
	

}