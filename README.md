[![Build Status](https://travis-ci.org/mpio-be/wadeR.svg?branch=master)](https://travis-ci.org/mpio-be/wadeR)


wadeR
------------
 Field work organizer (mapping and data entry).

Installation
------------

``` r
install.packages("devtools")
devtools::install_github("mpio-be/wadeR")
```

Site install
``` r
  require(wadeR)
  wadeR::install_ui(pwd = askpass::askpass()  )
```

Notes
------------
 - data entry pages are customized from `./inst/UI/DataEntry/_TABLENAME_/global.R` files
 

 