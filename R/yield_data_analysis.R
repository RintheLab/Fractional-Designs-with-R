# Analysis of yield data (fractional design with 5 factors and resolution V)
library(FrF2)
library(ggplot2)

# Factors considered
yield_factors <- read.csv("data/yield_factors.csv")
colnames(yield_factors) <- c("Factor", "-1", "+1")
yield_factors

# Import data
yield_data <- read.csv("data/yield_data.csv")
head(yield_data)

# Linear model
yield_lm <- lm(Yield ~ (.)^2, data = yield_data)

# Summary
summary(yield_lm)

# Alias structure
aliases(yield_lm)

# Daniel plot
jpeg("graphs/daniel_plot_yield_data.jpeg")
DanielPlot(yield_lm)
dev.off()

# Pareto chart
yield_coeffs <- coefficients(yield_lm)[-1] # We discard the intercept

yield_effects <- data.frame(
  Effect = names(yield_coeffs),
  Value  = unname(yield_coeffs),
  AbsoluteValue = abs(unname(yield_coeffs)),
  Sign   = as.character(unname(sign(yield_coeffs)))
)

ggplot(yield_effects, aes(AbsoluteValue, reorder(Effect, -AbsoluteValue, abs))) +
  geom_col(aes(fill = Sign)) +
  xlab("Magnitude of effect") +
  ylab("Effect") +
  theme_minimal()

ggsave("graphs/pareto_chart_yield_data.jpeg")

# Subsequent analysis by ANOVA
yield_lm2 <- lm(Yield ~ Catalyst*Temperature*Concentration, yield_data)
anova(yield_lm2)