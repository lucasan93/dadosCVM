test_that("dados_diarios", {
  library(dadosCVM)
  daily <- dados_diarios(cnpj  = '01.608.573/0001-65',
                         start = as.Date('2020-12-01'),
                         end   = as.Date('2021-01-01'))

  testthat::expect_s3_class(daily,
                            'data.frame')

  testthat::expect_equal(ncol(daily),
                         8)

})
