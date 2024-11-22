***************************************************************************
***		 Ejercicio panel de datos: efecto de la educación sexual en la  ***
***	   		 la fecundidad en las comunas de Medellín                   ***
***		Autores: Wilmer Rojas, John Esteban Londoño & William Aguirre 	***
***************************************************************************

clear all

cd "C:\Users\HP-Laptop\OneDrive - Universidad de Antioquia\Maestría en Economía\Evaluación de impacto\Inferencia-Causal\Inferencia_causal\Panel de datos\"
*Datos ECV 2012
import excel "2012.xlsx", sheet("Vivienda_Hogar_Personas_ECV2012") firstrow

*Se crea la variable de año
gen year = 2012

*Se guarda en formato .dta
save ECV2012.dta 

clear all

*Datos ECV 2013
import excel "2013.xlsx", sheet("Vivienda_Hogare_PersonaECV2013") firstrow

*Se crea la variable de año
gen year = 2013

*Se guarda en formato .dta
save ECV2013.dta 

*Se realiza la unión de las dos encuestas 

clear all

use ECV2013.dta, clear  
append using ECV2012, force

*Se validan los registros

tab year
 
*Se recodifican las variables 

*Ingreso ///

tab ingreso

replace ingreso = "." if ingreso == "90" | ingreso == "98" | ingreso == "99" | ingreso == "999" | ///
    ingreso == "9999" | ingreso == "99999999" | ingreso == "No aplica" | ///
    ingreso == "No recibió" | ingreso == "No responde" | ingreso == "No sabe si recibió" | ///
    ingreso == "Si recibió pero no sabe sobre el monto"

tab ingreso

*Jefe de hogar ///	

tab jefe

replace jefe="1" if jefe =="Jefe(a) del hogar"
replace jefe="0" if jefe !="1"	

tab jefe

* Estado civil ///

tab e_civil

replace e_civil="1" if e_civil=="Soltero(a)"
replace e_civil="0" if e_civil!="1"

tab e_civil

*Raza ///

tab raza 

replace raza = "0" if raza == "Blanco" | raza == "Mestizo"  
replace raza = "." if raza == "No sabe" | raza == "No responde"  
replace raza = "1" if raza != "0" & raza != "."  

tab raza

*Sexo ///

tab sexo

replace sexo="1" if sexo=="Mujer"
replace sexo="0" if sexo=="Hombre"

tab sexo

*Educacion ///

tab educacion

replace educacion="1" if educacion=="Doctorado (5 años)" | ///
		educacion=="Especialización (2 año)" | ///
		educacion=="Especialización (2 años)" | ///
		educacion=="Maestría (3 años)" | ///
		educacion=="Universidad (7 años)" 
		
replace educacion="0" if educacion!="1"  		

tab educacion

* Leer ///

tab leer 

replace leer="1" if leer=="Si"
replace leer="0" if leer=="No"

tab leer

*Hijos ///

tab hijos

replace hijos="." if hijos=="No aplica"

tab hijos

* Afiliación ///

tab afiliacion

replace afiliacion="1" if afiliacion=="No está afiliado y no está encuestado el SISBEN" | ///
                          afiliacion=="No está afiliado y no está encuestado en el SISBEN" | ///
						  afiliacion=="No está afiliado y está encuestado en el SISBEN"
replace afiliacion="0" if afiliacion!="1"

tab afiliacion

*Trabajo ///

tab trabajo

replace trabajo="1" if trabajo=="Trabajando"
replace trabajo="0" if trabajo!="1"

tab trabajo

* D ///

tab D

replace D="." if D=="-98" | D=="No resp." | D=="No responde" | D=="No sabe"
replace D="1" if D=="Sí" | D=="Si"
replace D="0" if D!="1" & D != "."

tab D

* Planifica ///

tab planifica

replace planifica="1" if planifica=="Sí" | planifica =="Si"
replace planifica="0" if planifica=="No"
replace planifica="." if planifica=="No resp." | ///
        planifica =="No sabe" | ///
		planifica=="No responde"


tab planifica

* Transformar variables
destring ingreso jefe e_civil raza educacion ///
 hijos afiliacion trabajo D planifica ///
 leer sexo, replace 
 
des

* Comuna ///
tab comuna

replace comuna="Robledo" if comuna=="Ciudadela de Occidente"
replace comuna="Belén" if comuna=="Belen"
replace comuna="Doce de Octubre" if comuna=="Doce De Octubre"
replace comuna="La América" if comuna=="La America"
replace comuna = "Laureles Estadio" if comuna == "Laureles-Estadio" | comuna == "Laureles Estado"

tab comuna

*Agregar las varibles

collapse (mean) edad ingreso hijos (sum) sexo jefe e_civil raza leer educacion afiliacion trabajo D planifica FE_P[w=FE_P], by(year comuna)

rename FE_P poblacion

