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
	?perfil_ <- (perfil (id ?id_) (gastoTotal ?gt&:(eq ?gt 0)) (gastoMaximo ?gm) (aplicacionesInstaladas $?apps_))
	?recomendacion_ <- (recomendacion (id ?id_) (precioMaximo -1) (ready No))
	(test(>= (length$ $?apps_) 30))
=>
	(modify ?recomendacion_ (precioMaximo 0))
)

(defrule recomendarGastoCompulsivo
	?perfil_ <- (perfil (id ?id_) (gastoTotal ?gt&:(neq ?gt 0)) (gastoMaximo ?gm) (aplicacionesInstaladas $?apps_))
	?recomendacion_ <- (recomendacion (id ?id_) (precioMaximo -1) (ready No))
	(test(>= (length$ $?apps_) 30))
	(test(>= (/ ?gt (length$ $?apps_)) 0.63))
=>
	(modify ?recomendacion_ (precioMaximo (*(/ ?gt (length$ $?apps_)) 2)))
)


(defrule recomendarGastoNoCompulsivo
	?perfil_ <- (perfil (id ?id_) (gastoTotal ?gt&:(neq ?gt 0)) (gastoMaximo ?gm) (aplicacionesInstaladas $?apps_))
	?recomendacion_ <- (recomendacion (id ?id_) (precioMaximo -1) (ready No))
	(test(>= (length$ $?apps_) 30))
	(test(<  (/ ?gt (length$ $?apps_)) 0.63))
=>
	(modify ?recomendacion_ (precioMaximo ?gm))
)

;-----------------------Reglas de Edad------------------------------

(defrule recomendarEdadPerfil
	?perfil_ <- (perfil (id ?id_) (edad ?ed_))
	?recomendacion_ <- (recomendacion (id ?id_) (ready No) (edadApp -1) )
	?peticion_ <- (peticion (id ?id_) (edadDestinatario ?edPet_&:(eq ?edPet_ -1)) (satisfecha No)) 
=>
	(modify ?recomendacion_ (edadApp ?ed_))
)

(defrule recomendarEdadPeticion
	?recomendacion_ <- (recomendacion (id ?id_) (ready No) (edadApp -1))
	?peticion_ <- (peticion (id ?id_) (edadDestinatario ?edPet_&:(neq ?edPet_ -1)) (satisfecha No)) 
=>
	(modify ?recomendacion_ (edadApp ?edPet_))
)

;---------------------------Reglas de Valoracion ----------------------------


(defrule recomendarValoracionNula
	?recomendacion_ <- (recomendacion (id ?id_) (ready No) (valoracionMin -1) )
	?peticion_ <- (peticion (id ?id_) (valoracionMin ?valMin_&:(eq ?valMin_ -1)) (satisfecha No)) 
=>
	(modify ?recomendacion_ (valoracionMin 3.5))
)

(defrule recomendarValoracionNoNula
	?recomendacion_ <- (recomendacion (id ?id_) (ready No) (valoracionMin -1) )
	?peticion_ <- (peticion (id ?id_) (valoracionMin ?valMin_&:(neq ?valMin_ -1)) (satisfecha No)) 
=>
	(modify ?recomendacion_ (valoracionMin ?valMin_))
)

;---------------------------Reglas de Espacio--------------------------------

(defrule recomendarEspacioPedido
	?recomendacion_ <- (recomendacion (id ?id_) (ready No) (espacio null) )
	?peticion_ <- (peticion (id ?id_) (espacioMax ?em_&:(neq ?em_ null)) (satisfecha No)) 
=>
	(modify ?recomendacion_ (espacio ?em_))
)

(defrule recomendarPocoEspacio
	?perfil_ <- (perfil (id ?id_) (version ?vers_) (aplicacionesInstaladas $?apps_))
	?recomendacion_ <- (recomendacion (id ?id_) (ready No) (espacio null))
	?peticion_ <- (peticion (id ?id_) (espacioMax null) (satisfecha No)) 
	(test (or (and (< (str-compare ?vers_ "6.0") 0) (>= (length$ $?apps_) 30)) (and (>= (str-compare ?vers_ "6.0") 0) (>= (length$ $?apps_) 100))))
=>
	(modify ?recomendacion_ (espacio ligera))
)

(defrule recomendarMedioEspacio
	?perfil_ <- (perfil (id ?id_) (version ?vers_) (aplicacionesInstaladas $?apps_))
	?recomendacion_ <- (recomendacion (id ?id_) (ready No) (espacio null) )
	?peticion_ <- (peticion (id ?id_) (espacioMax null) (satisfecha No)) 
	(test(>= (str-compare ?vers_ "6.0") 0) )
	(test(>= (length$ $?apps_) 30))
	(test(< (length$ $?apps_) 100))
	
=>
	(modify ?recomendacion_ (espacio medio))
)

(defrule recomendarPesadoEspacio
	?perfil_ <- (perfil (id ?id_) (version ?vers_) (aplicacionesInstaladas $?apps_))
	?recomendacion_ <- (recomendacion (id ?id_) (ready No) (espacio null))
	?peticion_ <- (peticion (id ?id_) (espacioMax null) (satisfecha No)) 
	(test(< (length$ $?apps_) 30))
	
=>
	(modify ?recomendacion_ (espacio pesada))
)
	
;-------------------------------------------------------------------------

(defrule setReady
	(declare (salience -11))
	?recomendacion_ <- (recomendacion (id ?id_) (genero $?genero_) (edadApp ?edad_&:(neq ?edad_ -1)) 
		(espacio ?espacio_&:(neq ?espacio_ null)) (precioMaximo ?precioMax_&:(neq ?precioMax_ -1)) (ready No))
	(test(neq (length$ $?genero_) 0))
=>
	(modify ?recomendacion_ (ready Si))
	(assert (appRecomendada (id ?id_) (posPodium 1)))
)
;Pedir pospodium < 3
;-------------------------------------------------------------------------


(defrule recomendarDescargas
	?perfil_ <- (perfil (id ?id_) (aplicacionesInstaladas $?aplicacionesInstaladas_))
	?peticion_ <- (peticion (id ?id_) (prioridad descargas) (listaApps $?listaApps_) (satisfecha No))
	?recomendacion_ <- (recomendacion (id ?id_) (genero $?genero_) (edadApp ?edad_) (espacio ?espacio_) (precioMaximo ?precioMax_)
		(ready Si)(valoracionMin ?valoracionMin_))
	?appRecomendada_ <- (appRecomendada (id ?id_) (nombre "") (posPodium ?posPodium_))
	?aplicacion_ <- (aplicacion (nombre ?nombreApp_) (valoracion ?valoracion_) (reviews ?reviews_) (espacio ?espacioApp_) (descargas ?descargasApp_)
		(precio ?precio_) (ultimaActualizacion ?ultimaActualizacion_) (androidVersion ?androidVersion_) (genero ?generoApp_) (edad ?edadApp_))
	
	(test (not (member$ ?nombreApp_ ?aplicacionesInstaladas_)))
	(test(>= ?edad_ (conversionEdad_Num ?edadApp_)))
	(test(>= ?descargasApp_ 50000))
	(test(>= ?reviews_ 5000))
	(test(>= ?valoracion_ ?valoracionMin_))
	(test(<= ?precio_ ?precioMax_))
	(test (member$ ?generoApp_ ?genero_))
	(test(or	
		(and (eq ?espacio_ ligera ) (or(<= ?espacioApp_ 3000000) (> ?espacioApp_ 0)))		
		(and (eq ?espacio_ medio  ) (or(<= ?espacioApp_ 15000000) (> ?espacioApp_ 0)))	
		(eq ?espacio_ pesada)
	))
	
	(forall
		(aplicacion 
			(nombre ?nombreApp_2&:
				(and(not (member$ ?nombreApp_2 $?aplicacionesInstaladas_))(neq ?nombreApp_2 ?nombreApp_) (not (member$ ?nombreApp_2 $?listaApps_)) )) 
			(reviews ?reviews_2&:(>= ?reviews_2 5000)) 
			(valoracion ?valoracion_2&:(>= ?valoracion_2 ?valoracionMin_)) 
			(espacio ?espacioApp_2&:(or 
				(and (eq ?espacio_ ligera ) (or(<= ?espacioApp_ 3000000) (> ?espacioApp_ 0)))		
			(and (eq ?espacio_ medio  ) (or(<= ?espacioApp_ 15000000) (> ?espacioApp_ 0)))
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
	(modify ?peticion_ (listaApps (insert$ $?listaApps_ 1 ?nombreApp_)))
	(modify ?appRecomendada_ (nombre ?nombreApp_)) 
	
)

(defrule appRecomendadaValoraciones
	?perfil_ <- (perfil (id ?id_) (aplicacionesInstaladas $?aplicacionesInstaladas_))
	?peticion_ <- (peticion (id ?id_) (prioridad valoracion) (listaApps $?listaApps_) (satisfecha No))
	?recomendacion_ <- (recomendacion (id ?id_) (genero $?genero_) (edadApp ?edad_) (espacio ?espacio_) (precioMaximo ?precioMax_) 
		(ready Si) (valoracionMin ?valoracionMin_))
	?appRecomendada_ <- (appRecomendada (id ?id_) (nombre "") (posPodium ?posPodium_))
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
		(and (eq ?espacio_ ligera ) (or(<= ?espacioApp_ 3000000) (> ?espacioApp_ 0)))		
		(and (eq ?espacio_ medio  ) (or(<= ?espacioApp_ 15000000) (> ?espacioApp_ 0)))
		(eq ?espacio_ pesada)
	))
	
	(forall
		(aplicacion 
			(nombre ?nombreApp_2&:
				(and(not (member$ ?nombreApp_2 $?aplicacionesInstaladas_))(neq ?nombreApp_2 ?nombreApp_) (not (member$ ?nombreApp_2 $?listaApps_)) )) 
			(reviews ?reviews_2&:(>= ?reviews_2 5000)) 
			(valoracion ?valoracion_2&:(>= ?valoracion_2 ?valoracionMin_)) 
			(espacio ?espacioApp_2&:(or 
				(and (eq ?espacio_ ligera ) (or(<= ?espacioApp_ 3000000) (> ?espacioApp_ 0)))		
				(and (eq ?espacio_ medio  ) (or(<= ?espacioApp_ 15000000) (> ?espacioApp_ 0)))
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
	(modify ?peticion_ (listaApps (insert$ $?listaApps_ 1 ?nombreApp_)))
	(modify ?appRecomendada_ (nombre ?nombreApp_)) 
)

(defrule appRecomendadaEspacio
	?perfil_ <- (perfil (id ?id_) (aplicacionesInstaladas $?aplicacionesInstaladas_))
	?peticion_ <- (peticion (id ?id_) (prioridad espacio) (listaApps $?listaApps_) (satisfecha No))
	?recomendacion_ <- (recomendacion (id ?id_) (genero $?genero_) (edadApp ?edad_) (espacio ?espacio_) (precioMaximo ?precioMax_)
		(ready Si) (valoracionMin ?valoracionMin_))
	?appRecomendada_ <- (appRecomendada (id ?id_) (nombre "") (posPodium ?posPodium_))
	?aplicacion_ <- (aplicacion (nombre ?nombreApp_) (valoracion ?valoracion_) (reviews ?reviews_) (espacio ?espacioApp_) (descargas ?descargasApp_)
		(precio ?precio_) (ultimaActualizacion ?ultimaActualizacion_) (androidVersion ?androidVersion_) (genero ?generoApp_) (edad ?edadApp_))
	
	(test (not (member$ ?nombreApp_ ?aplicacionesInstaladas_)))
	
	(test(>= ?edad_ (conversionEdad_Num ?edadApp_)))
	(test(>= ?descargasApp_ 50000))
	(test(>= ?reviews_ 5000))
	(test(>= ?valoracion_ ?valoracionMin_))
	(test(<= ?precio_ ?precioMax_))
	(test (neq (member$ ?generoApp_ ?genero_) FALSE))
	
	;--espacioApp = -1 => Varies with device => suponemos que la app es muy pesada 
	(test(or	
		(and (eq ?espacio_ ligera ) (or(<= ?espacioApp_ 3000000) (> ?espacioApp_ 0)))		
		(and (eq ?espacio_ medio  ) (or(<= ?espacioApp_ 15000000) (> ?espacioApp_ 0)))	
		(eq ?espacio_ pesada)
	))
	
	(forall
		(aplicacion 
			(nombre ?nombreApp_2&:
				(and(not (member$ ?nombreApp_2 $?aplicacionesInstaladas_))(neq ?nombreApp_2 ?nombreApp_) (not (member$ ?nombreApp_2 $?listaApps_)) )) 
			(reviews ?reviews_2&:(>= ?reviews_2 5000)) 
			(valoracion ?valoracion_2&:(>= ?valoracion_2 ?valoracionMin_)) 
			(espacio ?espacioApp_2&:(or 
				(and (eq ?espacio_ ligera ) (or(<= ?espacioApp_ 3000000) (> ?espacioApp_ 0)))		
				(and (eq ?espacio_ medio  ) (or(<= ?espacioApp_ 15000000) (> ?espacioApp_ 0)))
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
	(modify ?peticion_ (listaApps (insert$ $?listaApps_ 1 ?nombreApp_)))
	(modify ?appRecomendada_ (nombre ?nombreApp_)) 
)




(defrule crearAppRecomendada
	?appRecomendada_ <- (appRecomendada (id ?id_) (nombre ?nombre_&:(neq ?nombre_ "")) (posPodium ?posPodium_))
	?peticion_ <- (peticion (id ?id_) (cantidadRecom ?cantidadRecom_) (satisfecha No))
	(not (exists 	(appRecomendada (id ?id_) (posPodium ?posPodium2_))        (test(> ?posPodium2_ ?posPodium_))))
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

(defrule crearRecomendacion
	?peticion_ <- (peticion (id ?id_) (satisfecha No) (listaApps $?listaApps_))
	(test (eq (length$ $?listaApps_) 0))
=>
	(assert (recomendacion (id ?id_)))
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

