

(defrule recomendarGenero_PetNula_Joven
	?perfil_ <- (perfil (id ?id_) (aplicacionesInstaladas $?apps_) (genero $?genPerf_) (edad ?edad_&:(and(>= ?edad_ 18) (< ?edad_ 30))))
	?recomendacion_ <- (recomendacion (id ?id_) (genero $?generoRec_) (ready No))
	?peticion_ <- (peticion (id ?id_) (genero $?genPet_)) 
	(test(eq (length$ $?genPet_) 0))
	(test(<  (length$ $?apps_) 30))
	(test (or
		(not (member$ Social $?generoRec_))
		(not (member$ Dating $?generoRec_))
		(not (member$ Shopping $?generoRec_))
		(not (member$ Comics $?generoRec_))
		(not (member$ Personalization $?generoRec_))
		(not (member$ Photography $?generoRec_))
	))
=>
	(modify ?recomendacion_ (genero (insert$ $?generoRec_ 1 Social Dating Shopping Comics Personalization Photography)))
)

(defrule recomendarGenero_PetNula_Adulto
	?perfil_ <- (perfil (id ?id_) (aplicacionesInstaladas $?apps_) (genero $?genPerf_) (edad ?edad_&:(and(>= ?edad_ 30) (< ?edad_ 50))))
	?recomendacion_ <- (recomendacion (id ?id_) (genero $?generoRec_) (ready No))
	?peticion_ <- (peticion (id ?id_) (genero $?genPet_)) 
	(test(eq (length$ $?genPet_) 0))
	(test(<  (length$ $?apps_) 30))
	(test (or
		(not (member$ Business $?generoRec_))
		(not (member$ Lifestyle $?generoRec_))
		(not (member$ HealthAndFitness $?generoRec_))
		(not (member$ Productivity $?generoRec_))
		(not (member$ NewsAndMagazines $?generoRec_))
		(not (member$ Finance $?generoRec_))

	))
=>
	(modify ?recomendacion_ (genero (insert$ $?generoRec_ 1 Business Lifestyle HealthAndFitness Productivity NewsAndMagazines Finance)))

)

(defrule recomendarGenero_PetNula_MasAdulto
	?perfil_ <- (perfil (id ?id_) (aplicacionesInstaladas $?apps_) (genero $?genPerf_) (edad ?edad_&:(>= ?edad_ 50) ))
	?recomendacion_ <- (recomendacion (id ?id_) (genero $?generoRec_) (ready No))
	?peticion_ <- (peticion (id ?id_) (genero $?genPet_)) 
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
	(modify ?recomendacion_ (genero (insert$ $?generoRec_ 1 Weather HouseAndHome Medical NewsAndMagazines BooksAndReference TravelAndLocal)))
)

(defrule recomendarGenero_PetNula_Menor
	?perfil_ <- (perfil (id ?id_) (aplicacionesInstaladas $?apps_) (genero $?genPerf_) (edad ?edad_&:(< ?edad_ 18)))
	?recomendacion_ <- (recomendacion (id ?id_) (genero $?generoRec_) (ready No))
	?peticion_ <- (peticion (id ?id_) (genero $?genPet_)) 
	(test(eq (length$ $?genPet_) 0))
	(test(<  (length$ $?apps_) 30))
	(test (or
		(not (member$ Education $?generoRec_))
		(not (member$ Educational $?generoRec_))
		(not (member$ Entertainment $?generoRec_))
	))
=>
	(modify ?recomendacion_ (genero (insert$ $?generoRec_ 1 Education Educational Entertainment)))

)

(defrule recomendarGenero_PetNula_AppsModa
	?perfil_ <- (perfil (id ?id_) (aplicacionesInstaladas $?apps_) (genero $?genPerf_) )
	?recomendacion_ <- (recomendacion (id ?id_) (genero $?generoRec_) (ready No))
	?peticion_ <- (peticion (id ?id_) (genero $?genPet_)) 
	(test(eq (length$ $?genPet_) 0))
	(test(<  (length$ $?apps_) 30))
	
	(aplicacion (nombre ?n1&:(member$ ?n1 ?apps_)) (genero ?gen&:(not (member$ ?gen ?generoRec_))))
	(aplicacion (nombre ?n2&:(and (member$ ?n2 ?apps_)(neq ?n1 ?n2))) (genero ?gen))
	(aplicacion (nombre ?n3&:(and (member$ ?n3 ?apps_)(neq ?n1 ?n3) (neq ?n2 ?n3))) (genero ?gen))
	(aplicacion (nombre ?n4&:(and (member$ ?n4 ?apps_)(neq ?n1 ?n4) (neq ?n2 ?n4) (neq ?n3 ?n4))) (genero ?gen))
		
=>
	(modify ?recomendacion_ (genero (insert$ $?generoRec_ 1 ?gen)))
)



(defrule recomendarGenero_PetNula_MujerJoven
	?perfil_ <- (perfil (id ?id_) (aplicacionesInstaladas $?apps_) (genero $?genPerf_) (sexo mujer) (edad ?ed&:(< ?ed 30)) )
	?recomendacion_ <- (recomendacion (id ?id_) (genero $?generoRec_) (ready No))
	?peticion_ <- (peticion (id ?id_) (genero $?genPet_)) 
	(test(eq (length$ $?genPet_) 0))
	(test(<  (length$ $?apps_) 30))
	(test (or
		(not (member$ Beauty $?generoRec_))
		(not (member$ Shopping $?generoRec_))
		(not (member$ ArtAndDesign $?generoRec_
		(not (member$ Photography $?generoRec_))

	))	
	
=>
	(modify ?recomendacion_ (genero (insert$ $?generoRec_ 1 Beauty Shopping ArtAndDesign Photography)))

)

(defrule recomendarGenero_PetNula_MujerAdulta
	?perfil_ <- (perfil (id ?id_) (aplicacionesInstaladas $?apps_) (genero $?genPerf_) (sexo mujer) (edad ?ed&:(< ?ed 30)) )
	?recomendacion_ <- (recomendacion (id ?id_) (genero $?generoRec_) (ready No))
	?peticion_ <- (peticion (id ?id_) (genero $?genPet_)) 
	(test(eq (length$ $?genPet_) 0))
	(test(<  (length$ $?apps_) 30))
	(test (or
		(not (member$ Parenting $?generoRec_))
		(not (member$ HouseAndHome $?generoRec_))
		(not (member$ Medical $?generoRec_))
	))	
	
=>
	(modify ?recomendacion_ (genero (insert$ $?generoRec_ 1 Parenting HouseAndHome Medical)))

)


Action Adventure Arcade ArtAndDesign AutoAndVehicles Beauty Board BooksAndReference
		Business Card Casino Casual Comics Communication Dating Education Educational Entertainment Events Finance FoodAndDrink 
		HealthAndFitness HouseAndHome LibrariesAndDemo Lifestyle MapsAndNavigation Medical Music MusicAndAudio NewsAndMagazines 
		Parenting Personalization  Productivity Puzzle Racing RolePlaying Shopping Simulation Social Sports Strategy 
		Tools TravelAndLocal Trivia VideoPlayersAndEditors Weather Word

(defrule recomendarGenero_PetNula_Hombre
	?perfil_ <- (perfil (id ?id_) (aplicacionesInstaladas $?apps_) (genero $?genPerf_) (sexo hombre) (edad ?ed&:(< ?ed 30)) )
	?recomendacion_ <- (recomendacion (id ?id_) (genero $?generoRec_) (ready No))
	?peticion_ <- (peticion (id ?id_) (genero $?genPet_)) 
	(test(eq (length$ $?genPet_) 0))
	(test(<  (length$ $?apps_) 30))
	(test (or
		(not (member$ Beauty $?generoRec_))
		(not (member$ Shopping $?generoRec_))
		(not (member$ ArtAndDesign $?generoRec_))
	))	
	
=>
	(modify ?recomendacion_ (genero (insert$ $?generoRec_ 1 Beauty Shopping ArtAndDesign)))

)


