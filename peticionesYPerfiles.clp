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