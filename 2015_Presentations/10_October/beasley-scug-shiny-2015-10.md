<style type="text/css">
.small-code pre code {
   font-size: 0.8em;
}
</style>


Interactive reports and webpages with R & Shiny
========================================================
OUHSC [Statistical Computing User Group](https://github.com/OuhscBbmc/StatisticalComputing)

Will Beasley, Dept of Pediatrics, 

Biomedical and Behavioral Methodology Core ([BBMC](http://ouhsc.edu/BBMC/))

[October 6, 2015](https://github.com/OuhscBbmc/StatisticalComputing/tree/master/2015_Presentations/10_October/)


Overview of Shiny
========================================================

A [Shiny](http://shiny.rstudio.com) report is basically a website connected to R.

  * Requires a UI (user interface) and server file.
  * Everything can be written in R.  Shiny will create & translate to the necessary HTML5, JavaScript & CSS components.  (But these can be written to create fancy reports.)
  * Can leverage almost all R capabilities.
  * Great [official gallery](http://shiny.rstudio.com/gallery/), [user examples](https://www.rstudio.com/products/shiny/shiny-user-showcase/), [tutorials](http://shiny.rstudio.com/tutorial/), and [documentation](http://shiny.rstudio.com/), and presence in [forums](https://groups.google.com/forum/#!forum/shiny-discuss) and  [StackOverflow](http://stackoverflow.com/questions/tagged/shiny).


Screen Shots
========================================================
(*Switch to the screen shots in PowerPoint*)


Code
========================================================
(*Switch back to these slides.*)

**Disclaimer**: The following code is a simplication of our real code.  The basics are the same, but the  encapsulation was flattenned and non-essential functions were omitted.


Retrieve Token
========================================================

```r
channel <- odbcConnect(dsn="BbmcSecurity")
token <- REDCapR::retrieve_token_mssql(
  project_name = "Gpav2", 
  channel      = channel
)
uri <- RODBC::sqlQuery(
  channel, 
  "EXEC Security.prcUriStatic @UriName 
    = 'RedcapBbmc'", 
  stringsAsFactors=FALSE
)[1, 'Value']
RODBC::odbcClose(channel)
```


Pull From REDCap (& Tidy a Litte)
========================================================

```r
# Pull
dsDC <- REDCapR::redcap_read(
  redcap_uri = redcapUri, 
  token      = token, 
  fields     = c("studyid", "dc")
)$data

# Tidy
dsDC <- dplyr::rename_(dsDC, 
  "study_id"       = "studyid",
  "dc_responsible" = "dc"
)
ds <- dplyr::left_join(
  x  = dsSchedule, 
  y  = dsDC, 
  by = "study_id"
)
```  

Recurring Write from VM to Shiny
========================================================

* Every ~10 minutes, run the previous code on the VM and save a **de-identified** text file to Shiny.  Use  [Task Scheduler](https://msdn.microsoft.com/en-us/library/windows/desktop/aa383614.aspx) in Windows, or  [Cron](https://help.ubuntu.com/community/CronHowto) in Linux.
* `pathOut` goes to a write-only directory on the Shiny server, exposed through [Samba](https://www.samba.org/), so CSVs are saved on the network like a local drive.
* R code couldn't be simpler:

```r
pathOut <- "//shiny-public/dump/near.csv"
write.csv(ds, file=pathOut, row.names=F)
```


Our Current Shiny Instance is Public-Only
========================================================

* Data must be PHI-free. (Displayed tables *and* underlying CSVs.)
* The instance currently run by the BBMC lacks user-authentication.
* The commericial versions of Shiny have many [authentication options](http://rstudio.github.io/shiny-server/latest/#authentication-security).  It was a breeze in a non-OUHSC server I helped with.  (I rarely make these claims.)
