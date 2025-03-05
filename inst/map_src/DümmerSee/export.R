

require(sf)
require(dplyr)

x = st_read("./inst/map_src/DümmerSee/OsterFeinerMoor.kml") |> st_zm()
OsterFeinerMoor =
  select(x, Name) |>
  rename(id = Name) |>
  st_make_valid()


usethis::use_data(OsterFeinerMoor, overwrite = TRUE)
