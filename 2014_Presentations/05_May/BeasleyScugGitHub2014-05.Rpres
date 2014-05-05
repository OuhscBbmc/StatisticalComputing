<style type="text/css">
.small-code pre code {
   font-size: 1.1em;
}
</style>

Statistical Collaboration with GitHub
========================================================
OUHSC [Statistical Computing User Group](https://github.com/OuhscBbmc/StatisticalComputing)

Will Beasley, Dept of Pediatrics, 

Biomedical and Behavioral Methodology Core ([BBMC](http://ouhsc.edu/BBMC/))

[May 6, 2014](https://github.com/OuhscBbmc/StatisticalComputing/tree/master/2014_Presentations/05_May/)

Overview of Git  
========================================================
**Git** is the underlying **version control system**.  It's a little similar to 'Track Changes' in MS Word, with three huge differences:
 1. Collaborators can make changes simultaneously. Track Changes frequently involves a painful cognitive load to  reconcile different versions.
 2. The entire history is accessible -not just the most recent version. At anytime, you can turn back the clock to any committed change ([example w/ SAS](https://github.com/OuhscBbmc/StatisticalComputing/commit/813856f8eb360ce0225665e992c028806f9cdc3e)).
 3. Coordinates an entire repository of files, not just isolated documents

Overview of GitHub  
========================================================
**GitHub** is an online service that leverages Git, and adds some sauce for statisticians
 * Hosts the repository online
  * Code
  * Data
  * Reports & output
 * Adds options for user permissions, such as read-only (unlike Dropbox)
 * Tools for visualizing code differences and developer activity
 * Project Management Tracking, "Issues", & notifications

Outline 
========================================================
 1. Benefits & Complete examples
 2. Creation and organization
 3. Communicate with statisticians and non-statisticians
 4. Precautions with health care and PHI data

Benefits 
========================================================
* Reproducibility for internal team
* Reproducibility for outsiders
* Hosting reports

Complete examples 
========================================================
### Public and applied 
 * [github.com/OuhscBbmc/OsctrAstonWeber](https://github.com/OuhscBbmc/OsctrAstonWeber)
 * [github.com/LiveOak/LylesCarbonSteelCorrosion](https://github.com/LiveOak/LylesCarbonSteelCorrosion)
 * [github.com/LiveOak/UcaBullying](https://github.com/LiveOak/UcaBullying)

### Public and methodological
 * [github.com/wibeasley/Wats](https://github.com/wibeasley/Wats)
 * [github.com/OuhscBbmc/REDCapR](https://github.com/OuhscBbmc/REDCapR)

### Communication
 * [github.com/OuhscBbmc/RedcapGovernanceDocs](https://github.com/OuhscBbmc/RedcapGovernanceDocs)
 * [github.com/OuhscBbmc/RedcapExample](https://github.com/OuhscBbmc/RedcapExample)
 * [github.com/OuhscBbmc/StatisticalComputing](https://github.com/OuhscBbmc/StatisticalComputing)

### Private
 * [github.com/OuhscBbmc/DeSheaToothakerIntroStats](https://github.com/OuhscBbmc/DeSheaToothakerIntroStats)
  
Reproducibility for Internal Team
========================================================
 * Easier to be disciplined about 
  * maintaining a current & coherent code base
  * *programmatic* data manipulation (instead of *manual*)
  * encapsulating analyses in different files
 * Team members can more easily review and synchronize with your changes
 * Easier to jump between computers
  
Reproducibility for Outsiders
========================================================


Benefits of Hosting Reports
========================================================
 * Single URL to send to anyone interested (not just those with access to the OUHSC file server).
 * Single report to send anyone (not a bunch of loose graphic files).
 
Four Life Cycle Templates
========================================================
 * Public from the start
 * Private forever
 * Private during development, then public
 * Dual: Maintain a public and a private
 
Mechanism
========================================================
The typical sequence of operations is
 1. Log in to your computer and **Sync** the repository to make sure it's up-to-date.
 2. **Modify**/create/delete a file (as normal).
 3. **Locally save** the changes to your computer's hard drive (as normal).
 4. **Sync** your *local* repository with the *central* repository again.  This "pulls" any changes from the server, attempts to merge the changes (which is usually successful), and finally "pushes" your recent changes to the server.

The GitHub Windows & Mac client hide a lot of the complexity.  

Containing Data 
========================================================
The BBMC employs a variety of strategies.  As we descend, security increases while reproducibility decreases.
 1. Public data is contained directly as CSVs.
 2. Assume users can download the same public database (eg, large Census files)
 3. Unshared data that Git "ignores" and doesn't push to the server
 4. Pulling from the OUHSC file server
 5. Pulling from a database
 
Never store PHI in a GitHub repository -even a "private" repository.

Publicity & Search Engine Optimizations 
========================================================

Cautions & Limitations 
========================================================
* Sync early & often
* When working in a team, avoid modifying the same file simultaneously.  Reconciliation costs you time (but is still easier than without GitHub).
* Works easiest with plain text (eg, SAS, R, CSV), rather than binary/proprietary formats (eg, docx & sas7bdat).  The storage mechanism doesn't care, but the "diff" views won't be available, and reconciling differences can't be done automatically.
* Reconciliation strategies have a range of sophistication
 * Command line functions for experts.
 * Formal branching & merging using GitHub's visual tools.
 * Our "Hard Reset" (which is only available option if you're not using version control).

Resources
========================================================
### Git and GitHub Mechanics
 * http://git-scm.com/
 * https://help.github.com/
 
#### Victoria Stodden, Friedrich Leisch, Roger D. Peng (editors)
 * [*Implementing Reproducible Research*](http://www.crcpress.com/product/isbn/9781466561595) (2014)
 
#### Christopher Gandrud
 * [*Reproducible Research with R and RStudio*](http://christophergandrud.github.io/RepResR-RStudio/) (2013)
