variables<-c(
  "comuna",
  "year",
  "ingreso",
  "jefe",
  "e_civil",
  "raza",
  "sexo",
  "educacion",
  "leer",
  "hijos",
  "afiliacion",
  "trabajo",
  "planifica",
  "D",
  "edad",
  "menor",
  "idVivienda",
  "idHogar",
  "idPersona",
  "hogares"
)

#2022
names(ECV_2022)
table(ECV_2022$hogar)

data2022<- ECV_2022 %>% 
  mutate(
    comuna = as.numeric(p_006),
    year = 2022,
    ingreso = as.numeric(p_254)/12,
    jefe = ifelse(p_017=="1",1,0),
    e_civil = ifelse(p_020=="1",1,0),
    raza =  case_when(p_023=="-98" ~0,
                      p_023=="-99" ~0,
                      p_023=="3" ~0,
                      p_023=="4" ~0,
                      .default = 1),
    sexo = ifelse(p_015=="2",1,0),
    educacion = ifelse(as.numeric(p_045)>6,1,0),
    leer = ifelse(p_035=="1",1,0),
    hijos = ifelse(as.numeric(p_058)>0,1,0),
    afiliacion = case_when(p_066=="6"~1,
                           p_066=="7"~1,
                           .default = 0),
    trabajo = ifelse(p_076=="1",1,0),
    planifica = ifelse(p_308=="1",1,0),
    D = ifelse(p_307=="1",1,0),
    edad = as.numeric(p_018),
    menor = ifelse(edad<18,1,0),
    idVivienda = as.numeric(Form),
    idHogar = as.numeric(paste0(idVivienda,hogar)),
    idPersona = as.numeric(idHogar,persona),
    hogares =as.numeric(FEH)
    )

data2022<-data2022 %>% select(variables)

writexl::write_xlsx(data2022,"C:/Users/HP-Laptop/OneDrive - Universidad de Antioquia/Maestría en Economía/Evaluación de impacto/Inferencia-Causal/Inferencia_causal/Panel de datos/2022.xlsx")


#2021
names(ECV_2021)
table(ECV_2021$P_016)

data2021<- ECV_2021 %>% 
  mutate(
    comuna = as.numeric(P_006),
    year = 2021,
    ingreso = as.numeric(P_269),
    jefe = ifelse(P_016=="1",1,0),
    e_civil = ifelse(P_022=="1",1,0),
    raza =  case_when(P_023=="-98" ~0,
                      P_023=="-99" ~0,
                      P_023=="3" ~0,
                      P_023=="4" ~0,
                      .default = 1),
    sexo = ifelse(P_018=="2",1,0),
    educacion = ifelse(as.numeric(P_049)>6,1,0),
    leer = ifelse(P_039=="1",1,0),
    hijos = ifelse(as.numeric(P_064)>0,1,0),
    afiliacion = case_when(P_074=="6"~1,
                           P_074=="7"~1,
                           .default = 0),
    trabajo = ifelse(P_077=="1",1,0),
    planifica = ifelse(P_073_c=="1",1,0),
    D = ifelse(P_073_b=="1",1,0),
    edad = as.numeric(P_021),
    menor = ifelse(edad<18,1,0),
    idVivienda = as.numeric(NoForm),
    idHogar = as.numeric(paste0(idVivienda,sHogar)),
    idPersona = seq(1,length(NoForm)),
    hogares =as.numeric(FEH)
  )

data2021<-data2021 %>% select(variables)

summary(data2021)

writexl::write_xlsx(data2021,"C:/Users/HP-Laptop/OneDrive - Universidad de Antioquia/Maestría en Economía/Evaluación de impacto/Inferencia-Causal/Inferencia_causal/Panel de datos/2021.xlsx")


#2019
names(ECV_2019)
table(ECV_2019$P_6)

data2019<- ECV_2019 %>% 
  mutate(
    comuna = as.numeric(P_6),
    year = 2019,
    ingreso = as.numeric(P_244),
    jefe = ifelse(P_17=="1",1,0),
    e_civil = ifelse(P_20=="1",1,0),
    raza =  case_when(P_23=="-98" ~0,
                      P_23=="-99" ~0,
                      P_23=="3" ~0,
                      P_23=="4" ~0,
                      .default = 1),
    sexo = ifelse(P_15=="2",1,0),
    educacion = ifelse(as.numeric(P_45)>6,1,0),
    leer = ifelse(P_35=="1",1,0),
    hijos = ifelse(as.numeric(P_58)>0,1,0),
    afiliacion = case_when(P_66=="6"~1,
                           P_66=="7"~1,
                           .default = 0),
    trabajo = ifelse(P_69=="1",1,0),
    planifica = ifelse(P_308=="1",1,0),
    D = ifelse(P_307=="1",1,0),
    edad = as.numeric(P_18),
    menor = ifelse(edad<18,1,0),
    idVivienda = as.numeric(Form),
    idHogar = as.numeric(paste0(idVivienda,Hogar)),
    idPersona = as.numeric(paste0(idVivienda,Orden)),
    hogares =as.numeric(FEVH)
  )

data2019<-data2019 %>% select(variables)

summary(data2019)

writexl::write_xlsx(data2019,"C:/Users/HP-Laptop/OneDrive - Universidad de Antioquia/Maestría en Economía/Evaluación de impacto/Inferencia-Causal/Inferencia_causal/Panel de datos/2019.xlsx")


#2018
names(ECV_2018)
table(ECV_2018$P_6)

data2018<- ECV_2018 %>% 
  mutate(
    comuna = as.numeric(P_6),
    year = 2018,
    ingreso = as.numeric(P_244),
    jefe = ifelse(P_17=="1",1,0),
    e_civil = ifelse(P_20=="1",1,0),
    raza =  case_when(P_23=="-98" ~0,
                      P_23=="-99" ~0,
                      P_23=="3" ~0,
                      P_23=="4" ~0,
                      .default = 1),
    sexo = ifelse(P_15=="2",1,0),
    educacion = ifelse(as.numeric(P_45)>6,1,0),
    leer = ifelse(P_35=="1",1,0),
    hijos = ifelse(as.numeric(P_58)>0,1,0),
    afiliacion = case_when(P_66=="6"~1,
                           P_66=="7"~1,
                           .default = 0),
    trabajo = ifelse(P_69=="1",1,0),
    planifica = ifelse(P_308=="1",1,0),
    D = ifelse(P_307=="1",1,0),
    edad = as.numeric(P_18),
    menor = ifelse(edad<18,1,0),
    idVivienda = as.numeric(Form),
    idHogar = as.numeric(paste0(idVivienda,Hogar)),
    idPersona = as.numeric(paste0(idVivienda,Orden)),
    hogares =as.numeric(FEVH)
  )

data2018<-data2018 %>% select(variables)

summary(data2018)

writexl::write_xlsx(data2018,"C:/Users/HP-Laptop/OneDrive - Universidad de Antioquia/Maestría en Economía/Evaluación de impacto/Inferencia-Causal/Inferencia_causal/Panel de datos/2018.xlsx")


#2017
names(ECV_2017)
table(ECV_2017$P_6)

data2017<- ECV_2017 %>% 
  mutate(
    comuna = as.numeric(P_6),
    year = 2017,
    ingreso = as.numeric(P_244),
    jefe = ifelse(P_17=="1",1,0),
    e_civil = ifelse(P_20=="1",1,0),
    raza =  case_when(P_23=="-98" ~0,
                      P_23=="-99" ~0,
                      P_23=="3" ~0,
                      P_23=="4" ~0,
                      .default = 1),
    sexo = ifelse(P_15=="2",1,0),
    educacion = ifelse(as.numeric(P_45)>6,1,0),
    leer = ifelse(P_35=="1",1,0),
    hijos = ifelse(as.numeric(P_58)>0,1,0),
    afiliacion = case_when(P_66=="6"~1,
                           P_66=="7"~1,
                           .default = 0),
    trabajo = ifelse(P_69=="1",1,0),
    planifica = ifelse(P_308=="1",1,0),
    D = ifelse(P_307=="1",1,0),
    edad = as.numeric(P_18),
    menor = ifelse(edad<18,1,0),
    idVivienda = as.numeric(formulario),
    idHogar = as.numeric(paste0(idVivienda,Hogar)),
    idPersona = as.numeric(paste0(idVivienda,Orden)),
    hogares =as.numeric(FEVH)
  )

data2017<-data2017 %>% select(variables)

summary(data2017)

writexl::write_xlsx(data2017,"C:/Users/HP-Laptop/OneDrive - Universidad de Antioquia/Maestría en Economía/Evaluación de impacto/Inferencia-Causal/Inferencia_causal/Panel de datos/2017.xlsx")



