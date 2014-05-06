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
 2. The entire history is accessible -not just the most recent version. At anytime, you can turn back the clock to any committed change ([demo w/ SAS](https://github.com/OuhscBbmc/StatisticalComputing/commit/813856f8eb360ce0225665e992c028806f9cdc3e)).
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
 * Easier to be disciplined about.
  * maintaining a current & coherent code base.
  * *programmatic* data manipulation (instead of *manual*).
  * encapsulating analyses in different files.
 * Team members can more easily review and synchronize with your changes.
 * Easier to jump between computers.
 * [github.com/OuhscBbmc/DeSheaToothakerIntroStats](https://github.com/OuhscBbmc/DeSheaToothakerIntroStats) quickly becomes a small website.
 
Reproducibility for Outsiders
========================================================
 * The inputs (ie, data and code) can be inspected & downloaded immediately.
  * Details too trivial for the article are available too.
 * The outputs (ie, stats, graphs, and reports) can be compared to their results.
 * Ideally the exactly software versions are easily determined.

Benefits of Hosting Reports
========================================================
 * Single URL to send to anyone interested (not just those with access to the OUHSC file server).
 * Single report to send anyone (not a bunch of loose graphic files).
 
Four Life Cycle Templates
========================================================
 * **Public** from the start.
 * **Private** forever.
 * **Private** during development, then **public**.
 * Dual: Maintain both a **public** and a **private**.
 
Mechanism
========================================================
The typical sequence of operations is
 1. Log in to your computer and **Sync** the repository to make sure it's up-to-date.
 2. **Modify**/create/delete a file (as normal).
 3. **Locally save** the changes to your computer's hard drive (as normal).
 4. **Commit** your saved changes to your local repository.
 5. **Sync** your *local* repository with the *central* repository again.  This "pulls" any changes from the server, attempts to merge the changes (which is usually successful), and finally "pushes" your recent changes to the server.

The GitHub Windows & Mac client hide a lot of the complexity.  

Demo
=======
 1. Create a new repository in wibeasley `ScugDemo-2014-05-06`.
 2. Assign a new user `mhunter1`.
 3. Clone on my local machine.
 4. Copy `RAnalysisSkeleton`.
 5. Push changes.
 6. Mike makes changes in the browser version & commits.
 7. I sync/pull his changes.
 8. Create an issue w/ links.

Containing Data 
========================================================
The BBMC employs a variety of strategies.  As we descend, security increases while reproducibility decreases.
 1. Public data is contained directly as CSVs.
 2. Assume users can download the same public database (eg, large Census files)
 3. Unshared data that Git "ignores" and doesn't push to the server
 4. Pulling from the OUHSC file server
 5. Pulling from a database
 
Even "private" GitHub repositories should never contain PHI.

RAnalysisSkeleton Repository
========================================================
This is minimal example that contains elements of most of my moderately sized projects (say, takes a few weeks start to finish).

https://github.com/wibeasley/RAnalysisSkeleton.

We'll return to this after we finish the slides.

Project Management and Communication
========================================================
 * Communicate with internal and external collaborators.
 * Three forms of communication have their place.
  1. Long-term documentation stored in the repository.  It should outlive GitHub.
  2. Email has private/internal thoughts & criticisms.
  3. GitHub issues host publically acceptable thoughts & criticisms.  Treat as public.  Don't assume GitHub will be in business in three years; forntunately the code & reports aren't tied to GitHub.  [Worst case](https://groups.google.com/forum/#!topic/ggplot2/dY1cKfCsb1o), you can serve them as a zip file on your faculty page.
 * Example issues: [REDCapR](https://github.com/OuhscBbmc/REDCapR/issues?direction=desc&sort=updated&state=open) and [RedcapGovernanceDocs](https://github.com/OuhscBbmc/RedcapGovernanceDocs/issues?direction=desc&page=1&sort=updated&state=open).

Distributing/Hosting Static Reports
========================================================
The [markdown report](https://github.com/wibeasley/RAnalysisSkeleton/blob/master/Analyses/Report1/Report1.md) is a quick way, but has narrow margins.

For *public* repositories, routing the [html report](http://htmlpreview.github.io/?https://github.com/wibeasley/RAnalysisSkeleton/blob/master/Analyses/Report1/Report1.html) through `http://htmlpreview.github.io` is typically better.

For private reports, `knitr` produces a self-contained html report.  The graphics, text, and numeric output is in a single file you can email.  Anyone with a modern browser can open the file.

Inspecting the **diffs** is a great way to see if the results changed over time.

My "UtilityScripts" Directory
========================================================
Contains files that aren't absolutely necessary for the analysis, but makes reproduction much easier.

Examples: [RAnalysisSkeleton](https://github.com/wibeasley/RAnalysisSkeleton/tree/master/UtilityScripts)

My "Reproduce" File
========================================================
Ideally expose a single file that can calls your other files in the correct order.  

It's almost as easy creating a documentation file that offers clear directions to a human.

Plus, you can assert that the intermediate & final files have been produced roughly correctly.

I still haven't figured out how to create knitr report automatically & robustly; the working directory throws me off.  I'll likely figure it out soon and put it on [RAnalysisSkeleton](https://github.com/wibeasley/RAnalysisSkeleton).

Examples: [SteelCorrosion](https://github.com/LiveOak/LylesCarbonSteelCorrosion/blob/master/UtilityScripts/Reproduce.R) ans [Wats](https://github.com/wibeasley/Wats/blob/master/UtilityScripts/Reproduce.R)

Publicity & Search Engine Optimizations 
========================================================
* In the repository's README.md file, provide any relevant information for humans **and search engines**.  
* It's obvious how it reduces barriers for human readers.  
* SEO is also important. Not only will it help improve the repository's SEO, it also improves the performance of your articles.

Cautions & Limitations -Part 1
========================================================
* Sync early & often
* When working in a team, avoid modifying the same file simultaneously.  Reconciliation costs you time (but is still easier than without GitHub).
* Works easiest with plain text (eg, SAS, R, CSV), rather than binary/proprietary formats (eg, docx & sas7bdat).  The storage mechanism doesn't care, but the "diff" views won't be available, and reconciling differences can't be done automatically.
* Reconciliation strategies have a range of sophistication.
 * Command line functions for experts.
 * Formal branching & merging using GitHub's visual tools.
 * Our "Hard Reset" (which is only available option if you're not using version control).
* Git branching & forking is an important in software development, but I discourage it for repositories focused on analytics.

Cautions & Limitations -Part 2
========================================================
Securing private information (data & comments).
* Layered defense.
* Good protocols & practices for data.
* Use eager [`.gitignore`](https://github.com/wibeasley/RAnalysisSkeleton/blob/master/UtilityScripts/Eager.gitignore) exclusions.

Resources
========================================================
### Git and GitHub Mechanics
 * http://git-scm.com/
 * https://help.github.com/
 
### [Implementing Reproducible Research](http://www.crcpress.com/product/isbn/9781466561595)
 * Victoria Stodden, Friedrich Leisch, Roger D. Peng (editors; 2014)
 
### [Reproducible Research with R and RStudio](http://christophergandrud.github.io/RepResR-RStudio/)
 * Christopher Gandrud (2013)
