xtset comuna year

* Modelo 1 con todas las variables
xtreg por_menor_hijos por_D_jefe por_trabajo_jefe por_afiliacion_jefe por_educacion_jefe por_leer_jefe por_raza_jefe por_madre_soltera ingreso i.year, fe
outreg2 using resultados1.doc, append ctitle("EFECTOS FIJOS") word dec(2) bdec(3) se stats(coef ci pval N)

estimates store fe_model

* Modelo de efectos aleatorios
xtreg por_menor_hijos por_D_jefe por_trabajo_jefe por_afiliacion_jefe por_educacion_jefe por_leer_jefe por_raza_jefe por_madre_soltera ingreso i.year, re
outreg2 using resultados1.doc, append ctitle("EFECTOS ALEATORIOS") word dec(2) bdec(3) se stats(coef ci pval N)

estimates store re_model

* Prueba de Hausman
hausman fe_model re_model


*Estimar el modelo por OLS
reg por_menor_hijos por_D_jefe por_trabajo_jefe por_afiliacion_jefe por_educacion_jefe por_leer_jefe por_raza_jefe por_madre_soltera ingreso i.year
outreg2 using resultados1.doc, append ctitle("OLS") word
outreg2 using ModeloOLS.doc, replace ///    
word dec(2) ctitle("Modelo APA") /// 
    bdec(3) se stats(coef ci pval N)