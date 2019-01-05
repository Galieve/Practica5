(defglobal ?*espera* = 0)
(defglobal ?*otroPerfil* = "1")
(defglobal ?*otraPeticion* = "1")
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
	(declare (salience 1001))
	;(test (eq ?*otroPerfil* "1"))
	(test (eq ?*espera* 1))
=>
	(printout t "HolaMundo" crlf)
	(bind ?*espera* (readline))
)

(defrule lee_IntroducirPeticion
	(declare (salience 1000))
=>
	(printout t "¿Quieres introducir una peticion en la base de datos (1= Si / En otro caso = No)?" crlf)
	(while (eq ?*otraPeticion* "1") do 
		;(
		(printout t "Escribe tu id" crlf)
		(bind ?idPeticion (readline))
		(printout t "Menu:" crlf )
		(printout t "0: Peticion rellena" crlf)
		(printout t "1: Añadir genero" crlf)
		(printout t "2: Deteriminar la edad del usuario final de la aplicacion" crlf)
		(printout t "3: Determinar prioridad por la que se recomiendan las aplicaciones (descargas valoracion espacio)" crlf)
		(printout t "4: Determinar el espacio maximo que ocuparan las aplicaiones" crlf)
		(printout t "5: Determinar la valoracion minima de las apliaciones que se recomendaran" crlf)
		(bind ?menu (read))
		(while (neq ?menu 0) do 
			;(
			(if (eq ?menu 1) then 
				;(
					(printout t "Inserta el genero" crlf)
					(bind ?nombreGeneroPeticion (read))
					(insert$ $?*generoPeticion* 1 ?*nombreGeneroPeticion* )
					;(modify $?generoPeticion (insert$ $?generoPeticion 1 ?nombreGeneroPeticion))
				;)
				else (
					if (eq ?menu 2) then
						;(
						(printout t "Escribe la edad" crlf)
						(bind ?edadPeticion (read))
						;)
					else (
						if (eq ?menu 3) then 
							;(
							(printout t "Inserta la prioridad (descargas valoracion espacio)" crlf)
							(bind ?prioridadPeticion (read))
							;)
						else (
							if (eq ?menu 4) then
								;(
								(printout t "Escribe el espacio maximo" crlf)
								(bind ?espacioMaxPeticion (read))
								;)
							else (
									if (eq ?menu 5) then
									;(
									(printout t "Escribe la valoracion minima (entero entre 0 y 5)" crlf)
									(bind ?valoracionMinPeticion (read))
									;)
								)
							)
						)
					)
			)
			(printout t "Menu:" crlf )
			(printout t "0: Peticion rellena" crlf)
			(printout t "1: Añadir genero" crlf)
			(printout t "2: Deteriminar la edad del usuario final de la aplicacion" crlf)
			(printout t "3: Determinar prioridad por la que se recomiendan las aplicaciones (descargas valoracion espacio)" crlf)
			(printout t "4: Determinar el espacio maximo que ocuparan las aplicaiones" crlf)
			(printout t "5: Determinar la valoracion minima de las apliaciones que se recomendaran" crlf)
			(printout t "¿Te interesa algún género en especial(S= Si / En otro caso = No)?" crlf)
			(bind ?menu (read))
			;)
		)
		(assert-string (str-cat "(peticion (id " ?idPeticion ") (genero " ?*generoPeticion* ") (edadDestinatario " ?edadPeticion 
			") (prioridad " ?prioridadPeticion ") (espacioMax " ?espacioMaxPeticion ") (valoracionMin " ?valoracionMinPeticion "))"
		))
		;)
		(bind ?otraPeticion (readline))
		)
	)

