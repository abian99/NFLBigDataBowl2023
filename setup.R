library(dplyr)
library(scales)
library(formattable)

players <- read.csv("nfl-big-data-bowl-2023/players.csv")
games <- read.csv("nfl-big-data-bowl-2023/games.csv")
plays <- read.csv("nfl-big-data-bowl-2023/plays.csv")
pffData <- read.csv("nfl-big-data-bowl-2023/pffScoutingData.csv")
week1 <- read.csv("nfl-big-data-bowl-2023/week1.csv")
pffData <- merge(pffData, plays,by=c("gameId","playId"))  %>%
  rename(
    team = possessionTeam
  )

seasonBlockingData <- pffData %>%
  inner_join(players, by="nflId") %>%
  group_by(nflId, team, pff_positionLinedUp) %>%
  filter(pff_role == "Pass Block") %>%
  filter(pff_positionLinedUp %in% c('LT', 'LG', 'C', 'RG', 'RT')) %>%
  mutate(
    GP = n_distinct(gameId),
    totalSnaps = n(),
    pff_beatenByDefender = percent((sum(pff_beatenByDefender)/n())),
    pff_hitAllowed = percent(sum(pff_hitAllowed)/n()),
    pff_hurryAllowed = percent(sum(pff_hurryAllowed)/n()),
    pff_sackAllowed = percent(sum(pff_sackAllowed)/n())
  ) %>%
  ungroup(nflId)%>%
  select(
    c(
      'displayName',
      'team',
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

week1Events <- filter(week1, event!="None")
# week1Events <- week1Events[ , c(2, 4, 16)] %>%
#   unique()
View(week1Events)
