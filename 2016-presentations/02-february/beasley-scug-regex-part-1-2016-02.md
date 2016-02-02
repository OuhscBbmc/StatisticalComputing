<style type="text/css">
.small-code pre code {
   font-size: 0.8em;
}
</style>


Text Manipulation with Regular Expressions Part 1
========================================================

OUHSC [Statistical Computing User Group](https://github.com/OuhscBbmc/StatisticalComputing)

Will Beasley, Dept of Pediatrics, 

Biomedical and Behavioral Methodology Core ([BBMC](http://ouhsc.edu/BBMC/))

[February 2, 2016](https://github.com/OuhscBbmc/StatisticalComputing/tree/master/2016-presentations/02-february/)


Overview of Regular Expressions
========================================================

A 'regex' is typically a carefully crafted string that describes a pattern of text.  It's uses include:
* Extracting components of the text,
* Substituting components of the text, or 
* Knowing if the pattern simply appears in the text.

Generalization of Simple Wildcards 
========================================================
It's like the big brother of wildcards you match filenames with<br/>(eg, `"*.R"`).

![windows-exporer](./images/windows-explorer-wildcard.png)


Simple Examples
========================================================

| Pattern           | Matches                        |
| ----------------- | ------------------------------ |
| **`mike`**        | "mike", "smike", "miked", etc. |
| **`mike4`**       | "mike4" |
| **`mike\d`**      | "mike" followed by any single digit (eg "mike8") |
| **`mike\d+`**     | "mike" followed by one or more digits (eg "mike1234") |
| **`^mike$`**      | only "mike" |


Complicated Example
========================================================
`\b19(?=(1|2))(\d{2})\b`  and `20\2`<br/>[converts years](https://regex101.com/r/mX5fE4/2) in the 1910s and 1920s to the 2010s and 2020s<br/>(but leaves later years as they are).

[![windows-exporer](./images/forward-lookahead.png)](https://regex101.com/r/mX5fE4/2)


Today's Tools
========================================================

* An online regex tester, **regex101** (https://regex101.com/)
* [Example "subject" text](https://github.com/OuhscBbmc/StatisticalComputing/tree/master/2016-presentations/02-february/)
* A local text editor, choose one of the following:
    * **Atom** (https://atom.io/)
    * **Notepad++** (https://notepad-plus-plus.org/)
* Language agnostic as possible.  SAS, R, and Python examples in Part 2.    

* Later, consider [RegexBuddy](http://www.regexbuddy.com/) for $40.
    

Cautions
========================================================    
* There's no single "regular expression" specification.  Each language (eg, Python & R) have slightly different flavors.
* There are two main branches of the specification.  We'll concentrate on 
    * the "Perl" branch (eg, `"\d\w"`) instead of 
    * the "Posix" branch (eg, `"[:digit:][:alnum:]"`)
* Don't forget the "g" option in regex101.com
    

Example 1
===================================
* Identify years in the 1990s, *or*
* Identify years ending in 7, 8, or 9, *or*
* Identify lines starting with a year, *or*
* "Capture" the century of each year, *or*
* Think of something else.

```
1916-1918 subscales for a subject
1998-1914 subscales for a subject
subscales for a subject 1998-1920
```

Example 2
===================================
* Flag the "bad" numeric values

```
1234
23

14a
1a3

 234
1.39
```

Example 3
===================================
* Swap the columns.

```
"CL_ID"            = "ClientID"
, "RMSEQ"          = "RemovedSequence"
, "RMVL_BEGDT"     = "RemovalBeginDate"
, "RMVL_ENDDT"     = "RemovalEndDate"
, "END_TYP_CDE"    = "EndTypeID"
, "REMOVED_FROM"   = "RemovedFromTypeID"
, "CURR_RMVL_TYP"  = "RemovalTypeCurrentID"
, "ORIG_RMVL_TYP"  = "RemovalTypeOriginalID"
, "FMLY_STRUCTURE" = "FamilyStructureTypeID"
```

Example 4
===================================
* Erase the "quietly" parameters.

```
requireNamespace("dplyr", quietly=T) #hadley/dplyr
requireNamespace("lubridate")
requireNamespace("OuhscMunge", quietly=TRUE) #OuhscBbmc/OuhscMunge
```
