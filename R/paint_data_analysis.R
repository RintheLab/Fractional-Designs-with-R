# Analysis of yield data (fractional design with 8 factors and resolution IV)
library(FrF2)
library(ggplot2)

# Import data
paint_data <- read.csv("data/paint_data.csv")
head(paint_data)

# Linear model
paint_lm <- lm(Brightness ~ (.)^2, data = paint_data)

# Alias structure
aliases(paint_lm)

# Daniel plot
jpeg("graphs/daniel_plot_paint_data.jpeg")
DanielPlot(paint_lm)
dev.off()

# Pareto chart
paint_coeffs <- coefficients(paint_lm)[-1] # We discard the intercept
paint_coeffs <- paint_coeffs[!is.na(paint_coeffs)] # Discard NA effects

paint_effects <- data.frame(
  Effect = names(paint_coeffs),
  Value  = unname(paint_coeffs),
  AbsoluteValue = abs(unname(paint_coeffs)),
  Sign   = as.character(unname(sign(paint_coeffs)))
)

ggplot(paint_effects, aes(AbsoluteValue, reorder(Effect, -AbsoluteValue, abs))) +
  geom_col(aes(fill = Sign)) +
  xlab("Magnitude of effect") +
  ylab("Effect") +
  theme_minimal()

ggsave("graphs/pareto_chart_paint_data.jpeg")

# Subsequent analysis by ANOVA
paint_lm2 <- lm(Brightness ~ A*B*G, data = paint_data)
anova(paint_lm2)

# Cube plot
jpeg("graphs/cube_plot_paint_data.jpeg")
cubePlot(paint_lm2, eff1 = "A", eff2 = "B", eff3 = "G")
dev.off()
