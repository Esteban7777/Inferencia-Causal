#2022
names(ECV_2022)
table(ECV_2022$hogar)
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
