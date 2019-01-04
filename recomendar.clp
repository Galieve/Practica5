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
	?recomendacion_ <- (recomendacion (id ?id_) (precioMaximo -1) (ready No))
	(test(eq ?gt 0))
	(test(>= (length$ $?apps_) 30))
=>
	(modify ?recomendacion_ (precioMaximo 0))
)

(defrule recomendarGastoCompulsivo
	?perfil_ <- (perfil (id ?id_) (gastoTotal ?gt) (gastoMaximo ?gm) (aplicacionesInstaladas $?apps_))
	?recomendacion_ <- (recomendacion (id ?id_) (precioMaximo -1) (ready No))
	(test(neq ?gt 0))
	(test(>= (length$ $?apps_) 30))
	(test(>= (/ ?gt (length$ $?apps_)) 0.63))
=>
	(modify ?recomendacion_ (precioMaximo (*(/ ?gt (length$ $?apps_)) 2)))
)


(defrule recomendarGastoNoCompulsivo
	?perfil_ <- (perfil (id ?id_) (gastoTotal ?gt) (gastoMaximo ?gm) (aplicacionesInstaladas $?apps_))
	?recomendacion_ <- (recomendacion (id ?id_) (precioMaximo -1) (ready No))
	(test(neq ?gt 0))
	(test(>= (length$ $?apps_) 30))
	(test(<  (/ ?gt (length$ $?apps_)) 0.63))
=>
	(modify ?recomendacion_ (precioMaximo ?gm))
)

;-----------------------Reglas de Edad------------------------------

(defrule recomendarEdadPerfil
	?perfil_ <- (perfil (id ?id_) (edad ?ed_))
	?recomendacion_ <- (recomendacion (id ?id_) (ready No) (edadApp -1) )
	?peticion_ <- (peticion (id ?id_) (edadDestinatario ?edPet_)) 
	(test(eq ?edPet_ -1))
=>
	(modify ?recomendacion_ (edadApp ?ed_))
)

(defrule recomendarEdadPeticion
	?recomendacion_ <- (recomendacion (id ?id_) (ready No) (edadApp -1))
	?peticion_ <- (peticion (id ?id_) (edadDestinatario ?edPet_)) 
	(test(neq ?edPet_ -1))
=>
	(modify ?recomendacion_ (edadApp ?edPet_))
)

;---------------------------Reglas de Valoracion ----------------------------


(defrule recomendarValoracionNula
	?recomendacion_ <- (recomendacion (id ?id_) (ready No) (valoracionMin -1) )
	?peticion_ <- (peticion (id ?id_) (valoracionMin ?valMin_)) 
	(test(eq ?valMin_ -1))

=>
	(modify ?recomendacion_ (valoracionMin 3.5))
)

(defrule recomendarValoracionNoNula
	?recomendacion_ <- (recomendacion (id ?id_) (ready No) (valoracionMin -1) )
	?peticion_ <- (peticion (id ?id_) (valoracionMin ?valMin_)) 
	(test(neq ?valMin_ -1))

=>
	(modify ?recomendacion_ (valoracionMin ?valMin_))
)

;---------------------------Reglas de Espacio--------------------------------

(defrule recomendarEspacioPedido
	?recomendacion_ <- (recomendacion (id ?id_) (ready No) (espacio null) )
	?peticion_ <- (peticion (id ?id_) (espacioMax ?em_)) 
	(test(neq ?em_ null))
=>
	(modify ?recomendacion_ (espacio ?em_))
)

(defrule recomendarPocoEspacio
	?perfil_ <- (perfil (id ?id_) (version ?vers_) (aplicacionesInstaladas $?apps_))
	?recomendacion_ <- (recomendacion (id ?id_) (ready No) (espacio null))
	?peticion_ <- (peticion (id ?id_) (espacioMax ?em_)) 
	(test(eq ?em_ null))
	(test (or (and (< (str-compare ?vers_ "6.0") 0) (>= (length$ $?apps_) 30)) (and (>= (str-compare ?vers_ "6.0") 0) (>= (length$ $?apps_) 100))))
=>
	(modify ?recomendacion_ (espacio ligera))
)

(defrule recomendarMedioEspacio
	?perfil_ <- (perfil (id ?id_) (version ?vers_) (aplicacionesInstaladas $?apps_))
	?recomendacion_ <- (recomendacion (id ?id_) (ready No) (espacio null) )
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
	?recomendacion_ <- (recomendacion (id ?id_) (ready No) (espacio null))
	?peticion_ <- (peticion (id ?id_) (espacioMax ?em_)) 
	(test(eq ?em_ null))
	(test(< (length$ $?apps_) 30))
	
=>
	(modify ?recomendacion_ (espacio pesada))
)



;--------------------------Reglas de Género---------------------------------

(defrule recomendarGeneroPeticionNoNula
	?recomendacion_ <- (recomendacion (id ?id_) (ready No) (genero $?generoRec_))
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

;--El resto de reglas de este apartado están en otro fichero	
	
	
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
	?peticion_ <- (peticion (id ?id_) (prioridad descargas) (listaApps $?listaApps_))
	?recomendacion_ <- (recomendacion (id ?id_) (genero $?genero_) (edadApp ?edad_) (espacio ?espacio_) (precioMaximo ?precioMax_)
		(ready Si)(valoracionMin ?valoracionMin_))
	?appRecomendada_ <- (appRecomendada (id ?id_) (nombre ?nombre_) (posPodium ?posPodium_))
	(test(eq ?nombre_ ""))
	?aplicacion_ <- (aplicacion (nombre ?nombreApp_) (valoracion ?valoracion_) (reviews ?reviews_) (espacio ?espacioApp_) (descargas ?descargasApp_)
		(precio ?precio_) (ultimaActualizacion ?ultimaActualizacion_) (androidVersion ?androidVersion_) (genero ?generoApp_) (edad ?edadApp_))
	
	(test (not (member$ ?nombreApp_ ?aplicacionesInstaladas_)))
	
	(test(>= ?edad_ (conversionEdad_Num ?edadApp_)))
	(test(>= ?descargasApp_ 50000))
	(test(>= ?reviews_ 5000))
	(test(>= ?valoracion_ ?valoracionMin_))
	(test(<= ?precio_ ?precioMax_))
	(test (neq (member$ ?generoApp_ ?genero_) FALSE))

	(test(or	
		(and (eq ?espacio_ ligera ) (<= ?espacioApp_ 3000000))		
		(and (eq ?espacio_ medio  ) (<= ?espacioApp_ 15000000))	
		(eq ?espacio_ pesada)
	))
	
	(forall
		(aplicacion 
			(nombre ?nombreApp_2&:
				(and(not (member$ ?nombreApp_2 $?aplicacionesInstaladas_))(neq ?nombreApp_2 ?nombreApp_) (not (member$ ?nombreApp_2 $?listaApps_)) )) 
			(reviews ?reviews_2&:(>= ?reviews_2 5000)) 
			(valoracion ?valoracion_2&:(>= ?valoracion_2 ?valoracionMin_)) 
			(espacio ?espacioApp_2&:(or 
				(and (eq ?espacio_ ligera ) (<= ?espacioApp_2 3000000))	
				(and (eq ?espacio_ medio ) (<= ?espacioApp_2 15000000))
				(eq ?espacio_ pesada))) 
			(descargas ?descargasApp_2&:(>= ?descargasApp_2 50000))
			(precio ?precio_2&:(<= ?precio_2 ?precioMax_)) 
			(genero ?generoApp_2&:(member$ ?generoApp_2 ?genero_))
			(edad ?edadApp_2&:(>= ?edad_ (conversionEdad_Num ?edadApp_2)))
		)
			
		(test(or		
				(> ?descargasApp_ ?descargasApp_2)	 
				(and (eq ?descargasApp_ ?descargasApp_2) (>= ?valoracion_ ?valoracion_2))
			)
		)
	)	
	(forall (appRecomendada (nombre ?nombre_2) (id ?id_) (posPodium ?posPodium2_&:(neq ?posPodium2_ ?posPodium_)))
						(test (neq ?nombre_2 ?nombreApp_)))
	

	
=>
	(printout t "Se ha recomendado la app: "?nombreApp_ crlf)
	(modify ?peticion_ (listaApps (insert$ $?listaApps_ 1 ?nombreApp_)))
	(modify ?appRecomendada_ (nombre ?nombreApp_)) 
	
)











;-------------------------


(defrule recomendarValoraciones
	?perfil_ <- (perfil (id ?id_) (aplicacionesInstaladas $?aplicacionesInstaladas_))
	?peticion_ <- (peticion (id ?id_) (prioridad valoracion) (listaApps $?listaApps_))
	?recomendacion_ <- (recomendacion (id ?id_) (genero $?genero_) (edadApp ?edad_) (espacio ?espacio_) (precioMaximo ?precioMax_) 
		(ready Si) (valoracionMin ?valoracionMin_))
	?appRecomendada_ <- (appRecomendada (id ?id_) (nombre ?nombre_) (posPodium ?posPodium_))
	(test(eq ?nombre_ ""))
	?aplicacion_ <- (aplicacion (nombre ?nombreApp_) (valoracion ?valoracion_) (reviews ?reviews_) (espacio ?espacioApp_) (descargas ?descargasApp_)
		(precio ?precio_) (ultimaActualizacion ?ultimaActualizacion_) (androidVersion ?androidVersion_) (genero ?generoApp_) (edad ?edadApp_))
	
	(test (not (member$ ?nombreApp_ ?aplicacionesInstaladas_)))
	
	(test(>= ?edad_ (conversionEdad_Num ?edadApp_)))
	(test(>= ?descargasApp_ 50000))
	(test(>= ?reviews_ 5000))
	(test(>= ?valoracion_ ?valoracionMin_))
	(test(<= ?precio_ ?precioMax_))
	(test (neq (member$ ?generoApp_ ?genero_) FALSE))

	(test(or	
		(and (eq ?espacio_ ligera ) (<= ?espacioApp_ 3000000))		
		(and (eq ?espacio_ medio  ) (<= ?espacioApp_ 15000000))	
		(eq ?espacio_ pesada)
	))
	
	(forall
		(aplicacion 
			(nombre ?nombreApp_2&:
				(and(not (member$ ?nombreApp_2 $?aplicacionesInstaladas_))(neq ?nombreApp_2 ?nombreApp_) (not (member$ ?nombreApp_2 $?listaApps_)) )) 
			(reviews ?reviews_2&:(>= ?reviews_2 5000)) 
			(valoracion ?valoracion_2&:(>= ?valoracion_2 ?valoracionMin_)) 
			(espacio ?espacioApp_2&:(or 
				(and (eq ?espacio_ ligera ) (<= ?espacioApp_2 3000000))	
				(and (eq ?espacio_ medio ) (<= ?espacioApp_2 15000000))
				(eq ?espacio_ pesada))) 
			(descargas ?descargasApp_2&:(>= ?descargasApp_2 50000))
			(precio ?precio_2&:(<= ?precio_2 ?precioMax_)) 
			(genero ?generoApp_2&:(member$ ?generoApp_2 ?genero_))
			(edad ?edadApp_2&:(>= ?edad_ (conversionEdad_Num ?edadApp_2)))
		)
			
		(test(or		
				(> ?valoracion_ ?valoracion_2)	 
				(and (eq ?valoracion_ ?valoracion_2) (>= ?descargasApp_ ?descargasApp_2))
			)
		)
	)	
	(forall (appRecomendada (nombre ?nombre_2) (id ?id_) (posPodium ?posPodium2_&:(neq ?posPodium2_ ?posPodium_)))
						(test (neq ?nombre_2 ?nombreApp_)))
	

	
=>
	(printout t "Se ha recomendado la app: "?nombreApp_ crlf)
	(modify ?peticion_ (listaApps (insert$ $?listaApps_ 1 ?nombreApp_)))
	(modify ?appRecomendada_ (nombre ?nombreApp_)) 
)






(defrule recomendarEspacio
	?perfil_ <- (perfil (id ?id_) (aplicacionesInstaladas $?aplicacionesInstaladas_))
	?peticion_ <- (peticion (id ?id_) (prioridad espacio) (listaApps $?listaApps_))
	?recomendacion_ <- (recomendacion (id ?id_) (genero $?genero_) (edadApp ?edad_) (espacio ?espacio_) (precioMaximo ?precioMax_)
		(ready Si) (valoracionMin ?valoracionMin_))
	?appRecomendada_ <- (appRecomendada (id ?id_) (nombre ?nombre_) (posPodium ?posPodium_))
	(test(eq ?nombre_ ""))
	?aplicacion_ <- (aplicacion (nombre ?nombreApp_) (valoracion ?valoracion_) (reviews ?reviews_) (espacio ?espacioApp_) (descargas ?descargasApp_)
		(precio ?precio_) (ultimaActualizacion ?ultimaActualizacion_) (androidVersion ?androidVersion_) (genero ?generoApp_) (edad ?edadApp_))
	
	(test (not (member$ ?nombreApp_ ?aplicacionesInstaladas_)))
	
	(test(>= ?edad_ (conversionEdad_Num ?edadApp_)))
	(test(>= ?descargasApp_ 50000))
	(test(>= ?reviews_ 5000))
	(test(>= ?valoracion_ ?valoracionMin_))
	(test(<= ?precio_ ?precioMax_))
	(test (neq (member$ ?generoApp_ ?genero_) FALSE))

	(test(or	
		(and (eq ?espacio_ ligera ) (<= ?espacioApp_ 3000000))		
		(and (eq ?espacio_ medio  ) (<= ?espacioApp_ 15000000))	
		(eq ?espacio_ pesada)
	))
	
	(forall
		(aplicacion 
			(nombre ?nombreApp_2&:
				(and(not (member$ ?nombreApp_2 $?aplicacionesInstaladas_))(neq ?nombreApp_2 ?nombreApp_) (not (member$ ?nombreApp_2 $?listaApps_)) )) 
			(reviews ?reviews_2&:(>= ?reviews_2 5000)) 
			(valoracion ?valoracion_2&:(>= ?valoracion_2 ?valoracionMin_)) 
			(espacio ?espacioApp_2&:(or 
				(and (eq ?espacio_ ligera ) (<= ?espacioApp_2 3000000))	
				(and (eq ?espacio_ medio ) (<= ?espacioApp_2 15000000))
				(eq ?espacio_ pesada))) 
			(descargas ?descargasApp_2&:(>= ?descargasApp_2 50000))
			(precio ?precio_2&:(<= ?precio_2 ?precioMax_)) 
			(genero ?generoApp_2&:(member$ ?generoApp_2 ?genero_))
			(edad ?edadApp_2&:(>= ?edad_ (conversionEdad_Num ?edadApp_2)))
		)
			
		(test(or		
				(> ?espacioApp_ ?espacioApp_2)	 
				(and (eq ?espacioApp_ ?espacioApp_2) (>= ?valoracion_ ?valoracion_2))
			)
		)
	)	
	(forall (appRecomendada (nombre ?nombre_2) (id ?id_) (posPodium ?posPodium2_&:(neq ?posPodium2_ ?posPodium_)))
						(test (neq ?nombre_2 ?nombreApp_)))
	

	
=>
	(printout t "Se ha recomendado la app: "?nombreApp_ crlf)
	(modify ?peticion_ (listaApps (insert$ $?listaApps_ 1 ?nombreApp_)))
	(modify ?appRecomendada_ (nombre ?nombreApp_)) 
)




(defrule crearAppRecomendada
	?appRecomendada_ <- (appRecomendada (id ?id_) (nombre ?nombre_) (posPodium ?posPodium_))
	(test(neq ?nombre_ ""))
	(not (exists 	(appRecomendada (id ?id_) (posPodium ?posPodium2_))        (test(> ?posPodium2_ ?posPodium_))))
	(test(< ?posPodium_ 3))
=>
	(assert (appRecomendada (id ?id_)		(posPodium	(+ ?posPodium_ 1) )))
)

