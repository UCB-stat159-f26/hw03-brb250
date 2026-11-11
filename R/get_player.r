#helper function to check player gender
is_female <- function(df) {
    col17 <- as.character(df[[17]])
    all(nchar(col17[col17 != ""]) == 8, na.rm = TRUE)
}

#helper function to get female player's birthdate
female_dob <- function(name) {
    url <- "https://raw.githubusercontent.com/Aneeshers/tennis-sackmann-archive/main/wta/wta_players.csv"
    df <- read.csv(url)
    clean_input <- gsub(" ", "", tolower(name))
    clean_db <- tolower(paste0(df$name_first, df$name_last))
    m <- df[clean_input == clean_db, ]
    if (nrow(m) > 0 && !is.na(m$dob[1]) && m$dob[1] != '') lubridate::ymd(m$dob[1]) else NULL
}

#helper function to fetch male player's birthdate
male_dob <- function(name) {
    url <- "https://raw.githubusercontent.com/Aneeshers/tennis-sackmann-archive/main/atp/atp_players.csv"
    df <- read.csv(url)
    clean_input <- gsub(" ", "", tolower(name))
    clean_db <- tolower(paste0(df$name_first ,df$name_last))
    #check if 'clean_input' is contained in 'clean_db'
    m <- df[grepl(clean_input, clean_db), ]
    if (nrow(m) > 0 && !is.na(m$dob[1]) && m$dob[1] != '') lubridate::ymd(m$dob[1]) else NULL
}

#helper function to fetch dob of female players
compute_opp_age <- function(df) {
    if (is_female(df)) {
    match_date <- lubridate::ymd(df[[1]])
    opp_dob <- lubridate::ymd(df[[17]])
    return(lubridate::time_length(lubridate::interval(opp_dob, match_date), "year"))
    }
    as.numeric(df[[17]])
}

#filter columns of raw df
clean_df <- function(df, opp_age, name) {
    player_dob <- female_dob(name)
    if (is.null(player_dob)) player_dob <- male_dob(name)
    match_date <- lubridate::ymd(df[[1]])
    player_age <- lubridate::time_length(lubridate::interval(player_dob, match_date), "year")
    data.frame(
        match_date=match_date,
        outcome = ifelse(df[[5]] == "W", "Match won", "Match lost"),
        player_age = player_age,
        age_diff = player_age - opp_age
    )
}

#helper function to parse JS file into a data frame
parse_js_data <- function(js_content, name) {
    ctx <- V8::v8()
    ctx$eval(paste(js_content, collapse="\n"))
    raw <- ctx$get("morematchmx")
    df <- as.data.frame(do.call(rbind, raw))
    opp_age <- compute_opp_age(df)
    clean_df(df, opp_age, name)
}

#public function that takes a player name and returns a cleaned table for graphic purporses
get_player <- function(name) {
    words <- unlist(strsplit(tolower(name), "[^a-z0-9]+"))
    words <- words[words != ""]
    #clean player name & build url
    clean_name <- paste0(toupper(substr(words, 1, 1)), substring(words, 2), collapse = "")
    url <- paste0("https://www.tennisabstract.com/jsmatches/",clean_name,"Career.js")
    #download to temporary file
    temp_file <- tempfile(fileext=".js")
    status <- download.file(url, temp_file, quiet=TRUE)

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



