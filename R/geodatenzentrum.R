#' geodatenzentrum
#'
#' tbd.
#'
#' @usage NULL
#' @format [R6::R6Class] object.
#'
#' @section Construction:
#' ```
#' GDZ <- geodatenzentrum$new(local_file_root)
#' ```
#'
#' * `GDZ`: `geodatenzentrum` object.
#' * `local_file_root`: Path to sync remote data sources to.
#'
#' @section Methods:
#' `$sync(source)`\cr
#' Syncs a remote data source to the `local_file_root`. Available data sources are listed in `$sources`.
#'
#' `$files(collection)`\cr
#' Lists all synced files for a collection/data source.
#'
#' `$shp_layers(collection)`\cr
#' Lists all available shp layers for a collection/data source.
#'
#' `$describe(collection)`\cr
#' Returns information on a collection/data source, e.g. documentation, citation and license.'
#'
#' `$read_sf(collection, layer)`\cr
#' Returns an object of class `sf` for a layer of a collection/data source.
#'
#' `$make_sp(sf)`\cr
#' Retuns an object of class `Spatial` for a given object of class `sf`.
#'
#' `$make_df(sp)`\cr
#' Fortifies a given object of class `Spatial` to a `data.frame`.
#'
#' `$fortify(collection, layer)`\cr
#' Combines `$read_sf()`, `$make_sp()` and `$make_df()` and returns a fortified `data.frame` for a given layer of a collection/data source.
#'
#' @name geodatenzentrum
#' @import bowerbird
#' @importFrom R6 R6Class
#' @importFrom sf st_read
#' @importFrom sp CRS
#' @importFrom broom tidy
#' @examples
#' \dontrun{
#' library(geodatenzentrum)
#'
#' # Create an instance of class geodatenzentrum
#' GDZ <- geodatenzentrum$new(local_file_root="./geodatenzentrum")
#'
#' # List available data sources
#' GDZ$sources
#'
#' # Sync a data source
#' GDZ$sync(source = "VG250")
#'
#' # List available shp layers for the collection
#' GDZ$shp_layers(collection = "VG250")
#'
#' # Fortify a shp layer to a data.frame
#' GDZ$fortify(collection = "VG250", layer = "VG250_KRS")
#' }
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
      description = "The overview of the license plate numbers contains the feature type AX_KreisRegion and AX_Gemeinde with attributes about: Name, Regional key of the administrative areas License plate number and Position (geometry data from the administrative areas in the scale 1:250 000 and additionally attributive geographical coordinates - GGMMSS -)",
      id = "kfz250_2018-09.utm32s.shape",
      doc_url = "http://sg.geodatenzentrum.de/web_download/sonstige/kfz250/kfz250.pdf",
      license = "dl-de/by-2-0",
      citation = "© GeoBasis-DE / BKG 2019",
      source_url = "http://www.geodatenzentrum.de/auftrag1/archiv/vektor/kfz250/2018/kfz250_2018-09.utm32s.shape.zip",
      method = list("bb_handler_rget"),
      postprocess = list("bb_unzip")
    ),
    "NUTS250" = bb_source(
      name = "NUTS250",
      description = "For the territory of the Federal Republic of Germany, the dataset comprises the regions of the systematics of the territorial units NUTS for the purpose of European statistics.",
      id = "nuts250_0101.utm32s.shape",
      doc_url = "http://sg.geodatenzentrum.de/web_download/nuts/nuts250_0101/nuts250_0101_eng.pdf",
      license = "dl-de/by-2-0",
      citation = "© GeoBasis-DE / BKG 2019",
      source_url = "http://sg.geodatenzentrum.de/web_download/nuts/nuts250_0101/utm32s/shape/nuts250_0101.utm32s.shape.zip",
      method = list("bb_handler_rget"),
      postprocess = list("bb_unzip")
    ),
    "VZ250" = bb_source(
      name = "VZ250",
      description = "The dataset includes the 'Gemeinden' (municipalities) of the Federal Republic of Germany with the superior administrative units and the corresponding NUTS regions.",
      id = "vz250_0101.utm32s.shape",
      doc_url = "http://sg.geodatenzentrum.de/web_download/vz/vz250_0101/vz250_0101_eng.pdf",
      license = "dl-de/by-2-0",
      citation = "© GeoBasis-DE / BKG 2019",
      source_url = "http://sg.geodatenzentrum.de/web_download/vz/vz250_0101/utm32s/shape/vz250_0101.utm32s.shape.zip",
      method = list("bb_handler_rget"),
      postprocess = list("bb_unzip")
    ),
    "VG2500" = bb_source(
      name = "VG2500",
      description = "The data stock comprises the administrative units of the hierarchical levels of public authority from the state to the districts with: their boundaries, the regional key number and the name of the administrative unit as well as the specific designation of the level of public authority of the respective federal state.",
      id = "vg2500.utm32s.shape",
      doc_url = "http://sg.geodatenzentrum.de/web_download/vg/vg2500/vg2500_eng.pdf",
      license = "dl-de/by-2-0",
      citation = "© GeoBasis-DE / BKG 2019",
      source_url = "http://sg.geodatenzentrum.de/web_download/vg/vg2500/utm32s/shape/vg2500.utm32s.shape.zip",
      method = list("bb_handler_rget"),
      postprocess = list("bb_unzip")
    ),
    "VG1000" = bb_source(
      name = "VG1000",
      description = "The data stock comprises the administrative units of the hierarchical levels of public authority from the state to the districts with their administrative boundaries, statistical code numbers and the name of the administrative unit as well as the specific designation of the level of public authority of the respective federal state.",
      id = "vg1000_0101.utm32s.shape.ebenen",
      doc_url = "http://sg.geodatenzentrum.de/web_download/vg/vg1000_0101/vg1000_0101_eng.pdf",
      license = "dl-de/by-2-0",
      citation = "© GeoBasis-DE / BKG 2019",
      source_url = "http://sg.geodatenzentrum.de/web_download/vg/vg1000_0101/utm32s/shape/vg1000_0101.utm32s.shape.ebenen.zip",
      method = list("bb_handler_rget"),
      postprocess = list("bb_unzip")
    ),
    "VG1000" = bb_source(
      name = "VG1000",
      description = "The data stock comprises the administrative units of the hierarchical levels of public authority from the state to the districts with their administrative boundaries, statistical code numbers and the name of the administrative unit as well as the specific designation of the level of public authority of the respective federal state.",
      id = "vg1000_0101.utm32s.shape.ebenen",
      doc_url = "http://sg.geodatenzentrum.de/web_download/vg/vg1000_0101/vg1000_0101_eng.pdf",
      license = "dl-de/by-2-0",
      citation = "© GeoBasis-DE / BKG 2019",
      source_url = "http://sg.geodatenzentrum.de/web_download/vg/vg1000_0101/utm32s/shape/vg1000_0101.utm32s.shape.ebenen.zip",
      method = list("bb_handler_rget"),
      postprocess = list("bb_unzip")
    ),
    "GN250" = bb_source(
      name = "GN250",
      description = "The Geographical Names contain names of the object ranges settlement, traffic, vegetation, water bodies, relief and areas.",
      id = "gn250.utm32s.shape",
      doc_url = "http://sg.geodatenzentrum.de/web_download/gn/gn250/gn250_eng.pdf",
      license = "dl-de/by-2-0",
      citation = "© GeoBasis-DE / BKG 2019",
      source_url = "http://sg.geodatenzentrum.de/web_download/gn/gn250/utm32s/shape/gn250.utm32s.shape.zip",
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
        "Use $describe() to get more detailed information on a data soource.",
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
    sp <- sp::spTransform(sp, CRS("+init=epsg:4326"))

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

