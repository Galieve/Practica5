(deffacts apps_init
	(aplicacion (nombre "FlipaClip - Cartoon animation") (categoria ART_AND_DESIGN) (valoracion 4.4) (reviews 194216) (espacio 10000000) (descargas 123456789) (precio 0) (edad Everyone) (genero ArtAndDesign) (ultimaActualizacion 3/08/2018) (androidVersion "4.0") )
	(aplicacion (nombre "Anime Manga Coloring Book") (categoria ART_AND_DESIGN) (valoracion 4.4) (reviews 194216) (espacio 10000000) (descargas 123456789) (precio 0) (edad Everyone) (genero ArtAndDesign) (ultimaActualizacion 19/07/2018) (androidVersion "4.0") )
	(aplicacion (nombre "Hola Caracola") (categoria ART_AND_DESIGN) (valoracion 4.4) (reviews 194216) (espacio 10000000) (descargas 123456789) (precio 0) (edad Everyone) (genero ArtAndDesign) (ultimaActualizacion 19/07/2018) (androidVersion "4.0") )

)

(deffacts perfiles_init
	(perfil (id "alguien") (edad 34) (sexo otro) (version "6.0") 
	(aplicacionesInstaladas "Name Art Photo Editor - Focus n Filters")
	(genero Comics)
	(gastoTotal 0) (gastoMaximo 0)
	)
	
	(perfil (id "nadie") (edad 12) (sexo hombre) (version "3.0") 
	(aplicacionesInstaladas )
	(genero Games Education ArtAndDesign)
	(gastoTotal 10) (gastoMaximo 10)
	)
)

(deffacts peticion_init
	(peticion (id "nadie") (genero Games Casual ArtAndDesign) (edadDestinatario -1) (prioridad descargas) (espacioMax medio) (valoracionMin 3.33))
	(peticion (id "alguien") (genero ) (espacioMax medio) (valoracionMin 4.3))

)

(deffacts recomendacion_init
	;(recomendacion (id "nadie"))
	(recomendacion (id "alguien"))
)