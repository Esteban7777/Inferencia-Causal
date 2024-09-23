###### PROCESAMIENTO CNPV 2018
t1<-Sys.time()
#Cargar las datas
library(readr)
library(tidyverse)

download_data<- function(data_download,n_chunk){
  
  data<-list() 
  
  chunks <- sprintf("%03d", 1:n_chunk)
  
  for (i in chunks){
    #Poner la ruta base del repositorio 
    path<-paste0("https://raw.githubusercontent.com/Esteban7777/Inferencia-Causal/refs/heads/main/CNPV2018/Data/",
                 data_download,"/",data_download,"_",i,".csv")
    
    #Descargar los chunk y añadirles la medición  
    data[[i]]<-read_csv(path,col_types = cols(.default = col_character()))
  }
  #Unir los chunks
  data<-bind_rows(data)
  #Nombrar el dataframe de acuerdo a la medición
  assign(paste0(data_download),data,envir = .GlobalEnv)
}

#Personas
download_data(data_download ="CNPV2018_5PER_A2_05001" ,n_chunk = 34)

#Viviendas
download_data(data_download ="CNPV2018_1VIV_A2_05001" ,n_chunk = 13)

#Hogares
download_data(data_download ="CNPV2018_2HOG_A2_05001" ,n_chunk = 9)

#MGN
download_data(data_download ="CNPV2018_MGN_A2_05001" ,n_chunk = 9)


#Crear las llaves que permiten cruzar las bases

#Personas
CNPV2018_5PER_A2_05001<- CNPV2018_5PER_A2_05001 %>% 
  mutate(
    skVivienda=paste0(COD_ENCUESTAS,U_DPTO,U_MPIO,UA_CLASE,U_EDIFICA,U_VIVIENDA),
    skPersona=paste0(COD_ENCUESTAS,U_DPTO,U_MPIO,UA_CLASE,U_EDIFICA,U_VIVIENDA,P_NRO_PER)
  )

#Viviendas
CNPV2018_1VIV_A2_05001<-CNPV2018_1VIV_A2_05001 %>% 
  mutate(
    skVivienda=paste0(COD_ENCUESTAS,U_DPTO,U_MPIO,UA_CLASE,U_EDIFICA,U_VIVIENDA),
    skViviendaHogar=paste0(COD_ENCUESTAS,U_DPTO,U_MPIO,UA_CLASE,U_VIVIENDA)
  )

#Hogares
CNPV2018_2HOG_A2_05001<-CNPV2018_2HOG_A2_05001 %>% 
  mutate(
    skViviendaHogar=paste0(COD_ENCUESTAS,U_DPTO,U_MPIO,UA_CLASE,U_VIVIENDA),
    skHogar=paste0(COD_ENCUESTAS,U_DPTO,U_MPIO,UA_CLASE,U_VIVIENDA,H_NROHOG)
  )

#MGN
CNPV2018_MGN_A2_05001<-CNPV2018_MGN_A2_05001 %>% 
  mutate(
    COD_MANZANA=paste0(
      U_DPTO,U_MPIO,UA_CLASE,U_SECT_RUR,U_SECC_RUR,UA2_CPOB,U_SECT_URB,U_SECC_URB,U_MZA),
    skVivienda=paste0(COD_ENCUESTAS,U_DPTO,U_MPIO,UA_CLASE,U_EDIFICA,U_VIVIENDA)
    )


#Construcción de variables de la vivienda
COD_MANZANA<-CNPV2018_MGN_A2_05001 %>% select(COD_MANZANA,skVivienda)
CNPV2018_1VIV_A2_05001<-CNPV2018_1VIV_A2_05001 %>% 
  mutate(
    V_MAT_PARED=as.numeric(V_MAT_PARED),
    V_MAT_PISO=as.numeric(V_MAT_PISO),
    VB_ACU=as.numeric(VB_ACU),
    VC_ALC=as.numeric(VC_ALC),
    VA1_ESTRATO=as.numeric(VA1_ESTRATO),
    flagParedesPrecarias= case_when(V_MAT_PARED>3 ~ 1, .default = 0),
    flagPisosPrecarios= case_when(V_MAT_PISO>3 ~ 1, .default = 0),
    flagFaltaAcueducto= case_when(VB_ACU==2 ~ 1, .default = 0),
    flagFaltaAlcantarillado= case_when(VC_ALC==2 ~ 1, .default = 0),
    estratoNumerico=case_when(is.na(VA1_ESTRATO)~0,
                              VA1_ESTRATO==9 ~0, .default=VA1_ESTRATO)
  ) %>% 
  left_join(COD_MANZANA,by = "skVivienda")


#Construcción de variables de las personas
DimNivelEducativo<-read.csv2("https://raw.githubusercontent.com/Esteban7777/Inferencia-Causal/refs/heads/main/CNPV2018/Data/DimNivelEducativo.csv")


CNPV2018_5PER_A2_05001<-CNPV2018_5PER_A2_05001 %>% 
  mutate(
    PA_LUG_NAC=as.numeric(PA_LUG_NAC), 
    P_EDADR=as.numeric(P_EDADR),
    P_TRABAJO=as.numeric(P_TRABAJO),
    flagMigranteInternacional=case_when(PA_LUG_NAC == 3 ~ 1, .default = 0),
    flagMigranteIntermunicipal=case_when(PA_LUG_NAC == 2 ~ 1, .default = 0),
    flagPET=case_when(P_EDADR > 3 ~ 1, .default = 0),
    flagOcupado=case_when(
      P_TRABAJO == 1 ~ 1,
      P_TRABAJO == 2 ~ 1,
      P_TRABAJO == 3 ~ 1, .default = 0),
    flagDesempleado= case_when(P_EDADR > 3 & P_TRABAJO== 4 ~1,
                               .default = 0),
    flagInactivo=case_when(P_EDADR > 3 & P_TRABAJO> 4 ~1,
                           P_EDADR > 3 & P_TRABAJO== 0 ~1,.default = 0),
    skNivelEducativo=as.numeric(P_NIVEL_ANOSR)
    ) %>%
  left_join(DimNivelEducativo,by = "skNivelEducativo") %>% 
  left_join(COD_MANZANA,by = "skVivienda")

#Construcción de las variables del hogar
ViviendaHogar<-CNPV2018_1VIV_A2_05001 %>% 
  select(skViviendaHogar,
         flagParedesPrecarias,
         flagPisosPrecarios,
         flagFaltaAcueducto,
         flagFaltaAlcantarillado,
         estratoNumerico,
         COD_MANZANA)

CNPV2018_2HOG_A2_05001<-CNPV2018_2HOG_A2_05001 %>% 
  left_join(ViviendaHogar, by="skViviendaHogar") %>% 
  mutate(
    H_NRO_DORMIT=as.numeric(H_NRO_DORMIT),
    HA_TOT_PER=as.numeric(HA_TOT_PER),
    personasHabitacion=case_when(H_NRO_DORMIT==99 ~ NA,
                                 is.na(HA_TOT_PER)~NA,
                                 .default = H_NRO_DORMIT/HA_TOT_PER),
    flagHacinamiento= case_when(personasHabitacion>3 ~1, .default = 0),
    precariedadVivienda=flagParedesPrecarias + 
      flagPisosPrecarios + 
      flagFaltaAcueducto +
      flagFaltaAlcantarillado +
      flagHacinamiento
      )
  
table(is.na(CNPV2018_2HOG_A2_05001$HA_TOT_PER))
#Agregación a nivel de manzana
#En variables de personas
variablesPersonas<-CNPV2018_5PER_A2_05001 %>%
  group_by(COD_MANZANA) %>% 
  summarise(
    POBLACION=n_distinct(skPersona),
    PET=sum(flagPET),
    Inactivo=sum(flagInactivo),
    Desempleados=sum(flagDesempleado),
    Ocupados=sum(flagOcupado),
    MigrantesInternacionales=sum(flagMigranteInternacional),
    MigrantesIntermunicipales=sum(flagMigranteIntermunicipal),
    EducacionPromedio=mean(Años_acumulados,na.rm = TRUE)
  ) %>% 
  mutate(
    PEA=Desempleados+Ocupados,
    TasaDesempleo=case_when(PEA==0 ~0, .default = Desempleados/PEA),
    PorcentajeMigrantesInternacionales=MigrantesInternacionales/POBLACION,
    PorcentajeMigrantesIntermunicipales=MigrantesIntermunicipales/POBLACION
  )

#En variables de viviendas
variablesViviendas<-CNPV2018_1VIV_A2_05001 %>% 
  group_by(COD_MANZANA) %>% 
  summarise(
    CantidadViviendas=n_distinct(skVivienda),
    ParedesPrecarias=sum(flagParedesPrecarias),
    PisosPrecarios=sum(flagPisosPrecarios),
    PrecariedadAcueducto=sum(flagFaltaAcueducto),
    PrecariedadAlcantarillado=sum(flagFaltaAlcantarillado),
    EstratoPromedio=mean(estratoNumerico,na.rm = TRUE)
  ) %>% 
  mutate(
    PorcentajeParedesPrecarias=ParedesPrecarias/CantidadViviendas,
    PorcentajePisosPrecarios=PisosPrecarios/CantidadViviendas,
    PorcentajePrecariedadAcueducto=PrecariedadAcueducto/CantidadViviendas,
    PorcentajePrecariedadAlcantarillado=PrecariedadAlcantarillado/CantidadViviendas 
  )

#En variables de hogar
variablesHogares<-CNPV2018_2HOG_A2_05001 %>% 
group_by(COD_MANZANA) %>% 
  summarise(
  CantidadHogares=n_distinct(skHogar),  
  PersonasHabitacion=mean(personasHabitacion,na.rm = TRUE),
  HogaresHacinados=sum(flagHacinamiento),
  PrecariedadPromedio=mean(precariedadVivienda,na.rm = TRUE)
  ) %>% 
  mutate( HogaresHacinados=HogaresHacinados/CantidadHogares  )

#Unir variables
ManzanasConsolidado<-variablesPersonas %>% 
  left_join(variablesHogares,by = "COD_MANZANA") %>% 
  left_join(variablesViviendas, by = "COD_MANZANA")


#Cargar data de vivienda VIS
vis_iv<-read_csv("https://raw.githubusercontent.com/Esteban7777/Inferencia-Causal/refs/heads/main/CNPV2018/Data/vis_iv.csv", col_types = cols(COD_DANE = col_character()))

vis_iv<-vis_iv %>% 
  mutate(COD_MANZANA=COD_DANE) %>% 
  left_join(ManzanasConsolidado, by = "COD_MANZANA")

t2<-Sys.time()

tiempo_procesamiento<-t2-t1
tiempo_procesamiento