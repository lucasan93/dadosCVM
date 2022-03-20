#' Registration Data' Download
#'
#' This function returns a data.frame containing the latest registration
#' data of all funds registered in CVM.
#'
#' @return a data.frame
#' @export
#'
#' @examples
#'
#'
cad_fi <- function() {

  # Require Packages
  require(dplyr)
  require(janitor)

  # Download CAD FI database from CVM
  temp <- tempfile()

  download.file(paste0('http://dados.cvm.gov.br',
                       '/dados',
                       '/FI',
                       '/CAD',
                       '/DADOS',
                       '/cad_fi.csv'),
                temp)

  # Read File
  read.csv(temp,
           sep   = ';',
           quote = "") %>%
    clean_names() %>%
    rename(tipo          = tp_fundo,
           cnpj          = cnpj_fundo,
           nome          = denom_social,
           registro      = dt_reg,
           constituicao  = dt_const,
           codigo_cvm    = cd_cvm,
           cancelamento  = dt_cancel,
           situacao      = sit,
           inicio_sit    = dt_ini_sit,
           inicio_atv    = dt_ini_ativ,
           inicio_exr    = dt_ini_exerc,
           fim_exr       = dt_fim_exerc,
           trib_lprazo   = trib_lprazo,
           qualificado   = invest_qualif,
           profissional  = invest_prof,
           entidade      = entid_invest,
           tx_perf       = taxa_perfm,
           inf_perf      = inf_taxa_perfm,
           tx_adm        = taxa_adm,
           inf_adm       = inf_taxa_adm,
           pl            = vl_patrim_liq,
           pl_data       = dt_patrim_liq,
           diretor       = diretor,
           adm_cnpj      = cnpj_admin,
           adm           = admin,
           tipo_gestor   = pf_pj_gestor,
           doc_gestor    = cpf_cnpj_gestor,
           gestor        = gestor,
           doc_auditor   = cnpj_auditor,
           auditor       = auditor,
           doc_custod    = cnpj_custodiante,
           custodiante   = custodiante,
           doc_control   = cnpj_controlador,
           controlador   = controlador) %>%
    mutate(tipo            = as.factor(tipo),
           cnpj            = as.character(cnpj),
           nome            = as.character(nome),
           registro        = as.Date(registro,
                                     '%Y-%m-%d'),
           constituicao    = as.Date(constituicao,
                                     '%Y-%m-%d'),
           codigo_cvm      = as.character(codigo_cvm),
           cancelamento    = as.Date(cancelamento,
                                     '%Y-%m-%d'),
           situacao        = as.factor(situacao),
           inicio_sit      = as.Date(inicio_sit,
                                     '%Y-%m-%d'),
           inicio_atv      = as.Date(inicio_atv,
                                     '%Y-%m-%d'),
           inicio_exr      = as.Date(inicio_exr,
                                     '%Y-%m-%d'),
           fim_exr         = as.Date(fim_exr,
                                     '%Y-%m-%d'),
           classe          = as.factor(classe),
           dt_ini_classe   = as.Date(dt_ini_classe,
                                     '%Y-%m-%d'),
           rentab_fundo    = as.character(rentab_fundo),
           condom          = as.factor(condom),
           fundo_cotas     = as.factor(fundo_cotas),
           fundo_exclusivo = as.factor(fundo_exclusivo),
           trib_lprazo     = as.factor(trib_lprazo),
           qualificado     = as.factor(qualificado),
           profissional    = as.factor(profissional),
           entidade        = as.factor(entidade),
           tx_perf         = as.numeric(tx_perf),
           inf_perf        = as.character(inf_perf),
           tx_adm          = as.numeric(tx_adm),
           inf_adm         = as.character(inf_adm),
           pl              = as.numeric(pl),
           pl_data         = as.Date(pl_data,
                                     '%Y-%m-%d'),
           diretor         = as.character(diretor),
           adm_cnpj        = as.character(adm_cnpj),
           adm             = as.character(adm),
           tipo_gestor     = as.factor(tipo_gestor),
           doc_gestor      = as.character(doc_gestor),
           auditor         = as.character(auditor),
           doc_custod      = as.character(doc_custod),
           controlador     = as.character(controlador))

}
