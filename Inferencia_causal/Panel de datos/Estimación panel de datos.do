***************************************************************************
***	    Ejercicio panel de datos: efecto de la educación sexual en la  ***
***	   		 la fecundidad en las comunas de Medellín                   ***
***		Autores: Wilmer Rojas, John Esteban Londoño & William Aguirre 	***
***************************************************************************

clear all
cd "C:\Users\zulet\OneDrive\Escritorio\Maestría Economía\III Semestre\Inferencia causal\GitHub\Inferencia-Causal\Inferencia-Causal\Inferencia_causal\Panel de datos"

use panel_comunas.dta, clear  



* PARTE A: Graficos de dispersión y tendenca lineal.

twoway (scatter por_planifica_jefe por_menor_hijos) (lfit por_planifica_jefe por_menor_hijos), ///
    title("% de hogares con menores con hijos vs % de jefes que planifican") ///
    xlabel(, grid) ylabel(, grid)
	
	
twoway (scatter  por_D_jefe por_planifica_jefe) (lfit  por_D_jefe por_planifica_jefe), ///
    title("Planificación jefe hogar vs información anticonceptivo") ///
    xlabel(, grid) ylabel(, grid)
	
	
twoway (scatter  por_D_jefe por_menor_hijos) (lfit  por_D_jefe por_menor_hijos), ///
    title(" hogares con padres menores de edad vs información planificación") ///
    xlabel(, grid) ylabel(, grid)

	
*SE EVIDENCIA UNA RELACIÓN NEGATIVA ENTRE EL % DE HOGARES CON MENORES DE EDAD CON HIJOS Y EL PORCENTAJE DE HOGARES EN LOS QUE EL JEFE DE HOGAR CUENTA CON INFORMACIÓN DE PLANIFICACIÓN

* PARTE B: Estimación del modelo

*Configuración del panel de datos
gen cod_comuna = .
replace cod_comuna = 1 if comuna == "Popular"
replace cod_comuna = 2 if comuna == "Santa Cruz"
replace cod_comuna = 3 if comuna == "Manrique"
replace cod_comuna = 4 if comuna == "Aranjuez"
replace cod_comuna = 5 if comuna == "Castilla"
replace cod_comuna = 6 if comuna == "Doce de Octubre"
replace cod_comuna = 7 if comuna == "Robledo"
replace cod_comuna = 8 if comuna == "Villa Hermosa"
replace cod_comuna = 9 if comuna == "Buenos Aires"
replace cod_comuna = 10 if comuna == "La Candelaria"
replace cod_comuna = 11 if comuna == "Laureles Estadio"
replace cod_comuna = 12 if comuna == "La América"
replace cod_comuna = 13 if comuna == "San Javier"
replace cod_comuna = 14 if comuna == "El Poblado"
replace cod_comuna = 15 if comuna == "Guayabal"
replace cod_comuna = 16 if comuna == "Belén"
replace cod_comuna = 50 if comuna == "Palmitas"
replace cod_comuna = 60 if comuna == "San Cristobal"
replace cod_comuna = 70 if comuna == "Altavista"
replace cod_comuna = 80 if comuna == "San Antonio de Prado"
replace cod_comuna = 90 if comuna == "Santa Elena"

xtset comuna year

*Estimación de modelos

*Modelo 1 con todas las variables
xtreg por_menor_hijos por_D_jefe por_trabajo_jefe por_afiliacion_jefe por_educacion_jefe por_leer_jefe por_raza_jefe por_madre_soltera ingreso i.year, fe

outreg2 using resultados.doc, append ctitle("EFECTOS FIJOS") word    
word dec(2) ctitle("Modelo APA") /// 
    bdec(3) se stats(coef ci pval N)

estimates store fe
* efecto aleatorio
xtreg por_menor_hijos por_D_jefe por_trabajo_jefe por_afiliacion_jefe por_educacion_jefe por_leer_jefe por_raza_jefe por_madre_soltera ingreso i.year, re

outreg2 using resultados.doc, append ctitle("EFECTOS ALEATORIOS") word 
word dec(2) ctitle("Modelo APA") /// 
    bdec(3) se stats(coef ci pval N)

estimates store fe

hausman fe re


*Modelo 2 retirando los hijos promedio del hogar
xtreg por_menor_hijos por_D_jefe por_planifica_jefe por_trabajo_jefe por_afiliacion_jefe por_educacion_jefe por_leer_jefe por_raza_jefe por_madre_soltera ingreso i.year, fe

*Modelo 3 Retirando leer_jefe
xtreg por_menor_hijos por_D_jefe por_planifica_jefe por_trabajo_jefe por_afiliacion_jefe por_educacion_jefe por_raza_jefe por_madre_soltera ingreso i.year, fe

*Modelo 4 Retirando educación_jefe
xtreg por_menor_hijos por_D_jefe por_planifica_jefe por_trabajo_jefe por_afiliacion_jefe por_raza_jefe por_madre_soltera ingreso i.year, fe


*Modelo 5 retirando planifica_jefe
xtreg por_menor_hijos por_D_jefe por_trabajo_jefe por_afiliacion_jefe por_raza_jefe por_madre_soltera ingreso i.year, fe


*Modelo 6 retirando ingreso
xtreg por_menor_hijos por_D_jefe por_trabajo_jefe por_afiliacion_jefe por_raza_jefe por_madre_soltera i.year, fe
outreg2 using resultados.doc, append ctitle("EFECTOS FIJOS") word
outreg2 using Modeloefectosfijos.doc, replace ///    
word dec(2) ctitle("Modelo APA") /// 
    bdec(3) se stats(coef ci pval N)

estimates store fe

*Se calcula los residuales para el modelo de efectos fijos
predict res_fe, resid 

xtreg por_menor_hijos por_D_jefe por_trabajo_jefe por_afiliacion_jefe por_raza_jefe por_madre_sotera i.year, re
outreg2 using resultados.doc, append ctitle("EFECTOS ALEATORIOS") word
outreg2 using Modeloefectosaleatorios.doc, replace ///    
word dec(2) ctitle("Modelo APA") /// 
    bdec(3) se stats(coef ci pval N)
estimates store re


*Se calcula los residuales para el modelo de efectos aleatorios
predict res_re,  ue 

* PARTE C: REALIZAR TEST DE HAUSMAN Y COMPARAR RESIDUALES
hausman fe re

*SE RECHAZA LA HIPOTESIS NULA, EL MODELO ADECUADO ES DE EFECTOS FIJOS

* PARTE D: COMPARAR LOS RESIDUALES
*Se grafican los residuales de ambos modelos
twoway (scatter res_fe cod_comuna, msymbol(o) mcolor(blue)) ///
       (scatter res_re cod_comuna, msymbol(x) mcolor(red)), ///
       legend(order(1 "FE Residuals" 2 "RE Residuals")) ///
       title("Comparación de Residuales") ///
       ylabel(, grid) xlabel(, grid)

* PARTE E COMPARAR CONTRA OLS
   
*Estimar el modelo por OLS
reg por_menor_hijos por_D_jefe por_trabajo_jefe por_afiliacion_jefe por_raza_jefe por_madre_sotera
outreg2 using resultados.doc, append ctitle("OLS") word
outreg2 using ModeloOLS.doc, replace ///    
word dec(2) ctitle("Modelo APA") /// 
    bdec(3) se stats(coef ci pval N)