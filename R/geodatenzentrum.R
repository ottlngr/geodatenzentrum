#' geodatenzentrum
#'
#' @import bowerbird
#' @importFrom R6 R6Class
#' @importFrom tools file_path_sans_ext
#' @importFrom sf st_read
#' @importFrom broom tidy
#' @export

geodatenzentrum <- R6Class("geodatenzentrum", list(

  sources = list(
    "vg250" = bb_source(
      name = "VG250",
      description = "The data stock comprises all administrative units of all hierarchical levels of public authority from the state to the municipalities with their administrative boundaries, statistical code numbers and the name of the administrative unit as well as the specific designation of the level of public authority of the respective federal state.",
      id = "1234",
      doc_url = "http://sg.geodatenzentrum.de/web_download/vg/vg250_3112/vg250_3112.pdf",
      license = "dl-de/by-2-0",
      citation = "© GeoBasis-DE / BKG 2019",
      source_url = "http://sg.geodatenzentrum.de/web_download/vg/vg250_0101/utm32s/shape/vg250_0101.utm32s.shape.ebenen.zip",
      method = list("bb_handler_rget"),
      postprocess = list("bb_unzip")
    ),
    "kfz250" = bb_source(
      name = "KFZ250",
      id = "1234",
      doc_url = "abc",
      license = "abc",
      citation = "abc",
      source_url = "http://www.geodatenzentrum.de/auftrag1/archiv/vektor/kfz250/2018/kfz250_2018-09.utm32s.shape.zip",
      method = list("bb_handler_rget"),
      postprocess = list("bb_unzip")
    )
  ),

  local_file_root = NULL,
  bb_config = NULL,
  collections = list(),
  layers = NULL,

  initialize = function(local_file_root) {

    self$local_file_root <- local_file_root
    self$bb_config <- bb_config(local_file_root)

  },

  print = function() {
    cat("<geodatenzentrum>",
        "\n\n",
        "Local file root: ",
        paste(self$local_file_root),
        "\n\n",
        "Available sources: ",
        paste0(names(self$sources), collape = ", "),
        "\n\n",
        "Reference: http://www.geodatenzentrum.de/",
        sep = "")
  },

  sync = function(source) {

    self$collections[[source]] <- bb_sync(bb_add(self$bb_config, self$sources[[source]]), verbose = TRUE, create_root = TRUE)

  },

  files = function(collection) {

    self$collections[[collection]]$files[[1]]$file

  },

  shp_layers = function(collection) {

    files <- self$files(collection)
    files <- files[grepl(".shp", files)]
    files <- sapply(files, file_name_without_ext, USE.NAMES = FALSE)
    return(files)

    # files <- self$files(collection)
    # files <- tools::file_path_sans_ext(files[grepl(".shp", files)])
    # self$layers <- basename(files)

  },

  read_sf = function(collection, layer) {

    f <- self$files(collection)
    shp <- f[grepl(pattern = ".shp", f)]
    dsn <- dirname(shp)

    sf <- st_read(dsn, layer)

    return(sf)

  },

  make_sp = function(sf) {

    sp <- as(sf, "Spatial")

    return(sp)

  },

  make_df = function(sp) {

    sp@data$id <- rownames(sp@data)
    points <- tidy(sp)
    df <- merge(points, sp@data, by = "id")

    return(df)

  },

  fortify = function(collection, layer) {

    sf <- self$read_sf(collection, layer)
    sp <- self$make_sp(sf)
    df <- self$make_df(sp)

    return(df)

  }

))

file_name_without_ext <- function(filename) {

  a <- strsplit(filename, "/", fixed = TRUE)[[1]]
  f <- a[length(a)]
  f <- sub("([^.]+.+)\\.[[:alnum:]]+$", "\\1", f)
  return(f)

}
