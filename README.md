
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
-   Develop a function that simplifies funds names (i.e. transforms
    ‘FUNDO DE INVESTIMENTO EM DIREITOS CREDITORIOS’ to ‘FIDC’) - 0%.

## Installation

You can install the development version of dadosCVM from
[GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("lucasan93/dadosCVM")
```

## Examples

### 1: Downloading the latest registration data from CVM:

The function *cad\_fi()* downloads the latest registration data
available on CVM.

``` r
library(dadosCVM)
library(dplyr)
library(kableExtra)
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
                             inicio_atv,
                             pl_data,
                             pl) %>% 
                      arrange(desc(pl)) %>% 
                      slice_head(n = 10) %>% 
                      mutate(pl = format(pl,
                                         big.mark = ','))

kable(dados_cadastrais)
```

<table>
<thead>
<tr>
<th style="text-align:left;">
cnpj
</th>
<th style="text-align:left;">
classe
</th>
<th style="text-align:left;">
tipo
</th>
<th style="text-align:left;">
inicio\_atv
</th>
<th style="text-align:left;">
pl\_data
</th>
<th style="text-align:left;">
pl
</th>
</tr>
</thead>
<tbody>
<tr>
<td style="text-align:left;">
01.608.573/0001-65
</td>
<td style="text-align:left;">
Fundo de Renda Fixa
</td>
<td style="text-align:left;">
FI
</td>
<td style="text-align:left;">
1997-01-02
</td>
<td style="text-align:left;">
2022-03-16
</td>
<td style="text-align:left;">
161,992,521,081
</td>
</tr>
<tr>
<td style="text-align:left;">
27.146.328/0001-77
</td>
<td style="text-align:left;">
Fundo de Renda Fixa
</td>
<td style="text-align:left;">
FI
</td>
<td style="text-align:left;">
2017-05-03
</td>
<td style="text-align:left;">
2022-03-16
</td>
<td style="text-align:left;">
139,552,555,270
</td>
</tr>
<tr>
<td style="text-align:left;">
07.593.972/0001-86
</td>
<td style="text-align:left;">
Fundo de Renda Fixa
</td>
<td style="text-align:left;">
FI
</td>
<td style="text-align:left;">
2005-09-21
</td>
<td style="text-align:left;">
2022-03-16
</td>
<td style="text-align:left;">
122,535,371,859
</td>
</tr>
<tr>
<td style="text-align:left;">
22.985.157/0001-56
</td>
<td style="text-align:left;">
FIP Multi
</td>
<td style="text-align:left;">
FIP
</td>
<td style="text-align:left;">
2015-09-01
</td>
<td style="text-align:left;">
2021-12-31
</td>
<td style="text-align:left;">
107,568,311,434
</td>
</tr>
<tr>
<td style="text-align:left;">
00.822.055/0001-87
</td>
<td style="text-align:left;">
Fundo de Renda Fixa
</td>
<td style="text-align:left;">
FI
</td>
<td style="text-align:left;">
1995-10-02
</td>
<td style="text-align:left;">
2022-03-16
</td>
<td style="text-align:left;">
95,571,933,959
</td>
</tr>
<tr>
<td style="text-align:left;">
01.597.187/0001-15
</td>
<td style="text-align:left;">
Fundo de Renda Fixa
</td>
<td style="text-align:left;">
FI
</td>
<td style="text-align:left;">
1996-12-30
</td>
<td style="text-align:left;">
2022-03-16
</td>
<td style="text-align:left;">
94,980,870,025
</td>
</tr>
<tr>
<td style="text-align:left;">
42.592.302/0001-46
</td>
<td style="text-align:left;">
Fundo de Renda Fixa
</td>
<td style="text-align:left;">
FI
</td>
<td style="text-align:left;">
2021-09-30
</td>
<td style="text-align:left;">
2022-03-16
</td>
<td style="text-align:left;">
68,004,534,472
</td>
</tr>
<tr>
<td style="text-align:left;">
42.592.315/0001-15
</td>
<td style="text-align:left;">
Fundo de Renda Fixa
</td>
<td style="text-align:left;">
FI
</td>
<td style="text-align:left;">
2021-09-30
</td>
<td style="text-align:left;">
2022-03-16
</td>
<td style="text-align:left;">
68,000,175,320
</td>
</tr>
<tr>
<td style="text-align:left;">
04.288.966/0001-27
</td>
<td style="text-align:left;">
Fundo de Renda Fixa
</td>
<td style="text-align:left;">
FI
</td>
<td style="text-align:left;">
2002-07-15
</td>
<td style="text-align:left;">
2022-03-16
</td>
<td style="text-align:left;">
63,260,905,203
</td>
</tr>
<tr>
<td style="text-align:left;">
03.737.219/0001-66
</td>
<td style="text-align:left;">
Fundo de Renda Fixa
</td>
<td style="text-align:left;">
FI
</td>
<td style="text-align:left;">
2005-08-24
</td>
<td style="text-align:left;">
2022-03-16
</td>
<td style="text-align:left;">
55,297,829,993
</td>
</tr>
</tbody>
</table>
