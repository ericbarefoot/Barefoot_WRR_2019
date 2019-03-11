eventData %>% filter(!(names %in% c('w00','w02', 'w03'))) %>%
ggplot(aes(Q, muuus)) + geom_point() +
scale_x_log10() +
geom_smooth(method = 'lm', se = F)


lm(I(log(areas)) ~ I(log(Q)), data = eventData) %>% summary
lm(I(log(lengs)) ~ I(log(Q)), data = eventData) %>% summary
lm(muuus ~ percs, data = eventData) %>% summary
