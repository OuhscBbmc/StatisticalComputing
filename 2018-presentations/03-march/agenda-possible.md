Open Agenda
======================

[SCUG](https://github.com/OuhscBbmc/StatisticalComputing), March 2018

#### Possible Topics

1. yaml & csv


1. [config](https://github.com/rstudio/config) package
    * centralize your project-wide settings so it's available & consistent across multiple files.
    * similar to a project-wide ['declare-globals'](https://github.com/wibeasley/RAnalysisSkeleton/blob/master/manipulation/te-ellis.R#L25) chunk.


1. tight text control
    * [`base::sprintf()`](https://www.rdocumentation.org/packages/base/versions/3.4.3/topics/sprintf)
    * [`glue::glue()`](http://glue.tidyverse.org) & friends

1. Landing page for documentation across projects, such as [BbmcResources](https://github.com/OuhscBbmc/BbmcResources)

1. writing style guides with your team
    * *project-specific*, such as the [dashboard](https://github.com/OuhscBbmc/miechv-3/blob/master/documentation/style-guides/dashboard-style.md) example.
    * *external consumption*, such as the [REDCap API Troubleshooting Guide](https://cdn.rawgit.com/OuhscBbmc/REDCapR/master/inst/doc/TroubleshootingApiCalls.html).
    * *language-specific* such as the
        * [tidyverse style guide for R](http://style.tidyverse.org/), which derived from the
        * [Google's Style Guide for R](https://google.github.io/styleguide/Rguide.xml) and
        * [Hadley's Style Guide for R](http://adv-r.had.co.nz/Style.html) (this one is probably more representative what your team might produce to unify your projects)

1. Use skeleton repos to jumpstart your projects, such as  [RAnalysisSkeleton](https://github.com/wibeasley/RAnalysisSkeleton)


1. verify-values

  ```r
  # ---- verify-values -----------------------------------------------------------
  # Sniff out problems
  # OuhscMunge::verify_value_headstart(ds)
  checkmate::assert_integer(ds$county_month_id    , lower=          1L              , any.missing=F, unique=T)
  checkmate::assert_integer(ds$county_id          , lower=          1L   , upper=77L, any.missing=F, unique=F)
  checkmate::assert_date(   ds$month              , lower="2012-01-01"              , any.missing=F)
  checkmate::assert_integer(ds$region_id          , lower=          1L   , upper=20L, any.missing=F)
  checkmate::assert_numeric(ds$fte                , lower=          0    , upper=40L, any.missing=F)
  checkmate::assert_logical(ds$fte_approximated                                     , any.missing=F)
  ```

1. inequality joins with sqldf

    Bounded by another table, using a join
    ```r
    d2 <- "
      SELECT
        o.[.record_matching_id],
        o.gender,
        o.age_months,
        o.bmi,
        p.percentile     AS percentile_lower,
        p.value
      FROM d_observed AS o
        LEFT OUTER JOIN d_pop_long AS p ON
          o.age_months = p.age_months AND
          o.gender     = p.gender     AND
          p.value      < o.bmi
      " %>%
      sqldf::sqldf(
        stringsAsFactors = FALSE
      )   
  ```

  Cumulation, by restricting on itself
  ```r
  ds_visit_cumulative_count <- "
    SELECT
      b.week, b.program_code, b.worker_name,
      count(distinct a.case_number) as     client_distinct_cumulative_by_worker
    FROM ds_visit_3 a
    JOIN ds_visit_3 b ON
      (a.week <= b.week)
      AND (a.program_code=b.program_code AND     a.worker_name=b.worker_name)
    GROUP BY b.program_code, b.worker_name, b.week
    ORDER BY b.program_code, b.worker_name, b.week
    " %>%
    sqldf::sqldf()
    ```

    Windows of time, using a join
    ```r
    ds_client_week_visit_goal <- "
      SELECT
        p.case_number,
        p.program_code,
        p.worker_name_last                AS worker_name,
        p.week_start_inclusive,
        --COUNT(v.visit_date)              AS visit_week_scheduled_count,
        SUM(v.visit_completed)           AS visit_week_completed_count
      FROM ds_possible_client_week p
        LEFT JOIN ds_visit v ON (
          p.case_number=v.case_number
          AND
          (p.week_start_inclusive <= v.visit_date AND v.visit_date<p.week_stop_exclusive)
        )
      GROUP BY p.case_number, p.week_start_inclusive
      ORDER BY p.case_number, p.week_start_inclusive
    " %>%
      sqldf::sqldf()    
    ```
