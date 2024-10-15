#Cargar los datos y paquetes
load("estratos_2y3_rdd.RData")




#Tratamiento
table(estratos_2y3_rdd$treat)

#Test de Mccrary
library(rddensity)
mccrary_test <- rddensity(estratos_2y3_rdd$score)
summary(mccrary_test)
#P valor >0.005 no se rechaza la hipotesis de continuidad por lo que se cumple el supuesto no sorting

#Se identifica si el diseño es nítido o difuso 
ggplot(estratos_2y3_rdd, aes(x = score, y =treat )) +
  geom_point(alpha = 0.3) + 
  labs(title = "Probabilidad de ser estrato 1 dado el Score",
       x = "Score", y = "Probabilidad de ser tratado") +
  theme_minimal()
#Se identifica un diseño nítido

#
