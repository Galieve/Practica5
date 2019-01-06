(defrule crearRecomendacion
	?peticion_ <- (peticion (id ?id_) (satisfecha No) (listaApps $?listaApps_))
	(test (eq (length$ $?listaApps_) 0))
=>
	(assert (recomendacion (id ?id_)))
)

(defrule crearAppRecomendada
	?appRecomendada_ <- (appRecomendada (id ?id_) (nombre ?nombre_&:(neq ?nombre_ "")) (posPodium ?posPodium_))
	?peticion_ <- (peticion (id ?id_) (cantidadRecom ?cantidadRecom_) (satisfecha No))
	(not (exists (appRecomendada (id ?id_) (posPodium ?posPodium2_)) (test(> ?posPodium2_ ?posPodium_))))
	(test(< ?posPodium_ ?cantidadRecom_))
=>
	(assert (appRecomendada (id ?id_) (posPodium	(+ ?posPodium_ 1) )))
)

(defrule satisfacerPeticion
	?peticion_ <- (peticion (id ?id_) (satisfecha No) (cantidadRecom ?cr_))
	(appRecomendada (id ?id_) (nombre ~"") (posPodium ?cr_))
=>
	(modify ?peticion_ (satisfecha Si))
)

(defrule printStart
	?peticion_ <- (peticion (id ?id_) (satisfecha Si))
=>
   (assert (printQuery (id ?id_)))
   (printout t "Gracias por la espera, " ?id_ crlf)
   (printout t "A continuación se le mostrarán las mejores aplicaciones para usted." crlf crlf)
)

;--Nota: si esta regla se activa quiere decir que ?pos_ < ?cantidadRecom_
(defrule printContinue
	?peticion_ <- (peticion (id ?id_) (cantidadRecom ?cantidadRecom_) (satisfecha Si))
	?printQuery_ <- (printQuery (id ?id_) (pos ?pos_))
	?appRecomendada <- (appRecomendada (id ?id_) (nombre ?n) (posPodium ?pos_))
=>
	(printout t "La "?pos_"ª aplicación que se le recomienda instalar es: " ?n crlf)
	(printout t "Esperamos que le interese." crlf)
	(modify ?printQuery_ (pos (+ ?pos_ 1)))
	(retract ?appRecomendada)
	
)

(defrule printFinish
	?peticion_ <- (peticion (id ?id_) (cantidadRecom ?cantidadRecom_) (satisfecha Si))
	?printQuery_ <- (printQuery (id ?id_) (pos ?pos_))
	(test (eq ?pos_ (+ ?cantidadRecom_ 1)))
=>
	(retract ?printQuery_)
	(printout t "Hasta aquí la lista de recomendaciones para usted." crlf)
	(printout t "Si desea instalar alguna aplicación, teclee el comando instalar acompañado de su identificador y el nombre de la aplicacion deseada." crlf crlf)
)

(defrule instalar
	?iq_ <- (installQuery (id ?id_) (nombre ?nombreApp_))
	?perfil_ <- (perfil (id ?id_) (aplicacionesInstaladas $?aplicacionesInstaladas_) (genero $?genero_) 
					(gastoTotal ?gastoTotal_) (gastoMaximo ?gastoMaximo_))
	(aplicacion (nombre ?nombreApp_) (genero ?generoApp_) (precio ?precio_))
	(test (not (member$ ?nombreApp_ ?aplicacionesInstaladas_)) )
=>
	(bind ?aplicacionesInstaladas_(insertElementoUnico ?nombreApp_ $?aplicacionesInstaladas_))
	(bind ?genero_ (insertElementoUnico ?generoApp_ $?genero_))
	(modify ?perfil_ (genero ?genero_) (aplicacionesInstaladas ?aplicacionesInstaladas_) 
		(gastoTotal (+ ?gastoTotal_ ?precio_)) (gastoMaximo (max ?gastoMaximo_ ?precio_)) )
	(printout t "Aplicacion " ?nombreApp_" instalada con éxito." crlf crlf)
	(retract ?iq_)
)

(defrule updatePerfilJuegos
	?perfil_ <- (perfil (id ?id_) (genero $?genPerf_) )
	(test (and
		(not (member$ Games $?genPerf_))
		(or
			(member$ Action $?genPerf_)
			(member$ Adventure $?genPerf_)
			(member$ Arcade $?genPerf_)
			(member$ Board $?genPerf_)
			(member$ Card $?genPerf_)
			(member$ Casino $?genPerf_)
			(member$ Casual $?genPerf_)
			(member$ Entertainment $?genPerf_)
			(member$ Music $?genPerf_)
			(member$ Puzzle $?genPerf_)
			(member$ Racing $?genPerf_)
			(member$ RolePlaying $?genPerf_)
			(member$ Simulation $?genPerf_)
			(member$ Strategy $?genPerf_)
			(member$ Trivia $?genPerf_)
			(member$ Word $?genPerf_)
		)
	))
=>
	(modify ?perfil_ (genero (insert$ $?genPerf_ 1 Games)))
)