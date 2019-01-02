(defmodule TEMPLATES (export ?ALL))

(defglobal ?*infinito* = 1000000000000000)

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
	(multislot aplicacionesInstaladas (default create$))
	(multislot genero (default create$)) 
	(slot gastoTotal (type NUMBER) (range 0 ?VARIABLE) (default 0));total 
	(slot gastoMaximo (type NUMBER) (range 0 ?VARIABLE) (default 0))
)


(deftemplate peticion
	(slot id (type STRING))
	(multislot generoPet (default create$))
	(slot edadDestinatario (type INTEGER) (range -1 ?VARIABLE) )
	(slot prioridad (type SYMBOL) (allowed-values espacio descargas valoracion) (default descargas))
	(slot espacioMax (type SYMBOL) (allowed-values ligera medio pesada null) (default null))
	(slot valoracionMin (type NUMBER) (range 0 5) (default 0))
)

(deftemplate recomendacion
	(slot id (type STRING) (default ""))
	(multislot genero (default create$))
	(slot edadApp (type INTEGER) (range -1 ?VARIABLE) (default -1))
	(slot espacio (type SYMBOL) (allowed-values ligera medio pesada null) (default null))
	(slot precioMaximo (type NUMBER) (range -1 ?VARIABLE) (default -1))
	(slot ready (allowed-values Si No) (default No))
)


(deftemplate appRecomendada
	(slot nombre (type STRING) (default ""))
	(slot id (type STRING))
	(slot posPodium (type INTEGER) (range 1 3))
	;(slot satisfecha (default No))
)