library(readxl)
library(tidyverse)

asistentes_dir = "app_ASISTENTES"

reference = readxl::read_xls(file.path(asistentes_dir,"reference.xls"))
write_rds(reference, file.path(asistentes_dir,"reference.rds"))

