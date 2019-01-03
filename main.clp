
;(defmodule MAIN (import TEMPLATES ?ALL) (import RECOMENDAR ?ALL) (import CASOS_PRUEBA ?ALL) )

(deftemplate inicial)

(defrule main
	(declare (salience -126))
=>
	(load "templates.clp")
	(load "recomendar.clp")
	(load "casosPrueba.clp")
	(reset)
	(assert (inicial))
	
	
)

(defrule onlyOneMain
	(declare(salience 126))
	?in <- (inicial)
=>
	(undefrule main)
	(retract ?in)
)

