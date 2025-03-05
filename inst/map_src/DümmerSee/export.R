

require(sf)
require(dplyr)

x = st_read("./inst/map_src/DümmerSee/OsterFeinerMoor.kml")
OsterFeinerMoor = select(x, Name) |> rename(id = Name)


usethis::use_data(OsterFeinerMoor, overwrite = TRUE)
