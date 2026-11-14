# tennisage

## Overview

'tennisage' is an R package designed to retrieve career match data from [Tennis Abstract](https://www.tennisabstract.com/) and generate scatter plot visualizations comparing player age against difference between player age and opponent age. It provides two functions:

* 'get_player()': Fetches and cleans career match data for a given tennis player.
* 'plot_player()': Generates a scatter plot of player age vs. age difference against opponents, color-coded by match outcome.

## Installation

```R
Install package directly from Github using 'devtools' or 'pak':
#Using devtools
devtools::install_github("UCB-stat159-f26/hw03-brb250")

#or using pak
pak::pak("UCB-stat159-f26/hw03-brb250")
```

## Usage
```R
library(tennisage)

#Retrieve career match data and plot for Serena Williams
serena <- get_player("serena williams")
plot_player(serena)

#Retrieve career match data and plot for Rafael Nadal
rafa <- get_player("Rafael Nadal")
plot_player(rafa)

#Invalid player names return a meaningful error message
get_player("Gaston Sanchez")
```

## Reflection

While working on this assignment, I learned:
* **R Package Tools:** Using developer packages like `devtools` to install and test packages directly from Github.
* **Package Dependencies & Namespaces:** How to manage internal dependencies using the `DESCRIPTION` file and calling functions via explicit namespace notation (`package::function()`) rather than relying on library calls.
*  **R Package Structure:** How to convert analytical scripts into a R package.