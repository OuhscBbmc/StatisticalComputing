bookdown Tutorial
======================

Resources & Examples
----------------------

* https://ouhscbbmc.github.io/data-science-practices-1/coding.html
* https://bookdown.org/yihui/bookdown/
* https://bookdown.org/
* https://github.com/rstudio/bookdown

Pros & Cons of bookdown
----------------------

### Cons

1. Some people forget how to write unless they're in Office
1. Office has helpful grammar checks
 
### Pros
  
1. markdown is super easy
    1. leverages your existing knitr knowledge
    1. same syntax used in GitHub issues & Stack Overflow
    1. can facilitate similar products, like blogdown
1. publish early drafts
    1. accessible by wide group
    1. editable by wide group (with GitHub PRs)
1. plain text is editable with almost anything
1. all the benefits of GitHub
    1. collaboration
    1. tracking & recover changes
    1. move between machines (*e.g.*, quick additions w/ tablet)
1. leverages R --all the modeling & graphs
1. multiple output formats every time
    1. html on server
    1. pdf
    1. epub
1. No real server is involved. 
    1. When the bookdown files are compiled, self-contained html/pdf/epub can be read on any client.
    1. unlike problems with Wordpress sites
    1. the site should last longer, without as much maintenance
1. VS Code has a portable spelling list
1. As a consumer/reader
    1. different formats
    1. searchable
    1. editable
    1. transparent -if I need to reproduce/follow

Pre-reqs
----------------------

* R
* RStudio
* rmarkdown
* tinytex?
* https://ouhscbbmc.github.io/data-science-practices-1/workstation.html

Demo
----------------------

* https://bookdown.org/yihui/bookdown/
* Start w/ simple example
  * https://github.com/rstudio/bookdown-demo
  * https://github.com/yihui/bookdown-minimal
* Render
* Push to GitHub (after a quick initial set up)
* Modify & Repeat

Decisions
----------------------

1. knit-merge (k-m) *vs* merge-knit (m-k)
1. special headers (section 2.2.3)
1. cross-references & references
    1. table of contents, figures, tables, & equations
    1. bibliography
    1. index
    1. captions
1. css styling

Tips & Lessons Learned
----------------------

1. Start with md files.  Escalate to Rmd only if necessary
2. Set heading names to facilitate references. The explicit value also helps search & replace.
3. Don't number the files (*e.g.*, `01-intro.md`, `02-install.md`).  Use `_bookdown.yml` to order chapters.
4. Add whenever you can.
  
    1. Full-scale writing at a desktop during quiet time and then render & push.
    2. Add a few sentences in the browser, but not yet render & push.
    3. Jot in a [scratch pad](https://ouhscbbmc.github.io/data-science-practices-1/scratch-pad.html) and move it around later.

5. Combination of Visual Studio Code & RStudio.
    1. VS Code packages that help markdown development.
        1. markdownlint
        2. previewing
        3. spell check

Discussion
----------------------

1. How to improve collaboration and combining chapters?
1. Deployment scenarios:
    1. public throughout the book's whole life span --ideal for bookdown
    1. private during writing, then public
    1. private --accessible only to authors
    1. private --accessible only to team (some don't have RStudio, and just need the output)

