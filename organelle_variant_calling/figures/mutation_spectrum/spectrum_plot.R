library (tidyverse)

spectrum_data = read.csv("spectrum.csv")

spectrum_data$SNV = factor(spectrum_data$SNV, levels = c("AT>GC", "GC>AT", "AT>CG", "GC>TA", "AT>TA", "GC>CG"))

ggplot(data=spectrum_data, aes(x=SNV, y=Rate)) +
  geom_bar(stat="identity") +
  facet_wrap(~Genome, scales = "free_y") +
  scale_y_continuous(breaks = scales::breaks_pretty(n = 6)) +
  ylab("Mutation Rate (per bp per generation)") +
  xlab ("Substitution Type") +
  theme_bw() +
  theme (panel.grid = element_blank()) +
  theme (axis.title = element_text(size=7, face="bold"), axis.text = element_text(size=5.5), strip.text = element_text(size=7, face="bold"))



ggsave("spectrum_plot.pdf", width=5.5, height=2.5)