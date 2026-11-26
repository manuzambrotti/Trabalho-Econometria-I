# Trabalho de Econometria - Pet shops e natalidade
# Giovana Quintero Lorenzi e Manuella Zambrotti Martins Ferreira de Sousa Vale
# Pergunta: municipios com mais pet shops por habitante tem menos nascimentos?


# 1. Limpando o espaco de trabalho

rm(list = ls())


# 2. Baixando os pacotes

library(stargazer)
library(ggplot2)
library(readr)
library(lmtest)
library(sandwich)
library(dplyr)


# 3. Importando a base de dados

dados <- read_csv("base_municipal_petshops_natalidade.csv")


# 4. Arrumando as variaveis

# uf e regiao viram dummies de estado/regiao na regressao
dados$uf <- factor(dados$uf)
dados$regiao <- factor(dados$regiao)

# dummy: 1 se o municipio tem pelo menos um pet shop, 0 se nao tem
dados$tem_petshop <- ifelse(dados$n_pet_total > 0, 1, 0)
table(dados$tem_petshop)


# 5. Estatisticas descritivas

stargazer(as.data.frame(dados), type = "text")

#gráficos 

ggplot(dados, aes(x = pet_10mil)) +
  geom_histogram(bins = 50, fill = "#3B5B7A", color = "white") +
  labs(x = "Pet shops por 10 mil hab.", y = "Número de municípios") +
  theme_classic()

ggplot(dados, aes(x = log(1 + pet_10mil))) +
  geom_histogram(bins = 40, fill = "#3B5B7A", color = "white") +
  labs(x = "log(1 + pet shops por 10 mil hab.)", y = "Número de municípios") +
  theme_classic()

#por região

dados %>%
  group_by(regiao) %>%
  summarise(natalidade = mean(taxa_natalidade),
            pet_10mil = mean(pet_10mil),
            renda = mean(renda_pc_2022),
            mulheres_sup = mean(pct_mulheres_superior))

#gráficos 

ggplot(dados, aes(x = regiao, y = taxa_natalidade)) +
  geom_bar(stat = "summary", fun = "mean", fill = "#3B5B7A") +
  labs(x = "", y = "Taxa de natalidade (por mil hab.)") +
  theme_classic()

ggplot(dados, aes(x = regiao, y = pet_10mil)) +
  geom_bar(stat = "summary", fun = "mean", fill = "#3B5B7A") +
  labs(x = "", y = "Pet shops por 10 mil hab.") +
  theme_classic()

# 6. Correlacao + grafico

cor(dados$taxa_natalidade, dados$pet_10mil)

ggplot(dados, aes(x = pet_10mil, y = taxa_natalidade)) +
  geom_point() +
  geom_smooth(method = "lm") +
  labs(x = "Pet shops por 10 mil hab", y = "Taxa de natalidade")


# 7. Regressao 1 (simples)

reg1 <- lm(taxa_natalidade ~ pet_10mil, data = dados)
summary(reg1)
bptest(reg1)                                        # teste de heterocedasticidade
coeftest(reg1, vcov = vcovHC(reg1, type = "HC1"))   # erros robustos


# 8. Regressao 2 (multipla)

reg2 <- lm(taxa_natalidade ~ pet_10mil + log_renda_pc + log_densidade +
             pct_mulheres_superior, data = dados)
summary(reg2)
bptest(reg2)
coeftest(reg2, vcov = vcovHC(reg2, type = "HC1"))


# 9. Regressao 3 (log da natalidade)

reg3 <- lm(log(taxa_natalidade) ~ pet_10mil + log_renda_pc + log_densidade +
             pct_mulheres_superior, data = dados)
summary(reg3)
bptest(reg3)
coeftest(reg3, vcov = vcovHC(reg3, type = "HC1"))


# 10. Regressao 4 (dummies de estado)

reg4 <- lm(taxa_natalidade ~ pet_10mil + log_renda_pc + log_densidade +
             pct_mulheres_superior + uf, data = dados)
summary(reg4)
bptest(reg4)
coeftest(reg4, vcov = vcovHC(reg4, type = "HC1"))


# 11. Teste F (dummies de estado)

waldtest(reg2, reg4, vcov = vcovHC(reg4, type = "HC1"))


# 12. Regressao 5 (dummy de ter pet shop)

reg5 <- lm(taxa_natalidade ~ tem_petshop + log_renda_pc + log_densidade +
             pct_mulheres_superior + uf, data = dados)
summary(reg5)
bptest(reg5)
coeftest(reg5, vcov = vcovHC(reg5, type = "HC1"))


# 13. Tabela final (com erros robustos)

ep_rob <- list(sqrt(diag(vcovHC(reg1, type = "HC1"))),
               sqrt(diag(vcovHC(reg2, type = "HC1"))),
               sqrt(diag(vcovHC(reg3, type = "HC1"))),
               sqrt(diag(vcovHC(reg4, type = "HC1"))),
               sqrt(diag(vcovHC(reg5, type = "HC1"))))

stargazer(reg1, reg2, reg3, reg4, reg5, type = "text",
          se = ep_rob,
          omit = "uf",
          add.lines = list(c("Dummies de estado", "Nao", "Nao", "Nao", "Sim", "Sim")),
          notes = "Erros padrao robustos (HC1) entre parenteses")
