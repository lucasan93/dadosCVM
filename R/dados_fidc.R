#' Dados FIDC
#'
#' This function returns a data.frame of FIDCs monthly data from CVM
#'
#' @param cnpj a character vector containing the CNPJ of the required funds
#' @param start a starting date, minimum value is 2005-01-01
#' @param end an end date
#' @param table a character value containing a FIDC' table number
#'
#' @return data.frame
#' @export
#'
#' @importFrom magrittr %>%
#' @importFrom rlang .data
#'
#'
dados_fidc <- function(cnpj, start, end, table){

  if (!table %in% c('I', 'II', 'III', 'IV', 'V', 'VI', 'VII', 'IX',
                    'X_1', 'X_1_1', 'X_2', 'X_3', 'X_4', 'X_5', 'X_6', 'X_7')) {
    stop('Table not available. See tabs_fidcs for reference.')
  }

  if (start < as.Date('2013-01-01')) {
    warning('Data unavailable for selected start date. Setting start date to 2013-01-01.')
  }

  if (end < as.Date('2013-01-01')) {
    warning('Data unavailable for selected end date. Setting end date to 2013-01-01.')
  }

  if (end > (Sys.Date() - lubridate::days(lubridate::day(Sys.Date())))) {
    warning(paste0('Data for end date unavailable. Setting end date to ', Sys.Date() - lubridate::days(lubridate::day(Sys.Date())),'.' ))
  }

  if (table == 'X_1_1' | table == 'X_7') {
    start <- max(as.Date('2019-11-30'), start)
    end   <- max(as.Date('2019-11-30'), end)
  }



  if (end >= start) {
    # URL in which data from after the threshold date is available
    url1 <- paste0('http://dados.cvm.gov.br',
                   '/dados',
                   '/FIDC',
                   '/DOC',
                   '/INF_MENSAL',
                   '/DADOS')

    # URL in which data from before the threshold date is available
    url2 <- paste0(url1,
                   '/HIST')

    # Date threshold
    date_threshold <- as.Date('2019-01-01')

    full_fidc <- data.frame()

    if (end >= date_threshold) {



      dados_m <- sort(substr(gsub('-', '', seq.Date(max(start,
                                                        as.Date(date_threshold)),
                                                    min(end, (Sys.Date() - lubridate::days(lubridate::day(Sys.Date())))),
                                                    by = 'month')),
                             1,
                             6),
                      decreasing = TRUE)

      print(paste0('Obtaining data between ', max(start, as.Date(date_threshold)), ' and ',  min(end, (Sys.Date() - lubridate::days(lubridate::day(Sys.Date()))))))


      prog <- progress::progress_bar$new(total = length(dados_m))

        for (month in seq_along(dados_m)) {

          prog$tick()

          temp <- tempfile()
          utils::download.file(paste0(url1,
                                      '/inf_mensal_fidc_',
                                      dados_m[month],
                                      '.zip'),
                               temp,
                               quiet = TRUE)

          fidc <- utils::read.csv(unz(temp,
                                      paste0('inf_mensal_fidc_tab_',
                                             table,
                                             '_',
                                             dados_m[month],
                                             '.csv')),
                                  sep   = ';',
                                  quote = '') %>%
                    dplyr::filter(.data$CNPJ_FUNDO %in% cnpj) %>%
                    dplyr::mutate(DT_COMPTC = as.Date(.data$DT_COMPTC, '%Y-%m-%d')) %>%
                    dplyr::filter(.data$DT_COMPTC >= start,
                                  .data$DT_COMPTC <= end) %>%
                    tidyr::pivot_longer(cols = c(tidyr::starts_with('TAB_'),
                                                 -tidyr::matches(c('TAB_X_CLASSE_SERIE',
                                                                   'TAB_X_TP_OPER'))),
                                        names_to = 'category',
                                        values_to = 'value')

          full_fidc <- dplyr::bind_rows(fidc,
                                        full_fidc)
        }
    }

      if (start < date_threshold) {

        hist_y <- sort(substr(seq.Date(max(start, as.Date('2013-01-01')),
                                      min(max(end, as.Date('2013-01-01')),
                                  as.Date(date_threshold - as.difftime(1,
                                  units = 'days'))),
                                      by = 'year'), 1, 4),
                       decreasing = TRUE)

        print(paste0('Obtaining data between ',
                     max(start, as.Date('2013-01-01')),
                     ' and ',
                     min(end,
                         as.Date(date_threshold - as.difftime(1,
                                                              units = 'days')))))

        prog <- progress::progress_bar$new(total = length(hist_y))

        for (year in seq_along(hist_y)) {

          prog$tick()

          temp <- tempfile()
          utils::download.file(paste0(url2,
                                      '/inf_mensal_fidc_',
                                      hist_y[year],
                                      '.zip'),
                               temp,
                               quiet = TRUE)

          fidc <- utils::read.csv(unz(temp,
                                      paste0('inf_mensal_fidc_tab_',
                                             table,
                                             '_',
                                             hist_y[year],
                                             '.csv')),
                                  sep   = ';',
                                  quote = '') %>%
            dplyr::filter(.data$CNPJ_FUNDO %in% cnpj) %>%
            dplyr::mutate(DT_COMPTC = as.Date(.data$DT_COMPTC, '%Y-%m-%d')) %>%
            dplyr::filter(.data$DT_COMPTC >= start,
                          .data$DT_COMPTC <= end) %>%
            tidyr::pivot_longer(cols =  c(tidyr::starts_with('TAB_'),
                                          -tidyr::matches(c('TAB_X_CLASSE_SERIE',
                                                            'TAB_X_TP_OPER'))),
                                    names_to = 'category',
                                    values_to = 'value')


          full_fidc <- dplyr::bind_rows(fidc,
                                        full_fidc)
        }
      }

    if (table == 'I') {
      full_fidc <- full_fidc %>%
        dplyr::left_join(dadosCVM::defs_fidcs,
                         by = 'category') %>%
        dplyr::filter(.data$item != 'total') %>%
        dplyr::rename(cnpj       = .data$CNPJ_FUNDO,
                      nome       = .data$DENOM_SOCIAL,
                      data       = .data$DT_COMPTC,
                      adm        = .data$ADMIN,
                      adm_cnpj   = .data$CNPJ_ADMIN,
                      condominio = .data$CONDOM,
                      cot_int    = .data$COTST_INTERESSE,
                      exclusivo  = .data$FUNDO_EXCLUSIVO) %>%
        dplyr::select(.data$data,
                      .data$cnpj,
                      .data$nome,
                      .data$adm,
                      .data$adm_cnpj,
                      .data$condominio,
                      .data$cot_int,
                      .data$exclusivo,
                      .data$category,
                      .data$base,
                      .data$segment,
                      .data$class,
                      .data$item,
                      .data$value) %>%
        dplyr::mutate(data    = as.Date(.data$data, '%Y-%m-%d'),
                      cnpj     = as.character(.data$cnpj),
                      nome     = as.character(.data$nome),
                      category = as.factor(.data$category),
                      base     = as.factor(.data$base),
                      segment  = as.factor(.data$segment),
                      class    = as.factor(.data$class),
                      item     = as.factor(.data$item)) %>%
        dplyr::mutate(value = dplyr::case_when(category == 'TAB_I2A11_VL_REDUCAO_RECUP' ~
                                          -value,
                                        TRUE ~ value))

    } else if (table == 'X_1' | table == 'X_2' | table == 'X_3' | table == 'X_6') {

      full_fidc <- full_fidc %>%
        dplyr::left_join(dadosCVM::defs_fidcs,
                         by = 'category') %>%
        dplyr::filter(.data$item != 'total') %>%
        dplyr::rename(cnpj       = .data$CNPJ_FUNDO,
                      nome       = .data$DENOM_SOCIAL,
                      data       = .data$DT_COMPTC,
                      serie      = .data$TAB_X_CLASSE_SERIE) %>%
        dplyr::select(.data$data,
                      .data$cnpj,
                      .data$nome,
                      .data$category,
                      .data$base,
                      .data$segment,
                      .data$class,
                      .data$serie,
                      .data$item,
                      .data$value) %>%
        dplyr::mutate(data    = as.Date(.data$data, '%Y-%m-%d'),
                      cnpj     = as.character(.data$cnpj),
                      nome     = as.character(.data$nome),
                      category = as.factor(.data$category),
                      base     = as.factor(.data$base),
                      segment  = as.factor(.data$segment),
                      class    = as.factor(.data$class),
                      serie    = as.factor(.data$serie),
                      item     = as.factor(.data$item))


    } else if (table == 'X_4') {
      full_fidc <- full_fidc %>%
        dplyr::left_join(dadosCVM::defs_fidcs,
                         by = 'category') %>%
        dplyr::filter(.data$item != 'total') %>%
        dplyr::rename(cnpj       = .data$CNPJ_FUNDO,
                      nome       = .data$DENOM_SOCIAL,
                      data       = .data$DT_COMPTC,
                      operacao   = .data$TAB_X_TP_OPER) %>%
        dplyr::select(.data$data,
                      .data$cnpj,
                      .data$nome,
                      .data$category,
                      .data$base,
                      .data$segment,
                      .data$class,
                      .data$item,
                      .data$operacao,
                      .data$value) %>%
        dplyr::mutate(data    = as.Date(.data$data, '%Y-%m-%d'),
                      cnpj     = as.character(.data$cnpj),
                      nome     = as.character(.data$nome),
                      category = as.factor(.data$category),
                      base     = as.factor(.data$base),
                      segment  = as.factor(.data$segment),
                      class    = as.factor(.data$class),
                      item     = as.factor(.data$item),
                      operacao = as.factor(.data$operacao))


    } else if (table != 'I' && table != 'X_I' && table != 'X_2' && table != 'X_3'
               && table != 'X_4' && table != 'X_6') {
      full_fidc <- full_fidc %>%
        dplyr::left_join(dadosCVM::defs_fidcs,
                         by = 'category') %>%
        dplyr::filter(.data$item != 'total') %>%
        dplyr::rename(cnpj       = .data$CNPJ_FUNDO,
                      nome       = .data$DENOM_SOCIAL,
                      data       = .data$DT_COMPTC) %>%
        dplyr::select(.data$data,
                      .data$cnpj,
                      .data$nome,
                      .data$category,
                      .data$base,
                      .data$segment,
                      .data$class,
                      .data$item,
                      .data$value) %>%
        dplyr::mutate(data    = as.Date(.data$data, '%Y-%m-%d'),
                      cnpj     = as.character(.data$cnpj),
                      nome     = as.character(.data$nome),
                      category = as.factor(.data$category),
                      base     = as.factor(.data$base),
                      segment  = as.factor(.data$segment),
                      class    = as.factor(.data$class),
                      item     = as.factor(.data$item))
    }

    return(full_fidc)
    rm(full_fidc)
    rm(fidc)

  } else if (end < start) {
    stop('Start date must be before end date.')
  }
}
