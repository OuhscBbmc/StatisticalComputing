# Manual corrections to the records are documented in "S:\CCAN\CCANResEval\MIECHV\RedCap\Chomp\SurveyCorrections\GpavCorrections.csv"
#   Be careful not to move this PHI file to somewhere unsafe.

rm(list=ls(all=TRUE))  #Clear the variables from previous runs.

# ---- load-sources ------------------------------------------------------------
source("./manipulation/ferry/survey-ferry.R")

# ---- load-packages -----------------------------------------------------------
library(magrittr)
requireNamespace("tibble")
requireNamespace("dplyr")
requireNamespace("DT")
requireNamespace("readr")
requireNamespace("testit")


# ---- declare-globals ---------------------------------------------------------
path_output         <- "./data-phi-free/derived/survey-violation.csv"    # Change this value for new validators.
project_id          <- 302L
redcap_version      <- "6.11.5"
default_arm         <- 1L
interview_date_name <- "cdemo_date_1"

validation_check <- function( name, error_message, priority, passing_test ) {
  # S3 object to check
  l <- list()
  class(l)        <- "check"
  l$name          <- name
  l$error_message <- error_message
  l$priority      <- priority
  l$passing_test  <- passing_test
  return( l )
}

# ---- load-data ---------------------------------------------------------------
ds_interview <- retrieve_clients(filter_only_interview_started=TRUE)  #Retrieve only those who have an interview.

# ---- tweak-data --------------------------------------------------------------
testit::assert("`interview_started` must be TRUE.", !is.na(ds_interview$interview_started) & ds_interview$interview_started)


# ---- assemble-checks ---------------------------------------------------------
# Add to this list for new validators.
checks <- list(
  validation_check(
    name          = "record_id_no_white_space",
    error_message = "'record_id' contains white space (that may be hard to see).",
    priority      = 1L,
    passing_test  = function( d ) {
      !grepl("\\s", d$record_id, perl=T)
    }
  ),
  validation_check(
    name          = "interview_started_set",
    error_message = "`interview_started` is not set.  It must be TRUE or FALSE, but not missing.",
    priority      = 2L,
    passing_test  = function( d ) {
      !is.na(d$interview_started)
    }
  ),
  validation_check(
    name          = "data_collector_set",
    error_message = "`data_collector` is not set.",
    priority      = 2L,
    passing_test  = function( d ) {
      !is.na(d$data_collector)
    }
  ),
  validation_check(
    name          = "wave_set",
    error_message = "`wave` is not set.",
    priority      = 2L,
    passing_test  = function( d ) {
      !is.na(d$wave)
    }
  ),
  validation_check(
    name          = "assess_validity",
    error_message = "`assess_validity` is not set.",
    priority      = 2L,
    passing_test  = function( d ) {
      !is.na(d$assess_validity)
    }
  ),
  validation_check(
    name          = "video_recording",
    error_message = "Video recording status not recorded",
    priority      = 2L,
    passing_test  = function( d ) {
      #IRB approval for video recording starting in Sept 2015.
      !is.na(d$did_video_recording_occur) | (d$cdemo_date_1 > 2015-09-01)
    }
  ),
  validation_check(
    name          = "cwbs_missing",
    error_message = "Interview was in home, but CWBS is missing.",
    priority      = 2L,
    passing_test  = function( d ) {
      # If the interview is at home, than the CWBS should be present.  An interview outside the home automatically passes.
      ifelse(d$interview_in_home, !is.na(d$cwbs_a), TRUE)
    }
  ),
  validation_check(
    name          = "participant_gender",
    error_message = "`participant_gender` is not set.",
    priority      = 2L,
    passing_test  = function( d ) {
      !is.na(d$participant_gender)
    }
  ),
  validation_check(
    name          = "participant_mob",
    error_message = "Participant is younger than 16.",
    priority      = 2L,
    passing_test  = function( d ) {
      # !((as.Date(d$cdemo_date_1) - as.Date(d$participant_mob))/365 < 16)
      age_in_years <- as.numeric(difftime(d$cdemo_date_1, d$participant_mob, units="days")/365.25)
      return( age_in_years >= 16 )
    }
  ),
  validation_check(
    name          = "index_child",
    error_message = "Participant is not pregnant, and index child DOB is missing",
    priority      = 1L,
    passing_test  = function( d ) {
      !((!d$pregnant_current) & (d$cdemo_dob_c01 < 0))
    }
  ),
  validation_check(
    name          = "index_child_age",
    error_message = "index child is over 60 months",
    priority      = 2L,
    passing_test  = function( d ) {
      !(d$pregnant_current %in% 0 & d$cdemo_age_c01 > 72)
    }
  ),
  validation_check(
    name          = "child_count",
    error_message = "The number of children must be at least 1.",
    priority      = 2L,
    passing_test  = function( d ) {
      d$cdemo_num_children >= 1
    }
  ),
  validation_check(
    name          = "consent_received",
    error_message = "The number IRB consent should be received within 45 days.",
    priority      = 2L,
    passing_test  = function( d ) {
      (d$paperwork_completed_consent | (d$days_since_interview < 45))
    }
  )
) #End the list of checks.




# Change this path for new validators.
cat(
  length(checks), " checks [have been defined](https://github.com/OuhscBbmc/P4/blob/master/analysis/survey-validation/survey-validation.R):\n\n 1. ",
  paste(sapply(checks, function(check) check$name), collapse=",\n 1. ") , "."
)

extract_violation_info <- function( d_violation, check ) {
  ## Be careful not to add any fields, b/c they could contain PHI (especially fields misbehaving values.).
  tibble::tibble(
    check_name                = check$name,
    record_id                 = d_violation$record_id,
    data_collector            = d_violation$data_collector,
    error_message             = check$error_message,
    priority                  = check$priority,
    interview_date            = d_violation[[interview_date_name]]
  )
}
empty_violation <- function(  ) {
  tibble::tibble(
    check_name                = "all_passed",
    record_id                 = 0L,
    data_collector            = "",
    error_message             = "No violations existed in the dataset",
    priority                  = ""
  )
}


# ---- execute-checks ----------------------------------------------------------
ds_violation_list <- list()
for( check in checks ) {
  index <- length(ds_violation_list) + 1L
  violations <- !check$passing_test(ds_interview)
  ds_violation_single <- ds_interview %>%
    dplyr::filter(violations)


  if( nrow(ds_violation_single) > 0L ) {
    ds_violation_list[[index]] <- extract_violation_info(ds_violation_single, check)
  }
  # rm(violations, ds_violation_single)
}

if( length( ds_violation_list) == 0L ) {
  ds_violation        <- empty_violation()
  ds_violation_pretty <- ds_violation
} else {
  ds_violation        <- dplyr::bind_rows(ds_violation_list)
  ds_violation_pretty <- ds_violation %>%
    dplyr::mutate(
      record_id         = sprintf(
                                  '<a href="https://bbmc.ouhsc.edu/redcap/redcap_v%s/DataEntry/grid.php?pid=%s&arm=%s&id=%s&page=participant_demographics" target="_blank">%s</a>',
                                  redcap_version, project_id, default_arm, record_id, record_id
                                 ),
      check_name        = gsub("_", " ", check_name),
      data_collector    = gsub("_", " ", data_collector),

      check_name        = factor(check_name)

    )
  colnames(ds_violation_pretty) <- gsub("_", " ", colnames(ds_violation_pretty))
}

message(length(checks), " checks have been executed.  ", nrow(ds_violation), " violation(s) were found.\n")

rm(check, ds_violation_list)

# ---- display-table ----------------------------------------------------------
DT::datatable(
  data         = ds_violation_pretty,
  filter       = "bottom",
  caption      = paste("Violations at", Sys.time()),
  escape       = FALSE,
  options      = list(pageLength = 30, dom = 'tip')
)

# The next line is purely for debugging.  It displays the entire dataset.
# DT::datatable(ds_interview) # Don't leave this uncommented.

# ---- verify-values -----------------------------------------------------------
# testit::assert("All IDs should be nonmissing and positive.", all(!is.na(ds_interview$CountyID) & (ds_interview$CountyID>0)))

# ---- specify-columns-to-upload -------------------------------------------------


# ---- save-to-disk ------------------------------------------------------------
message("Saving list of violations to `", path_output, "`.")

readr::write_csv(ds_violation, path=path_output)
