test_that("dados_fidc", {

  fidc <- dados_fidc(cnpj  = '24.194.675/0001-87',
                      start = as.Date('2018-10-01'),
                      end   = as.Date('2019-03-01'),
                      table = 'II')

  testthat::expect_s3_class(fidc,
                            'data.frame')

  testthat::expect_equal(ncol(fidc),
                         36)

})
