#' Dados Diarios
#'
#' This function returns a data.frame of investment funds daily data from CVM
#'
#' @param cnpj a character vector containing the CNPJ of the required funds
#' @param start a starting date, minimum value is 2005-01-01
#' @param end an end date
#'
#' @return data.frame
#' @export
#'
#' @importFrom magrittr %>%
#' @importFrom rlang .data
#'
dados_diarios <- function(cnpj, start, end){

  if (start < as.Date('2005-01-01')) {
    warning('Data unavailable for selected start date. Setting start date to 2005-01-01.')
  }

  if (end > Sys.Date()) {
    warning(paste0('End date cant be in the future. Setting end date to',
                   Sys.Date(),
                   '.' ))
  }

  if (end >= start) {

  # Nomes das Variáveis

  # URL in which data from after the threshold date is available
  url1 <- paste0('http://dados.cvm.gov.br',
                 '/dados',
                 '/FI',
                 '/DOC',
                 '/INF_DIARIO',
                 '/DADOS')

  # URL in which data from before the threshold date is available
  url2 <- paste0(url1,
                 '/HIST')

  # Date threshold
  date_threshold <- as.Date('2021-01-01')

  diario_f <- data.frame()

  if (end >= date_threshold) {

    dados_m <- sort(substr(gsub('-', '', seq.Date(max(start,
                                                      as.Date(date_threshold)),
                                                  min(end, Sys.Date()),
                                                  by = 'month')),
                           1,
                           6),
                    decreasing = TRUE)

    print(paste0('Obtaining data between ',
                 max(start, as.Date(date_threshold)),
                 ' and ',
                 min(end,Sys.Date())))

    prog <- progress::progress_bar$new(total = length(dados_m))

    for (month in seq_along(dados_m)) {

      prog$tick()

      temp <- tempfile()
      utils::download.file(paste0(url1,
                                  '/inf_diario_fi_',
                                  dados_m[month],
                                  '.csv'),
                           temp,
                           quiet = TRUE)

      diario <- utils::read.csv(temp, sep = ';', quote = "") %>%
          dplyr::select(.data$CNPJ_FUNDO,
                        .data$DT_COMPTC,
                        .data$VL_TOTAL,
                        .data$VL_QUOTA,
                        .data$VL_PATRIM_LIQ,
                        .data$CAPTC_DIA,
                        .data$RESG_DIA,
                        .data$NR_COTST) %>%
          dplyr::mutate(DT_COMPTC = as.Date(.data$DT_COMPTC, '%Y-%m-%d')) %>%
          dplyr::filter(.data$CNPJ_FUNDO %in% cnpj   &
                        .data$DT_COMPTC    >= start  &
                        .data$DT_COMPTC    <= end)

        diario_f <- rbind(diario,
                          diario_f)
    }
  }

  if (start < date_threshold) {

    hist_y <- sort(substr(seq.Date(max(start, as.Date('2005-01-01')), min(end,
                as.Date(date_threshold - as.difftime(1, units = 'days'))),
                              by = 'year'), 1, 4),
                   decreasing = TRUE)

    hist_m <- sort(substr(gsub('-', '', seq.Date(max(start,as.Date('2005-01-01')),
                                                 min(max(end, as.Date('2005-01-01')),
                        as.Date(date_threshold - as.difftime(1,
                                                  units = 'days'))),
                                        by = 'month')), 1, 6),
                   decreasing = TRUE)

    print(paste0('Obtaining data between ',
                 max(start, as.Date('2005-01-01')),
                 ' and ',
                 min(max(end, as.Date('2005-01-01')), Sys.Date())))

    prog <- progress::progress_bar$new(total = length(hist_y))


    for (year in seq_along(hist_y)) {

      prog$tick()

      temp <- tempfile()
      utils::download.file(paste0(url2,
                           '/inf_diario_fi_',
                           hist_y[year],
                           '.zip'),
                    temp,
                    quiet = TRUE)

      months <- hist_m[grepl(pattern = hist_y[year], substr(hist_m, 1, 4))]

      for (month in seq_along(months)) {

        diario <- utils::read.csv(unz(temp,
                               paste0('inf_diario_fi_',
                               months[month],
                               '.csv')),
                            sep = ';') %>%
          dplyr::select(.data$CNPJ_FUNDO,
                        .data$DT_COMPTC,
                        .data$VL_TOTAL,
                        .data$VL_QUOTA,
                        .data$VL_PATRIM_LIQ,
                        .data$CAPTC_DIA,
                        .data$RESG_DIA,
                        .data$NR_COTST) %>%
          dplyr::mutate(DT_COMPTC = as.Date(.data$DT_COMPTC, '%Y-%m-%d')) %>%
          dplyr::filter(.data$CNPJ_FUNDO %in% cnpj   &
                        .data$DT_COMPTC    >= start  &
                        .data$DT_COMPTC    <= end)

        diario_f <- rbind(diario,
                          diario_f)
      }
    }
  }

  diario_f <- diario_f %>%
                janitor::clean_names() %>%
                dplyr::rename(cnpj     = .data$cnpj_fundo,
                       data     = .data$dt_comptc,
                       v_total  = .data$vl_total,
                       v_quota  = .data$vl_quota,
                       pl       = .data$vl_patrim_liq,
                       capt     = .data$captc_dia,
                       resg     = .data$resg_dia,
                       cotistas = .data$nr_cotst) %>%
                dplyr::mutate(cnpj     = as.character(.data$cnpj),
                       data     = as.Date(.data$data,
                                          '%Y-%m_%d'),
                       v_total  = as.numeric(.data$v_total),
                       v_quota  = as.numeric(.data$v_quota),
                       pl       = as.numeric(.data$pl),
                       capt     = as.numeric(.data$capt),
                       resg     = as.numeric(.data$resg),
                       cotistas = as.numeric(.data$cotistas))

  return(diario_f)
  rm(diario_f)
  rm(diario)
  rm(dados_m)

  } else if (end < start) {
    stop('Start date must be before end date.')
  }
}
