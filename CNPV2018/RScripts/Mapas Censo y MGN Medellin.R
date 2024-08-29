library(tidyverse)
library(sf)
library(readxl)

MGN<-st_read("C:/Users/HP-Laptop/OneDrive - Universidad de Antioquia/Maestría en Economía/Evaluación de impacto/Inferencia-Causal/CNPV2018/Data/SHP_MGN2018_INTGRD_MANZ/MGN_ANM_MANZANA.shp")

Manzanas_Censo <- read_excel("C:/Users/HP-Laptop/OneDrive - Universidad de Antioquia/Maestría en Economía/Evaluación de impacto/Inferencia-Causal/CNPV2018/Data/factMedellinManzanasConsolidado.xlsx")

MGN<-MGN %>% filter(MPIO_CDPMP=="05001" & CLAS_CCDGO=="1")

Manzanas_Censo<-Manzanas_Censo %>% mutate(COD_DANE_A=COD_MANZANA)

MGN_Censo<-MGN %>% left_join(Manzanas_Censo,by="COD_DANE_A")

Estrato<-ggplot() + 
  geom_sf(data = MGN_Censo, aes(fill = EstratoPromedio))+
  scale_fill_gradient(low="darkred", high = "white")+
  labs(
    title="Estrato promedio Medellín")


Precariedad<-ggplot() + 
  geom_sf(data = MGN_Censo, aes(fill = PrecariedadPromedio))+
  scale_fill_gradient(low="white", high = "gray")+
  labs(
    title="Precariedad promedio Medellín")

Precariedad