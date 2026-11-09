#helper function to check player gender
is_female <- function(df) {
    col17 <- as.character(df[[17]])
    all(nchar(col17[col17 != ""]) == 8, na.rm = TRUE)
}
#helper function to calculate opponent age for female players
compute_opp_age <- function(df) {
    if (is_female(df)) {
    match_date <- lubridate::ymd(df[[1]])
    opp_dob <- lubridate::ymd(df[[17]])
    return(lubridate::time_length(lubridate::interval(opp_dob, match_date), "year"))
    }
    as.numeric(df[[17]])
}

#filter columns of raw df
clean_df <- function(df, opp_age) {
    raw_outcome <- df[[5]] #column 5 holds "W" or "L"
    data.frame(
        match_date=lubridate::ymd(df[[1]]),
        outcome = ifelse(raw_outcome == "W", "Match Williams won", "Match lost"),
        opp_age = opp_age
    )
}

#helper function to parse JS file into a data frame
parse_js_data <- function(js_content, name) {
    ctx <- V8::v8()
    ctx$eval(paste(js_content, collapse="\n"))
    raw <- ctx$get("morematchmx")
    df <- as.data.frame(do.call(rbind, raw))
    opp_age <- compute_opp_age(df)
    clean_df(df, opp_age)
}

get_player <- function(name) {
    #clean player name & build url
    clean_name <- gsub(" ", "", tools::toTitleCase(name))
    url <- paste0("https://www.tennisabstract.com/jsmatches/",clean_name,"Career.js")
    #download to temporary file
    temp_file <- tempfile(fileext=".js")
    status <- suppressWarnings(try(download.file(url, temp_file, quiet=TRUE), silent=TRUE))

    #returns meaningful error message if download fails
    if (inherits(status, "try-error") || status != 0) {
        stop(paste("Invalid player name:", name))
    }
    #read & parse JS file
    js_content <- readLines(temp_file, warn=FALSE)
    unlink(temp_file)
    #parse JS file into a data frame with helper function
    parse_js_data(js_content, name)
}



