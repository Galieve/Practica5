(deftemplate aplicacion
    (slot nombre (type STRING))
    (slot categoria (type SYMBOL) (allowed-values ART_AND_DESIGN AUTO_AND_VEHICLES BEAUTY BOOKS_AND_REFERENCE BUSINESS COMICS COMMUNICATION DATING EDUCATION 
		ENTERTAINMENT EVENTS FAMILY FINANCE FOOD_AND_DRINK GAME HEALTH_AND_FITNESS HOUSE_AND_HOME LIBRARIES_AND_DEMO LIFESTYLE MAPS_AND_NAVIGATION MEDICAL 
		NEWS_AND_MAGAZINES PARENTING PERSONALIZATION PHOTOGRAPHY PRODUCTIVITY SHOPPING SOCIAL SPORTS TOOLS TRAVEL_AND_LOCAL VIDEO_PLAYERS WEATHER))
    (slot valoracion (type NUMBER) (range 0 5))
	(slot reviews (type INTEGER) (range 0 ?VARIABLE))
	(slot espacio (type INTEGER) (range -1 ?VARIABLE)) ;-1 significa tamaño desconocido
	(slot descargas (type INTEGER) (range 0 ?VARIABLE)) 
	(slot precio (type NUMBER) (range 0 ?VARIABLE))
	(slot edad (type SYMBOL) (allowed-values Adultsonly18+ Everyone Everyone10+ Mature17+ Teen Unrated ))
	(slot genero (type SYMBOL) (allowed-values Action Adventure Arcade ArtAndDesign AutoAndVehicles Beauty Board BooksAndReference
		Business Card Casino Casual Comics Communication Dating Education Educational Entertainment Events Finance FoodAndDrink 
		HealthAndFitness HouseAndHome LibrariesAndDemo Lifestyle MapsAndNavigation Medical Music MusicAndAudio NewsAndMagazines 
		Parenting Personalization Photography Productivity Puzzle Racing RolePlaying Shopping Simulation Social Sports Strategy 
		Tools TravelAndLocal Trivia VideoPlayersAndEditors Weather Word ))
	(slot ultimaActualizacion (type SYMBOL))
	(slot androidVersion (type STRING))
)


(deftemplate perfil
	(slot id (type STRING))
	(slot edad (type INTEGER) (range 0 ?VARIABLE) (default 0))
	(slot sexo (type SYMBOL) (allowed-values hombre mujer otro))
	(slot version (type STRING) )
	(multislot aplicacionesInstaladas (default create$) )
	(multislot genero (default create$)) 
	(slot gastoTotal (type NUMBER) (range 0 ?VARIABLE) (default 0));total 
	(slot gastoMaximo (type NUMBER) (range 0 ?VARIABLE) (default 0))
)


(deftemplate peticion
	(slot id (type STRING))
	(multislot generoPet (default create$))
	(slot edadDestinatario (type INTEGER) (range 0 ?VARIABLE) )
	(slot prioridad (type SYMBOL) (allowed-values espacio descargas valoracion) (default descargas))
	(slot espacioMax (type SYMBOL) (allowed-values ligera medio pesada) (default nil))
	(slot valoracionMin (type NUMBER) (range 0 5) (default 0))
)

(deftemplate recomendacion
	(slot id (type STRING))
	(multislot genero (default create$))
	(slot edadApp (type INTEGER) (range 0 ?VARIABLE) (default nil))
	(slot espacio (type SYMBOL) (allowed-values ligera medio pesada) (default NIL))
	(slot precioMaximo (type NUMBER) (range 0 ?VARIABLE) (default NIL))
	(slot ready (allowed-values Si No) (default No))
)


(deftemplate appRecomendada
	(slot nombre (type STRING) (default nil))
	(slot id (type STRING))
	(slot posPodium (type INTEGER) (range 1 3))
	;(slot satisfecha (default No))
)



;NUMAPPS antes de perfil bueno = 30!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

;----------------------Reglas de gasto------------------------

(defrule recomendarGastoInit
	?perfil_ <- (perfil (id ?id_) (gastoTotal ?gt) (gastoMaximo ?gm) (aplicacionesInstaladas ?apps_))
	?recomendacion_ <- (recomendacion (id ?id_) )
	(< ($(length$ ?apps) 30))
=>
	(modify ?recomendacion_ (precioMaximo ?VARIABLE))
)

(defrule recomendarGastoTotalCero
	?perfil_ <- (perfil (id ?id_) (gastoTotal ?gt) (gastoMaximo ?gm) (aplicacionesInstaladas ?apps_))
	?recomendacion_ <- (recomendacion (id ?id) )
	(eq (?gt 0))
	(>= ($(length$ ?apps) 30))
=>
	(modify ?recomendacion_ (precioMaximo 0))
)

(defrule recomendarGastoCompulsivo
	?perfil_ <- (perfil (id ?id_) (gastoTotal ?gt) (gastoMaximo ?gm) (aplicacionesInstaladas ?apps_))
	?recomendacion_ <- (recomendacion (id ?id) )
	(neq (?gt 0))
	(>= ($(length$ ?apps) 30))
	(>= / (?gt $(length$ ?apps)) 0.63)
=>
	(modify ?recomendacion_ (precioMaximo * ( / (?gt $(length$ ?apps)) 2)))
)


(defrule recomendarGastoNoCompulsivo
	?perfil_ <- (perfil (id ?id_) (gastoTotal ?gt) (gastoMaximo ?gm) (aplicacionesInstaladas ?apps_))
	?recomendacion_ <- (recomendacion (id ?id) )
	(neq (?gt 0))
	(>= (length$ ?apps) 30)
	(< / (?gt (length$ ?apps)) 0.63)
=>
	(modify ?recomendacion_ (precioMaximo ?gm))
)

;-----------------------Reglas de Edad------------------------------

(defrule recomendarEdadPerfil
	?perfil_ <- (perfil (id ?id_) (edad ?ed_))
	?recomendacion_ <- (recomendacion (id ?id) )
	?peticion_ <- (peticion (id ?id_) (edadDestinatario ?edPet_)) 
	(eq (?edPet_ nil))
=>
	(modify ?recomendacion_ (edadApp ?ed_))
)

(defrule recomendarEdadPeticion
	?recomendacion_ <- (recomendacion (id ?id) )
	?peticion_ <- (peticion (id ?id_) (edadDestinatario ?edPet_)) 
	(neq (?edPet_ nil))
=>
	(modify ?recomendacion_ (edadApp ?edPet_))
)

;---------------------------Reglas de Espacio--------------------------------

(defrule recomendarEspacioPedido
	?recomendacion_ <- (recomendacion (id ?id))
	?peticion_ <- (peticion (id ?id_) (espacioMax ?em_)) 
	(neq (?em nil))
=>
	(modify ?recomendacion_ (espacio ?em_))
)

(defrule recomendarPocoEspacio
	?perfil_ <- (perfil (id ?id_) (version ?vers_))
	?recomendacion_ <- (recomendacion (id ?id))
	?peticion_ <- (peticion (id ?id_) (espacioMax ?em_)) 
	(eq ?em nil)
	(or (and (< ?vers_ "6.0") (>= (length$ ?apps) 30)) (and (>= ?vers_ "6.0") (>= (length$ ?apps) 100)))
=>
	(modify ?recomendacion_ (espacio ligera))
)

(defrule recomendarMedioEspacio
	?perfil_ <- (perfil (id ?id_) (version ?vers_))
	?recomendacion_ <- (recomendacion (id ?id))
	?peticion_ <- (peticion (id ?id_) (espacioMax ?em_)) 
	(eq (?em nil))
	(>= ?vers_ "6.0") 
	(>= (length$ ?apps) 30)
	(< (length$ ?apps) 100)
	
=>
	(modify ?recomendacion_ (espacio medio))
)

(defrule recomendarPesadoEspacio
	?perfil_ <- (perfil (id ?id_) (version ?vers_))
	?recomendacion_ <- (recomendacion (id ?id))
	?peticion_ <- (peticion (id ?id_) (espacioMax ?em_)) 
	(eq (?em nil))
	(< (length$ ?apps) 30)
	
=>
	(modify ?recomendacion_ (espacio pesada))
)



;--------------------------Reglas de Género---------------------------------

(defrule recomendarGeneroPeticionNoNula
	?recomendacion_ <- (recomendacion (id ?id))
	?peticion_ <- (peticion (id ?id_) (generoPet ?genP_)) 
	(neq (?genP_ nil))
	
=>
	(modify ?recomendacion_ (genero ?genP_))
)

(defrule recomendarGeneroPeticionNulaMuchasApps
	?perfil_ <- (perfil (id) (aplicacionesInstaladas ?apps_) (genero ?genPerf_))
	?recomendacion_ <- (recomendacion (id ?id))
	?peticion_ <- (peticion (id ?id_) (generoPet ?genP_)) 
	(eq (?genP_ nil))
	(>=  (length$ ?apps) 30)
=>
	(modify ?recomendacion_ (genero ?genPerf_))
)


(defrule recomendarGeneroPeticionNulaPocasApps
	?perfil_ <- (perfil (id) (aplicacionesInstaladas ?apps_) (genero ?genPerf_))
	?recomendacion_ <- (recomendacion (id ?id) (genero $?generoRec_))
	?peticion_ <- (peticion (id ?id_) (generoPet ?genP_)) 
	(eq (?genP_ nil))
	(<  (length$ ?apps) 30)
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
	?recomendacion_ <- (recomendacion (id ?id_) (genero ?genero_) (edadApp ?edad_) (espacio ?espacio_) (precioMaximo ?preciMax_) (ready No))
	(neq (?genero_ nil))
	(neq (?edad_ nil)
	(neq (?espacio_ nil))
	(neq (?precioMax_ nil))
=>
	(modify ?recomendacion_ (ready Si))
	(assert (appRecomendada (id ?id_) (posPodium 1)))
)
;Pedir pospodium < 3
;-------------------------------------------------------------------------

(deffunction conversionEdad_Num (?edadApp_)
	(if (eq (?edadApp_  Everyone)) then 0
	else (
		if (eq (?edadApp_ Everyone10+) then 10)
		else (
			if (eq (?edadApp_ Teen) then 13)
			else (
				if (eq (?edadApp_ Mature17+) then 17)
				else (18)
				)
			)
		)
	)
)

(defrule recomendarDescargas
	?perfil_ <- (perfil (id ?id_) (aplicacionesInstaladas ?aplicacionesInstaladas_))
	?peticion_ <- (peticion (id ?id_) (prioridad descargas))
	?recomendacion_ <- (recomendacion (id ?id_) (genero ?genero_) (edadApp ?edad_) (espacio ?espacio_) (precioMaximo ?preciMax_) (ready Si))
	?appRecomendada_ <- (appRecomendada (id ?id_) (nombre ?nombre_) (posPodium ?posPodium_))
	(eq (?nombre_ nil))
	?aplicacion_ <- (aplicacion (nombre ?nombreApp_) (valoracion ?valoracion_) (reviews ?reviews_) (espacio ?espacioApp_) (descargas ?descargasApp_)
		(precio ?precio_) (ultimaActualizacion ?ultimaActualizacion_) (androidVersion ?androidVersion_) (genero ?generoApp_) (edad ?edadApp_))
	
	(test (not (member$ ?nombreApp_ ?aplicacionesInstaladas_)))
	
	(>= (?edad_ (conversionEdad_Num ?edadApp_)))
	(>= (?descargasApp_ 50000))
	(>= (?reviews 5000))
	(>= (?valoracion 3.5))
	(<= (?precio_ ?preciMax_))
	(member$ ?generoApp_ ?genero_)
	(or (	
		(and (eq (?espacio_ ligera) ) (<= (?espacioApp_ 3000000)) )		
		(and (eq (?espacio_ medio)  ) (<=(espacioApp_ 15000000)))	
		)
	)
	
	
	
	(forall (aplicacion  (nombre ?nombreApp_2) (valoracion ?valoracion_2) (descargas ?descargasApp_2)
		(genero ?generoApp_2) (edad ?edadApp_2) )
		(test (>= (?edad_ (conversionEdad_Num ?edadApp_))))
		(test (>= (?descargasApp_ 50000)))
		(test (>= (?reviews 5000)))
		(test (>= (?valoracion 3.5)))
		(test (<= (?precio_ ?preciMax_)))
		(test (member$ ?generoApp_ ?genero_))
		(test (or (	
			(and (eq (?espacio_ ligera) ) (<= (?espacioApp_ 3000000)) )		
			(and (eq (?espacio_ medio)  ) (<=(espacioApp_ 15000000)))	
			)
		))
		(test ( 
			or 	
				(		
					(> (?descargasApp_ ?descargasApp_2) )	 
					(and ((eq (?descargasApp_ ?descargasApp_2)) (>=(?valoracion_ ?valoracion_2))))
					)	
				))
		(test (not (member$ ?nombreApp_2 ?aplicacionesInstaladas_)))
	)
	(forall (appRecomendada (nombre ?nombre_2) (id ?id_) )
	(test (neq (?nombre_2 ?nombre_)))
	)

=>
	(modify ?appRecomendada_ (nombre ?nombre_))
	
)



(defrule recomendarValoracion
	?perfil_ <- (perfil (id ?id_) (aplicacionesInstaladas ?aplicacionesInstaladas_))
	?peticion_ <- (peticion (id ?id_) (prioridad valoracion))
	?recomendacion_ <- (recomendacion (id ?id_) (genero ?genero_) (edadApp ?edad_) (espacio ?espacio_) (precioMaximo ?preciMax_) (ready Si))
	?appRecomendada_ <- (appRecomendada (id ?id_) (nombre ?nombre_) (posPodium ?posPodium_))
	(eq (?nombre_ nil))
	?aplicacion_ <- (aplicacion (nombre ?nombreApp_) (valoracion ?valoracion_) (reviews ?reviews_) (espacio ?espacioApp_) (descargas ?descargasApp_)
		(precio ?precio_) (ultimaActualizacion ?ultimaActualizacion_) (androidVersion ?androidVersion_) (genero ?generoApp_) (edad ?edadApp_))
	
	(test (not (member$ ?nombreApp_ ?aplicacionesInstaladas_)))
	
	(>= (?edad_ (conversionEdad_Num ?edadApp_)))
	(>= (?descargasApp_ 50000))
	(>= (?reviews 5000))
	(>= (?valoracion 3.5))
	(<= (?precio_ ?preciMax_))
	(member$ ?generoApp_ ?genero_)
	(or (	
		(and (eq (?espacio_ ligera) ) (<= (?espacioApp_ 3000000)) )		
		(and (eq (?espacio_ medio)  ) (<=(espacioApp_ 15000000)))	
		)
	)
	
	
	
	(forall (aplicacion  (nombre ?nombreApp_2) (valoracion ?valoracion_2) (descargas ?descargasApp_2)
		(genero ?generoApp_2) (edad ?edadApp_2) )
		(test (>= (?edad_ (conversionEdad_Num ?edadApp_))))
		(test (>= (?descargasApp_ 50000)))
		(test (>= (?reviews 5000)))
		(test (>= (?valoracion 3.5)))
		(test (<= (?precio_ ?preciMax_)))
		(test (member$ ?generoApp_ ?genero_))
		(test (or (	
			(and (eq (?espacio_ ligera) ) (<= (?espacioApp_ 3000000)) )		
			(and (eq (?espacio_ medio)  ) (<=(espacioApp_ 15000000)))	
			)
		))
		(test ( 
			or 	
				(		
					(> (?valoracion_ ?valoracion_2) )	 
					(and ((eq (?valoracion_ ?valoracion_2)) (>=(?descargasApp_ ?descargasApp_2))))
					)	
				))
		(test (not (member$ ?nombreApp_2 ?aplicacionesInstaladas_)))
	)
	(forall (appRecomendada (nombre ?nombre_2) (id ?id_) )
	(test (neq (?nombre_2 ?nombre_)))
	)

=>
	(modify ?appRecomendada_ (nombre ?nombre_))
	
)



(defrule recomendarEspacio
	?perfil_ <- (perfil (id ?id_) (aplicacionesInstaladas ?aplicacionesInstaladas_))
	?peticion_ <- (peticion (id ?id_) (prioridad espacio))
	?recomendacion_ <- (recomendacion (id ?id_) (genero ?genero_) (edadApp ?edad_) (espacio ?espacio_) (precioMaximo ?preciMax_) (ready Si))
	?appRecomendada_ <- (appRecomendada (id ?id_) (nombre ?nombre_) (posPodium ?posPodium_))
	(eq (?nombre_ nil))
	?aplicacion_ <- (aplicacion (nombre ?nombreApp_) (valoracion ?valoracion_) (reviews ?reviews_) (espacio ?espacioApp_) (descargas ?descargasApp_)
		(precio ?precio_) (ultimaActualizacion ?ultimaActualizacion_) (androidVersion ?androidVersion_) (genero ?generoApp_) (edad ?edadApp_))
	
	(test (not (member$ ?nombreApp_ ?aplicacionesInstaladas_)))
	
	(>= (?edad_ (conversionEdad_Num ?edadApp_)))
	(>= (?descargasApp_ 50000))
	(>= (?reviews 5000))
	(>= (?valoracion 3.5))
	(<= (?precio_ ?preciMax_))
	(member$ ?generoApp_ ?genero_)
	(or (	
		(and (eq (?espacio_ ligera) ) (<= (?espacioApp_ 3000000)) )		
		(and (eq (?espacio_ medio)  ) (<=(espacioApp_ 15000000)))	
		)
	)
	
	
	
	(forall (aplicacion  (nombre ?nombreApp_2) (valoracion ?valoracion_2) (espacio ?espacioApp_2) 
		(genero ?generoApp_2) (edad ?edadApp_2) )
		(test (>= (?edad_ (conversionEdad_Num ?edadApp_))))
		(test (>= (?descargasApp_ 50000)))
		(test (>= (?reviews 5000)))
		(test (>= (?valoracion 3.5)))
		(test (<= (?precio_ ?preciMax_)))
		(test (member$ ?generoApp_ ?genero_))
		(test (or (	
			(and (eq (?espacio_ ligera) ) (<= (?espacioApp_ 3000000)) )		
			(and (eq (?espacio_ medio)  ) (<=(espacioApp_ 15000000)))	
			)
		))
		(test ( 
			or 	
				(		
					(> (?espacioApp_ ?espacioApp_2) )	 
					(and ((eq (?espacioApp_ ?espacioApp_2)) (>=(?valoracion_ ?valoracion_2))))
					)	
				))
		(test (not (member$ ?nombreApp_2 ?aplicacionesInstaladas_)))
	)
	(forall (appRecomendada (nombre ?nombre_2) (id ?id_) )
	(test (neq (?nombre_2 ?nombre_)))
	)

=>
	(modify ?appRecomendada_ (nombre ?nombre_))
	
)



(defrule crearAppRecomendada
	?appRecomendada_ <- (appRecomendada (id ?id_) (nombre ?nombre_) (posPodium ?posPodium_))
	(neq ?nombre_ nil)
	(not (exists 	(appRecomendada (id ?id_) (posPodium ?pos_Podium2))        (test(> (?pos_Podium2_ ?posPodium_)))))
	(< (?posPodium_ 3))
=>
	(assert (appRecomendada (id ?id_)		(posPodium	(+ (?posPodium_ 1)	) )))
)


