;NUMapps_ antes de perfil bueno = 30!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

;----------------------Reglas de gasto------------------------

(defrule recomendarGastoInit
	?perfil_ <- (perfil (id ?id_) (gastoTotal ?gt) (gastoMaximo ?gm) (aplicacionesInstaladas $?apps_))
	?recomendacion_ <- (recomendacion (id ?id_) (precioMaximo -1) (ready No))
	(test(< (length$ $?apps_) 30))
	
=>
	(modify ?recomendacion_ (precioMaximo ?*infinito*))
)

(defrule recomendarGastoTotalCero
	?perfil_ <- (perfil (id ?id_) (gastoTotal ?gt) (gastoMaximo ?gm) (aplicacionesInstaladas $?apps_))
	?recomendacion_ <- (recomendacion (id ?id) (precioMaximo -1) (ready No))
	(test(eq ?gt 0))
	(test(>= (length$ $?apps_) 30))
=>
	(modify ?recomendacion_ (precioMaximo 0))
)

(defrule recomendarGastoCompulsivo
	?perfil_ <- (perfil (id ?id_) (gastoTotal ?gt) (gastoMaximo ?gm) (aplicacionesInstaladas $?apps_))
	?recomendacion_ <- (recomendacion (id ?id) (precioMaximo -1) (ready No))
	(test(neq ?gt 0))
	(test(>= (length$ $?apps_) 30))
	(test(>= (/ ?gt (length$ $?apps_)) 0.63))
=>
	(modify ?recomendacion_ (precioMaximo (*(/ ?gt (length$ $?apps_)) 2)))
)


(defrule recomendarGastoNoCompulsivo
	?perfil_ <- (perfil (id ?id_) (gastoTotal ?gt) (gastoMaximo ?gm) (aplicacionesInstaladas $?apps_))
	?recomendacion_ <- (recomendacion (id ?id) (precioMaximo -1) (ready No))
	(test(neq ?gt 0))
	(test(>= (length$ $?apps_) 30))
	(test(<  (/ ?gt (length$ $?apps_)) 0.63))
=>
	(modify ?recomendacion_ (precioMaximo ?gm))
)

;-----------------------Reglas de Edad------------------------------

(defrule recomendarEdadPerfil
	?perfil_ <- (perfil (id ?id_) (edad ?ed_))
	?recomendacion_ <- (recomendacion (id ?id) (ready No) (edadApp -1) )
	?peticion_ <- (peticion (id ?id_) (edadDestinatario ?edPet_)) 
	(test(eq ?edPet_ -1))
=>
	(modify ?recomendacion_ (edadApp ?ed_))
)

(defrule recomendarEdadPeticion
	?recomendacion_ <- (recomendacion (id ?id) (ready No) (edadApp -1))
	?peticion_ <- (peticion (id ?id_) (edadDestinatario ?edPet_)) 
	(test(neq ?edPet_ -1))
=>
	(modify ?recomendacion_ (edadApp ?edPet_))
)

;---------------------------Reglas de Espacio--------------------------------

(defrule recomendarEspacioPedido
	?recomendacion_ <- (recomendacion (id ?id) (ready No) (espacio null) )
	?peticion_ <- (peticion (id ?id_) (espacioMax ?em_)) 
	(test(neq ?em_ null))
=>
	(modify ?recomendacion_ (espacio ?em_))
)

(defrule recomendarPocoEspacio
	?perfil_ <- (perfil (id ?id_) (version ?vers_) (aplicacionesInstaladas $?apps_))
	?recomendacion_ <- (recomendacion (id ?id) (ready No) (espacio null))
	?peticion_ <- (peticion (id ?id_) (espacioMax ?em_)) 
	(test(eq ?em_ null))
	(test (or (and (< (str-compare ?vers_ "6.0") 0) (>= (length$ $?apps_) 30)) (and (>= (str-compare ?vers_ "6.0") 0) (>= (length$ $?apps_) 100))))
=>
	(modify ?recomendacion_ (espacio ligera))
)

(defrule recomendarMedioEspacio
	?perfil_ <- (perfil (id ?id_) (version ?vers_) (aplicacionesInstaladas $?apps_))
	?recomendacion_ <- (recomendacion (id ?id) (ready No) (espacio null) )
	?peticion_ <- (peticion (id ?id_) (espacioMax ?em_)) 
	(test(eq ?em_ null))
	(test(>= (str-compare ?vers_ "6.0") 0) )
	(test(>= (length$ $?apps_) 30))
	(test(< (length$ $?apps_) 100))
	
=>
	(modify ?recomendacion_ (espacio medio))
)

(defrule recomendarPesadoEspacio
	?perfil_ <- (perfil (id ?id_) (version ?vers_) (aplicacionesInstaladas $?apps_))
	?recomendacion_ <- (recomendacion (id ?id) (ready No) (espacio null))
	?peticion_ <- (peticion (id ?id_) (espacioMax ?em_)) 
	(test(eq ?em_ null))
	(test(< (length$ $?apps_) 30))
	
=>
	(modify ?recomendacion_ (espacio pesada))
)



;--------------------------Reglas de Género---------------------------------

(defrule recomendarGeneroPeticionNoNula
	?recomendacion_ <- (recomendacion (id ?id_) (genero $?generoRec_) (ready No) )
	?peticion_ <- (peticion (id ?id_) (genero $?genP_)) 
	(test(neq (length$ $?genP_) 0))
	(test(eq (length$ $?generoRec_) 0))
	
=>
	(modify ?recomendacion_ (genero ?genP_))
)

(defrule recomendarGeneroPeticionNulaMuchasapps_
	?perfil_ <- (perfil (id ?id_) (aplicacionesInstaladas $?apps_) (genero $?genPerf_))
	?recomendacion_ <- (recomendacion (id ?id_) (genero $?generoRec_) (ready No) )
	?peticion_ <- (peticion (id ?id_) (genero $?genP_)) 
	(test(eq  (length$ $?genP_) 0))
	(test(>=  (length$ $?apps_) 30))
	(test(eq (length$ $?generoRec_) 0))
	
=>
	(modify ?recomendacion_ (genero ?genPerf_))
)


(defrule recomendarGeneroPeticionNulaPocasapps_
	?perfil_ <- (perfil (id ?id_) (aplicacionesInstaladas $?apps_) (genero $?genPerf_))
	?recomendacion_ <- (recomendacion (id ?id_) (genero $?generoRec_) (ready No))
	?peticion_ <- (peticion (id ?id_) (genero $?genP_)) 
	(test(eq (length$ $?genP_) 0))
	(test(<  (length$ $?apps_) 30))
	(test(eq (length$ $?generoRec_) 0))
=>
	(modify ?recomendacion_ (genero ?generoRec_ Action Adventure Arcade ArtAndDesign AutoAndVehicles Beauty Board BooksAndReference
		Business Card Casino Casual Comics Communication Dating Education Educational Entertainment Events Finance FoodAndDrink 
		HealthAndFitness HouseAndHome LibrariesAndDemo Lifestyle MapsAndNavigation Medical Music MusicAndAudio NewsAndMagazines 
		Parenting Personalization Photography Productivity Puzzle Racing RolePlaying Shopping Simulation Social Sports Strategy 
		Tools TravelAndLocal Trivia VideoPlayersAndEditors Weather Word))
)


	
	
	
;-------------------------------------------------------------------------

(defrule setReady
	(declare (salience -11))
	?recomendacion_ <- (recomendacion (id ?id_) (genero $?genero_) (edadApp ?edad_) (espacio ?espacio_) (precioMaximo ?precioMax_) (ready No))
	(test(neq (length$ $?genero_) 0))
	(test(neq ?edad_ -1))
	(test(neq ?espacio_ null))
	(test(neq ?precioMax_ -1))
=>
	(modify ?recomendacion_ (ready Si))
	(assert (appRecomendada (id ?id_) (posPodium 1)))
)
;Pedir pospodium < 3
;-------------------------------------------------------------------------

(deffunction conversionEdad_Num (?edadApp_)
	(if (eq ?edadApp_  Everyone) then 0
	else (
		if (eq ?edadApp_ Everyone10+) then 10
		else (
			if (eq ?edadApp_ Teen) then 13
			else (
				if (eq ?edadApp_ Mature17+) then 17
				else 18
				)
			)
		)
	)
)

(defrule recomendarDescargas
	?perfil_ <- (perfil (id ?id_) (aplicacionesInstaladas $?aplicacionesInstaladas_))
	?peticion_ <- (peticion (id ?id_) (prioridad descargas))
	?recomendacion_ <- (recomendacion (id ?id_) (genero $?genero_) (edadApp ?edad_) (espacio ?espacio_) (precioMaximo ?precioMax_) (ready Si))
	?appRecomendada_ <- (appRecomendada (id ?id_) (nombre ?nombre_) (posPodium ?posPodium_))
	(test(eq ?nombre_ ""))
	?aplicacion_ <- (aplicacion (nombre ?nombreApp_) (valoracion ?valoracion_) (reviews ?reviews_) (espacio ?espacioApp_) (descargas ?descargasApp_)
		(precio ?precio_) (ultimaActualizacion ?ultimaActualizacion_) (androidVersion ?androidVersion_) (genero ?generoApp_) (edad ?edadApp_))
	
	(test (not (member$ ?nombreApp_ ?aplicacionesInstaladas_)))
	
	(test(>= ?edad_ (conversionEdad_Num ?edadApp_)))
	(test(>= ?descargasApp_ 50000))
	(test(>= ?reviews_ 5000))
	(test(>= ?valoracion_ 3.5))
	(test(<= ?precio_ ?precioMax_))
	(test (neq (member$ ?generoApp_ ?genero_) FALSE))
	(test(or	
		(and (eq ?espacio_ ligera ) (<= ?espacioApp_ 3000000))		
		(and (eq ?espacio_ medio  ) (<= ?espacioApp_ 15000000))	
		(eq ?espacio_ pesada)
	))
	
	

	
=>
	(printout t ?generoApp_ " y el genero recomendado es: " ?genero_ crlf)
	(modify ?appRecomendada_ (nombre ?nombreApp_))
	
)



(defrule recomendarValoracion
	?perfil_ <- (perfil (id ?id_) (aplicacionesInstaladas $?aplicacionesInstaladas_))
	?peticion_ <- (peticion (id ?id_) (prioridad valoracion))
	?recomendacion_ <- (recomendacion (id ?id_) (genero $?genero_) (edadApp ?edad_) (espacio ?espacio_) (precioMaximo ?precioMax_) (ready Si))
	?appRecomendada_ <- (appRecomendada (id ?id_) (nombre ?nombre_) (posPodium ?posPodium_))
	(test(eq ?nombre_ ""))
	?aplicacion_ <- (aplicacion (nombre ?nombreApp_) (valoracion ?valoracion_) (reviews ?reviews_) (espacio ?espacioApp_) (descargas ?descargasApp_)
		(precio ?precio_) (ultimaActualizacion ?ultimaActualizacion_) (androidVersion ?androidVersion_) (genero ?generoApp_) (edad ?edadApp_))
	
	(test (not (member$ ?nombreApp_ ?aplicacionesInstaladas_)))
	
	(test(>= ?edad_ (conversionEdad_Num ?edadApp_)))
	(test(>= ?descargasApp_ 50000))
	(test(>= ?reviews_ 5000))
	(test(>= ?valoracion_ 3.5))
	(test(<= ?precio_ ?precioMax_))
	(test (member$ ?generoApp_ ?genero_))
	(test(or	
		(and (eq ?espacio_ ligera ) (<= ?espacioApp_ 3000000))		
		(and (eq ?espacio_ medio  ) (<= ?espacioApp_ 15000000))	
	))
	
	
	(forall (aplicacion  (nombre ?nombreApp_2) (valoracion ?valoracion_2) (descargas ?descargasApp_2) (genero ?generoApp_2) (edad ?edadApp_2) )
		(test (>= ?edad_ (conversionEdad_Num ?edadApp_)))
		(test (>= ?descargasApp_ 50000))
		(test (>= ?reviews_ 5000))
		(test (>= ?valoracion_ 3.5))
		(test (<= ?precio_ ?precioMax_))
		(test (member$ ?generoApp_ ?genero_))
		(test (or 
			(and (eq ?espacio_ ligera ) (<= ?espacioApp_ 3000000))	
			(and (eq ?espacio_ medio ) (<= ?espacioApp_ 15000000))	
		))
		(test	(or	
					(> ?valoracion_ ?valoracion_2 )	 
					(and (eq ?valoracion_ ?valoracion_2) (>= ?descargasApp_ ?descargasApp_2 ))
				)	
		)
		(test (not (member$ ?nombreApp_2 $?aplicacionesInstaladas_)))
	)
	(forall (appRecomendada (nombre ?nombre_2) (id ?id_) )
	(test (neq ?nombre_2 ?nombre_))
	)

=>
	(modify ?appRecomendada_ (nombre ?nombre_))
	
)



(defrule recomendarEspacio
	?perfil_ <- (perfil (id ?id_) (aplicacionesInstaladas $?aplicacionesInstaladas_))
	?peticion_ <- (peticion (id ?id_) (prioridad espacio))
	?recomendacion_ <- (recomendacion (id ?id_) (genero $?genero_) (edadApp ?edad_) (espacio ?espacio_) (precioMaximo ?precioMax_) (ready Si))
	?appRecomendada_ <- (appRecomendada (id ?id_) (nombre ?nombre_) (posPodium ?posPodium_))
	(test(eq ?nombre_ ""))
	?aplicacion_ <- (aplicacion (nombre ?nombreApp_) (valoracion ?valoracion_) (reviews ?reviews_) (espacio ?espacioApp_) (descargas ?descargasApp_)
		(precio ?precio_) (ultimaActualizacion ?ultimaActualizacion_) (androidVersion ?androidVersion_) (genero ?generoApp_) (edad ?edadApp_))
	
	(test (not (member$ ?nombreApp_ ?aplicacionesInstaladas_)))
	
	(test(>= ?edad_ (conversionEdad_Num ?edadApp_)))
	(test(>= ?descargasApp_ 50000))
	(test(>= ?reviews_ 5000))
	(test(>= ?valoracion_ 3.5))
	(test(<= ?precio_ ?precioMax_))
	(test (member$ ?generoApp_ ?genero_))
	(test(or	
		(and (eq ?espacio_ ligera ) (<= ?espacioApp_ 3000000))		
		(and (eq ?espacio_ medio  ) (<= ?espacioApp_ 15000000))	
	))
	
	
	
	(forall (aplicacion  (nombre ?nombreApp_2) (valoracion ?valoracion_2) (espacio ?espacioApp_2) 
		(genero ?generoApp_2) (edad ?edadApp_2) )
		(test (>= ?edad_ (conversionEdad_Num ?edadApp_)))
		(test (>= ?descargasApp_ 50000))
		(test (>= ?reviews_ 5000))
		(test (>= ?valoracion_ 3.5))
		(test (<= ?precio_ ?precioMax_))
		(test (member$ ?generoApp_ ?genero_))
		(test (or 
			(and (eq ?espacio_ ligera ) (<= ?espacioApp_ 3000000))	
			(and (eq ?espacio_ medio ) (<= ?espacioApp_ 15000000))	
		))
		(test(or		
				(> ?espacioApp_ ?espacioApp_2)	 
				(and (eq ?espacioApp_ ?espacioApp_2) (>= ?valoracion_ ?valoracion_2))	
			)
		)
		(test (not (member$ ?nombreApp_2 $?aplicacionesInstaladas_)))
	)
	(forall (appRecomendada (nombre ?nombre_2) (id ?id_) )
		(test (neq ?nombre_2 ?nombre_))
	)

=>
	(modify ?appRecomendada_ (nombre ?nombre_))
	
)



(defrule crearAppRecomendada
	?appRecomendada_ <- (appRecomendada (id ?id_) (nombre ?nombre_) (posPodium ?posPodium_))
	(test(neq ?nombre_ ""))
	(not (exists 	(appRecomendada (id ?id_) (posPodium ?posPodium2_))        (test(> ?posPodium2_ ?posPodium_))))
	(test(< ?posPodium_ 3))
=>
	(assert (appRecomendada (id ?id_)		(posPodium	(+ ?posPodium_ 1) )))
)


