defs_fidcs <- readr::read_delim("C:/Users/lmarin/Desktop/Research/Arquivos R/concorrentes/defs_fidcs.txt",
                         delim = "\t", escape_double = FALSE,
                         trim_ws = TRUE)

usethis::use_data(defs_fidcs, overwrite = TRUE)
