
<!-- README.md is generated from README.Rmd. Please edit that file -->

# rsicons

<!-- badges: start -->

[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://lifecycle.r-lib.org/articles/stages.html#experimental)
[![R-CMD-check](https://github.com/rundel/rsicons/workflows/R-CMD-check/badge.svg)](https://github.com/rundel/rsicons/actions)
<!-- badges: end -->

The goal of `rsicons` is to make the various icons used within the
RStudio IDE available as images that can be embedded in other projects
(e.g. RMarkdown documents, Shiny apps, etc.)

## Installation

<!--
You can install the released version of rsicons from [CRAN](https://CRAN.R-project.org) with:

``` r
install.packages("rsicons")
```
-->

The development version can be installed from
[GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("rundel/rsicons")
```

## Example

The core function of the package is `icon()` which lets you insert a
named icon in a chunk

``` r
library(rsicons)
icon("rstudio", height=64)
```

<img src="man/figures/README-example-1.png" width="64" />

, via inline code
<img src="man/figures/README-example-1.png" width="24" />, or any where
else you can embed an image.

Details about each icon can be obtained via the `icon_info()` function,

``` r
icon_info("rstudio")
#> $type
#> [1] "File"
#> 
#> $sizes
#> [1] "16x16"   "24x24"   "32x32"   "48x48"   "64x64"   "128x128" "256x256"
#> [8] "512x512"
#> 
#> $formats
#> [1] "PNG"
```

### Available Icons

A listing of currently available icons can be obtained with
`available_icons()`, this listing can be refined by providing a
`pattern` which uses regular expressions to match the icon names,

``` r
available_icons(pattern = "vcs")
#> $Other
#> [1] "vcsUnstage"
#> 
#> $Source
#> [1] "vcsFileDiff"
#> 
#> $VCS
#>  [1] "vcsAddFiles"     "vcsCommit"       "vcsDiff"         "vcsIgnore"      
#>  [5] "vcsPull"         "vcsPullRebase"   "vcsPush"         "vcsRefresh"     
#>  [9] "vcsRemoveFiles"  "vcsResolve"      "vcsRevert"       "vcsShowHistory" 
#> [13] "vcsViewOnGitHub"
```

Similarly, a list of all available types can obtained with,

``` r
available_types()
#>  [1] "Application"            "Build"                  "Common"                
#>  [4] "Common - Code"          "Connections"            "Console"               
#>  [7] "Debugging"              "Environment"            "File"                  
#> [10] "Files"                  "Help"                   "History"               
#> [13] "HTML preview"           "Jobs"                   "Other"                 
#> [16] "Packages"               "packrat"                "PDF"                   
#> [19] "Plots"                  "Plumber IDE features"   "Presentation"          
#> [22] "Profiler"               "Projects"               "RSConnect connectivity"
#> [25] "Shiny IDE features"     "Source"                 "Terminal"              
#> [28] "Tutorial"               "VCS"                    "Version control"       
#> [31] "Viewer"                 "Workspace"
```

If instead you would would more directly like to view the available
icons, you can use the preview functions:

``` r
preview_icon("application-x-r-project")
```

<img src="man/figures/README-pr_icon-1.png" width="384" />

``` r
preview_type("File")
```

<img src="man/figures/README-pr_type-1.png" width="544" />

### All Current Icons

<img src="man/figures/README-pr_all-1.png" width="1344" />
