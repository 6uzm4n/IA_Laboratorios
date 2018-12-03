CHECKERS﻿(defglobal ?*SIZE* = 8) ;Dimensiones del tablero. Predeterminadas: 8
(defglobal ?*CHECKERS* = 3) ;Filas de fichas para cada jugador. Predeterminadas: 3
(defglobal ?*WHITE* = 1) ;Signo de las fichas negras.
(defglobal ?*BLACK* = -1)  ;Signo de las fichas blancas

(defglobal ?*board* = (create$)) ;Multicampo que contiene el tablero.

(defmodule MAIN (export ?ALL))

(deffunction MAIN::append (?multicampo ?simple)
  ;Añade el parámetro simple al final del parámetro multicampo
  (return (insert$ ?multicampo (+ 1 (length$ ?multicampo)) ?simple))
)

(deffunction MAIN::coord_to_board (?y ?x)
  ;Devuelve el equivalente en posición dadas unas coordenadas del tablero.
  (return (+ (* ?*SIZE* (- ?y 1)) ?x))
)

(deffunction MAIN::get_piece (?board ?y ?x)
  ;Devuelve la ficha que se encuentra en unas coordenadas dadas del tablero.
  (return (nth$ (coord_to_board ?y ?x) ?board))
)

(deffunction MAIN::initialize ()
	;Inicia el tablero en la variable ?*board* en función de los parámetros definidos en ?*SIZE* y ?*CHECKERS*.
	;La posición 1-1 es arriba a la izquierda, y la 8-8 abajo a la derecha. Los 0 son espacios vacíos.
  ;Los 1, 2, -1 y -2 son fichas y damas de cada jugador.
  (bind ?board (create$))
  (loop-for-count (?y 1 ?*SIZE*) do
		(loop-for-count (?x 1 ?*SIZE*) do
			(if (and (= 1 (mod (+ ?x ?y) 2)) (<= ?y ?*CHECKERS*)) then
				(bind ?board (append ?board 1))
			else
				(if (and (= 1 (mod (+ ?x ?y) 2)) (> ?y (- ?*SIZE* ?*CHECKERS*))) then
					(bind ?board (append ?board -1))
				else
					(bind ?board (append ?board 0))
				)
			)
		)
	)
  (return ?board)
)

(deffunction MAIN::print_board (?board)
	;Imprime por pantalla ?board, el tablero de juego
	;Cada casilla de nuestro tablero tendrá el siguiente aspecto:
	;	#######
	;	#     #		- 7 caracteres en horizontal
	;	#  O  #		- 5 caracteres en vertical
	;	#     #		- El caracter central representa el contenido (" ", "@" o "O")
	;	#######

	(clear-window)
	(bind ?i 1)
	(loop-for-count (?y 0 (* 4 ?*SIZE*)) do
		(loop-for-count (?x 0 (* 6 ?*SIZE*)) do
			(if (or (= 0 (mod ?y 4)) (= 0 (mod ?x 6))) then
				(printout t "#")
			else
				(if (and (= 0 (mod ?y 2)) (= 0 (mod ?x 3))) then
					(switch (nth$ ?i ?board)
						(case 0 then (printout t " "))
						(case 1 then (printout t "o"))
						(case -1 then (printout t "x"))
            (case 2 then (printout t "@"))
            (case -2 then (printout t "X"))
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
	(return)
)

(defrule MAIN::start "Crea el tablero y da comienzo a la partida."
  ;Sin condiciones
=>
  (bind ?s -1) ;Filas del tablero
  (bind ?c -1) ;Filas de fichas
  (bind ?f 0) ;Color de fichas del jugador

  (while (or (not (integerp ?s)) (not (> ?s 0))) do
    (printout t "Numero de filas y columnas del tablero (predeterminadas 8):" crlf)
    (bind ?s (read))
  )
  (bind ?*SIZE* ?s)

  (while (or (not (integerp ?c)) (not (> ?c 0)) (not (< ?c (div ?*SIZE* 2)))) do
    (printout t "Numero de filas con fichas (debe ser menor que la mitad del tablero)(predeterminadas 3):" crlf)
    (bind ?c (read))
  )
  (bind ?*CHECKERS* ?c)

  (while (and (not (= ?*BLACK* ?f)) (not (= ?*WHITE* ?f))) do
    (printout t "Elige tu color de fichas (Blanco:" ?*WHITE* " Negro:" ?*BLACK* "):" crlf)
    (bind ?f (read))
  )
  (switch ?f
    (case ?*BLACK* then
      (assert (player_color ?*BLACK*))
      (assert (computer_color ?*WHITE*))
      (focus COMPUTER)
    )
    (case ?*WHITE* then
      (assert (player_color ?*WHITE*))
      (assert (computer_color ?*BLACK*))
      (focus PLAYER)
    )
  )
  (assert (turn 1))
  (assert (board (initialize)))
)

(deffunction MAIN::check_kills (?board ?player)
  ;Devuelve una lista de las posiciones en las que se encuentra una ficha que puede comer a otra.
  ;El parámetro player ha de ser 1 o -1 y define el jugador que come.
  (bind ?kills (create$))
  (loop-for-count (?y 1 ?*SIZE*) do
		(loop-for-count (?x 1 ?*SIZE*) do
      (if (= 1 (* (get_piece ?board ?y ?x) ?player)) then
        ;Calcula movimiento de fichas normales.
        (if (and (<= 1 (+ ?y (* 2 ?player))) (>= ?*SIZE* (+ ?y (* 2 ?player)))) then
          ;Si no se sale verticalmente.
          (if (and (<= 1 (- ?x 2))       (> 0 (* ?player (get_piece ?board (+ ?y ?player) (- ?x 1)))) (= 0 (get_piece ?board (+ ?y (* 2 ?player)) (- ?x 2)))) then
            ;Si puede comer a izquierda
            (bind ?kills (append ?kills (implode$ (create$ ?y ?x (+ ?y (* 2 ?player)) (- ?x 2)))))
          )
          (if (and (>= ?*SIZE* (+ ?x 2)) (> 0 (* ?player (get_piece ?board (+ ?y ?player) (+ ?x 1)))) (= 0 (get_piece ?board (+ ?y (* 2 ?player)) (+ ?x 2)))) then
            ;Si puede comer a derecha
            (bind ?kills (append ?kills (implode$ (create$ ?y ?x (+ ?y (* 2 ?player)) (+ ?x 2)))))
          )
        )
      )
      (if (= 2 (* (get_piece ?board ?y ?x) ?player)) then
        ;Calcula movimiento de damas.
        (bind ?bl 0) ;Flag para cuando no puede seguir buscando por abajo-izquierda
        (bind ?br 0) ;Flag para cuando no puede seguir buscando por abajo-derecha
        (bind ?tl 0) ;Flag para cuando no puede seguir buscando por arriba-izquierda
        (bind ?tr 0) ;Flag para cuando no puede seguir buscando por arriba-derecha
        (loop-for-count (?i 1 (max ?x ?y (- ?*SIZE* ?x) (- ?*SIZE* ?y))) do
          (if (and (>= ?*SIZE* (+ ?y ?i))  (<= 1 (- ?x ?i)) (> 2 ?bl)) then
            ;Abajo-izquierda
            (if (and (= 0 (get_piece ?board (+ ?y ?i) (- ?x ?i))) (= 1 ?bl)) then
              ;Si encuentra un espacio libre y está comiendo, guarda el posible estado.
              (bind ?kills (append ?kills (implode$ (create$ ?y ?x (+ ?y ?i) (- ?x ?i)))))
            else
              (if (or (and (> 0 (* ?player (get_piece ?board (+ ?y ?i) (- ?x ?i)))) (= 1 ?tr))  (< 0 (* ?player (get_piece ?board (+ ?y ?i) (- ?x ?i))))) then
                ;Si encuentra una ficha alida el flag se pone a 2 y no puede seguir comiendo.
                ;Si encuentra una ficha enemiga y el flag ya está a uno, se pone a 2 y no puede seguir comiendo.
                (bind ?bl 2)
              else
                (if (and (> 0 (* ?player (get_piece ?board (+ ?y ?i) (- ?x ?i)))) (= 0 ?bl)) then
                  (bind ?bl 1)
                )
              )
            )
          )
          (if (and (>= ?*SIZE* (+ ?y ?i))  (>= ?*SIZE* (+ ?x ?i)) (> 2 ?br)) then
            ;Abajo-derecha
            (if (and (= 0 (get_piece ?board (+ ?y ?i) (+ ?x ?i))) (= 1 ?br)) then
              ;Si encuentra un espacio libre y está comiendo, guarda el posible estado.
              (bind ?kills (append ?kills (implode$ (create$ ?y ?x (+ ?y ?i) (+ ?x ?i)))))
            else
              (if (or (and (> 0 (* ?player (get_piece ?board (+ ?y ?i) (+ ?x ?i)))) (= 1 ?tr))  (< 0 (* ?player (get_piece ?board (+ ?y ?i) (+ ?x ?i))))) then
                ;Si encuentra una ficha alida el flag se pone a 2 y no puede seguir comiendo.
                ;Si encuentra una ficha enemiga y el flag ya está a uno, se pone a 2 y no puede seguir comiendo.
                (bind ?br 2)
              else
                (if (and (> 0 (* ?player (get_piece ?board (+ ?y ?i) (+ ?x ?i)))) (= 0 ?br)) then
                  (bind ?br 1)
                )
              )
            )
          )
          (if (and (<= 1 (- ?y ?i))        (<= 1 (- ?x ?i)) (> 2 ?tl)) then
            ;Arriba-izquierda
            (if (and (= 0 (get_piece ?board (- ?y ?i) (- ?x ?i))) (= 1 ?tl)) then
              ;Si encuentra un espacio libre y está comiendo, guarda el posible estado.
              (bind ?kills (append ?kills (implode$ (create$ ?y ?x (- ?y ?i) (- ?x ?i)))))
            else
              (if (or (and (> 0 (* ?player (get_piece ?board (- ?y ?i) (- ?x ?i)))) (= 1 ?tr))  (< 0 (* ?player (get_piece ?board (- ?y ?i) (- ?x ?i))))) then
                ;Si encuentra una ficha alida el flag se pone a 2 y no puede seguir comiendo.
                ;Si encuentra una ficha enemiga y el flag ya está a uno, se pone a 2 y no puede seguir comiendo.
                (bind ?tl 2)
              else
                (if (and (> 0 (* ?player (get_piece ?board (- ?y ?i) (- ?x ?i)))) (= 0 ?tl)) then
                  ;Si encuentra una ficha enemiga y el flag está a 0, lo pone a 1 y puede comer.
                  (bind ?tl 1)
                )
              )
            )
          )
          (if (and (<= 1 (- ?y ?i))        (>= ?*SIZE* (+ ?x ?i)) (> 2 ?tr)) then
            ;Arriba-derecha
            (if (and (= 0 (get_piece ?board (- ?y ?i) (+ ?x ?i))) (= 1 ?tr)) then
              ;Si encuentra un espacio libre y está comiendo, guarda el posible estado.
              (bind ?kills (append ?kills (implode$ (create$ ?y ?x (- ?y ?i) (+ ?x ?i)))))
            else
              (if (or (and (> 0 (* ?player (get_piece ?board (- ?y ?i) (+ ?x ?i)))) (= 1 ?tr))  (< 0 (* ?player (get_piece ?board (- ?y ?i) (+ ?x ?i))))) then
                ;Si encuentra una ficha alida el flag se pone a 2 y no puede seguir comiendo.
                ;Si encuentra una ficha enemiga y el flag ya está a uno, se pone a 2 y no puede seguir comiendo.
                (bind ?tr 2)
              else
                (if (and (> 0 (* ?player (get_piece ?board (- ?y ?i) (+ ?x ?i)))) (= 0 ?tr)) then
                  (bind ?tr 1)
                )
              )
            )
          )
        )
      )
    )
	)
  (return ?kills)
)

(deffunction MAIN::check_moves (?board ?player)
  ;Devuelve una lista de las posiciones en las que se encuentra una ficha que puede moverse sin comer.
  ;El parámetro player ha de ser 1 o -1 y define el jugador que mueve.
  (bind ?moves (create$))
  (loop-for-count (?y 1 ?*SIZE*) do
		(loop-for-count (?x 1 ?*SIZE*) do
      (if (= 1 (* (get_piece ?board ?y ?x) ?player)) then
        ;Calcula movimiento de fichas normales.
        (if (and (<= 1 (+ ?y ?player)) (>= ?*SIZE* (+ ?y ?player))) then
          ;Si no se sale verticalmente.
          (if (and (<= 1 (- ?x 1))         (= 0 (get_piece ?board (+ ?y ?player) (- ?x 1)))) then
            ;Si puede mover la izquierda
            (bind ?moves (append ?moves (implode$ (create$ ?y ?x (+ ?y ?player) (- ?x 1)))))
          )
          (if (and (>= ?*SIZE* (+ ?x 1))   (= 0 (get_piece ?board (+ ?y ?player) (+ ?x 1)))) then
            ;Si puede mover a la derecha
            (bind ?moves (append ?moves (implode$ (create$ ?y ?x (+ ?y ?player) (+ ?x 1)))))
          )
        )
      )
      (if (= 2 (* (get_piece ?board ?y ?x) ?player)) then
        ;Calcula movimiento de damas.
        (bind ?bl TRUE) ;Flag para cuando no puede seguir buscando por abajo-izquierda
        (bind ?br TRUE) ;Flag para cuando no puede seguir buscando por abajo-derecha
        (bind ?tl TRUE) ;Flag para cuando no puede seguir buscando por arriba-izquierda
        (bind ?tr TRUE) ;Flag para cuando no puede seguir buscando por arriba-derecha
        (loop-for-count (?i 1 (max ?x ?y (- ?*SIZE* ?x) (- ?*SIZE* ?y))) do
          (if (and (>= ?*SIZE* (+ ?y ?i))  (<= 1 (- ?x ?i)) ?bl) then
            ;Abajo-izquierda
            (if (= 0 (get_piece ?board (+ ?y ?i) (- ?x ?i))) then
              (bind ?moves (append ?moves (implode$ (create$ ?y ?x (+ ?y ?i) (- ?x ?i)))))
            else
              ;Si encuentra un obstáculo se pone el flag a FALSE
              (bind ?bl FALSE)
            )
          )
          (if (and (>= ?*SIZE* (+ ?y ?i))  (>= ?*SIZE* (+ ?x ?i)) ?br) then
            ;Abajo-derecha
            (if (= 0 (get_piece ?board (+ ?y ?i) (+ ?x ?i))) then
              (bind ?moves (append ?moves (implode$ (create$ ?y ?x (+ ?y ?i) (+ ?x ?i)))))
            else
              ;Si encuentra un obstáculo se pone el flag a FALSE
              (bind ?br FALSE)
            )
          )
          (if (and (<= 1 (- ?y ?i))        (<= 1 (- ?x ?i)) ?tl) then
            ;Arriba-izquierda
            (if (= 0 (get_piece ?board (- ?y ?i) (- ?x ?i))) then
              (bind ?moves (append ?moves (implode$ (create$ ?y ?x (- ?y ?i) (- ?x ?i)))))
            else
              ;Si encuentra un obstáculo se pone el flag a FALSE
              (bind ?tl FALSE)
            )
          )
          (if (and (<= 1 (- ?y ?i))        (>= ?*SIZE* (+ ?x ?i)) ?tr) then
            ;Arriba-derecha
            (if (= 0 (get_piece ?board (- ?y ?i) (+ ?x ?i))) then
              (bind ?moves (append ?moves (implode$ (create$ ?y ?x (- ?y ?i) (+  ?x ?i)))))
            else
              ;Si encuentra un obstáculo se pone el flag a FALSE
              (bind ?tr FALSE)
            )
          )
        )
      )
		)
	)
  (return ?moves)
)

(deffunction MAIN::keep_killing (?board ?player ?move)
  (bind ?keep_killing FALSE)
  (bind ?pos_kills (check_kills ?board ?player))
  (bind ?y (nth$ 3 (explode$ ?move)))
  (bind ?x (nth$ 4 (explode$ ?move)))
  (loop-for-count (?i 1 (length$ ?pos_kills)) do
    (bind ?ny (nth$ 1 (explode$ (nth$ ?i ?pos_kills))))
    (bind ?nx (nth$ 2 (explode$ (nth$ ?i ?pos_kills))))
    (if (and (= ?y ?ny) (= ?x ?nx)) then
      (bind ?keep_killing TRUE)
    )
  )
  (return ?keep_killing)
)

(deffunction MAIN::move (?board ?player ?move)
  (bind ?y (nth$ 1 (explode$ ?move)))
  (bind ?x (nth$ 2 (explode$ ?move)))
  (bind ?ny (nth$ 3 (explode$ ?move)))
  (bind ?nx (nth$ 4 (explode$ ?move)))
  (bind ?pos_kills (check_kills ?board ?player))
  (bind ?pos_moves (check_moves ?board ?player))
  (if (member$ ?move ?pos_kills) then
    ;Si come una ficha
    (bind ?i 1)
    ;Define la diagonal en la que come según el movimiento.
    (if (< ?y ?ny) then
      (bind ?iy 1)
    else
      (bind ?iy -1)
    )
    (if (< ?x ?nx) then
      (bind ?ix 1)
    else
      (bind ?ix -1)
    )
    (while (not (= ?ny (+ ?y (* ?i ?iy)))) do
      (bind ?board (replace$ ?board (coord_to_board (+ ?y (* ?i ?iy)) (+ ?x (* ?i ?ix)))
                                        (coord_to_board (+ ?y (* ?i ?iy)) (+ ?x (* ?i ?ix))) 0))
      (bind ?i (+ ?i 1))
    )
    (bind ?board (replace$ ?board (coord_to_board ?ny ?nx) (coord_to_board ?ny ?nx) (* 2 ?player)))
    (bind ?board (replace$ ?board (coord_to_board ?ny ?nx) (coord_to_board ?ny ?nx) (get_piece ?board ?y ?x)))
    (bind ?board (replace$ ?board (coord_to_board ?y ?x) (coord_to_board ?y ?x) 0))
    (return (create$ 2 ?board))
  )
  (if (and (member$ ?move ?pos_moves) (< 0 (length$ ?pos_kills))) then
    ;Si intenta mover pero puede comer.
    (printout t "Estas obligado a comer una ficha." crlf)
    (return (create$ -1))
  )
  (if (member$ ?move ?pos_moves) then
    ;Si mueve una ficha.
    (bind ?board (replace$ ?board (coord_to_board ?ny ?nx) (coord_to_board ?ny ?nx) (get_piece ?board ?y ?x)))
    (bind ?board (replace$ ?board (coord_to_board ?y ?x) (coord_to_board ?y ?x) 0))
    (return (create$ 1 ?board))
  )
  (printout t "Introduce un movimiento valido." crlf)
  (return (create$ -1))
)


(deffunction MAIN::crown (?board)
  (loop-for-count (?x 1 ?*SIZE*) do
    (if (= 1 (get_piece ?board ?*SIZE* ?x)) then
      (bind ?board (replace$ ?board (coord_to_board ?*SIZE* ?x) (coord_to_board ?*SIZE* ?x) 2))
    )
    (if (= -1 (get_piece ?board 1 ?x)) then
      (bind ?board (replace$ ?board (coord_to_board 1 ?x) (coord_to_board 1 ?x) -2))
    )
  )
  (return ?board)
)

(defrule MAIN::victory "Termina la partida."
  (victory ?v)
  (computer_color ?c)
=>
  (switch (= ?v ?c)
    (case TRUE then (printout t "Victoria del ORDENADOR." crlf))
    (case FALSE then (printout t "Victoria del JUGADOR." crlf))
  )
  (halt)
)

(defmodule PLAYER (import MAIN ?ALL))

(defrule PLAYER::player_turn "Realiza el turno del jugador."
  (declare (salience 10))
  (player_color ?c)
  ?f1 <- (turn ?t)
  ?f2 <- (board $?b)
=>
  (print_board ?b)
  (if (or (and (= 0 (length$ (check_moves ?b ?c))) (= 0 (length$ (check_kills ?b ?c)))) (and (not (member$ ?c ?b)) (not (member$ (* 2 ?c) ?b)))) then
    (assert (victory (* -1 ?c)))
    (return)
  )
  (printout t "Introduce tu movimiento JUGADOR." crlf)
  (printout t "Introduce las coordenadas de la ficha quieres mover y las de la posicion objetivo (y1 x1 y2 x2)" crlf)
  (bind ?move_result (create$ -1))
  (bind ?keep_killing FALSE)
  (while (or (not (< 0 (nth$ 1 ?move_result))) ?keep_killing) do
    (bind ?move (readline))
    (bind ?move_result (move ?b ?c ?move))
    (if (< 0 (nth$ 1 ?move_result)) then
      (bind ?b (delete$ ?move_result 1 1))
    )
    (if (= 2 (nth$ 1 ?move_result)) then
      (bind ?keep_killing (keep_killing ?b ?c ?move))
      (if ?keep_killing then
        (print_board ?b)
        (printout t "Sigue comiendo JUGADOR..." crlf)
      )
    )
  )
  (bind ?b (crown ?b))
  (retract ?f1)
  (retract ?f2)
  (assert (turn (+ ?t 1)))
  (assert (board ?b))
  (pop-focus)
  (focus COMPUTER)
)

(defmodule COMPUTER (import MAIN ?ALL))

(defrule COMPUTER::computer_turn "Realiza el turno del jugador."
  (declare (salience 10))
  (computer_color ?c)
  ?f1 <- (turn ?t)
  ?f2 <- (board $?b)
  =>
  (print_board ?b)
  (if (or (and (= 0 (length$ (check_moves ?b ?c))) (= 0 (length$ (check_kills ?b ?c)))) (and (not (member$ ?c ?b)) (not (member$ (* 2 ?c) ?b)))) then
    (assert (victory (* -1 ?c)))
    (return)
  )
  (printout t "Introduce tu movimiento ORDENADOR." crlf)
  (printout t "Introduce las coordenadas de la ficha quieres mover y las de la posicion objetivo (y1 x1 y2 x2)" crlf)
  (bind ?move_result (create$ -1))
  (bind ?keep_killing FALSE)
  (while (or (not (< 0 (nth$ 1 ?move_result))) ?keep_killing) do
    (bind ?move (readline))
    (bind ?move_result (move ?b ?c ?move))
    (if (< 0 (nth$ 1 ?move_result)) then
      (bind ?b (delete$ ?move_result 1 1))
    )
    (if (= 2 (nth$ 1 ?move_result)) then
      (bind ?keep_killing (keep_killing ?b ?c ?move))
      (if ?keep_killing then
        (print_board ?b)
        (printout t "Sigue comiendo ORDENADOR..." crlf)
      )
    )
  )
  (bind ?b (crown ?b))
  (assert (turn (+ ?t 1)))
  (assert (board ?b))
  (retract ?f1)
  (retract ?f2)
  (pop-focus)
  (focus PLAYER)
)
