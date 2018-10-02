I'd like to connect a [DT/DataTable](https://rstudio.github.io/DT/) to a css file in two ways:

1. how can this be accomplished with [classes](https://www.w3schools.com/cssref/sel_class.asp)?
2. how can this be accomplished with [ids](https://www.w3schools.com/CSSref/sel_id.asp)?

I'm adapting the styles of [Knitr style table with CSS](https://stackoverflow.com/questions/24254552/knitr-style-table-with-css).  This is my best guess.  The `stripe` and other [built-in classes](https://datatables.net/manual/styling/classes) work, but not the ones I've defined below in flat-table.css.

**Rmd file**

    ---
    title: "dt-css"
    output:
      html_document:
        # theme: NULL
        css: flat-table.css
    ---

    ```{r setup, include=FALSE}
    knitr::opts_chunk$set(echo = TRUE)
    ```

    ```{r echo=FALSE}
    library(magrittr)
    ds <- mtcars %>%
      dplyr::select(mpg, cyl, disp) %>%
      head()

    DT::datatable(
      data        = ds,
      class       = "flat-table-class"
      # class       = "flat-table stripe",
      # extensions  = 'Responsive'
    )

    DT::datatable(
      data        = ds,
      elementId   = "flat-table-id"
    )
    ```

**flat-table.css**

    .flat-table-class {
      display: block;
      font-family: sans-serif;
      -webkit-font-smoothing: antialiased;
      font-size: 115%;
      overflow: auto;
      width: auto;
    }

    #flat-table-id {
      display: block;
      font-family: sans-serif;
      -webkit-font-smoothing: antialiased;
      font-size: 115%;
      overflow: auto;
      width: auto;
    }

    th {
      background-color: rgb(112, 196, 105);
      color: white;
      font-weight: normal;
      padding: 20px 30px;
      text-align: center;
    }
    td {
      background-color: rgb(238, 238, 238);
      color: rgb(111, 111, 111);
      padding: 20px 30px;
    }

