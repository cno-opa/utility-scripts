# Most Holy OPA Programming Style and Resource Guide

This is a shared document of OPA programming style guidelines and resources. Please contribute!

## Contents
 * Style
 * Resources

## Style

Style conventions are important. If your code is consistent, semantic, and concise, it will be easier for you and for other people to understand. If it is easier to understand, it is easier to debug and easier to improve.

Here are some conventions to follow:

__File names:__ End files with `.R` and keep the names as short as possible, in lowercase, and use hyphens instead of spaces to separate words.

__Naming:__ Use lower camelcase for functions (myFunction) and underscores for object assignment (my_data). Try to limit your names to two words. Do not use periods to separate words.

__Indentation:__ Use two spaces, not tabs.

__Spaces:__ Use spaces around all operators (=, +, -, <-, &, |, and so on).

__Comments:__ Comment functions and other significant sections of your code so folks know what's going on, but be concise. For example:

```R
#this function prints a friendly greeting
greet <- function(name) {
    print( paste("Hello", name, ", you smell great today.", sep = " ") )
}
```

__Layout:__ Think of your script like you would any other document. It's read from top to bottom, should be organized into groups of things. Here is a general layout:

 * Prefatory comments, copyright
 * Load data
 * Function definition
 * Function execution
 * Testing
 * Save your work

__Dragons to avoid:__ Don't do these:

 * Use `=` instead of `<-`
 * Use `attach()`
 * Use `T` or `F` for `TRUE` or `FALSE`

## Resources

### git and Github

 * [git documentation](http://git-scm.com/doc)
 * [Github guides](https://guides.github.com/)
 * [Github cheat sheet (pdf)](https://training.github.com/kit/downloads/github-git-cheat-sheet.pdf)

### R

 * [Nice R Code](http://nicercode.github.io/)
 * [R Cookbook](http://www.cookbook-r.com/)
 * [Hadley Wickham's _Advanced R_](http://adv-r.had.co.nz/)
 * [Spatial data hints in R](http://spatial.ly/category/r-spatial-data-hints/)
 * [Google's R Styleguide](http://google-styleguide.googlecode.com/svn/trunk/Rguide.xml)
 * [Draft of R Coding Conventions](https://docs.google.com/document/d/1esDVxyWvH8AsX-VJa-8oqWaHLs4stGlIbk8kLc5VlII/edit#heading=h.10337d87494d)

### Miscellaneous

 * [Regular expression tester](http://www.regexr.com/)
 * [D3 for mere mortals](http://www.recursion.org/d3-for-mere-mortals/)
 * [Unofficial index of all PyData talks](https://github.com/DataTau/datascience-anthology-pydata)
