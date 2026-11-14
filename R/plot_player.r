#' @title Plot player career matches 
#' @description Plots a player's career matches by age difference with opponent.
#' @param df Data frame returned by \code{get_player()}
#' @return A ggplot object.
#' @export
plot_player <- function(df) {
    player <- gsub("([a-z])([A-Z])", "\\1 \\2", attr(df, "player_name"))
    player <- tools::toTitleCase(tolower(trimws(player)))
    ages <- floor(range(df$player_age, na.rm=TRUE))
    ggplot2::ggplot(df, ggplot2::aes(x=player_age, y=age_diff, color=outcome)) +
    ggplot2::theme_classic() +
    ggplot2::geom_hline(yintercept = seq(-20, 20, by=10), color = "grey98") +
    ggplot2::geom_hline(yintercept=0, color="grey40") +
    ggplot2::geom_point(alpha=0.6) +
    ggplot2::scale_color_manual(name=NULL, values=c("Match won"="deepskyblue", "Match lost"="deeppink4")) +
    ggplot2::scale_y_continuous(name=NULL, breaks=c(-20,-15,-10,0,10,15,20),
        labels = c("-20","Younger\nthan\nopponent","-10","Same age","+10","Older\nthan\nopponent","+20 years")) +
    ggplot2::scale_x_continuous(name="Player's age:", position="top") +
    ggplot2::labs(title=paste0(player, "'s Professional Matches, Age ", ages[1], " to ", ages[2])) +
    ggplot2::theme(plot.title = ggplot2::element_text(face = "bold"), legend.position = "top", legend.justification = "left", axis.line=ggplot2::element_blank(), axis.ticks = ggplot2::element_blank(), axis.text = ggplot2::element_text(color="grey40"))
}