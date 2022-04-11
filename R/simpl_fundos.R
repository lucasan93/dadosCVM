

### function under development - do not use
### função em desenvolvimento - nao use

library(dplyr)
library(tm)
library(stringr)



x <- dadosCVM::cad_fi() %>%
                  pull(nome) %>%
                  unique()

simpl_funds <- function(names){

  rem <- stringr::str_to_upper(c('de', 'investimento', 'fundo', 'em', 'multimercado',
                                 'cotas', 'privado', 'fundos', 'crédito', 'exterior',
                                 'no', 'renda', 'ações', 'fixa', 'fi', 'credito',
                                 'financeiro', 'fic', 'quotas', 'direitos', 'prazo', 'ie', 'participações',
                                 'creditórios', 'di', 'longo', 'prev', 'fdo', 'priv', 'invest', 'multiestrategia', 'inv', 'referenciado', 'previdenciário', 'long', 'aplicacao', 'cred', 'ficfi', 'não', 'imobiliário', 'padronizados', 'fdos', 'aplic', 'mult', 'previdência', 'acoes', 'fia', 'fidc', 'creditorios', 'curto', 'créd', 'fii', 'investimentos', 'rf', 'fim', 'cp', 'fmia', 'exclusivo', 'lp', 'multiestrategia', 'am', 'total', 'multi', 'qualificado', 'faq', 'fip', 'yield', 'participacoes', 'fife', 'multissetorial', 'np', 'previdenciario', 'imobiliario', 'moderado', 'incentivado', 'alocação', 'aplicação', 'rv', 'fc', 'performance', 'fof', 'soberano', 'dividendos', 'fmp', 'financ', 'fgts', 'conservador', 'fie', 'multigestor', 'fiq', 'nao', 'exclusive', 'estruturado', 'empresas', 'liquidez', 'públicos', 'títulos', 'fin', 'invest', 'financ', 'financ', 'F A Q'))

  stringr::str_squish(stringr::str_remove_all(gsub('[[:punct:]]',' ', names), paste(paste0('\\b',rem,'\\b'),collapse = '|')))

}


k <- simpl_funds(x)


print(length(k))

print(length(unique(k)))


View(k)
