(deffacts perfiles_init
	(perfil (id "alguien") (edad 34) (sexo otro) (version "6.0") 
	;(aplicacionesInstaladas 1 2 "350 Diy Room Decor Ideas")
	(genero Comics)
	(gastoTotal 0) (gastoMaximo 0)
	)
	
	(perfil (id "nadie") (edad 12) (sexo hombre) (version "3.0") 
	;(aplicacionesInstaladas 1 2)
	(genero Games Education ArtAndDesign)
	(gastoTotal 10) (gastoMaximo 10)
	)
)

(deffacts peticion_init
	(peticion (id "nadie")
	;(genero Games Casual)
	(edadDestinatario -1)
	(prioridad descargas)
	(espacioMax ligera)
	(valoracionMin 3.33))
)

(deffacts recomendacion_init
	(id "nadie")
)

(defrule x
(declare (salience -5555))
 ?p <- (perfil (id ?id_) (genero $?g))
=>
	(printout t ?id_ "=" (length$ $?g) crlf)
)
;


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
		
		(test (not (member$ ?nombreApp_2 $?aplicacionesInstaladas_)))
	)	
	



(defrule recomendarGeneroPeticionNulaPocasapps_
	(declare (salience -1))
	?perfil_ <- (perfil (id ?id_) (aplicacionesInstaladas $?apps_) (genero $?genPerf_))
	?recomendacion_ <- (recomendacion (id ?id_) (genero $?generoRec_) (ready No))
	?peticion_ <- (peticion (id ?id_) (genero $?genP_)) 
	(test(eq (length$ $?genP_) 0))
	(test(<  (length$ $?apps_) 30))
	(test(eq (length$ $?generoRec_) 0))
=>
	(modify ?recomendacion_ (genero Action Adventure Arcade ArtAndDesign AutoAndVehicles Beauty Board BooksAndReference
		Business Card Casino Casual Comics Communication Dating Education Educational Entertainment Events Finance FoodAndDrink 
		HealthAndFitness HouseAndHome LibrariesAndDemo Lifestyle MapsAndNavigation Medical Music MusicAndAudio NewsAndMagazines 
		Parenting Personalization Photography Productivity Puzzle Racing RolePlaying Shopping Simulation Social Sports Strategy 
		Tools TravelAndLocal Trivia VideoPlayersAndEditors Weather Word))
)


(defrule x
		?recomendacion_ <- (recomendacion (id ?id_) (genero $?generoRec_) (ready Si))
=>
	(printout t ?generoRec_ crlf)
)



