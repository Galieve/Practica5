
;(defmodule MAIN (import TEMPLATES ?ALL) (import RECOMENDAR ?ALL) (import CASOS_PRUEBA ?ALL) )

(defrule main

=>
	(load "templates.clp")
	(load "recomendar.clp")
	(load "casosPrueba.clp")
	(reset)
	
)

