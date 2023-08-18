library(tidyverse)
library(tidymodels)
library(gapminder)
library(unvotes)
library(widyr)
library(tidytext)

gapminder%>% 
    group_by(year) %>% 
    summarize(lifeExp = mean(lifeExp)) %>% 
    ggplot(aes(year, lifeExp)) +
    geom_line()

gapminder%>% 
    group_by(country) %>% 
    summarize(model = list(lm(lifeExp ~ year))) %>% 
    mutate(tidied = map(model, tidy)) %>% 
    unnest(tidied) %>% 
    filter(term == "year")


gapminder %>%
    select(country, year, lifeExp) %>%
    pivot_wider(names_from = country, values_from = lifeExp) %>% # Widen
    select(-year) %>%
    cor(use = "pairwise.complete.obs") %>% # Matrix operation
    as_tibble(rownames = "item1") %>%
    pivot_longer(cols = -item1, names_to = "item2") %>% # Re-tidy
    filter(!near(value, 1)) %>% 
    arrange(desc(value))

gapminder %>%
    pairwise_cor(country, year, lifeExp, sort = TRUE)

gapminder %>%
    pairwise_cor(country, year, lifeExp, upper = FALSE, sort = TRUE)


votes <- un_votes %>%
    mutate(vote = as.numeric(vote)) %>%
    pairwise_cor(country, rcid, vote, use = "pairwise.complete.obs", sort = TRUE)

votes %>% 
    filter(item1 %in% c("Spain","United States")) %>% 
    group_by(item1) %>% 
    top_n(30, abs(correlation)) %>%
    mutate(item2 = tidytext::reorder_within(item2, correlation, item1)) %>% 
    ggplot(aes(correlation, reorder(item2, correlation))) +
    geom_col() +
    facet_wrap(~item1, scales = "free_y") +
    tidytext::scale_y_reordered() +
    labs(x = "Correlation of votes", y = "")
    


# library(ranger)
# 
# # sample data
# # install.packages("AmesHousing")
# d <- AmesHousing::make_ames()
# 
# nt <- seq(1, 501, 10)
# 
# oob_mse <- vector("numeric", length(nt))
# 
# for(i in 1:length(nt)){
#     rf <- ranger(Sale_Price ~ ., d, num.trees = nt[i], write.forest = FALSE)
#     oob_mse[i] <- rf$prediction.error
# }
# 
# 
# plot(x = nt, y = oob_mse, col = "red", type = "l")