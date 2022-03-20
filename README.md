
<!-- README.md is generated from README.Rmd. Please edit that file -->

# dadosCVM

<!-- badges: start -->
<!-- badges: end -->

The goal of dadosCVM is to obtain data of investments funds registered
on Comissão de Valores Imobiliários (*Security and Exchange Commissions
from Brazil*). Data is collected from files available at
<http://dados.cvm.gov.br/dados/>.

Main goals/ideas are descripted below:

-   Download of latest Registration Data (‘Dados Cadastrais’) available
    on CVM - 100%;
-   Quick access to Registration Data (‘Dados Cadastrais’), which will
    be updated on a monthly basis and will provide a quicker access to
    the database;

## Installation

You can install the development version of dadosCVM from
[GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("lucasan93/dadosCVM")
```

## Example 1: Downloading the latest registration data from CVM:

The function *cad\_fi()* downloads the latest registration data
available on CVM.

``` r
library(dadosCVM)
library(dplyr)
```

Below the top-10 funds in operation are extracted, sorted by their
equity and identified by their CNPJ (Brazil National Registry of Legal
Entities number).

``` r
dados_cadastrais <- cad_fi() %>%
                      filter(situacao == 'EM FUNCIONAMENTO NORMAL') %>% 
                      select(cnpj,
                             classe,
                             tipo,
                             pl) %>% 
                      arrange(desc(pl)) %>% 
                      slice_head(n = 10)

dados_cadastrais
#>                  cnpj              classe tipo           pl
#> 1  01.608.573/0001-65 Fundo de Renda Fixa   FI 161992521081
#> 2  27.146.328/0001-77 Fundo de Renda Fixa   FI 139552555270
#> 3  07.593.972/0001-86 Fundo de Renda Fixa   FI 122535371859
#> 4  22.985.157/0001-56           FIP Multi  FIP 107568311434
#> 5  00.822.055/0001-87 Fundo de Renda Fixa   FI  95571933959
#> 6  01.597.187/0001-15 Fundo de Renda Fixa   FI  94980870025
#> 7  42.592.302/0001-46 Fundo de Renda Fixa   FI  68004534472
#> 8  42.592.315/0001-15 Fundo de Renda Fixa   FI  68000175320
#> 9  04.288.966/0001-27 Fundo de Renda Fixa   FI  63260905203
#> 10 03.737.219/0001-66 Fundo de Renda Fixa   FI  55297829993
```
