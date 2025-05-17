library(AER)

poisson_test_data = read.csv ("num_SNVs_per_line.csv")

model <- glm(poisson_test_data$sum ~ 1, family = poisson)

dispersiontest(model)