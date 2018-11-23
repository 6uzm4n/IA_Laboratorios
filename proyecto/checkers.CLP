(defglobal ?*size* = 8) ;Dimensiones del tablero. LEGAL: 8?
(defglobal ?*checkers* = 3) ;Filas de damas para cada jugador. LEGAL: 3?

(defglobal ?*board* = (create$)) ;Multicampo que contiene el tablero.

(deffunction append (?multicampo ?simple)
  ;Añade el parámetro simple al final del parámetro multicampo
  (return (insert$ ?multicampo (+ 1 (length$ ?multicampo)) ?simple))
)

(deffunction initialize ()
	;Inicia el tablero en la variable ?*board* en función de los parámetros definidos en ?*size* y ?*checkers*.
	
	(loop-for-count (?y 1 ?*size*) do
		(loop-for-count (?x 1 ?*size*) do
			(if (and (= 1 (mod (+ ?x ?y) 2)) (<= ?y ?*checkers*)) then
				(bind ?*board* (append ?*board* 1))
			else
				(if (and (= 1 (mod (+ ?x ?y) 2)) (> ?y (- ?*size* ?*checkers*))) then
					(bind ?*board* (append ?*board* -1))
				else
					(bind ?*board* (append ?*board* 0))
				)
			)
		)
	)
)

(deffunction print_tablero ()
	;Imprime por pantalla ?*board*, el tablero de juego
	;Cada casilla de nuestro tablero tendrá el siguiente aspecto:
	;	#######
	;	#     #		- 7 caracteres en horizontal
	;	#  O  #		- 5 caracteres en vertical
	;	#     #		- El caracter central representa el contenido (" ", "@" o "O")
	;	#######

	(clear-window)
	(bind ?i 1)
	(loop-for-count (?y 0 (* 4 ?*size*)) do
		(loop-for-count (?x 0 (* 6 ?*size*)) do
			(if (or (= 0 (mod ?y 4)) (= 0 (mod ?x 6))) then
				(printout t "#")
			else
				(if (and (= 0 (mod ?y 2)) (= 0 (mod ?x 3))) then
					(switch (nth$ ?i ?*board*)
						(case 0 then (printout t " "))
						(case 1 then (printout t "O"))
						(case -1 then (printout t "@"))
						)
					(bind ?i (+ ?i 1))
				else
					(printout t " ")
				)
				
			)
		)
		(printout t crlf)
	)
	(printout t crlf)
	(return  )
)