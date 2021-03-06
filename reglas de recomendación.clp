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
	(modify ?recomendacion_ (precioMaximo (* ?gm 1.2)))
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

;---------------------------Reglas de Version--------------------------------

(defrule recomendarVersion
	?recomendacion_ <- (recomendacion (id ?id_) (ready No) (version "") )
	?perfil_ <- (perfil (id ?id_) (version ?v)) 
=>
	(modify ?recomendacion_ (version ?v))		
)

;---------------------------Reglas de Espacio--------------------------------

(defrule recomendarEspacioPedido
	?recomendacion_ <- (recomendacion (id ?id_) (ready No) (espacio null) )
	?peticion_ <- (peticion (id ?id_) (espacio ?em_&:(neq ?em_ null)) (satisfecha No)) 
=>
	(modify ?recomendacion_ (espacio ?em_))
)

(defrule recomendarPocoEspacio
	?perfil_ <- (perfil (id ?id_) (version ?vers_) (aplicacionesInstaladas $?apps_))
	?recomendacion_ <- (recomendacion (id ?id_) (ready No) (espacio null))
	?peticion_ <- (peticion (id ?id_) (espacio null) (satisfecha No)) 
	(test (or (and (< (str-compare ?vers_ "6.0") 0) (>= (length$ $?apps_) 30)) (and (>= (str-compare ?vers_ "6.0") 0) (>= (length$ $?apps_) 100))))
=>
	(modify ?recomendacion_ (espacio ligera))
)

(defrule recomendarMedioEspacio
	?perfil_ <- (perfil (id ?id_) (version ?vers_) (aplicacionesInstaladas $?apps_))
	?recomendacion_ <- (recomendacion (id ?id_) (ready No) (espacio null) )
	?peticion_ <- (peticion (id ?id_) (espacio null) (satisfecha No)) 
	(test(>= (str-compare ?vers_ "6.0") 0) )
	(test(>= (length$ $?apps_) 30))
	(test(< (length$ $?apps_) 100))
	
=>
	(modify ?recomendacion_ (espacio medio))
)

(defrule recomendarPesadoEspacio
	?perfil_ <- (perfil (id ?id_) (version ?vers_) (aplicacionesInstaladas $?apps_))
	?recomendacion_ <- (recomendacion (id ?id_) (ready No) (espacio null))
	?peticion_ <- (peticion (id ?id_) (espacio null) (satisfecha No)) 
	(test(< (length$ $?apps_) 30))
	
=>
	(modify ?recomendacion_ (espacio pesada))
)
	
;----------------------Fin de la recomendación----------------------------

(defrule setReady
	(declare (salience -11))
	?recomendacion_ <- (recomendacion (id ?id_) (genero $?genero_) (edadApp  ~-1) 
		(espacio ~null) (precioMaximo ~-1) (version ~"") (ready No))
	(test(neq (length$ $?genero_) 0))
=>
	(modify ?recomendacion_ (ready Si))
	(assert (appRecomendada (id ?id_) (posPodium 1)))
)
;----------------------Seleccionar la mejor aplicación-------------------------


(defrule appRecomendadaDescargas
	?perfil_ <- (perfil (id ?id_) (aplicacionesInstaladas $?aplicacionesInstaladas_))
	?peticion_ <- (peticion (id ?id_) (prioridad descargas) (listaApps $?listaApps_) (satisfecha No))
	?recomendacion_ <- (recomendacion (id ?id_) (genero $?genero_) (edadApp ?edad_) (espacio ?espacio_) (precioMaximo ?precioMax_)
		(ready Si)(valoracionMin ?valoracionMin_) (version ?version_))
	?appRecomendada_ <- (appRecomendada (id ?id_) (nombre "") (posPodium ?posPodium_))
	?aplicacion_ <- (aplicacion (nombre ?nombreApp_) (valoracion ?valoracion_) (reviews ?reviews_) (espacio ?espacioApp_) (descargas ?descargasApp_)
		(precio ?precio_) (androidVersion ?androidVersion_) (genero ?generoApp_) (edad ?edadApp_))
	
	(test (not (member$ ?nombreApp_ ?aplicacionesInstaladas_)))
	(test (or (> (str-compare ?version_ ?androidVersion_) 0) (eq ?androidVersion_ "Varies with device")))
	(test(>= ?edad_ (conversionEdad_Num ?edadApp_)))
	(test(>= ?descargasApp_ 50000))
	(test(>= ?reviews_ 5000))
	(test(>= ?valoracion_ ?valoracionMin_))
	(test(<= ?precio_ ?precioMax_))
	(test (member$ ?generoApp_ ?genero_))
	(test(or	
		(and (eq ?espacio_ ligera ) (<= ?espacioApp_ 15000000) (> ?espacioApp_ 0))		
		(and (eq ?espacio_ medio  ) (<= ?espacioApp_ 50000000) (> ?espacioApp_ 0))	
		(eq ?espacio_ pesada)
	))
	
	(not
		(aplicacion 
			(nombre ?nombreApp_2&:
				(and(not (member$ ?nombreApp_2 $?aplicacionesInstaladas_))(neq ?nombreApp_2 ?nombreApp_) (not (member$ ?nombreApp_2 $?listaApps_)) )) 
			(reviews ?reviews_2&:(>= ?reviews_2 5000)) 
			(valoracion ?valoracion_2&:(>= ?valoracion_2 ?valoracionMin_))
			(precio ?precio_2&:(<= ?precio_2 ?precioMax_))
			
			(espacio ?espacioApp_2&:(or 
				(and (eq ?espacio_ ligera ) (<= ?espacioApp_2 15000000) (> ?espacioApp_2 0))	
				(and (eq ?espacio_ medio  ) (<= ?espacioApp_2 50000000) (> ?espacioApp_2 0))
				(eq ?espacio_ pesada))) 
			(descargas ?descargasApp_2&:(and				
				(>= ?descargasApp_2 50000)
				(or
					(< ?descargasApp_ ?descargasApp_2)
					(and (eq ?descargasApp_ ?descargasApp_2) (< ?valoracion_ ?valoracion_2))
					(and (eq ?descargasApp_ ?descargasApp_2) (eq ?valoracion_ ?valoracion_2) (> ?espacioApp_ ?espacioApp_2))
					(and (eq ?descargasApp_ ?descargasApp_2) (eq ?valoracion_ ?valoracion_2) (eq ?espacioApp_ ?espacioApp_2) (> ?precio_ ?precio_2))
				)
			))			 
			(genero ?generoApp_2&:(member$ ?generoApp_2 ?genero_))
			(edad ?edadApp_2&:(>= ?edad_ (conversionEdad_Num ?edadApp_2)))
			(androidVersion ?androidVersion_2&:(> (str-compare ?version_ ?androidVersion_2)0))
		)
	)
	(test (not (member$ ?nombreApp_ $?listaApps_)))
	

	
=>
	(modify ?peticion_ (listaApps (insert$ $?listaApps_ 1 ?nombreApp_)))
	(modify ?appRecomendada_ (nombre ?nombreApp_)) 
	
)


(defrule appRecomendadaValoraciones
	?perfil_ <- (perfil (id ?id_) (aplicacionesInstaladas $?aplicacionesInstaladas_))
	?peticion_ <- (peticion (id ?id_) (prioridad valoracion) (listaApps $?listaApps_) (satisfecha No))
	?recomendacion_ <- (recomendacion (id ?id_) (genero $?genero_) (edadApp ?edad_) (espacio ?espacio_) (precioMaximo ?precioMax_) 
		(ready Si) (valoracionMin ?valoracionMin_) (version ?version_))
	?appRecomendada_ <- (appRecomendada (id ?id_) (nombre "") (posPodium ?posPodium_))
	?aplicacion_ <- (aplicacion (nombre ?nombreApp_) (valoracion ?valoracion_) (reviews ?reviews_) (espacio ?espacioApp_) (descargas ?descargasApp_)
		(precio ?precio_) (androidVersion ?androidVersion_) (genero ?generoApp_) (edad ?edadApp_))
	
	(test (not (member$ ?nombreApp_ ?aplicacionesInstaladas_)))
	(test (or (> (str-compare ?version_ ?androidVersion_) 0) (eq ?androidVersion_ "Varies with device")))
	(test(>= ?edad_ (conversionEdad_Num ?edadApp_)))
	(test(>= ?descargasApp_ 50000))
	(test(>= ?reviews_ 5000))
	(test(>= ?valoracion_ ?valoracionMin_))
	(test(<= ?precio_ ?precioMax_))
	(test (neq (member$ ?generoApp_ ?genero_) FALSE))

	(test(or	
		(and (eq ?espacio_ ligera ) (<= ?espacioApp_ 15000000) (> ?espacioApp_ 0))	
		(and (eq ?espacio_ medio  ) (<= ?espacioApp_ 50000000) (> ?espacioApp_ 0))
		(eq ?espacio_ pesada)
	))
	
	(not
		(aplicacion 
			(nombre ?nombreApp_2&:
				(and(not (member$ ?nombreApp_2 $?aplicacionesInstaladas_))(neq ?nombreApp_2 ?nombreApp_) (not (member$ ?nombreApp_2 $?listaApps_)) )) 
			(reviews ?reviews_2&:(>= ?reviews_2 5000)) 
			(valoracion ?valoracion_2&:(>= ?valoracion_2 ?valoracionMin_)) 
			(espacio ?espacioApp_2&:(or 
				(and (eq ?espacio_ ligera ) (<= ?espacioApp_ 15000000) (> ?espacioApp_2 0))		
				(and (eq ?espacio_ medio  ) (<= ?espacioApp_ 50000000) (> ?espacioApp_2 0))
				(eq ?espacio_ pesada)))
			(precio ?precio_2&:(<= ?precio_2 ?precioMax_)) 				
			(descargas ?descargasApp_2&:(and
				(>= ?descargasApp_2 50000)
				(or		
					(< ?valoracion_ ?valoracion_2)	 
					(and (eq ?valoracion_ ?valoracion_2) (< ?descargasApp_ ?descargasApp_2))
					(and (eq ?valoracion_ ?valoracion_2) (eq ?descargasApp_ ?descargasApp_2) (> ?espacioApp_ ?espacioApp_2))
					(and (eq ?espacioApp_ ?espacioApp_2) (eq ?descargasApp_ ?descargasApp_2) (eq ?valoracion_ ?valoracion_2) (> ?precio_ ?precio_2))	
				)
			))
			(genero ?generoApp_2&:(member$ ?generoApp_2 ?genero_))
			(edad ?edadApp_2&:(>= ?edad_ (conversionEdad_Num ?edadApp_2)))
			(androidVersion ?androidVersion_2&:(or (> (str-compare ?version_ ?androidVersion_2) 0) (eq ?androidVersion_ "Varies with device")))
		)
	)
	(test (not (member$ ?nombreApp_ $?listaApps_)))	
=>
	(modify ?peticion_ (listaApps (insert$ $?listaApps_ 1 ?nombreApp_)))
	(modify ?appRecomendada_ (nombre ?nombreApp_)) 
)

(defrule appRecomendadaEspacio
	?perfil_ <- (perfil (id ?id_) (aplicacionesInstaladas $?aplicacionesInstaladas_))
	?peticion_ <- (peticion (id ?id_) (prioridad espacio) (listaApps $?listaApps_) (satisfecha No))
	?recomendacion_ <- (recomendacion (id ?id_) (genero $?genero_) (edadApp ?edad_) (espacio ?espacio_) (precioMaximo ?precioMax_)
		(ready Si) (valoracionMin ?valoracionMin_) (version ?version_))
	?appRecomendada_ <- (appRecomendada (id ?id_) (nombre "") (posPodium ?posPodium_))
	?aplicacion_ <- (aplicacion (nombre ?nombreApp_) (valoracion ?valoracion_) (reviews ?reviews_) (espacio ?espacioApp_) (descargas ?descargasApp_)
		(precio ?precio_) (androidVersion ?androidVersion_) (genero ?generoApp_) (edad ?edadApp_))
	
	(test (not (member$ ?nombreApp_ ?aplicacionesInstaladas_)))
	(test (or (> (str-compare ?version_ ?androidVersion_) 0) (eq ?androidVersion_ "Varies with device")))
	(test(>= ?edad_ (conversionEdad_Num ?edadApp_)))
	(test(>= ?descargasApp_ 50000))
	(test(>= ?reviews_ 5000))
	(test(>= ?valoracion_ ?valoracionMin_))
	(test(<= ?precio_ ?precioMax_))
	(test (neq (member$ ?generoApp_ ?genero_) FALSE))
	
	;--espacioApp = -1 => Varies with device => suponemos que la app es muy pesada 
	(test(or	
		(and (eq ?espacio_ ligera ) (<= ?espacioApp_ 15000000) (> ?espacioApp_ 0))	
		(and (eq ?espacio_ medio  ) (<= ?espacioApp_ 50000000) (> ?espacioApp_ 0))
		(eq ?espacio_ pesada)
	))
	(not(aplicacion 
			(nombre ?nombreApp_2&:
				(and(not (member$ ?nombreApp_2 $?aplicacionesInstaladas_))(neq ?nombreApp_2 ?nombreApp_) (not (member$ ?nombreApp_2 $?listaApps_)) )) 
			(reviews ?reviews_2&:(>= ?reviews_2 5000)) 
			(valoracion ?valoracion_2&:(>= ?valoracion_2 ?valoracionMin_)) 
			(descargas ?descargasApp_2&:(>= ?descargasApp_2 50000))
			(precio ?precio_2&:(<= ?precio_2 ?precioMax_)) 
			(espacio ?espacioApp_2&:(and
				(or 
					(and (eq ?espacio_ ligera ) (<= ?espacioApp_ 15000000) (> ?espacioApp_2 0))		
					(and (eq ?espacio_ medio  ) (<= ?espacioApp_ 50000000) (> ?espacioApp_2 0))
					(eq ?espacio_ pesada)
				)
				(or		
					(> ?espacioApp_ ?espacioApp_2)	 
					(and (eq ?espacioApp_ ?espacioApp_2) (< ?descargasApp_ ?descargasApp_2))
					(and (eq ?espacioApp_ ?espacioApp_2) (eq ?descargasApp_ ?descargasApp_2) (< ?valoracion_ ?valoracion_2))
					(and (eq ?espacioApp_ ?espacioApp_2) (eq ?descargasApp_ ?descargasApp_2) (eq ?valoracion_ ?valoracion_2) (> ?precio_ ?precio_2))	


				)
			))
			(genero ?generoApp_2&:(member$ ?generoApp_2 ?genero_))
			(edad ?edadApp_2&:(>= ?edad_ (conversionEdad_Num ?edadApp_2)))
			(androidVersion ?androidVersion_2&:(or (> (str-compare ?version_ ?androidVersion_2) 0) (eq ?androidVersion_ "Varies with device")))
		)
	
	)
	(test (not (member$ ?nombreApp_ $?listaApps_)))
	
=>
	(modify ?peticion_ (listaApps (insert$ $?listaApps_ 1 ?nombreApp_)))
	(modify ?appRecomendada_ (nombre ?nombreApp_)) 
)

(defrule appRecomendadaPrecioAsc
	?perfil_ <- (perfil (id ?id_) (aplicacionesInstaladas $?aplicacionesInstaladas_))
	?peticion_ <- (peticion (id ?id_) (prioridad precioAsc) (listaApps $?listaApps_) (satisfecha No))
	?recomendacion_ <- (recomendacion (id ?id_) (genero $?genero_) (edadApp ?edad_) (espacio ?espacio_) (precioMaximo ?precioMax_)
		(ready Si) (valoracionMin ?valoracionMin_) (version ?version_))
	?appRecomendada_ <- (appRecomendada (id ?id_) (nombre "") (posPodium ?posPodium_))
	?aplicacion_ <- (aplicacion (nombre ?nombreApp_) (valoracion ?valoracion_) (reviews ?reviews_) (espacio ?espacioApp_) (descargas ?descargasApp_)
		(precio ?precio_) (androidVersion ?androidVersion_) (genero ?generoApp_) (edad ?edadApp_))
	
	(test (not (member$ ?nombreApp_ ?aplicacionesInstaladas_)))
	(test (or (> (str-compare ?version_ ?androidVersion_) 0) (eq ?androidVersion_ "Varies with device")))
	(test(>= ?edad_ (conversionEdad_Num ?edadApp_)))
	(test(>= ?descargasApp_ 50000))
	(test(>= ?reviews_ 5000))
	(test(>= ?valoracion_ ?valoracionMin_))
	(test(<= ?precio_ ?precioMax_))
	(test (neq (member$ ?generoApp_ ?genero_) FALSE))
	
	;--espacioApp = -1 => Varies with device => suponemos que la app es muy pesada 
	(test(or	
		(and (eq ?espacio_ ligera ) (<= ?espacioApp_ 15000000) (> ?espacioApp_ 0))	
		(and (eq ?espacio_ medio  ) (<= ?espacioApp_ 50000000) (> ?espacioApp_ 0))
		(eq ?espacio_ pesada)
	))
	(not(aplicacion 
			(nombre ?nombreApp_2&:
				(and(not (member$ ?nombreApp_2 $?aplicacionesInstaladas_))(neq ?nombreApp_2 ?nombreApp_) (not (member$ ?nombreApp_2 $?listaApps_)) )) 
			(reviews ?reviews_2&:(>= ?reviews_2 5000)) 
			(valoracion ?valoracion_2&:(>= ?valoracion_2 ?valoracionMin_)) 
			(descargas ?descargasApp_2&:(>= ?descargasApp_2 50000))
			(precio ?precio_2&:(<= ?precio_2 ?precioMax_)) 
			(espacio ?espacioApp_2&:(and
				(or 
					(and (eq ?espacio_ ligera ) (<= ?espacioApp_ 15000000) (> ?espacioApp_2 0))		
					(and (eq ?espacio_ medio  ) (<= ?espacioApp_ 50000000) (> ?espacioApp_2 0))
					(eq ?espacio_ pesada)
				)
				(or	
					(> ?precio_ ?precio_2)
					(and (eq ?precio_ ?precio_2) (< ?descargasApp_ ?descargasApp_2))
					(and (eq ?precio_ ?precio_2) (eq ?descargasApp_ ?descargasApp_2) (< ?valoracion_ ?valoracion_2))
					(and (eq ?precio_ ?precio_2) (eq ?descargasApp_ ?descargasApp_2) (eq ?valoracion_ ?valoracion_2) (> ?espacioApp_ ?espacioApp_2))	


				)
			))
			(genero ?generoApp_2&:(member$ ?generoApp_2 ?genero_))
			(edad ?edadApp_2&:(>= ?edad_ (conversionEdad_Num ?edadApp_2)))
			(androidVersion ?androidVersion_2&:(or (> (str-compare ?version_ ?androidVersion_2) 0) (eq ?androidVersion_ "Varies with device")))
		)
	
	)
	(test (not (member$ ?nombreApp_ $?listaApps_)))
	
=>
	(modify ?peticion_ (listaApps (insert$ $?listaApps_ 1 ?nombreApp_)))
	(modify ?appRecomendada_ (nombre ?nombreApp_)) 
)

(defrule appRecomendadaPrecioDesc
	?perfil_ <- (perfil (id ?id_) (aplicacionesInstaladas $?aplicacionesInstaladas_))
	?peticion_ <- (peticion (id ?id_) (prioridad precioDesc) (listaApps $?listaApps_) (satisfecha No))
	?recomendacion_ <- (recomendacion (id ?id_) (genero $?genero_) (edadApp ?edad_) (espacio ?espacio_) (precioMaximo ?precioMax_)
		(ready Si) (valoracionMin ?valoracionMin_) (version ?version_))
	?appRecomendada_ <- (appRecomendada (id ?id_) (nombre "") (posPodium ?posPodium_))
	?aplicacion_ <- (aplicacion (nombre ?nombreApp_) (valoracion ?valoracion_) (reviews ?reviews_) (espacio ?espacioApp_) (descargas ?descargasApp_)
		(precio ?precio_) (androidVersion ?androidVersion_) (genero ?generoApp_) (edad ?edadApp_))
	
	(test (not (member$ ?nombreApp_ ?aplicacionesInstaladas_)))
	(test (or (> (str-compare ?version_ ?androidVersion_) 0) (eq ?androidVersion_ "Varies with device")))
	(test(>= ?edad_ (conversionEdad_Num ?edadApp_)))
	(test(>= ?descargasApp_ 50000))
	(test(>= ?reviews_ 5000))
	(test(>= ?valoracion_ ?valoracionMin_))
	(test(<= ?precio_ ?precioMax_))
	(test (neq (member$ ?generoApp_ ?genero_) FALSE))
	
	;--espacioApp = -1 => Varies with device => suponemos que la app es muy pesada 
	(test(or	
		(and (eq ?espacio_ ligera ) (<= ?espacioApp_ 15000000) (> ?espacioApp_ 0))	
		(and (eq ?espacio_ medio  ) (<= ?espacioApp_ 50000000) (> ?espacioApp_ 0))
		(eq ?espacio_ pesada)
	))
	(not(aplicacion 
			(nombre ?nombreApp_2&:
				(and(not (member$ ?nombreApp_2 $?aplicacionesInstaladas_))(neq ?nombreApp_2 ?nombreApp_) (not (member$ ?nombreApp_2 $?listaApps_)) )) 
			(reviews ?reviews_2&:(>= ?reviews_2 5000)) 
			(valoracion ?valoracion_2&:(>= ?valoracion_2 ?valoracionMin_)) 
			(descargas ?descargasApp_2&:(>= ?descargasApp_2 50000))
			(precio ?precio_2&:(<= ?precio_2 ?precioMax_)) 
			(espacio ?espacioApp_2&:(and
				(or 
					(and (eq ?espacio_ ligera ) (<= ?espacioApp_ 15000000) (> ?espacioApp_2 0))		
					(and (eq ?espacio_ medio  ) (<= ?espacioApp_ 50000000) (> ?espacioApp_2 0))
					(eq ?espacio_ pesada)
				)
				(or	
					(< ?precio_ ?precio_2)
					(and (eq ?precio_ ?precio_2) (< ?descargasApp_ ?descargasApp_2))
					(and (eq ?precio_ ?precio_2) (eq ?descargasApp_ ?descargasApp_2) (< ?valoracion_ ?valoracion_2))
					(and (eq ?precio_ ?precio_2) (eq ?descargasApp_ ?descargasApp_2) (eq ?valoracion_ ?valoracion_2) (> ?espacioApp_ ?espacioApp_2))	


				)
			))
			(genero ?generoApp_2&:(member$ ?generoApp_2 ?genero_))
			(edad ?edadApp_2&:(>= ?edad_ (conversionEdad_Num ?edadApp_2)))
			(androidVersion ?androidVersion_2&:(or (> (str-compare ?version_ ?androidVersion_2) 0) (eq ?androidVersion_ "Varies with device")))
		)
	
	)
	(test (not (member$ ?nombreApp_ $?listaApps_)))
	
=>
	(modify ?peticion_ (listaApps (insert$ $?listaApps_ 1 ?nombreApp_)))
	(modify ?appRecomendada_ (nombre ?nombreApp_)) 
)