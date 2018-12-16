CHECKERS﻿(defglobal ?*SIZE* = 8) ;Dimensiones del tablero. Predeterminadas: 8
(defglobal ?*CHECKERS* = 3) ;Filas de fichas para cada jugador. Predeterminadas: 3
(defglobal ?*WHITE* = 1) ;Signo de las fichas negras.
(defglobal ?*BLACK* = -1)  ;Signo de las fichas blancas
(defglobal ?*DEPTH* = 4)  ;Profundidad a la que llega el árbol de búsqueda.

(defglobal ?*NEWID* = 0) ;Almacena el último id que se ha dado a un nodo del arbol.


;==================================================================================================
; MODULO MAIN
;==================================================================================================
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
	;	#     #		- El caracter central representa el contenido (" ", "o", "x", "%" o "@")
	;	#######

	;(clear-window)
	(bind ?i 1)
	(loop-for-count (?y 0 (* 4 ?*SIZE*)) do
		(loop-for-count (?x 0 (* 6 ?*SIZE*)) do
			(if (or (= 0 (mod ?y 4)) (= 0 (mod ?x 6))) then
				(printout t "#")
			else
				(if (and (= 0 (mod ?y 2)) (= 0 (mod ?x 3))) then
					(switch (nth$ ?i ?board)
						(case 0 then (printout t " "))
						(case 1 then (printout t "o")) ;Caracter para fichas blancas
						(case -1 then (printout t "x")) ;Caracter para fichas negras
            					(case 2 then (printout t "@")) ;Caracter para damas blancas
          					(case -2 then (printout t "%")) ;Caracter para damas negras
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
        (bind ?bl 0) ;Flag para controlar la búsqueda por abajo-izquierda
        (bind ?br 0) ;Flag para controlar la búsqueda por abajo-derecha
        (bind ?tl 0) ;Flag para controlar la búsqueda por arriba-izquierda
        (bind ?tr 0) ;Flag para controlar la búsqueda por arriba-derecha
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
                  ;Si encuentra una ficha enemiga y el flag está a 0, lo pone a 1 y puede comer.
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
                  ;Si encuentra una ficha enemiga y el flag está a 0, lo pone a 1 y puede comer.
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
                  ;Si encuentra una ficha enemiga y el flag está a 0, lo pone a 1 y puede comer.
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

(deffunction MAIN::check_end (?board)
  ;Dado un tablero devuelve 1/-1 en caso de que el tablero constituya un final de la partida y FALSE en caso contrario.
  ;En caso de devolver 1, ganan las blancas. Si devuelve -1 ganan las negras.
  (if (and (not (member$ -1 ?board)) (not (member$ -2 ?board))) then
    ;Comprueba si no existen fichas negras en el tablero.
    (return 1)
  )
  (if (and (= 0 (length$ (check_kills ?board -1))) (= 0 (length$ (check_moves ?board -1)))) then
    ;Comprueba si no existen movimientos posibles para las fichas negras.
    (return 1)
  )
  (if (and (not (member$ 1 ?board)) (not (member$ 2 ?board))) then
    ;Comprueba si no existen fichas blancas en el tablero.
    (return -1)
  )
  (if (and (= 0 (length$ (check_kills ?board 1))) (= 0 (length$ (check_moves ?board 1)))) then
    ;Comprueba si no existen movimientos posibles para las fichas blancas.
    (return -1)
  )
  (return FALSE)
)

(deffunction MAIN::heur_value (?board)
  ;Dado un tablero devuelve un valor heurístico que representa el estado del tablero. Cuanto mayor sea,
  ;se considera que el tablero es más beneficioso para las fichas blancas. De la misma forma, cuanto
  ;menor sea se considerará mejor tablero para las negras.
  (bind ?heur 0)
  (if (eq 1 (check_end ?board)) then
    (return 999999)
  )
  (if (eq -1 (check_end ?board)) then
    (return -999999)
  )
  (foreach ?piece ?board
    (bind ?heur (+ ?heur (* 1000 ?piece)))
  )
  (bind ?heur (+ ?heur (* 100 (length$ (check_kills ?board 1)))))
  (bind ?heur (- ?heur (* 100 (length$ (check_kills ?board -1)))))
  (bind ?heur (+ ?heur (* 10 (length$ (check_moves ?board 1)))))
  (bind ?heur (- ?heur (* 10 (length$ (check_moves ?board -1)))))
  (return ?heur)
)

(deffunction MAIN::consecutive (?move1 ?move2)
  ;Dados dos movimientos, devuelve TRUE si son consecutivos y FALSE si no lo son.
  ;Por ej. se consideran consecutivos los siguientes movimientos: "1 2 2 1" "2 1 3 2"
  (bind ?y (nth$ 3 (explode$ ?move1)))
  (bind ?x (nth$ 4 (explode$ ?move1)))
  (bind ?ny (nth$ 1 (explode$ ?move2)))
  (bind ?nx (nth$ 2 (explode$ ?move2)))
  (return (and (= ?y ?ny) (= ?x ?nx)))
)

(deffunction MAIN::keep_killing (?board ?player ?move)
  ;Dado un tablero y un movimiento previo de un jugador, calcula si puede seguir comiendo fichas.
  (bind ?keep_killing FALSE)
  (bind ?pos_kills (check_kills ?board ?player))
  (foreach ?kill ?pos_kills
    (if (consecutive ?move ?kill) then
      (bind ?keep_killing TRUE)
    )
  )
  (return ?keep_killing)
)

(deffunction MAIN::move (?board ?player ?move)
  ;Dado un tablero, un jugador y un movimiento, devuelve el tablero resultante tras realizar dicho movimiento.
  ;Además, unido al tabelro devuelve 1 en caso de que sea un movimiento normal y 2 si come una ficha.
  (bind ?y (nth$ 1 (explode$ ?move)))
  (bind ?x (nth$ 2 (explode$ ?move)))
  (bind ?ny (nth$ 3 (explode$ ?move)))
  (bind ?nx (nth$ 4 (explode$ ?move)))
  (bind ?pos_kills (check_kills ?board ?player))
  (bind ?pos_moves (check_moves ?board ?player))
  (if (member$ ?move ?pos_kills) then
    ;Si come una ficha:
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
      ;Elimina toda ficha que se encuentre entre la casilla inicial y la final (come fichas).
      (bind ?board (replace$ ?board (coord_to_board (+ ?y (* ?i ?iy)) (+ ?x (* ?i ?ix)))
                                        (coord_to_board (+ ?y (* ?i ?iy)) (+ ?x (* ?i ?ix))) 0))
      (bind ?i (+ ?i 1))
    )
    ;Mueve la ficha de la posición inicial a la posición objetivo.
    (bind ?board (replace$ ?board (coord_to_board ?ny ?nx) (coord_to_board ?ny ?nx) (get_piece ?board ?y ?x)))
    ;Elimina la ficha de la posición inicial.
    (bind ?board (replace$ ?board (coord_to_board ?y ?x) (coord_to_board ?y ?x) 0))
    (return (create$ 2 ?board))
  )
  (if (and (member$ ?move ?pos_moves) (< 0 (length$ ?pos_kills))) then
    ;Si intenta mover pero puede comer fichas se muestra un mensaje de error.
    (printout t "Estas obligado a comer una ficha." crlf)
    (printout t "Posibles movimientos: " ?pos_kills crlf) ;Debug
    (return (create$ -1))
  )
  (if (member$ ?move ?pos_moves) then
    ;Si mueve una ficha:
    ;Mueve la ficha de la posición inicial a la posición objetivo.
    (bind ?board (replace$ ?board (coord_to_board ?ny ?nx) (coord_to_board ?ny ?nx) (get_piece ?board ?y ?x)))
    ;Elimina la ficha de la posición inicial.
    (bind ?board (replace$ ?board (coord_to_board ?y ?x) (coord_to_board ?y ?x) 0))
    (return (create$ 1 ?board))
  )
  ;Si el movimiento no es válido se muestra un mensaje de error.
  (printout t "Introduce un movimiento valido." crlf)
  (printout t "Posibles movimientos: " ?pos_moves ?pos_kills crlf) ;Debug
  (return (create$ -1))
)

(deffunction MAIN::crown (?board)
  ;Comprueba el tablero que se pasa como parámetro y transforma las fichas en dama si es posible.
  ;Será posible transformarla cuando estas estén al final del tablero, dependiendo del color.
  (loop-for-count (?x 1 ?*SIZE*) do
    (if (= 1 (get_piece ?board ?*SIZE* ?x)) then
      ;Transforma las piezas blancas.
      (bind ?board (replace$ ?board (coord_to_board ?*SIZE* ?x) (coord_to_board ?*SIZE* ?x) 2))
    )
    (if (= -1 (get_piece ?board 1 ?x)) then
      ;Transforma las piezas negras.
      (bind ?board (replace$ ?board (coord_to_board 1 ?x) (coord_to_board 1 ?x) -2))
    )
  )
  (return ?board)
)

(defrule MAIN::victory "Termina la partida en caso de que un jugador marque la victoria."
  (victory ?v)
  (computer_color ?c)
=>
  (switch (= ?v ?c)
    (case TRUE then (printout t "Victoria del ORDENADOR." crlf))
    (case FALSE then (printout t "Victoria del JUGADOR." crlf))
  )
  (halt)
)

;==================================================================================================
; MODULO DEL JUGADOR
;==================================================================================================
(defmodule PLAYER (import MAIN ?ALL))

(defrule PLAYER::player_turn "Realiza el turno del jugador."
  (declare (salience 100))
  (player_color ?c)
  ?f <- (board $?b)
=>
  ;Imprime el tablero al principio del turno.
  (print_board ?b)
  ;Comprueba si se termina la partida.
  (bind ?v (check_end ?b))
  (if ?v then
    (assert (victory ?v))
    (return)
  )
  ;Pide un movimiento al jugador hasta que este sea uno válido.
  (printout t "Introduce tu movimiento JUGADOR." crlf)
  (printout t "Introduce las coordenadas de la ficha quieres mover y las de la posicion objetivo (y1 x1 y2 x2)" crlf)
  (bind ?move_result (create$ -1))
  (bind ?keep_killing FALSE)
  (while (or (not (< 0 (nth$ 1 ?move_result))) ?keep_killing) do
    (bind ?move (readline))
    (bind ?move_result (move ?b ?c ?move))
    (if (< 0 (nth$ 1 ?move_result)) then
      ;Si es un movimiento normal.
      (bind ?b (delete$ ?move_result 1 1))
    )
    (if (= 2 (nth$ 1 ?move_result)) then
      ;Si se ha comido ficha en el movimiento, se comprueba si puede seguir comiendo.
      (bind ?keep_killing (keep_killing ?b ?c ?move))
      (if ?keep_killing then
        ;Si se puede seguir comiendo se pide un nuevo movimiento al jugador.
        (print_board ?b)
        (printout t "Sigue comiendo JUGADOR..." crlf)
      )
    )
  )
  ;Se tranforman en damas las fichas correspondientes.
  (bind ?b (crown ?b))
  (retract ?f)
  (assert (board ?b))
  ;Cambia el foco de la ejecución al ordenador.
  (pop-focus)
  (focus COMPUTER)
)

;==================================================================================================
; MODULO DEL ORDENADOR
;==================================================================================================
(defmodule COMPUTER (import MAIN ?ALL))

(deftemplate COMPUTER::node
  (slot id)
  (slot father)
  (multislot board)
  (multislot move)
  (slot value)
  (slot depth)
  (slot visited)
  (slot cut)
)

(deftemplate COMPUTER::combo_move
  (multislot board)
  (slot depth)
  (slot turn)
  (multislot moves)
  (slot father)
)

(defrule COMPUTER::start_tree "Inicializa el árbol de búsqueda de movimientos."
  (declare (salience 25))
  (not (alfabeta))
  (not (endturn))
  (board $?b)
=>
  ;Imprime el tablero al principio del turno.
  (print_board ?b)
  ;Comprueba si se termina la partida.
  (bind ?v (check_end ?b))
  (if ?v then
    (assert (victory ?v))
    (return)
  )
  ;Inicializa el nodo padre del árbol.
  (assert (node (id 0) (father nil) (board $?b) (move "") (value nil) (depth 0) (cut FALSE)))
)

(defrule COMPUTER::build_tree "Construye el árbol de búsqueda de movimientos."
  (declare (salience 25))
  (not (alfabeta))
  (not (endturn))
  (computer_color ?cc)
  ?f <- (node (id ?id) (board $?b) (depth ?d) (cut FALSE))
  (test (< ?d ?*DEPTH*))
=>
  (switch (mod ?d 2)
    (case 0 then (bind ?turn ?cc))
    (case 1 then (bind ?turn (* -1 ?cc)))
  )
  (bind ?move_list (check_moves $?b ?turn))
  (bind ?kill_list (check_kills $?b ?turn))
  (if (= 0 (length$ ?kill_list)) then
    ;Si no se puede comer se recorre la lista de movimientos normales:
    (foreach ?move ?move_list
      (bind ?tmp_board (delete$ (move $?b ?turn ?move) 1 1))
      (bind ?tmp_board (crown ?tmp_board))
      ;Calculamos su heurístico.
      (if (or (= (+ ?d 1) ?*DEPTH*) (check_end ?tmp_board)) then
        (bind ?heur (* ?cc (heur_value ?tmp_board)))
        (bind ?cut TRUE)
      else
        (bind ?heur nil)
        (bind ?cut FALSE)
      )
      (bind ?*NEWID* (+ ?*NEWID* 1))
  		(assert (node (id ?*NEWID*) (father ?id) (board ?tmp_board) (move ?move) (value ?heur) (depth (+ ?d 1)) (cut ?cut) (visited FALSE)))
    )
  else
    ;Si se puede comer se recorre la lista de movimientos con comida:
    (foreach ?kill ?kill_list
      (bind ?tmp_board (delete$ (move $?b ?turn ?kill) 1 1))
      (bind ?keep_killing (keep_killing ?tmp_board ?turn ?kill))
      (if ?keep_killing then
        ;En caso de que se pueda seguir comiendo lo almacenamos para checkearlo en otro método.
        (assert (combo_move (board ?tmp_board) (depth ?d) (turn ?turn) (moves (create$ ?kill)) (father ?id)))
      else
        ;Si no se puede seguir comiendo guardamos el movimiento en el arbol.
        (bind ?tmp_board (crown ?tmp_board))
        ;Calculamos su heurístico.
    		(if (or (= (+ ?d 1) ?*DEPTH*) (check_end ?tmp_board)) then
    			(bind ?heur (* ?cc (heur_value ?tmp_board)))
          (bind ?cut TRUE)
    		else
    			(bind ?heur nil)
          (bind ?cut FALSE)
    		)
        (bind ?*NEWID* (+ ?*NEWID* 1))
        (assert (node (id ?*NEWID*) (father ?id) (board ?tmp_board) (move ?kill) (value ?heur) (depth (+ ?d 1)) (cut ?cut) (visited FALSE)))
      )
    )
  )
)

(defrule COMPUTER::check_combos "Calcula los movimientos consecutivos."
  (declare (salience 50))
  (computer_color ?cc)
  ?f <- (combo_move (board $?board) (turn ?turn) (depth ?depth) (moves $?moves) (father ?father))
=>
  ;Guardamos la lista de posibles movimientos.
  (bind ?kill_list (check_kills ?board ?turn))
  (foreach ?kill ?kill_list
    (if (consecutive (nth$ (length$ $?moves) $?moves) ?kill) then
      ;Si el movimiento es consecutivo al último que se ha realizado este se ejecuta
      (bind ?tmp_board (delete$ (move ?board ?turn ?kill) 1 1))
      (bind ?keep_killing (keep_killing ?tmp_board ?turn ?kill))
      (if ?keep_killing then
        ;En caso de que se pueda seguir comiendo lo ponemos a la cola para volver a checkear..
        (assert (combo_move (board ?tmp_board) (depth ?depth) (turn ?turn) (moves (append ?moves ?kill)) (father ?father)))
      else
        ;Si no se puede seguir comiendo guardamos el movimiento en el arbol.
        (bind ?tmp_board (crown ?tmp_board))
        ;Calculamos su heurístico.
        (if (or (= (+ ?depth 1) ?*DEPTH*) (check_end ?tmp_board)) then
    			(bind ?heur (* ?cc (heur_value ?tmp_board)))
          (bind ?cut TRUE)
    		else
    			(bind ?heur nil)
          (bind ?cut FALSE)
    		)
        (bind ?*NEWID* (+ ?*NEWID* 1))
        (assert (node (id ?*NEWID*) (father ?father) (board ?tmp_board) (move (append ?moves ?kill)) (value ?heur) (depth (+ ?depth 1)) (cut ?cut) (visited FALSE)))
      )
    )
  )
  (retract ?f)
)

(defrule COMPUTER::alfabeta "Marca el fin de la construcción del árbol y comienza el algoritmo alfabeta."
  (declare (salience 24))
  (not (alfabeta))
  (not (endturn))
=>
  ;(halt) ;Debug
  (assert (alfabeta))
)

(defrule COMPUTER::heur_expand "Expande el heuristico."
	(declare (salience 15))
  (alfabeta)
	?f1 <- (node (id ?id1) (depth ?d1) (value ?v1) (cut FALSE))
	?f2 <- (node (id ?id2) (depth ?d2) (value ?v2) (father ?id1) (visited FALSE))
  (not (node (father ?id2) (visited FALSE)))
  (test (not (eq ?v2 nil)))
=>
  ;Marcamos el hijo como visitado
  (modify ?f2 (visited TRUE))
  ;Si el padre no tiene valor, le asignamos el del hijo.
	(if (eq ?v1 nil) then
		(modify ?f1 (value ?v2))
	else
		(if (= 0 (mod ?d1 2)) then
      ;Si el padre es un nodo max y el valor del hijo es mayor, se sube.
			(if (< ?v1 ?v2) then
				(modify ?f1 (value ?v2))
			)
		else
      ;Si el padre es un nodo min y el valor del hijo es menor, se sube.
			(if (> ?v1 ?v2) then
				(modify ?f1 (value ?v2))
			)
		)
	)
)

(defrule COMPUTER::cut_max "Poda el árbol bajo nodos max."
	(declare (salience 20))
  (alfabeta)
	(node (id ?id) (depth ?d1) (value ?v1))
	?f <- (node (depth ?d2) (value ?v2) (father ?id) (cut FALSE) (visited FALSE))
  (test (and (not (eq ?v1 nil)) (not (eq ?v2 nil)) (< ?d2 ?*DEPTH*) (< ?v2 ?v1) (= 0 (mod ?d1 2))))
=>
  (modify ?f (cut TRUE))
)

(defrule COMPUTER::cut_min "Poda el árbol bajo nodos min."
	(declare (salience 20))
  (alfabeta)
	(node (id ?id1) (depth ?d1) (value ?v1))
  ?f <- (node (depth ?d2) (value ?v2) (father ?id1) (cut FALSE) (visited FALSE))
  (test (and (not (eq ?v1 nil)) (not (eq ?v2 nil)) (< ?d2 ?*DEPTH*) (> ?v2 ?v1) (= 1 (mod ?d1 2))))
=>
  (modify ?f (cut TRUE))
)

(defrule COMPUTER::cut_clear "Elimina las hojas no visitadas del arbol de búsqueda bajo un nodo cortado."
  (declare (salience 20))
  (alfabeta)
  (node (id ?id1) (cut TRUE))
  ?f <- (node (father ?id1) (visited FALSE))
=>
  (retract ?f)
)

(defrule COMPUTER::cut_orphan "Elimina los nodos que quedan huérfanos tras otros borrados."
  (declare (salience 20))
  (alfabeta)
  ?f <- (node (father ?id1))
  (not (node (id ?id1)))
  (test (not (eq nil ?id1)))
=>
  (retract ?f)
)

(defrule COMPUTER::cpu_move "Realiza el movimiento que haya calculado el árbol."
  (declare (salience 10))
  ?f1 <- (alfabeta)
  ?f2 <- (board $?b)
  (node (depth 0) (value ?v1))
  (node (depth 1) (value ?v1) (move $?move) (board $?new_board))
=>
  (printout t "Movimiento del ordenador: " $?move crlf)
  (retract ?f1)
  (retract ?f2)
  (assert (board ?new_board))
  (assert (endturn))
  ;(halt) ;Debug
)

(defrule COMPUTER::final_clear "Elimina el árbol de búsqueda después de acabar ésta."
  (declare (salience 25))
  (endturn)
  ?f <- (node)
=>
  (retract ?f)
)

(defrule COMPUTER::end_turn "Termina el turno del ordenador."
  (declare (salience 10))
  ?f2 <- (endturn)
=>
  ;Reiniciamos el contador de nodos del árbol.
  (bind ?*NEWID* 0)
  ;Eliminamos el hecho "endturn"
  (retract ?f2)
  ;Cambiamos el foco de la ejecución al jugador.
  (pop-focus)
  (focus PLAYER)
)
