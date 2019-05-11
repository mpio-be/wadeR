
# How to exclude inactive (closed) nests not to show on the map
 - create a new `nest_state` class : `nota` = not active
 - update `NESTS()` to ignore `nota` nests

system.file("examples/showcase/classic/app.R", package = 'bs4Dash')