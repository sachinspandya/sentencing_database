# load required packages

library(dplyr)
library(statebins)
library(ggplot2)

# Produce State_Count_Map dataframe

load_path1 <- here::here("data-raw","sc_list_2009.csv ")
load_path2 <- here::here("data-raw", "state_sentencing_commissions_2023.csv")

df1 <- readr::read_csv(file = load_path1, col_types = readr::cols(.default = "c")) |>
      janitor::remove_empty(which = c("rows", "cols"))

df2 <- readr::read_csv(file = load_path2, col_types = readr::cols(.default = "c")) |>
  janitor::remove_empty(which = c("rows", "cols"))

df <- left_join(df1, df2, by = "stateab")

state_map2009 <- statebins(df,
                       state_col = "state",
                       value_col = "commission2009",
                       font_size = 4,
                       round = FALSE,
                       ggplot2_scale_function = scale_fill_manual,
                       name = "Sentencing Commissions - Jan. 2009",
                       values = c("0" = "gray","1" = "purple")
                       ) +
                       theme_statebins(legend_position="bottom") +
                       labs(
    #title = "State Sentencing Commissions",
    #subtitle = "As of January 2009",
    #fill='Location in Government',
    caption = "Source: App. B, Connecticut Sentencing Task Force Report (2009)"
    )


df2 <- df |>
       mutate(db_auth2 = if_else(is.na(db_auth) == TRUE, "0", db_auth))

cols <- c("1" = "red", "2" = "purple", "0" = "#FFFACD")



state_map2023 <- statebins(df2,
                           state_col = "state",
                           value_col = "db_auth2",
                           font_size = 4,
                           #na_label = "white",
                           round = TRUE,
                           ggplot2_scale_function = ggplot2::scale_fill_manual,
                           values = cols) +
                           theme_statebins(legend_position="none") +
                           labs(caption = "Source: State Statutes, 2023")

ggsave(filename = "state_map_2009_fig.png",
       plot = state_map2009,
       path = here::here("figures"),
       limitsize = FALSE,
       bg = "white",
       width = 7,
       height = 5
)

ggsave(filename = "state_map_2023_fig.png",
       plot = state_map2023,
       path = here::here("figures"),
       limitsize = FALSE,
       bg = "white",
       width = 7,
       height = 5
)
