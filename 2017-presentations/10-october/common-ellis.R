library(magrittr)

neuter_program_name <- function( x, max_length = 28L, substitution_character = "?" ) {
  chopped <- tolower(substr(x, 1, max_length))
  # gsub("\\s", "+", chopped)
  # letters_only <- gsub("[^a-z]", "+", chopped)
  # base::iconv(
  #     x     = letters_only,
  #     from  = "latin1",
  #     to    = "ASCII//TRANSLIT",
  #     sub   = substitution_character
  #   )
  chopped
}

clean_to_ascii <- function( x, substitution_character="?" ) {
  base::iconv(x=x, from="latin1", to="ASCII//TRANSLIT", sub=substitution_character)
}

# convert_sas_to_csv <- function( directory, path_in, path_out, rename_columns=TRUE ) {
#   d_sas   <- haven::read_sas(file.path(uri_directory, path_in))
#   if( rename_columns )
#     colnames(d_sas) <- unname(sjmisc::get_label(d_sas))
#   readr::write_csv(d_sas, file.path(uri_directory, path_out))
# }

retrieve_program <- function ( ) {
  sql_program <- "
    SELECT
      p.program_code,
      p.program_name_ugly   AS program_name,
      m.model_name_short    AS model_name,
      m.model_id,
      p.miechv_3
      -- c.county_name,
      -- c.county_id,
    FROM Osdh.tbl_lu_program AS p
      INNER JOIN Osdh.tbl_lu_model AS m ON p.model_id=m.model_id
      -- INNER JOIN Osdh.tbl_lu_county AS c ON p.county_id = c.county_id
  "

  channel         <- open_dsn_channel()
  ds_program      <- RODBC::sqlQuery(channel, sql_program, stringsAsFactors=FALSE)
  RODBC::odbcClose(channel); rm(channel, sql_program)

  ds_program <- ds_program %>%
    tibble::as_tibble() %>%
    dplyr::mutate(
      program_name_neutered         = neuter_program_name(program_name)
    )
}

# retrieve_key <- function( uri_name ) {
#   checkmate::assert_string(uri_name, pattern="^[-A-Za-z0-9]+$")
#   sql <- "EXEC Security.prc_key_value_static @project='miechv', @attribute = ?"
#
#   channel         <- open_dsn_channel(dsn_name = "BbmcSecurity")
#   uri_directory   <- RODBCext::sqlExecute(channel, sql, data = uri_name, stringsAsFactors=FALSE, fetch=TRUE)[1, 'value']
#   #
#   # uri_directory   <- RODBCext::sqlExecute(channel, "EXEC Security.prcUri @UriName = ?", data = uri_name, stringsAsFactors=FALSE, fetch=TRUE)[1, 'Value']
#   # uriDirectory  <- RODBC::sqlQuery(channel, "EXEC Security.prcUri @UriName = 'EtoDump'", stringsAsFactors=FALSE)[1, 'Value']
#   # date_dump <- as.Date(gsub("^.+?/(\\d{4}-\\d{2}-\\d{2})$", "\\1",  uri_directory))
#
#   RODBC::odbcClose(channel); rm(channel)
#
#   return( uri_directory )
# } # retrieve_uri(uri_name="eto-dump")

retrieve_eto_dump <- function( file_name="" ) {
  parent_directory <- OuhscMunge::retrieve_key_value("eto-dump-parent", "miechv", "BbmcSecurity")
  eto_dump <- file.path(
    # retrieve_key(uri_name="eto-dump-parent"),
    parent_directory,
    miechv3::config_value("dump_eto_subdirectory"),
    file_name
  )

  if( !dir.exists(eto_dump) & !file.exists(eto_dump) )
    stop("The eto-dump file/directory does not exist at `", eto_dump, "`.  The package may need to be rebuilt on your local machine.")

  return( eto_dump )
}# retrieve_eto_dump()
# retrieve_eto_dump("bbmc-touchpoint-visit-03.csv")

open_dsn_channel <- function( dsn_name="MiechvEvaluation" ) {
  requireNamespace("RODBC")

  # Uses Trusted/integrated authentication
  channel <- RODBC::odbcConnect(dsn = dsn_name)
  testit::assert("The ODBC channel should open successfully.", channel != -1L)

  info <- RODBC::odbcGetInfo(channel)
  testit::assert(
    "The ODBC driver version must be at least 13.0",
    numeric_version(info["Driver_Ver"]) >= numeric_version("13.0")
  )

  return( channel )
}
# source("./manipulation/osdh/ellis/common-ellis.R")
# channel <- open_dsn_channel()
# RODBC::odbcClose(channel); rm(channel)

# first_nonmissing <- function( x ) {
# Moved to OuhscMunge package
#   # http://stackoverflow.com/a/40515261/1082435
#   x[which(!is.na(x))[1]]
# }

deterge_ocappa_id <- function( x, verbose = FALSE ) {
  # The top value is around 47,000.
  if( verbose ) {
    print(table(nchar(x)))
  }
  x <- gsub(",", "", ifelse(nchar(x)==0L, NA_character_, x))

  x <- dplyr::if_else(dplyr::between(nchar(x), 3, 5), x, NA_character_)
  # checkmate::assert_character(x    , any.missing=TRUE , pattern="^\\d{4,5}$", unique=FALSE)
  x <- as.integer(x)
  x <- dplyr::if_else(dplyr::between(x, 100L, 48000L), x, NA_integer_)
  x
}

verify_data_frame <- function( d, minimum_row_count=100L ) {
  # Verify that a legit data.frame was returned (and not an error message)
  checkmate::assert_class(d, "data.frame")

  # Verify at least 100 rows were returned (or whatever the argument value was).
  checkmate::assert_integer(nrow(d), lower=minimum_row_count, len=1, any.missing=F)
}

cast_yn_to_boolean <- function( x ) {
  checkmate::assert_character(x)

  dplyr::recode(
    x,
    'Yes'               = TRUE,
    'yes'               = TRUE,
    'No'                = FALSE,
    'no'                = FALSE,
    'No - Reason Code'  = FALSE,
    'No --- reason code'= FALSE,


    `Unknown`           = as.logical(NA_character_),
    .missing            = as.logical(NA_character_)
  )
}

trim_date <- function( x, date_range ) {
  checkmate::assert_date(x          , any.missing = T)
  checkmate::assert_date(date_range , any.missing = F)

  dplyr::if_else(
    dplyr::between(x, date_range[1], date_range[2]),
    x,
    as.Date(NA_character_)
  )
}
