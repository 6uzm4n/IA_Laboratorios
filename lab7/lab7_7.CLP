;LABORATORIO 7-7 INTELIGENCIA ARTIFICIAL

;Dados dos hechos multicampo, devuelve la unión de los elementos de ambos.

(deffunction append (?multicampo ?simple)
;Añade el parámetro simple al final del parámetro multicampo.
  (return (insert$ ?multicampo (+ 1 (length$ ?multicampo)) ?simple))
)

(deffunction union (?mult1 ?mult2)
;Devuelve la intersección de los multicampo pasados como parámetro.
	(bind $?union (create$))
  (foreach ?i ?mult1
    (if (eq FALSE (member$ ?i ?mult2)) then
      (bind $?union (append $?union ?i))
    )
  )
  (foreach ?j ?mult2
    (bind $?union (append $?union ?j))
  )
	(return ?union)
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
	(printout t "La union es: " (union $?a $?b) crlf)
  (halt)
)
