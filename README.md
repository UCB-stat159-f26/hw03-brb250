# R Package 

## Overview

This package is an R package designed to retrieve career match data from [Tennis Abstract](https:www//tennisabstract.com/) and generate scatter plot visualizations comparing player age against difference between player age and opponent age.

## Installation

```R
Install package directly from Github using 'devtools' or 'pak':
#Using devtools
devtools::install_github("stat159-fall2026/hw03-brb250")

#or using pak
pak::pak("stat159-fall2026/hw03-brb250")
```

## Reflection

While working on this assignment, I learned:
* **R Package Tools:** Using developer packages like `devtools` to install and test packages directly from Github.
* **Package Dependencies & Namespaces:** How to manage internal dependencies using the `DESCRIPTION` file and calling functions via explicit namespace notation (`package::function()`) rather than relying on library calls.
*  **R Package Structure:** How to convert analytical scripts into a R package.