



(deffunction menu ()
	(printout t "Las opciones permitidas son:" crlf )
	(printout t "1: Especificar el género de la recomendación." crlf)
	(printout t "2: Deteriminar la edad del usuario final de la aplicación." crlf)
	(printout t "3: Determinar prioridad por la que se recomiendan las aplicaciones (descargas valoracion espacio)." crlf)
	(printout t "4: Determinar el espacio máximo que ocuparán las aplicaiones." crlf)
	(printout t "5: Determinar la valoracion mínima de las apliaciones que se recomendarán." crlf)
	(printout t "6: Seleccionar el número máximo de recomendaciones." crlf)
	(printout t "0: Finalizar." crlf)
	(printout t "Introduzca la opción que desea: ")
)

(deffunction peticion ()
	(printout t "Bienvenido al gestor de peticiones." crlf)
	(printout t "Escriba su identificador: ")
	(bind ?idPeticion (str-cat "\""(readline) "\""))
	(printout t crlf)
	(bind ?menu -1)
	(bind ?generoPeticion (create$))
	(bind ?edadPeticion -1)
	(bind ?prioridadPeticion descargas)
	(bind ?espacioPeticion null)
	(bind ?valoracionMinPeticion -1)
	(bind ?cantidadRecom_ 3)
	(while (neq ?menu 0) do
		(menu)
		(bind ?menu (read))
		(if (eq ?menu 1) then 
			(printout t "Escriba el género: ")
			(bind ?nombreGeneroPeticion (read))
			(bind ?generoPeticion (insert$ $?generoPeticion 1 ?nombreGeneroPeticion ))
		else (if (eq ?menu 2) then
				(printout t "Escribe la edad: ")
				(bind ?edadPeticion (readline))
			else (if (eq ?menu 3) then 
					(printout t "Inserta la prioridad (descargas valoracion espacio): ")
					(bind ?prioridadPeticion (readline))
				else (if (eq ?menu 4) then
						(printout t "Escribe el tipo de aplicación que busca (ligera medio pesada): ")
						(bind ?espacioPeticion (readline))
					else (if (eq ?menu 5) then
							(printout t "Escribe la valoracion minima (entre 0 y 5): ")
							(bind ?valoracionMinPeticion (float (string-to-field (readline))))
							(bind ?valoracionMinPeticion (min ?valoracionMinPeticion 5))
							(bind ?valoracionMinPeticion (max ?valoracionMinPeticion 0))
						else (if (eq ?menu 6) then
								(printout t "Escribe el número de aplicaciones a recomendar: ")
								(bind ?cantidadRecom_ (readline))
							)
						)
					)
				)
			)
		)
		(printout t crlf "Instrucción tramitada, gracias por su tiempo." crlf)
		(if (member$ ?menu (create$ 1 2 3 4 5)) then (printout t "Continue con su petición por favor." crlf crlf))		
	)
	(bind ?menu -1)
	(assert-string (str-cat 
		"(peticion (id " ?idPeticion ") (genero " (implode$ ?generoPeticion) ") (edadDestinatario " ?edadPeticion 
		") (prioridad " ?prioridadPeticion ") (espacio " ?espacioPeticion ") (valoracionMin " 
		?valoracionMinPeticion ") (cantidadRecom " ?cantidadRecom_"))"
	))
)