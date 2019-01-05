(defglobal ?*espera* = 0)
(defglobal ?*otroPerfil* = "1")
(defglobal ?*otraPeticion* = "Si")
(defglobal ?*edadPerfil* = "")
(defglobal ?*edadPeticion* = -1)
(defglobal ?*idPerfil* = "")
(defglobal ?*idPeticion* = "")
(defglobal ?*sexoPerfil* = "")
(defglobal ?*versionPerfil* = "")
;(defglobal $?appsPerfil = "")
(defglobal ?*gastoTotalPerfil* = "")
(defglobal ?*gastoMaximoPerfil* = "")
(defglobal ?*generoPeticion* = (create$))
(defglobal ?*prioridadPeticion* = descargas)
(defglobal ?*espacioMaxPeticion* = null)
(defglobal ?*valoracionMinPeticion* = -1)
(defglobal ?*aux1* = "")
(defglobal ?*nombreAppPerfil* = "")
(defglobal ?*nombreGeneroPeticion* = 27)
(defglobal ?*menu* = -1)

(defrule leePerfil
	(declare (salience 101))
	;(test (eq ?*otroPerfil* "1"))
	(test (eq ?*espera* 1))
=>
	(printout t "HolaMundo" crlf)
	(bind ?*espera* (readline))
)

(defrule lee_IntroducirPeticion
	(declare (salience 100))
=>
	(printout t "¿Desea introducir una petición? Itroduzca Si en caso afirmativo: ")
	(bind ?*otraPeticion* (read))
	(while (eq ?*otraPeticion* "Si") do 
		(printout t "Escribe tu id" crlf)
		(bind ?*idPeticion* (str-cat "\""(readline) "\""))
		
		(while (neq ?*menu* 0) do
			(printout t "Menu:" crlf )
			(printout t "0: Peticion rellena" crlf)
			(printout t "1: Añadir genero" crlf)
			(printout t "2: Deteriminar la edad del usuario final de la aplicacion" crlf)
			(printout t "3: Determinar prioridad por la que se recomiendan las aplicaciones (descargas valoracion espacio)" crlf)
			(printout t "4: Determinar el espacio maximo que ocuparan las aplicaiones" crlf)
			(printout t "5: Determinar la valoracion minima de las apliaciones que se recomendaran" crlf)
			(printout t "Introduzca la opción que desea: ")
			(bind ?*menu* (read))
			;(
			(if (eq ?*menu* 1) then 
				;(
					(printout t "Inserta el genero: ")
					(bind ?*nombreGeneroPeticion* (read))
					(bind ?*generoPeticion* (insert$ $?*generoPeticion* 1 ?*nombreGeneroPeticion* ))
					;(modify $?*generoPeticion* (insert$ $?*generoPeticion* 1 ?*nombreGeneroPeticion*))
					(printout t ?*generoPeticion* crlf)
					(printout t ?*nombreGeneroPeticion* crlf)
				;)
				else (
					if (eq ?*menu* 2) then
						;(
						(printout t "Escribe la edad: ")
						(bind ?*edadPeticion* (readline))
						;)
					else (
						if (eq ?*menu* 3) then 
							;(
							(printout t "Inserta la prioridad (descargas valoracion espacio): ")
							(bind ?*prioridadPeticion* (readline))
							;)
						else (
							if (eq ?*menu* 4) then
								;(
								(printout t "Escribe el espacio maximo: ")
								(bind ?*espacioMaxPeticion* (readline))
								;)
							else (
									if (eq ?*menu* 5) then
									;(
									(printout t "Escribe la valoracion minima (entero entre 0 y 5): ")
									(bind ?*valoracionMinPeticion* (readline))
									;)
								)
							)
						)
					)
			)			
		)
		(bind ?*menu* -1)
		(assert-string (str-cat "(peticion (id " ?*idPeticion* ") (genero " (implode$ ?*generoPeticion*) ") (edadDestinatario " ?*edadPeticion* 
			") (prioridad " ?*prioridadPeticion* ") (espacioMax " ?*espacioMaxPeticion* ") (valoracionMin " ?*valoracionMinPeticion* "))"
		))
		(printout t (str-cat "(peticion (id " ?*idPeticion* ") (genero " (implode$ ?*generoPeticion*) ") (edadDestinatario " ?*edadPeticion* 
			") (prioridad " ?*prioridadPeticion* ") (espacioMax " ?*espacioMaxPeticion* ") (valoracionMin " ?*valoracionMinPeticion* "))") crlf)
		(assert-string (str-cat "(recomendacion (id " ?*idPeticion* "))"))
		(assert-string (str-cat "(perfil (id " ?*idPeticion* "))"))
		(printout t "¿Desea introducir otra petición? Itroduzca Si en caso afirmativo: ")
		(bind ?*otraPeticion* (read))
		)
	)

