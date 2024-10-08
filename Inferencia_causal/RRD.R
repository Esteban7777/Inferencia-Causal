
#Cargar los datos y paquetes
setwd("C:/Users/HP-Laptop/OneDrive - Universidad de Antioquia/Maestría en Economía/Evaluación de impacto/Inferencia-Causal")
load("Inferencia_causal/estratos_2y3_rdd.RData")
library(rdrobust)
library(rdd)


#Exploración de los datos

#Tratamiento
table(estratos_2y3_rdd$treat)

#Variable de asignación
hist(estratos_2y3_rdd$score)

#Dependientes
hist(estratos_2y3_rdd$viv_informal)

hist(estratos_2y3_rdd$pop_dens)

hist(estratos_2y3_rdd$hous_dens)

hist(estratos_2y3_rdd$comercial)

hist(estratos_2y3_rdd$accs_c)

hist(estratos_2y3_rdd$migran_5)

#Exploración visual de la discontinuidad de las variables
plot(estratos_2y3_rdd$score,estratos_2y3_rdd$viv_informal)
plot(estratos_2y3_rdd$score,estratos_2y3_rdd$pop_dens)
plot(estratos_2y3_rdd$score,estratos_2y3_rdd$hous_dens)
plot(estratos_2y3_rdd$score,estratos_2y3_rdd$comercial)
plot(estratos_2y3_rdd$score,estratos_2y3_rdd$accs_c)
plot(estratos_2y3_rdd$score,estratos_2y3_rdd$migran_5)

#Test de McCrary
DCdensity(runvar = estratos_2y3_rdd$score,cutpoint = 0)


