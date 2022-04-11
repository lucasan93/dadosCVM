test_that("cad_fi", {
  library(dadosCVM)
  dados_cadastrais <- dadosCVM::cad_fi()

  testthat::expect_s3_class(dados_cadastrais,
                            'data.frame')

  testthat::expect_equal(ncol(dados_cadastrais),
                         39)

  testthat::expect_gt(nrow(dados_cadastrais),
                             6*10^4)
})
