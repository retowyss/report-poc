# R Report POC
library(plumber)

# Setup -----------------------------------------------------------------------

if(!fs::dir_exists("static")) {
  fs::dir_create("static")
}

rmarkdown::render(
  input = "index.Rmd", 
  output_file = "static/index.html", 
  clean = TRUE
)

# This makes the rendered index file available at the base url
#* @assets ./static /
list()

# Shared Functions ------------------------------------------------------------

render_Rmd <- function(fn, ext, args) {
  tmp <- fs::file_temp(ext = ext)
  rmarkdown::render(
    input = paste0("reports/", fn, ".Rmd"), 
    output_file = tmp, 
    clean = TRUE,
    params = args,
  )
  
  readBin(tmp, "raw", n = fs::file_info(tmp)$size)
} 

# Reports ---------------------------------------------------------------------

# rnorm plot in pdf
#* @serializer contentType list(type="application/pdf")
#* @get /rnorm/<n:int>
function(n){
  n <- min(n, 10e5)
  render_Rmd("rnorm", ".pdf", list(n = n))
}

# Swiss Public Transport Time Table
#* @serializer contentType list(type="application/pdf")
#* @get /swiss-public-transport-timetable/<from>/<to>
function(from, to){
  args <- list(from = from, to = to)
  render_Rmd("swiss-public-transport-timetable", ".pdf", args)
}


# Plotly Plot
#* @get /plotly/<species>
#* @html
function(species){
  args <- list(species = species)
  render_Rmd("plotly", ".html", args)
}



