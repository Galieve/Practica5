(deffunction contieneJuegos (?array)
	(if (or
			(member$ Games $?array)
			(subsetp (create$ Action Adventure Arcade Board Card Casino Casual Entertainment
				Music Puzzle Racing RolePlaying Simulation Strategy Trivia Word) ?array)
		)
		then TRUE else FALSE
	)
)

(deffunction insertElementoUnico (?el ?array)
	(if (not (member$ ?el ?array)) then
		(bind $?array (insert$ $?array 1 ?el))
	)
	(return ?array)
)

(deffunction insertListElementoUnico (?list ?array)
	(foreach ?l ?list 
		(bind ?array (insertElementoUnico ?l ?array))
	)
)

(deffunction conversionEdad_Num (?edadApp_)
	(if (eq ?edadApp_  Everyone) then 0
	else (
		if (eq ?edadApp_ Everyone10+) then 10
		else (
			if (eq ?edadApp_ Teen) then 13
			else (
				if (eq ?edadApp_ Mature17+) then 17
				else 18
				)
			)
		)
	)
)

(deffunction instalar (?id_ ?nombreApp_)
	(assert (installQuery (id (str-cat "\"" ?id_ "\"")) (nombre ?nombreApp_)))
)
