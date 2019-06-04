Open Agenda
======================

[SCUG](https://github.com/OuhscBbmc/StatisticalComputing), June 2019



#### Possible Topics 

1. GitLab on campus

1. SQLite with R and other languages

1. `case` waterfalls in SQL

1. [CTE](https://www.essentialsql.com/introduction-common-table-expressions-ctes/)s (common table expressions) in SQL.  ([Example](https://github.com/OuhscBbmc/DhsWaiver/blob/master/Analysis/Eda/ad-hoc/attachment-biobehavioral-catchup/attachment-biobehavioral-catchup-2019-06.sql) in a private link.)

    ```sql
    use dhs_waiver_premiss_1;

    with r as ( -- stands for 'r'eferral
      SELECT   
        referral_sha,
        roster.group_assignment,
        year(ReferralDate) as referral_year,
        case 
          when RemovalBeginDate is null then 0
          else 1
        end as child_removed,
        (datediff(day, Dob, ReferralDate) / (365.25/12))  as age_in_month,
        case
          when [RemovalBeginDate] is null and
              datediff(day, Dob, ReferralDate) < 180                      then '1) not removed; before 6m old'
          when [RemovalBeginDate] is null and
              datediff(day, Dob, ReferralDate) between 180 and 730        then '1b) not removed; between 6m & 24m old'
          when [RemovalBeginDate] is null and
              datediff(day, Dob, ReferralDate) > 730                      then '1c) not removed; after 24m old'
              
          when dob is null                                                then 'dob is missing' 
          when ReferralDate is null                                       then 'ReferralDate is missing' 
          when RemovalendDate is null                                     then '4) not reunified' 

          when datediff(day, ReferralDate, RemovalBeginDate) > 92 and
              datediff(day, Dob, ReferralDate) < 180                      then '2a) not initially removed; before 6m old'   -- ie, 3 months between referral & removed
          when datediff(day, ReferralDate, RemovalBeginDate) > 92 and
              datediff(day, Dob, ReferralDate) between 180 and 730        then '2b) not initially removed; between 6m & 24m old'   -- ie, 3 months between referral & removed
          when datediff(day, ReferralDate, RemovalBeginDate) > 92 and
              datediff(day, Dob, ReferralDate) > 730                      then '2c) not initially removed; after 24m old'   -- ie, 3 months between referral & removed

          when datediff(day, Dob, RemovalendDate) < 180                   then '3a) initially removed; reunified before 6m old'    
          when datediff(day, Dob, RemovalendDate) between 180 and 730     then '3b) initially removed; reunified between 6m & 24m old'    
          when datediff(day, Dob, RemovalendDate) > 730                   then '3c) initially removed; reunified after 24m old' 
          else                                                         'uncaught case'
        end as removal_outcome

      FROM [dhs_waiver_premiss_1].[DhsRead].[aocs_removed] a
        left join dbo.tbl_roster roster on a.ReferralID = roster.referral_id
      where 
        GatherSubstance = 1
        AND
        '2017-01-01' <= ReferralDate and ReferralDate <= '2017-12-31'
        and
        StaffCurrentRegion = 3
        --and 
        --roster.group_assignment = 'SAU'
    )
    select
      referral_year,
      removal_outcome,
      --group_assignment,
      count(*) as kid_count,
      count(distinct referral_sha) as referral_count
    from r
    group by 
      referral_year
      ,removal_outcome
      --,group_assignment
    order by 
      referral_year
      ,removal_outcome
      --,group_assignment
    
    ```
    
1. *plumber** package:
    > Gives the ability to automatically generate and serve an HTTP API from R functions using the annotations in the R documentation around your functions.

1. Creating thumbnails in an html page by scanning for all graphics in a subdirectory
      * [example](https://github.com/OuhscBbmc/DeSheaToothakerIntroStats/blob/master/thumbnails/thumbnails.md)
      * [code](https://github.com/OuhscBbmc/DeSheaToothakerIntroStats/tree/master/thumbnails)
      
1. Technical Debt

    * ["Introduction to the Technical Debt Concept"](https://www.agilealliance.org/introduction-to-the-technical-debt-concept/)
    * ["Project Management and Technical Debt"](https://www.agilealliance.org/project-management-and-technical-debt/)
    * ["Escaping the black hole of technical debt"](https://www.atlassian.com/agile/software-development/technical-debt)

1. [yaml](https://github.com/viking/r-yaml/) & csv
    * flatten/denormalize list to data.frame [example](https://stackoverflow.com/questions/47242697/denormalize-coerce-list-with-nested-vectors-to-data-frame-in-r)

1. controlling long pipelines with flow files, such as [reproduce.R](https://github.com/dss-ialh/displaying-health-data/blob/master/utility/reproduce.R)

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

Recently Discussed
-------------------------------------------

#### Dec 2018

**Shiny**
1. Review of Oct 2015 presentation
    * [slides](https://rawgit.com/OuhscBbmc/StatisticalComputing/master/2015_Presentations/10_October/beasley-scug-shiny-2015-10.html#/) of "Interactive reports and webpages with R & Shiny"
    * [supplemental material](2015_Presentations/10_October)
1. Deployment scenarios
    * public vs pro
    * hosts
    * authentication
1. Comparison with similar and/or overlapping reporting solutions, including:
    * JavaScript-enhanced graphs using
        * ggplot + plotly
        * straight plotly
    * 'static' knitr html reports
        * cron job refreshing the underlying dataset every ~10 min
        * saved to a secured file server accessible by your team
    * Power BI and others

#### June 2018

1. Shiny, especially deployment & security

1. text editors
    * my favorites: [RStudio](https://www.rstudio.com/products/rstudio/download/preview/), [Atom](https://atom.io/), and [Notepad++](https://notepad-plus-plus.org/).
    * find & replace across files with regexes: Atom
    * easily zoom in & out is especially nice when sharing screens: tie -- Atom & Notepad++
    * Markdown preview in Atom
    * multicolumn select: 1st place--RStudio and 2nd place--Atom (with the [Sublime-Style-Column-Selection](https://atom.io/packages/Sublime-Style-Column-Selection) package)

1. Snippets
    * pros & cons vs functions

1. GitHub Gists
    * pros & cons vs full repos

1. Diversion about Microsoft's acquisition of GitHub.

#### April 2018

1. Computations on server vs local machines

#### March 2018

1. Python & R tradeoffs on the follow dimensions
    * production system vs research
    * computer science background vs stats background
    * data manipulation vs analysis
    * propagation of ideas/manuscripts to external audiences
    * development costs

1. [knitr](https://yihui.name/knitr/) & automated reports
    * some overlap with this [2013 presentation](https://github.com/OuhscBbmc/StatisticalComputing/blob/master/2013_Presentations/03_March/RedcapForUserGroup.pptx) and this [2014 presentation](https://github.com/OuhscBbmc/StatisticalComputing/blob/master/2014_Presentations/09_September/LiterateProgrammingPatternsAndPracticesWithREDCap.pdf).

1. GitHub
    * some overlap with this [2014 presentation](http://htmlpreview.github.io/?https://raw.githubusercontent.com/OuhscBbmc/StatisticalComputing/master/2014_Presentations/05_May/BeasleyScugGitHub2014-05.html) and this [2014 presentation](https://github.com/OuhscBbmc/StatisticalComputing/blob/master/2014_Presentations/09_September/LiterateProgrammingPatternsAndPracticesWithREDCap.pdf).

1. benefits of promoting consistency of files/patterns across projects, and using skeletons ([example](https://github.com/wibeasley/RAnalysisSkeleton)).

1. [REDCap](https://projectredcap.org/) & research
    * creating REDCap projects
    * token security
    * [REDCapR](https://github.com/OuhscBbmc/REDCapR)
    *  some overlap with this [2014 presentation](https://github.com/OuhscBbmc/StatisticalComputing/blob/master/2014_Presentations/09_September/LiterateProgrammingPatternsAndPracticesWithREDCap.pdf).
