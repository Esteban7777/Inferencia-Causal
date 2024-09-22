##### FILTRAR DATA PARA MEDELLIN #######

#Se filtran los datos para el municipio de interés y se guarda en csv

#Cargar los datos
library(readr)
Personas <- read_csv("C:/Users/HP-Laptop/Downloads/CNPV2018_5PER_A2_05.CSV")
Viviendas <- read_csv("C:/Users/HP-Laptop/Downloads/CNPV2018_1VIV_A2_05.CSV")
Hogares <- read_csv("C:/Users/HP-Laptop/Downloads/CNPV2018_2HOG_A2_05.CSV")
MGN <- read_csv("C:/Users/HP-Laptop/Downloads/CNPV2018_MGN_A2_05.CSV")

#Filtrar los datos
library(tidyverse)

Personas<-Personas %>% filter(U_DPTO=="05" & U_MPIO=="001")
Viviendas<-Viviendas %>% filter(U_DPTO=="05" & U_MPIO=="001")
Hogares<-Hogares %>% filter(U_DPTO=="05" & U_MPIO=="001")
MGN<-MGN %>% filter(U_DPTO=="05" & U_MPIO=="001")

#Exportar en formato csv
path<-"C:/Users/HP-Laptop/OneDrive - Universidad de Antioquia/Maestría en Economía/Evaluación de impacto/Inferencia-Causal/CNPV2018/Data"

# Dividir los datos y guardarlos en archivos CSV
save_data<-function(data,length_chunk,name_file){
  
  n_chunk <- ceiling(nrow(data) / length_chunk)
  
  for (i in seq_len(n_chunk)) {
  # Definir el índice inicial y final para cada bloque
  start_chunk <- (i - 1) * length_chunk + 1
  end_chunk <- min(i * length_chunk, nrow(data))
  
  # Extraer el bloque
  chunk <- data[start_chunk:end_chunk, ]
  
  # Definir el nombre del archivo CSV
  name_files <- sprintf(name_file, i)
  
  # Guardar el bloque en un archivo CSV con codificación UTF-8
  write.csv(chunk, name_files, row.names = FALSE, fileEncoding = "UTF-8")
  }}

save_data(data = Personas, 
          length_chunk = 70000,
          name_file =paste0(path,
                            "/CNPV2018_5PER_A2_05001/CNPV2018_5PER_A2_05001_%03d.csv"))

save_data(data = Viviendas, 
          length_chunk = 70000,
          name_file =paste0(path,
                            "/CNPV2018_1VIV_A2_05001/CNPV2018_1VIV_A2_05001_%03d.csv"))

save_data(data = Hogares, 
          length_chunk = 100000,
          name_file =paste0(path,
                            "/CNPV2018_2HOG_A2_05001/CNPV2018_2HOG_A2_05001_%03d.csv"))

save_data(data = MGN, 
          length_chunk = 100000,
          name_file =paste0(path,
                            "/CNPV2018_MGN_A2_05001/CNPV2018_MGN_A2_05001_%03d.csv"))
