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


;
