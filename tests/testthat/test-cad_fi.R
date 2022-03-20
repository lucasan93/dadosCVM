test_that("cad_fi", {
  dados_cadastrais <- cad_fi()

  testthat::expect_s3_class(dados_cadastrais,
                            'data.frame')

  testthat::expect_equal(ncol(dados_cadastrais),
                         40)

  testthat::expect_gt(nrow(dados_cadastrais),
                             6*10^4)
})
