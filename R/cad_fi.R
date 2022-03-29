#' Registration Data' Download
#'
#' This function returns a data.frame containing the latest registration
#' data of all funds registered in CVM.
#'
#' @return a data.frame
#' @export
#'
#'
#'
cad_fi <- function() {

  # Download CAD FI database from CVM
  temp <- tempfile()

  utils::download.file(paste0('http://dados.cvm.gov.br',
                       '/dados',
                       '/FI',
                       '/CAD',
                       '/DADOS',
                       '/cad_fi.csv'),
                       temp,
                       quiet = TRUE)

  # Read File
  utils::read.csv(temp,
                  sep   = ';',
                  quote = "") %>%
    janitor::clean_names() %>%
    dplyr::rename(tipo          = .data$tp_fundo,
                  cnpj          = .data$cnpj_fundo,
                  nome          = .data$denom_social,
                  registro      = .data$dt_reg,
                  constituicao  = .data$dt_const,
                  codigo_cvm    = .data$cd_cvm,
                  cancelamento  = .data$dt_cancel,
                  situacao      = .data$sit,
                  inicio_sit    = .data$dt_ini_sit,
                  inicio_atv    = .data$dt_ini_ativ,
                  inicio_exr    = .data$dt_ini_exerc,
                  fim_exr       = .data$dt_fim_exerc,
                  trib_lprazo   = .data$trib_lprazo,
                  qualificado   = .data$invest_qualif,
                  profissional  = .data$invest_prof,
                  entidade      = .data$entid_invest,
                  tx_perf       = .data$taxa_perfm,
                  inf_perf      = .data$inf_taxa_perfm,
                  tx_adm        = .data$taxa_adm,
                  inf_adm       = .data$inf_taxa_adm,
                  pl            = .data$vl_patrim_liq,
                  pl_data       = .data$dt_patrim_liq,
                  diretor       = .data$diretor,
                  adm_cnpj      = .data$cnpj_admin,
                  adm           = .data$admin,
                  tipo_gestor   = .data$pf_pj_gestor,
                  doc_gestor    = .data$cpf_cnpj_gestor,
                  gestor        = .data$gestor,
                  doc_auditor   = .data$cnpj_auditor,
                  auditor       = .data$auditor,
                  doc_custod    = .data$cnpj_custodiante,
                  custodiante   = .data$custodiante,
                  doc_control   = .data$cnpj_controlador,
                  controlador   = .data$controlador) %>%
    dplyr::mutate(tipo          = as.factor(.data$tipo),
                  cnpj          = as.character(.data$cnpj),
                  nome          = as.character(.data$nome),
                  registro      = as.Date(.data$registro, '%Y-%m-%d'),
                  constituicao  = as.Date(.data$constituicao, '%Y-%m-%d'),
                  codigo_cvm    = as.character(.data$codigo_cvm),
                  cancelamento  = as.Date(.data$cancelamento, '%Y-%m-%d'),
                  situacao        = as.factor(.data$situacao),
                  inicio_sit      = as.Date(.data$inicio_sit, '%Y-%m-%d'),
                  inicio_atv      = as.Date(.data$inicio_atv, '%Y-%m-%d'),
                  inicio_exr      = as.Date(.data$inicio_exr, '%Y-%m-%d'),
                  fim_exr         = as.Date(.data$fim_exr, '%Y-%m-%d'),
                  classe          = as.factor(.data$classe),
                  dt_ini_classe   = as.Date(.data$dt_ini_classe, '%Y-%m-%d'),
                  rentab_fundo    = as.character(.data$rentab_fundo),
                  condom          = as.factor(.data$condom),
                  fundo_cotas     = as.factor(.data$fundo_cotas),
                  fundo_exclusivo = as.factor(.data$fundo_exclusivo),
                  trib_lprazo     = as.factor(.data$trib_lprazo),
                  qualificado     = as.factor(.data$qualificado),
                  profissional    = as.factor(.data$profissional),
                  entidade        = as.factor(.data$entidade),
                  tx_perf         = as.numeric(.data$tx_perf),
                  inf_perf        = as.character(.data$inf_perf),
                  tx_adm          = as.numeric(.data$tx_adm),
                  inf_adm         = as.character(.data$inf_adm),
                  pl              = as.numeric(.data$pl),
                  pl_data         = as.Date(.data$pl_data, '%Y-%m-%d'),
                  diretor         = as.character(.data$diretor),
                  adm_cnpj        = as.character(.data$adm_cnpj),
                  adm             = as.character(.data$adm),
                  tipo_gestor     = as.factor(.data$tipo_gestor),
                  doc_gestor      = as.character(.data$doc_gestor),
                  auditor         = as.character(.data$auditor),
                  doc_custod      = as.character(.data$doc_custod),
                  controlador     = as.character(.data$controlador))
}
