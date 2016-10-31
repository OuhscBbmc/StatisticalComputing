<style type="text/css">
.small-code pre code {
   font-size: 1.1em;
}
</style>



BBMC Validator: catch and communicate data errors
========================================================

OUHSC [Statistical Computing User Group](https://github.com/OuhscBbmc/StatisticalComputing)

Will Beasley, Dept of Pediatrics, 

Biomedical and Behavioral Methodology Core ([BBMC](http://ouhsc.edu/BBMC/))

[November 11, 2016](https://github.com/OuhscBbmc/StatisticalComputing/tree/master/2016-presentations/11-november)



Objectives for Validator Software
========================================================

1. catches & displays data entry errors,
1. communicates problems to statisticians,
1. communicates problems to data collectors and managers<br/>(who typically have some tech phobia),
1. executes with automation, and
1. produces self-contained report file that can be emailed. 



`validation_check` S3 object
========================================================

```r
validation_check <- function( 
  name, error_message, priority, passing_test 
) {
  # S3 object to check
  l <- list()
  class(l)         <- "check"
  l$name           <- name
  l$error_message  <- error_message
  l$priority       <- priority
  l$passing_test   <- passing_test
  return( l )
}
```


Declare List of Checks
========================================================
class: small-code

```r
# Add to this list for new validators.
checks <- list(
  validation_check(
    name          = "record_id_no_white_space",
    error_message = "'record_id' contains white space.",
    priority      = 1L,
    passing_test  = function( d ) {
      !grepl("\\s", d$record_id, perl=T)
    }
  ),
  validation_check(
    name          = "interview_started_set",
    error_message = "`interview_started` can't be missing.",
    priority      = 2L,
    passing_test  = function( d ) {
      !is.na(d$interview_started)
    }
  ),
  ...
)
```

Execute Checks
========================================================
class: small-code

```r
for( check in checks ) {
  index <- length(ds_violation_list) + 1L
  violations <- !check$passing_test(ds_interview)
  ds_violation <- ds_interview %>%
    dplyr::filter(violations)


  if( nrow(ds_violation) > 0L ) {
    ds_violation_list[[index]] <- extract_violation_info(ds_violation, check)
  }
  rm(violations, ds_violation)
}
```

Display Failures as HTML
========================================================
class: small-code

```r
DT::datatable(
  data         = ds_violation_pretty,
  filter       = "bottom",
  caption      = paste("Violations at", Sys.time()),
  escape       = FALSE,
  options      = list(pageLength = 30, dom = 'tip')
)
```

Save Failures as CSV
========================================================
class: small-code

```r
# ---- save-to-disk ----------------------------------
message("Saving list of violations to `", path_output, "`.")

readr::write_csv(ds_violation, path=path_output)
```

Table of Violations
========================================================
![display-table](images/display-table.png)

Portable HTML Report
========================================================
![full-html-report](images/full-html-report.png)
