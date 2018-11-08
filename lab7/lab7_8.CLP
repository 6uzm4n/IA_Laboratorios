;LABORATORIO 7-8 INTELIGENCIA ARTIFICIAL

;Dados dos hechos multicampo, devuelve la intersección de los elementos de ambos.

(deffunction append (?multicampo ?simple)
;Añade el parámetro simple al final del parámetro multicampo.
  (return (insert$ ?multicampo (+ 1 (length$ ?multicampo)) ?simple))
)

(deffunction intersection (?mult1 ?mult2)
;Devuelve la intersección de los multicampo pasados como parámetro.
	(bind $?intersection (create$))
  (foreach ?i ?mult1
    (if (not (eq FALSE (member$ ?i ?mult2))) then
      (bind $?intersection (append $?intersection ?i))
    )
  )
  (foreach ?j ?mult2
    (if (not (eq FALSE (member$ ?j ?mult1))) then
      (bind $?intersection (append $?intersection ?j))
    )
  )
	(return ?intersection)
)

(defrule R0 "Error para cuando no se ha definido ningun hecho."
  (declare (salience 1))
=>
  (printout t "ERROR: No se han inicializado dos hechos (hecho $x)." crlf)
)

(defrule R1
	(declare (salience 5))
	?f1 <- (hecho $?a)
  ?f2 <- (hecho $?b)
  (test (not (eq ?f1 ?f2)))
=>
  (retract ?f1)
  (retract ?f2)
	(printout t "La interseccion es: " (intersection $?a $?b) crlf)
  (halt)
)
