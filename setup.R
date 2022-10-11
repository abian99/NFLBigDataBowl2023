library(dplyr)
library(scales)
players <- read.csv("nfl-big-data-bowl-2023/players.csv")
games <- read.csv("nfl-big-data-bowl-2023/games.csv")
pffData <- read.csv("nfl-big-data-bowl-2023/pffScoutingData.csv")

seasonBlockingData <- pffData %>%
  inner_join(players, by="nflId") %>%
  group_by(nflId, pff_positionLinedUp) %>%
  filter(pff_role == "Pass Block") %>%
  mutate(
    GP = n_distinct(gameId),
    totalSnaps = n(),
    pff_beatenByDefender = label_percent(accuracy = 0.01)(sum(pff_beatenByDefender)/n()),
    pff_hitAllowed = label_percent(accuracy = 0.01)(sum(pff_hitAllowed)/n()),
    pff_hurryAllowed = label_percent(accuracy = 0.01)(sum(pff_hurryAllowed)/n()),
    pff_sackAllowed = label_percent(accuracy = 0.01)(sum(pff_sackAllowed)/n())
  ) %>%
  select(
    c(
      'displayName',
      'GP',
      'totalSnaps',
      'pff_positionLinedUp',
      'pff_beatenByDefender',
      'pff_hitAllowed',
      'pff_hurryAllowed',
      'pff_sackAllowed'
    )
  ) %>%
  unique()

print(seasonBlockingData)