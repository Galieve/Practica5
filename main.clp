
;(defmodule MAIN (import TEMPLATES ?ALL) (import RECOMENDAR ?ALL) (import CASOS_PRUEBA ?ALL) )

(deftemplate inicial)

(defrule main
	(declare (salience -127))
=>
	(load "templates.clp")
	(load "funciones.clp")
	(load "recomendar.clp")
	(load "recomendar_2.clp")
	;(load "entrada_salida.clp")
	(load "casosPrueba.clp")
	(reset)
	(assert (inicial))	
)

(defrule onlyOneMain
	(declare(salience 127))
	?in <- (inicial)
=>
	(undefrule main)
	(retract ?in)
)

