test_that("dados_diarios", {
  daily <- dadosCVM::dados_diarios(cnpj  = '01.608.573/0001-65',
                         start = as.Date('2020-12-01'),
                         end   = as.Date('2021-01-01'))

})
