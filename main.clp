(deftemplate inicial)

(defrule main
	(declare (salience -127))
=>
	(load "templates.clp")
	(load "funciones.clp")
	(load "reglas de recomendación.clp")
	(load "reglas de recomendación de géneros.clp")
	(load "misc.clp")
	(load "entrada_salida.clp")
	(load " de .clp")
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

