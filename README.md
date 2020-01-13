[![Build Status](https://travis-ci.org/mpio-be/wadeR.svg?branch=master)](https://travis-ci.org/mpio-be/wadeR)

wadeR
------------
Wader (or any open breeder) field work organizer: mapping and data entry. 

Package installation
------------

``` r
devtools::install_github("mpio-be/wadeR")
```

### Previous versions
``` r
# tuned to work with Red Phalarope as main study species. 
devtools::install_github("mpio-be/wadeR@2019")

```

Site installation
``` r
  require(wadeR);
  install_ui(install_package = TRUE)
```


Web server reload
``` r
  wadeR::reboot_webserver()
```



Notes
------------
 - data entry pages are customized from `./inst/UI/DataEntry/_TABLENAME_/global.R` files
 

 