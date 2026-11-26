# Pet shops e natalidade nos municípios brasileiros

**Trabalho de Econometria**  
**Autoras:** Giovana Quintero Lorenzi e Manuella Zambrotti Martins Ferreira de Sousa Vale

## Pergunta de pesquisa

Municípios com mais *pet shops* por habitante têm menos nascimentos?

O projeto examina a associação entre a quantidade de *pet shops* por 10 mil habitantes e a taxa de natalidade municipal, usando dados em corte transversal dos **5.570 municípios brasileiros**. As estimativas são feitas por Mínimos Quadrados Ordinários (MQO), com especificações alternativas e erros-padrão robustos HC1. A análise é associativa, não uma identificação de efeito causal.

## Arquivos

- `base_municipal_petshops_natalidade.csv`: base municipal consolidada utilizada nas análises.
- `analise.R`: script com preparação de variáveis, estatísticas descritivas, gráficos, cinco regressões, testes de Breusch–Pagan, teste de Wald e tabela de resultados.

## Dados e variáveis

A base consolidada reúne informações municipais relacionadas a nascimentos, população, estabelecimentos do setor pet e características socioeconômicas. Conforme a documentação do trabalho, foram utilizadas informações do SINASC (nascimentos), do Censo Demográfico de 2022 (características municipais) e de registros de estabelecimentos CNPJ/Base dos Dados. A variável de nascimentos é construída com referência ao período 2021–2023; as demais medidas devem ser interpretadas conforme as definições e fontes descritas no relatório.

Principais variáveis usadas no script:

- `taxa_natalidade`: nascidos vivos por mil habitantes;
- `pet_10mil`: número de *pet shops* por 10 mil habitantes;
- `log_renda_pc`: logaritmo da renda per capita;
- `log_densidade`: logaritmo da densidade demográfica;
- `pct_mulheres_superior`: percentual de mulheres com ensino superior completo;
- `uf`: unidade da federação, usada como fator nas regressões;
- `tem_petshop`: indicador criado no script, igual a 1 quando `n_pet_total > 0`.

## Como reproduzir a análise

1. Baixe os arquivos `analise.R` e `base_municipal_petshops_natalidade.csv` para **a mesma pasta**.
2. Abra o R ou o RStudio e defina essa pasta como diretório de trabalho (no RStudio, pode-se abrir o script e usar **Session → Set Working Directory → To Source File Location**).
3. Caso ainda não tenha os pacotes, instale-os no console do R:

   ```r
   install.packages(c("stargazer", "ggplot2", "readr", "lmtest", "sandwich", "dplyr"))
   ```

4. Execute `analise.R` do início ao fim.

O script imprime os resultados no console e exibe os gráficos no ambiente gráfico do R. Ele não requer arquivos externos além do CSV incluído neste repositório.

## Especificações estimadas

1. Regressão simples da taxa de natalidade em `pet_10mil`.
2. Inclusão de renda, densidade demográfica e escolaridade feminina.
3. Modelo com logaritmo da taxa de natalidade como variável dependente.
4. Inclusão de indicadores de unidade da federação.
5. Substituição de `pet_10mil` pelo indicador `tem_petshop`, mantendo controles e indicadores estaduais.

Os testes de Breusch–Pagan e a inferência com erros-padrão robustos HC1 são realizados no script. O teste de Wald compara os modelos 2 e 4 quanto à inclusão conjunta dos indicadores estaduais.

## Uso de inteligência artificial

Ferramentas de IA foram utilizadas como apoio à organização e documentação dos arquivos do repositório e à revisão de aspectos de reprodutibilidade do script. O relatório acadêmico contém a descrição do uso de IA e o link público da conversa, conforme as orientações da disciplina.
