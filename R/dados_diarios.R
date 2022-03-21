dados_diarios <- function(cnpj, start, end){

  url1 <- paste0('http://dados.cvm.gov.br',
                 '/dados',
                 '/FI',
                 '/DOC',
                 '/INF_DIARIO',
                 '/DADOS')

  url2 <- paste0(url1,
                 '/HIST')

  months <- sort(substr(gsub('-',
                             '',
                             seq.Date(start,
                                      end,
                                      by = 'month')),
                        1,
                        6),
                 decreasing = TRUE)

  dados_f <- data.frame()

  for (month in seq_along(months)) {
    if (substr(months[month], 1, 4) >= 2017) {

      temp <- tempfile()
      download.file(paste0(url1,
                           '/inf_diario_fi_',
                           months[month],
                           '.csv'),
                    temp)

      dados <- read.csv(temp,
                        sep   = ';',
                        quote = "") %>%
                mutate(DT_COMPTC = as.Date(DT_COMPTC,
                                           '%Y-%m-%d')) %>%
                filter(CNPJ_FUNDO %in% cnpj   &
                       DT_COMPTC    >= start  &
                       DT_COMPTC    <= end)

      dados_f <- rbind(dados,
                       dados_f)

    }
  }
}

dados_diarios(cnpj = cnpj,
              start = start,
              end = end)

start <- as.Date('2021-03-01')
end   <- as.Date('2022-03-01')

cnpj <- c('01.608.573/0001-65',
          '27.146.328/0001-77')
