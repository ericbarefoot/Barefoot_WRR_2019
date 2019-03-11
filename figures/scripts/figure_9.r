

diffPallet = c('#b2df8a', '#33a02c')

labb = c('Lateral', 'Longitudinal')

muWithLatLon = modelMu_update %>% ggplot(aes(x = Q_o, y = mu, color = label)) + geom_smooth(method = 'lm', se = F) +
geom_point() + theme_minimal() + scale_color_manual(labels = labb, values = diffPallet, guide = guide_legend(title = '')) + labs(x = 'Runoff', y = expression(paste(mu))) + theme(legend.position = 'bottom')

percentilesPlot = eventData %>% filter(!(names %in% c('w00', 'w02', 'w03'))) %>% ggplot(aes(x = percs, y = muuus)) + geom_smooth(method = 'lm', se = F, color = 'black') + geom_point() + theme_minimal() + labs(x = 'Flow Percentile', y = expression(paste(mu)))


combined = grid.arrange(grobs = list(muWithLatLon, percentilesPlot), widths = c(1,1),
layout_matrix = rbind(c(1,2)))

ggsave(filename = 'figure_9_draft.pdf', plot = combined, path = here('figures','outputs'), width = 8, height = 4, units = 'in')
