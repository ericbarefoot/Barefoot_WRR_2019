## figure_6.r
## Showing trend of mu and area with runoff
## Eric Barefoot
## Feb 2019

library(gridExtra)

# produces a draft figure that is touched up in adobe illustrator

figout = here('figures','outputs','figure_6_draft.pdf')
source(here('analysis','dist_basics.r'))
source(here('analysis','runoff_width_modeling.r'))
source(here('analysis','functions','boxaxes.r'))
source(here('analysis','functions','disch_conv.r'))
source(here('analysis','effect_analysis.r'))


pal = c('red3','cadetblue4','chartreuse4','royalblue4','orchid4','palevioletred','goldenrod3','darkorange2','dodgerblue','darkolivegreen3','mediumorchid2','navajowhite2')

shapes = c(19,1,1,19,19,19,19,19,19,19,19,19)

survey_labels = as.character(1:12)

mu_runoff = logTransformNoZero %>% filter(!(survey %in% c('00'))) %>% group_by(survey) %>%
summarize(runoff = mean(runoff), mu = mean(logWidth), mu_upr = mu + sd(logWidth), mu_lwr = mu - sd(logWidth)) %>%
ggplot() +
geom_line(data = ModelsToPlot, aes(x = runoff, y = fit, linetype = model)) +
geom_errorbar(aes(x = runoff, ymin = mu_lwr, ymax = mu_upr), color = pal) +
geom_point(aes(x = runoff, y = mu, color = survey, shape = survey), size = 2) +
scale_color_manual(values = pal, guide = FALSE) +
scale_shape_manual(values = shapes, guide = FALSE) +
# scale_x_log10() +
scale_linetype(labels = c('Mixed-Effects Model', 'Null Model'), guide = guide_legend(title = '')) +
labs(x = 'Runoff (mm/hr)', y = expression(mu)) +
theme_minimal() + theme(legend.position = 'bottom')

# mu_runoff

modelData = surveyData %>% filter(!(survey %in% c('00', '02', '03')))
plotData = surveyData %>% filter(!(survey %in% c('00')))

runoff_area_plot =  ggplot() +
geom_smooth(aes(x = runoff, y = area), color = 'black', method = 'lm', se = F, size = 0.5, data = modelData) +
geom_point(aes(x = runoff, y = area, color = survey, shape = survey), size = 2, data = plotData) +
scale_color_manual(values = pal, labels = survey_labels, guide = guide_legend(title = 'Survey')) +
scale_shape_manual(values = shapes, guide = FALSE) +
scale_x_continuous(trans = 'log10', breaks = base_breaks(), labels = prettyNum) +
scale_y_continuous(trans = 'log10', breaks = base_breaks(), labels = prettyNum) +
labs(x = 'Runoff (mm/hr)', y = expression(paste('Total Area (',m^2,')'))) +
theme_minimal()

# runoff_area_plot

combined = grid.arrange(grobs = list(mu_runoff, runoff_area_plot), widths = c(1,1.25),
layout_matrix = rbind(c(1,2)))

ggsave(plot = combined, filename = 'figure_6_draft.pdf', path = here('figures','outputs'), width = 8, height = 4, units = 'in')
