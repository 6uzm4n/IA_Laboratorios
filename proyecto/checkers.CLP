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

(deffunction MAIN::get_piece (?y ?x)
  ;Devuelve la ficha que se encuentra en unas coordenadas dadas del tablero.
  (return (nth$ (coord_to_board ?y ?x) ?*board*))
)

(deffunction MAIN::initialize ()
	;Inicia el tablero en la variable ?*board* en función de los parámetros definidos en ?*SIZE* y ?*CHECKERS*.
	;La posición 1-1 es arriba a la izquierda, y la 8-8 abajo a la derecha. Los 0 son espacios vacíos.
  ;Los 1, 2, -1 y -2 son fichas y damas de cada jugador.
	(loop-for-count (?y 1 ?*SIZE*) do
		(loop-for-count (?x 1 ?*SIZE*) do
			(if (and (= 1 (mod (+ ?x ?y) 2)) (<= ?y ?*CHECKERS*)) then
				(bind ?*board* (append ?*board* 1))
			else
				(if (and (= 1 (mod (+ ?x ?y) 2)) (> ?y (- ?*SIZE* ?*CHECKERS*))) then
					(bind ?*board* (append ?*board* -1))
				else
					(bind ?*board* (append ?*board* 0))
				)
			)
		)
	)
)

(deffunction MAIN::print_board ()
	;Imprime por pantalla ?*board*, el tablero de juego
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
					(switch (nth$ ?i ?*board*)
						(case 0 then (printout t " "))
						(case 1 then (printout t "o"))
						(case -1 then (printout t "x"))
            (case 2 then (printout t "O"))
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
  (initialize)
  (print_board)
)

(deffunction MAIN::check_kills (?player)
  ;Devuelve una lista de las posiciones en las que se encuentra una ficha que puede comer a otra.
  ;El parámetro player ha de ser 1 o -1 y define el jugador que come.
  (bind ?kills (create$))
  (loop-for-count (?y 1 ?*SIZE*) do
		(loop-for-count (?x 1 ?*SIZE*) do
      (if (= 1 (* (get_piece ?y ?x) ?player)) then
        ;Calcula movimiento de fichas normales.
        (if (and (<= 1 (+ ?y (* 2 ?player))) (>= ?*SIZE* (+ ?y (* 2 ?player)))) then
          ;Si no se sale verticalmente.
          (if (and (<= 1 (- ?x 2))       (> 0 (* ?player (get_piece (+ ?y ?player) (- ?x 1)))) (= 0 (get_piece (+ ?y (* 2 ?player)) (- ?x 2)))) then
            ;Si puede comer a izquierda
            (bind ?kills (append ?kills (implode$ (create$ ?y ?x (+ ?y (* 2 ?player)) (- ?x 2)))))
          )
          (if (and (>= ?*SIZE* (+ ?x 2)) (> 0 (* ?player (get_piece (+ ?y ?player) (+ ?x 1)))) (= 0 (get_piece (+ ?y (* 2 ?player)) (+ ?x 2)))) then
            ;Si puede comer a derecha
            (bind ?kills (append ?kills (implode$ (create$ ?y ?x (+ ?y (* 2 ?player)) (+ ?x 2)))))
          )
        )
        (if (= 2 (* (get_piece ?y ?x) ?player)) then
          ;Calcula movimiento de damas.
          (printout t "No debería printear esto." crlf)
        )
  		)
    )
	)
  (return ?kills)
)

(deffunction MAIN::check_moves (?player)
  ;Devuelve una lista de las posiciones en las que se encuentra una ficha que puede moverse sin comer.
  ;El parámetro player ha de ser 1 o -1 y define el jugador que mueve.
  (bind ?moves (create$))
  (loop-for-count (?y 1 ?*SIZE*) do
		(loop-for-count (?x 1 ?*SIZE*) do
      (if (= 1 (* (get_piece ?y ?x) ?player)) then
        ;Calcula movimiento de fichas normales.
        (if (and (<= 1 (+ ?y ?player)) (>= ?*SIZE* (+ ?y ?player))) then
          ;Si no se sale verticalmente.
          (if (and (<= 1 (- ?x 1))         (= 0 (get_piece (+ ?y ?player) (- ?x 1)))) then
            ;Si puede mover la izquierda
            (bind ?moves (append ?moves (implode$ (create$ ?y ?x (+ ?y ?player) (- ?x 1)))))
          )
          (if (and (>= ?*SIZE* (+ ?x 1))   (= 0 (get_piece (+ ?y ?player) (+ ?x 1)))) then
            ;Si puede mover a la derecha
            (bind ?moves (append ?moves (implode$ (create$ ?y ?x (+ ?y ?player) (+ ?x 1)))))
          )
        )
      )
      (if (= 2 (* (get_piece ?y ?x) ?player)) then
        ;Calcula movimiento de damas.
        (bind ?bl TRUE) ;Flag para cuando no puede seguir buscando por abajo-izquierda
        (bind ?br TRUE) ;Flag para cuando no puede seguir buscando por abajo-derecha
        (bind ?tl TRUE) ;Flag para cuando no puede seguir buscando por arriba-izquierda
        (bind ?tr TRUE) ;Flag para cuando no puede seguir buscando por arriba-derecha
        (loop-for-count (?i 1 (max ?x ?y (- ?*SIZE* ?x) (- ?*SIZE* ?y))) do
          (if (and (>= ?*SIZE* (+ ?y ?i))  (<= 1 (- ?x ?i)) ?bl) then
            ;Abajo-izquierda
            (if (= 0 (get_piece (+ ?y ?i) (- ?x ?i))) then
              (bind ?moves (append ?moves (implode$ (create$ ?y ?x (+ ?y ?i) (- ?x ?i)))))
            else
              ;Si encuentra un obstáculo se pone el flag a FALSE
              (bind ?bl FALSE)
            )
          )
          (if (and (>= ?*SIZE* (+ ?y ?i))  (>= ?*SIZE* (+ ?x ?i)) ?br) then
            ;Abajo-derecha
            (if (= 0 (get_piece (+ ?y ?i) (+ ?x ?i))) then
              (bind ?moves (append ?moves (implode$ (create$ ?y ?x (+ ?y ?i) (+ ?x ?i)))))
            else
              ;Si encuentra un obstáculo se pone el flag a FALSE
              (bind ?br FALSE)
            )
          )
          (if (and (<= 1 (- ?y ?i))        (<= 1 (- ?x ?i)) ?tl) then
            ;Arriba-izquierda
            (if (= 0 (get_piece (- ?y ?i) (- ?x ?i))) then
              (bind ?moves (append ?moves (implode$ (create$ ?y ?x (- ?y ?i) (- ?x ?i)))))
            else
              ;Si encuentra un obstáculo se pone el flag a FALSE
              (bind ?tl FALSE)
            )
          )
          (if (and (<= 1 (- ?y ?i))        (>= ?*SIZE* (+ ?x ?i)) ?tr) then
            ;Arriba-derecha
            (if (= 0 (get_piece (- ?y ?i) (+ ?x ?i))) then
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

(deffunction MAIN::move (?player ?move)
  (bind ?y (nth$ 1 (explode$ ?move)))
  (bind ?x (nth$ 2 (explode$ ?move)))
  (bind ?ny (nth$ 3 (explode$ ?move)))
  (bind ?nx (nth$ 4 (explode$ ?move)))
  (bind ?pos_kills (check_kills ?player))
  (bind ?pos_moves (check_moves ?player))
  (if (member$ ?move ?pos_kills) then
    ;Si come una ficha
    (bind ?i 1)
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
      (bind ?*board* (replace$ ?*board* (coord_to_board (+ ?y (* ?i ?iy)) (+ ?x (* ?i ?ix)))
                                        (coord_to_board (+ ?y (* ?i ?iy)) (+ ?x (* ?i ?ix))) 0))
      (bind ?i (+ ?i 1))
    )
    (bind ?*board* (replace$ ?*board* (coord_to_board ?ny ?nx) (coord_to_board ?ny ?nx) (* 2 ?player)))
    (bind ?*board* (replace$ ?*board* (coord_to_board ?ny ?nx) (coord_to_board ?ny ?nx) (get_piece ?y ?x)))
    (bind ?*board* (replace$ ?*board* (coord_to_board ?y ?x) (coord_to_board ?y ?x) 0))
    (return TRUE)
  )
  (if (and (member$ ?move ?pos_moves) (< 0 (length$ ?pos_kills))) then
    ;Si intenta mover pero puede comer.
    (printout t "Estas obligado a comer una ficha." crlf)
    (return FALSE)
  )
  (if (member$ ?move ?pos_moves) then
    ;Si mueve una ficha.
    (bind ?*board* (replace$ ?*board* (coord_to_board ?ny ?nx) (coord_to_board ?ny ?nx) (get_piece ?y ?x)))
    (bind ?*board* (replace$ ?*board* (coord_to_board ?y ?x) (coord_to_board ?y ?x) 0))
    (return TRUE)
  )
  (printout t "Introduce un movimiento valido." crlf)
)

(deffunction MAIN::crown ()
  (loop-for-count (?x 1 ?*SIZE*) do
    (if (= 1 (get_piece ?*SIZE* ?x)) then
      (bind ?*board* (replace$ ?*board* (coord_to_board ?*SIZE* ?x) (coord_to_board ?*SIZE* ?x) 2))
    )
    (if (= -1 (get_piece 1 ?x)) then
      (bind ?*board* (replace$ ?*board* (coord_to_board 1 ?x) (coord_to_board 1 ?x) -1))
    )
  )
)

(defmodule PLAYER)

(defmodule COMPUTER)
