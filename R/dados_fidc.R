#' Title
#'
#' @param cnpj
#' @param start
#' @param end
#' @param table
#'
#' @return
#' @export
#'
#' @examples
dados_fidc <- function(cnpj, start, end, table){

  if (end >= start && start >= as.Date('2013-01-01')) {

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
                                                    end,
                                                    by = 'month')),
                             1,
                             6),
                      decreasing = TRUE)


        for (month in seq_along(dados_m)) {

          temp <- tempfile()
          utils::download.file(paste0(url1,
                                      '/inf_mensal_fidc_',
                                      dados_m[month],
                                      '.zip'),
                               temp)

          fidc <- utils::read.csv(unz(temp,
                                      paste0('inf_mensal_fidc_tab_',
                                             table,
                                             '_',
                                             dados_m[month],
                                             '.csv')),
                                  sep   = ';',
                                  quote = '') %>%
                    dplyr::filter(CNPJ_FUNDO %in% cnpj)

          full_fidc <- rbind(fidc,
                             full_fidc)


        }

    }

      if (start < date_threshold) {

        hist_y <- sort(substr(seq.Date(start, min(end,
                                  as.Date(date_threshold - as.difftime(15,
                                  units = 'days'))),
                                      by = 'year'), 1, 4),
                       decreasing = TRUE)


        for (year in seq_along(hist_y)) {

          temp <- tempfile()
          utils::download.file(paste0(url2,
                                      '/inf_mensal_fidc_',
                                      hist_y[year],
                                      '.zip'),
                               temp)

          fidc <- utils::read.csv(unz(temp,
                                      paste0('inf_mensal_fidc_tab_',
                                             table,
                                             '_',
                                             hist_y[year],
                                             '.csv')),
                                  sep   = ';',
                                  quote = '') %>%
            dplyr::filter(CNPJ_FUNDO %in% cnpj) %>%
            dplyr::mutate(DT_COMPTC = as.Date(DT_COMPTC, '%Y-%m-%d')) %>%
            dplyr::filter(DT_COMPTC >= start,
                          DT_COMPTC <= end)

          full_fidc <- rbind(fidc,
                             full_fidc)

        }

      }

  } else if (end < start) {
    stop('Start date must be before end date.')
  } else if (start < as.Date('2005-01-01')) {
    stop('Minimum date must be 2013-01-01.')
  }

  return(full_fidc)
  rm(full_fidc)
  rm(fidc)

}
