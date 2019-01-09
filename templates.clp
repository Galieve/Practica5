(defglobal ?*infinito* = 1000000000000000)

(deftemplate aplicacion
    (slot nombre (type STRING))
    (slot valoracion (type NUMBER) (range 0 5))
	(slot reviews (type INTEGER) (range 0 ?VARIABLE))
	(slot espacio (type INTEGER) (range -1 ?VARIABLE)) ;-1 significa tamaño desconocido
	(slot descargas (type INTEGER) (range 0 ?VARIABLE)) 
	(slot precio (type NUMBER) (range 0 ?VARIABLE))
	(slot edad (type SYMBOL) (allowed-values Adultsonly18+ Everyone Everyone10+ Mature17+ Teen Unrated ))
	(slot genero (type SYMBOL) (allowed-values All Games Action Adventure Arcade ArtAndDesign AutoAndVehicles Beauty Board BooksAndReference
		Business Card Casino Casual Comics Communication Dating Education Educational Entertainment Events Finance FoodAndDrink 
		HealthAndFitness HouseAndHome LibrariesAndDemo Lifestyle MapsAndNavigation Medical Music MusicAndAudio NewsAndMagazines 
		Parenting Personalization Photography Productivity Puzzle Racing RolePlaying Shopping Simulation Social Sports Strategy 
		Tools TravelAndLocal Trivia VideoPlayersAndEditors Weather Word ))
	(slot androidVersion (type STRING))
)


(deftemplate perfil
	(slot id (type STRING))
	(slot edad (type INTEGER) (range 0 ?VARIABLE) (default 0))
	(slot sexo (type SYMBOL) (allowed-values hombre mujer otro))
	(slot version (type STRING) )
	(multislot aplicacionesInstaladas)
	(multislot genero ) 
	(slot gastoTotal (type NUMBER) (range 0 ?VARIABLE) (default 0));total 
	(slot gastoMaximo (type NUMBER) (range 0 ?VARIABLE) (default 0))
)


(deftemplate peticion
	(slot id (type STRING))
	(multislot genero)
	(slot edadDestinatario (type INTEGER) (range -1 ?VARIABLE) (default -1))
	(slot prioridad (type SYMBOL) (allowed-values espacio descargas valoracion precioAsc precioDesc) (default descargas))
	(slot espacio (type SYMBOL) (allowed-values ligera medio pesada null) (default null))
	(slot valoracionMin (type NUMBER) (range -1 5) (default -1))
	(multislot listaApps)
	(slot cantidadRecom (type INTEGER) (range 1 ?VARIABLE) (default 3))
	(slot satisfecha (allowed-values Si No) (default No))
)

(deftemplate recomendacion
	(slot id (type STRING) (default ""))
	(multislot genero )
	(slot edadApp (type INTEGER) (range -1 ?VARIABLE) (default -1))
	(slot espacio (type SYMBOL) (allowed-values ligera medio pesada null) (default null))
	(slot precioMaximo (type NUMBER) (range -1 ?VARIABLE) (default -1))
	(slot valoracionMin (type NUMBER) (range -1 5) (default -1))
	(slot version (type STRING) (default ""))
	(slot ready (allowed-values Si No) (default No))
)


(deftemplate appRecomendada
	(slot nombre (type STRING) (default ""))
	(slot id (type STRING))
	(slot posPodium (type INTEGER) (range 1 ?VARIABLE))
)

(deftemplate printQuery
	(slot id (type STRING) (default ""))
	(slot pos (type INTEGER) (range 1 ?VARIABLE) (default 1))
)

(deftemplate installQuery
	(slot id (type STRING) (default ""))
	(slot nombre (type STRING))
)
