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
