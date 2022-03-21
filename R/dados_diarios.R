dados_diarios <- function(cnpj, start, end){

  require(dplyr)
  require(janitor)

  url1 <- paste0('http://dados.cvm.gov.br',
                 '/dados',
                 '/FI',
                 '/DOC',
                 '/INF_DIARIO',
                 '/DADOS')

  url2 <- paste0(url1,
                 '/HIST')

  date_threshold <- as.Date('2021-01-01')

  diario_f <- data.frame()


  if (end >= date_threshold) {
    dados_m <- sort(substr(gsub('-',
                                '',
                                seq.Date(max(start,
                                             as.Date(date_threshold)),
                                         end,
                                         by = 'month')),
                           1,
                           6),
                    decreasing = TRUE)

    for (month in seq_along(dados_m)) {

        temp <- tempfile()
        download.file(paste0(url1,
                             '/inf_diario_fi_',
                             dados_m[month],
                             '.csv'),
                      temp)

        diario <- read.csv(temp,
                          sep   = ';',
                          quote = "") %>%
          select(CNPJ_FUNDO,
                 DT_COMPTC,
                 VL_TOTAL,
                 VL_QUOTA,
                 VL_PATRIM_LIQ,
                 CAPTC_DIA,
                 RESG_DIA,
                 NR_COTST) %>%
          mutate(DT_COMPTC = as.Date(DT_COMPTC,
                                     '%Y-%m-%d')) %>%
          filter(CNPJ_FUNDO %in% cnpj   &
                   DT_COMPTC    >= start  &
                   DT_COMPTC    <= end)

        diario_f <- rbind(diario,
                          diario_f)
    }
  }


  if (start < date_threshold) {

    hist_y <- sort(substr(seq.Date(start,
                min(end,
                as.Date(date_threshold - as.difftime(15,
                                                      unit = 'days'))),
                              by = 'year'),
                          1,
                          4),
                   decreasing = TRUE)

    hist_m <- sort(substr(gsub('-',
                               '',
                               seq.Date(start,
                        min(end,
                        as.Date(date_threshold - as.difftime(15,
                                                  unit = 'days'))),
                                        by = 'month')),
                          1,
                          6),
                   decreasing = TRUE)

    for (year in seq_along(hist_y)) {

      temp <- tempfile()
      download.file(paste0(url2,
                           '/inf_diario_fi_',
                           hist_y[year],
                           '.zip'),
                    temp)

      months <- hist_m[grepl(pattern = hist_y[year],
                       substr(hist_m, 1, 4))]

      for (month in seq_along(months)) {

        diario <- read.csv(unz(temp,
                               paste0('inf_diario_fi_',
                               months[month],
                               '.csv')),
                            sep = ';') %>%
          select(CNPJ_FUNDO,
                 DT_COMPTC,
                 VL_TOTAL,
                 VL_QUOTA,
                 VL_PATRIM_LIQ,
                 CAPTC_DIA,
                 RESG_DIA,
                 NR_COTST) %>%
          mutate(DT_COMPTC = as.Date(DT_COMPTC,
                                     '%Y-%m-%d')) %>%
          filter(CNPJ_FUNDO %in% cnpj   &
                   DT_COMPTC    >= start  &
                   DT_COMPTC    <= end)

        diario_f <- rbind(diario,
                          diario_f)

      }

    }

  }

  diario_f <- diario_f %>%
                janitor::clean_names() %>%
                rename(cnpj     = cnpj_fundo,
                       data     = dt_comptc,
                       v_total  = vl_total,
                       v_quota  = vl_quota,
                       pl       = vl_patrim_liq,
                       capt     = captc_dia,
                       resg     = resg_dia,
                       cotistas = nr_cotst) %>%
                mutate(cnpj     = as.character(cnpj),
                       data     = as.Date(data,
                                          '%Y-%m_%d'),
                       v_total  = as.numeric(v_total),
                       v_quota  = as.numeric(v_quota),
                       pl       = as.numeric(pl),
                       capt     = as.numeric(capt),
                       resg     = as.numeric(resg),
                       cotistas = as.numeric(cotistas))

  return(diario_f)
  rm(diario_f)
  rm(diario)
  rm(dados_m)

}

