#' geodatenzentrum
#'
#' tbd.
#'
#' @section Usage
#' GDZ <- geodatenzentrum$new(local_file_root)
#'
#' GDZ$snyc(source)
#' GDZ$files(collection)
#' GDZ$shp_layers(collection)
#' GDZ$describe(collection)
#' GDZ$read_sf(collection, layer)
#' GDZ$make_sp(sf)
#' GDZ$make_df(sp)
#' GDZ$fortify(collection, layer)
#'
#' @section Arguments
#' * `GDZ`: `geodatenzentrum` object.
#' * `local_file_root`: Path to sync remote data sources to.
#'
#' @section Details
#' tbd.
#' @import bowerbird
#' @importFrom R6 R6Class
#' @importFrom tools file_path_sans_ext
#' @importFrom sf st_read
#' @importFrom sp CRS
#' @importFrom broom tidy
#' @export

geodatenzentrum <- R6Class("geodatenzentrum", list(

  sources = list(
    "VG250" = bb_source(
      name = "VG250",
      description = "The data stock comprises all administrative units of all hierarchical levels of public authority from the state to the municipalities with their administrative boundaries, statistical code numbers and the name of the administrative unit as well as the specific designation of the level of public authority of the respective federal state.",
      id = "vg250_0101.utm32s.shape.ebenen",
      doc_url = "http://sg.geodatenzentrum.de/web_download/vg/vg250_3112/vg250_3112.pdf",
      license = "dl-de/by-2-0",
      citation = "© GeoBasis-DE / BKG 2019",
      source_url = "http://sg.geodatenzentrum.de/web_download/vg/vg250_0101/utm32s/shape/vg250_0101.utm32s.shape.ebenen.zip",
      method = list("bb_handler_rget"),
      postprocess = list("bb_unzip")
    ),
    "VG250_EW" = bb_source(
      name = "VG250_EW",
      description = "The data stock comprises all administrative units of all hierarchical levels of public authority from the state to the municipalities with their administrative boundaries, statistical code numbers and the name of the administrative unit as well as the specific designation of the level of public authority of the respective federal state. The product VG250-EW contains population figures additionally.",
      id = "vg250-ew_2017-12-31.utm32s.shape.ebenen",
      doc_url = "http://sg.geodatenzentrum.de/web_download/vg/vg250-ew_3112/vg250-ew_3112.pdf",
      license = "dl-de/by-2-0",
      citation = "© GeoBasis-DE / BKG 2019",
      source_url = "http://www.geodatenzentrum.de/auftrag1/archiv/vektor/vg250_ebenen/2017/vg250-ew_2017-12-31.utm32s.shape.ebenen.zip",
      method = list("bb_handler_rget"),
      postprocess = list("bb_unzip")
    ),
    "KFZ250" = bb_source(
      name = "KFZ250",
      description = "he overview of the license plate numbers contains the feature type AX_KreisRegion and AX_Gemeinde with attributes about: Name, Regional key of the administrative areas License plate number and Position (geometry data from the administrative areas in the scale 1:250 000 and additionally attributive geographical coordinates - GGMMSS -)",
      id = "kfz250_2018-09.utm32s.shape",
      doc_url = "http://sg.geodatenzentrum.de/web_download/sonstige/kfz250/kfz250.pdf",
      license = "dl-de/by-2-0",
      citation = "© GeoBasis-DE / BKG 2019",
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
    files <- sapply(files, basename_without_extension, USE.NAMES = FALSE)
    return(files)

  },

  describe = function(collection) {

    name <- self$sources[[collection]]$name
    description <- self$sources[[collection]]$description
    doc_url <- self$sources[[collection]]$doc_url
    license <- self$sources[[collection]]$license
    citation <- self$sources[[collection]]$citation

    n_files <- length(self$files(collection = collection))
    shp_layers <- self$shp_layers(collection = collection)

    cat("\n",
        sprintf("<%s>", name),
        "\n\n",
        paste(description), "\n\n",
        "Documentation: ", paste(doc_url), "\n",
        "Lincense: ", paste(license), "\n",
        "Citation: ", paste(citation), "\n\n",
        sprintf("Contains %s files. Call $files() for details.", n_files), "\n\n",
        "Contained shp layers: ", paste0(shp_layers, collapse = ", "), "\n\n",
        sep = "")

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
    #sp <- sp::spTransform(sp, "+proj=longlat +datum=EPSG:32732 +no_defs +ellps=EPSG:32732 +towgs84=0,0,0")
    sp <- sp::spTransform(sp, CRS("+init=epsg:32732"))

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

