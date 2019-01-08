;--------------------------Reglas de Género---------------------------------

(defrule recomendarGeneroPeticionNoNula
	?recomendacion_ <- (recomendacion (id ?id_) (ready No) (genero $?generoRec_&:(eq (length$ $?generoRec_) 0)))
	?peticion_ <- (peticion (id ?id_) (genero $?genP_) (satisfecha No))
	(test (neq (length$ $?genP_) 0))
=>
	(modify ?recomendacion_ (genero ?genP_))
)

(defrule recomendarGeneroPeticionNulaMuchasApps
	?perfil_ <- (perfil (id ?id_) (aplicacionesInstaladas $?apps_) (genero $?genPerf_))
	?recomendacion_ <- (recomendacion (id ?id_) (genero $?generoRec_) (ready No) )
	?peticion_ <- (peticion (id ?id_) (genero $?genP_&:(eq  (length$ $?genP_) 0)) (satisfecha No))
	(test (eq (length$ $?generoRec_) 0))
	(test(>=  (length$ $?apps_) 30))	
=>
	(modify ?recomendacion_ (genero ?genPerf_))
)

(defrule recomendarGenero_PetNula_Joven
	?perfil_ <- (perfil (id ?id_) (aplicacionesInstaladas $?apps_) (genero $?genPerf_) (edad ?edad_&:(and(>= ?edad_ 18) (< ?edad_ 30))))
	?recomendacion_ <- (recomendacion (id ?id_) (genero $?generoRec_) (ready No))
	?peticion_ <- (peticion (id ?id_) (genero $?genPet_) (satisfecha No)) 
	(test(eq (length$ $?genPet_) 0))
	(test(<  (length$ $?apps_) 30))
	(test (or
		(not (member$ Social $?generoRec_))
		(not (member$ Dating $?generoRec_))
		(not (member$ Shopping $?generoRec_))
		(not (member$ Comics $?generoRec_))
		(not (member$ Personalization $?generoRec_))
		(not (member$ Photography $?generoRec_))
		(not (member$ Music $?generoRec_))
		(not (member$ MusicAndAudio $?generoRec_))
		(not (member$ Communication $?generoRec_))

	))
=>
	(bind $?generoRec_ (insertListElementoUnico
		(create$ Social Dating Shopping Comics Personalization Photography Music MusicAndAudio Communication)
		?generoRec_))
	(modify ?recomendacion_ (genero $?generoRec_))
)

(defrule recomendarGenero_PetNula_Adulto
	?perfil_ <- (perfil (id ?id_) (aplicacionesInstaladas $?apps_) (genero $?genPerf_) (edad ?edad_&:(and(>= ?edad_ 30) (< ?edad_ 50))))
	?recomendacion_ <- (recomendacion (id ?id_) (genero $?generoRec_) (ready No))
	?peticion_ <- (peticion (id ?id_) (genero $?genPet_) (satisfecha No)) 
	(test(eq (length$ $?genPet_) 0))
	(test(<  (length$ $?apps_) 30))
	(test (or
		(not (member$ Business $?generoRec_))
		(not (member$ Lifestyle $?generoRec_))
		(not (member$ HealthAndFitness $?generoRec_))
		(not (member$ NewsAndMagazines $?generoRec_))
		(not (member$ Finance $?generoRec_))
		(not (member$ Communication $?generoRec_))
	))
=>
	(bind $?generoRec_ (insertListElementoUnico(create$ Business Lifestyle HealthAndFitness NewsAndMagazines Finance Communication) ?generoRec_))
	(modify ?recomendacion_ (genero $?generoRec_))

)

(defrule recomendarGenero_PetNula_MasAdulto
	?perfil_ <- (perfil (id ?id_) (aplicacionesInstaladas $?apps_) (genero $?genPerf_) (edad ?edad_&:(>= ?edad_ 50) ))
	?recomendacion_ <- (recomendacion (id ?id_) (genero $?generoRec_) (ready No))
	?peticion_ <- (peticion (id ?id_) (genero $?genPet_) (satisfecha No)) 
	(test(eq (length$ $?genPet_) 0))
	(test(<  (length$ $?apps_) 30))
	(test (or
		(not (member$ Weather $?generoRec_))
		(not (member$ HouseAndHome $?generoRec_))
		(not (member$ Medical $?generoRec_))
		(not (member$ NewsAndMagazines $?generoRec_))
		(not (member$ BooksAndReference $?generoRec_))
		(not (member$ TravelAndLocal $?generoRec_))
	))
=>
	(bind $?generoRec_ (insertListElementoUnico(create$ Weather HouseAndHome Medical NewsAndMagazines BooksAndReference TravelAndLocal) ?generoRec_))
	(modify ?recomendacion_ (genero $?generoRec_))
)

(defrule recomendarGenero_PetNula_Menor
	?perfil_ <- (perfil (id ?id_) (aplicacionesInstaladas $?apps_) (genero $?genPerf_) (edad ?edad_&:(< ?edad_ 18)))
	?recomendacion_ <- (recomendacion (id ?id_) (genero $?generoRec_) (ready No))
	?peticion_ <- (peticion (id ?id_) (genero $?genPet_) (satisfecha No)) 
	(test(eq (length$ $?genPet_) 0))
	(test(<  (length$ $?apps_) 30))
	(test (or
		(not (member$ Education $?generoRec_))
		(not (member$ Educational $?generoRec_))
		(not (member$ Entertainment $?generoRec_))
	))
=>
	(bind $?generoRec_ (insertListElementoUnico(create$ Education Educational Entertainment) ?generoRec_))
	(modify ?recomendacion_ (genero $?generoRec_))

)

(defrule recomendarGenero_PetNula_AppsModa
	?perfil_ <- (perfil (id ?id_) (aplicacionesInstaladas $?apps_) (genero $?genPerf_) )
	?recomendacion_ <- (recomendacion (id ?id_) (genero $?generoRec_) (ready No))
	?peticion_ <- (peticion (id ?id_) (genero $?genPet_) (satisfecha No)) 
	(test(eq (length$ $?genPet_) 0))
	(test(<  (length$ $?apps_) 30))
	
	(aplicacion (nombre ?n1&:(member$ ?n1 ?apps_)) (genero ?gen&:(not (member$ ?gen ?generoRec_))))
	(aplicacion (nombre ?n2&:(and (member$ ?n2 ?apps_)(neq ?n1 ?n2))) (genero ?gen))
	(aplicacion (nombre ?n3&:(and (member$ ?n3 ?apps_)(neq ?n1 ?n3) (neq ?n2 ?n3))) (genero ?gen))
	(aplicacion (nombre ?n4&:(and (member$ ?n4 ?apps_)(neq ?n1 ?n4) (neq ?n2 ?n4) (neq ?n3 ?n4))) (genero ?gen))
		
=>
	(bind $?generoRec_(insertElementoUnico ?gen ?generoRec_))
	(modify ?recomendacion_ (genero $?generoRec_))
)



(defrule recomendarGenero_PetNula_MujerJoven
	?perfil_ <- (perfil (id ?id_) (aplicacionesInstaladas $?apps_) (genero $?genPerf_) (sexo mujer) (edad ?ed&:(< ?ed 30)) )
	?recomendacion_ <- (recomendacion (id ?id_) (genero $?generoRec_) (ready No))
	?peticion_ <- (peticion (id ?id_) (genero $?genPet_) (satisfecha No)) 
	(test(eq (length$ $?genPet_) 0))
	(test(<  (length$ $?apps_) 30))
	(test (or
		(not (member$ Beauty $?generoRec_))
		(not (member$ ArtAndDesign $?generoRec_))
		(not (member$ Photography $?generoRec_))
	))
=>	
	(bind $?generoRec_ (insertListElementoUnico(create$ Beauty ArtAndDesign Photography) ?generoRec_))
	(modify ?recomendacion_ (genero $?generoRec_))
)

(defrule recomendarGenero_PetNula_MujerAdulta
	?perfil_ <- (perfil (id ?id_) (aplicacionesInstaladas $?apps_) (genero $?genPerf_) (sexo mujer) (edad ?ed&:(>= ?ed 30)) )
	?recomendacion_ <- (recomendacion (id ?id_) (genero $?generoRec_) (ready No))
	?peticion_ <- (peticion (id ?id_) (genero $?genPet_) (satisfecha No)) 
	(test(eq (length$ $?genPet_) 0))
	(test(<  (length$ $?apps_) 30))
	(test (or
		(not (member$ Parenting $?generoRec_))
		(not (member$ HouseAndHome $?generoRec_))
		(not (member$ Medical $?generoRec_))
	))	
	
=>
	(bind $?generoRec_ (insertListElementoUnico(create$ Parenting HouseAndHome Medical) ?generoRec_))
	(modify ?recomendacion_ (genero $?generoRec_))
)

(defrule recomendarGenero_PetNula_HombreJoven
	?perfil_ <- (perfil (id ?id_) (aplicacionesInstaladas $?apps_) (genero $?genPerf_) (sexo hombre) (edad ?ed&:(< ?ed 30)) )
	?recomendacion_ <- (recomendacion (id ?id_) (genero $?generoRec_) (ready No))
	?peticion_ <- (peticion (id ?id_) (genero $?genPet_) (satisfecha No)) 
	(test(eq (length$ $?genPet_) 0))
	(test(<  (length$ $?apps_) 30))
	(test (or
		(not(contieneJuegos ?generoRec_))
		(not (member$ LibrariesAndDemo $?generoRec_))
		(not (member$ VideoPlayersAndEditors $?generoRec_))
		(not (member$ FoodAndDrink $?generoRec_))
		(not (member$ Comics $?generoRec_))

	))	
	
=>
	(bind $?generoRec_ (insertListElementoUnico(create$ Games LibrariesAndDemo VideoPlayersAndEditors FoodAndDrink Comics) ?generoRec_))
	(modify ?recomendacion_ (genero $?generoRec_))

)


(defrule recomendarGenero_PetNula_HombreAdulto
	?perfil_ <- (perfil (id ?id_) (aplicacionesInstaladas $?apps_) (genero $?genPerf_) (sexo hombre) (edad ?ed&:(>= ?ed 30)) )
	?recomendacion_ <- (recomendacion (id ?id_) (genero $?generoRec_) (ready No))
	?peticion_ <- (peticion (id ?id_) (genero $?genPet_) (satisfecha No)) 
	(test (eq (length$ $?genPet_) 0))
	(test (<  (length$ $?apps_) 30))
	(test (or
		(not (member$ Events $?generoRec_))
		(not (member$ Productivity $?generoRec_))
		(not (member$ MapsAndNavigation $?generoRec_))
		(not (member$ AutoAndVehicles $?generoRec_))
	))	
=>
	(bind $?generoRec_ (insertListElementoUnico(create$ Events Productivity MapsAndNavigation AutoAndVehicles) ?generoRec_))
	(modify ?recomendacion_ (genero $?generoRec_))
)

;---- Games es un género privado que usamos para englobar todos los juegos. Aquí se traducen.
(defrule recomendarJuegos
	?recomendacion_ <- (recomendacion (id ?id_) (genero $?generoRec_) (ready No))
	(test (member$ Games $?generoRec_))
=>
	(bind $?generoRec_ (delete$ $?generoRec_ (member$ Games $?generoRec_) (member$ Games $?generoRec_)))
	(bind $?generoRec_ (insertListElementoUnico 
		(create$ Action Adventure Arcade Board Card Casino Casual Entertainment Music Puzzle Racing RolePlaying Simulation Strategy Trivia Word)
		?generoRec_))
	(modify ?recomendacion_ (genero $?generoRec_))
)



(defrule recomendarGeneroUltimasAppsInstaladas
	?perfil_ <- (perfil (id ?id_) (aplicacionesInstaladas $?apps_) (genero $?genPerf_)  )
	?recomendacion_ <- (recomendacion (id ?id_) (genero $?generoRec_) (ready No))
	?peticion_ <- (peticion (id ?id_) (genero $?genPet_) (satisfecha No))
	(test (eq (length$ $?genPet_) 0))
	(aplicacion (nombre ?n1&:(eq ?n1 (nth$ 1 $?apps_ ))) (genero ?g1))
	(aplicacion (nombre ?n2&:(eq ?n2 (nth$ 2 $?apps_ ))) (genero ?g2))
	(test (or
		(not (member$ ?g1 ?generoRec_))
		(not (member$ ?g2 ?generoRec_))
	))
=>
	(bind $?generoRec_ (insertListElementoUnico (create$ ?g1 ?g2) ?generoRec_))
	(modify ?recomendacion_ (genero $?generoRec_ ))
	
)


