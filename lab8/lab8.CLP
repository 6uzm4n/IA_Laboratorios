(deftemplate jarras
  (slot jarra1 (type INTEGER) (range 0 4))
  (slot jarra2 (type INTEGER) (range 0 3))
  (slot previo)
  (slot accion)
)

(deffacts estado-inicial "Estado inicial de las jarras."
  (jarras (jarra1 0) (jarra2 0) (previo 0) (accion "Inicializar: Jarra de la izquierda:4L Jarra de la derecha:3L" ))
)

(defrule llenar4 "Llena la jarra de 4 litros"
  ?f <- (jarras (jarra1 ?a) (jarra2 ?b))
  (test (< ?a 4))
  (not (jarras (jarra1 4) (jarra2 ?b)))
=>
  (assert (jarras (jarra1 4) (jarra2 ?b) (previo ?f) (accion "Llenar jarra izquierda.")))
)

(defrule llenar3 "Llena la jarra de 3 litros"
  ?f <- (jarras (jarra1 ?a) (jarra2 ?b))
  (test (< ?b 3))
  (not (jarras (jarra1 ?a) (jarra2 3)))
=>
  (assert (jarras (jarra1 ?a) (jarra2 3) (previo ?f) (accion "Llenar jarra derecha.")))
)

(defrule vaciar4 "Vacía la jarra de 4 litros"
  ?f <- (jarras (jarra1 ?a) (jarra2 ?b))
  (test (> ?a 0))
  (not (jarras (jarra1 0) (jarra2 ?b)))
=>
  (assert (jarras (jarra1 0) (jarra2 ?b) (previo ?f) (accion "Vaciar jarra izquierda.")))
)

(defrule vaciar3 "Vacía la jarra de 3 litros"
  ?f <- (jarras (jarra1 ?a) (jarra2 ?b))
  (test (> ?a 0))
  (not (jarras (jarra1 ?a) (jarra2 0)))
=>
  (assert (jarras (jarra1 ?a) (jarra2 0) (previo ?f) (accion "Vaciar jarra derecha.")))
)

(defrule verter4 "Vierte el contenido de la jarra de 4 litros en la de 3 litros."
  ?f <- (jarras (jarra1 ?a) (jarra2 ?b))
  (test (and (> ?a 0) (< ?b 3)))
  ;(not (jarras  (jarra1 ?j1 & ~(max 0 (- ?a (- 3 ?b)))) (jarra2 ?j2 & ~(min 3 (+ ?a ?b)))))
=>
  (assert (jarras (jarra1 (max 0 (- ?a (- 3 ?b)))) (jarra2 (min 3 (+ ?a ?b))) (previo ?f) (accion "Verter jarra izquierda en jarra derecha.")))
)

(defrule verter3 "Vierte el contenido de la jarra de 3 litros en la de 4 litros."
  ?f <- (jarras (jarra1 ?a) (jarra2 ?b))
  (test (and (< ?a 4) (> ?b 0)))
  ;(not (jarras (jarra1 (min 4 (+ ?a ?b))) (jarra2 (max 0 (- ?b (- 4 ?a))))))
=>
  (assert (jarras (jarra1 (min 4 (+ ?a ?b))) (jarra2 (max 0 (- ?b (- 4 ?a)))) (previo ?f) (accion "Verter jarra derecha en jarra izquierda.")))
)

(defrule encontrado "Comprueba si el programa ha encontrado la solucion"
  (declare (salience 5))
  ?f <- (jarras (jarra1 ?a) (jarra2 ?b))
  (test (= 2 ?a))
=>
  (printout t "Se ha encontrado una solucion:" crlf crlf)
  (assert (ruta ?f))
)

(defrule leer_ruta "Guarda la ruta que ha seguido el programa."
  (declare (salience 20))
  (not (escribiendo))
  ?r <- (ruta ?first $?rest)
  ?f <- (jarras (previo ?p))
  (test (and (eq ?f ?first) (not (eq ?p 0))))
=>
  (assert (ruta ?p ?first $?rest))
  (retract ?r)
)

(defrule fin_ruta "Se ha encontrado la ruta completa"
  (declare (salience 20))
  (not (escribiendo))
  (ruta ?first $?rest)
  ?f <- (jarras (previo ?p))
  (test (and (eq ?f ?first) (eq ?p 0)))
=>
  (assert (escribiendo))
)

(defrule escribir "Escribe la ruta que ha seguido el programa."
  (declare (salience 15))
  ?r <- (ruta ?first $?ruta)
  ?f <- (jarras (jarra1 ?a) (jarra2 ?b) (previo ?p) (accion ?accion))
  (test (eq ?f ?first))
=>
  (printout t "ACCION:  "  ?accion crlf)
  (printout t "ESTADO:  "  "Jarra de la izquierda: " ?a "     Jarra de la derecha: " ?b crlf crlf)
  (retract ?r)
  (assert (ruta $?ruta))
)

(defrule fin "Finaliza el programa."
  (declare (salience 10))
  (escribiendo)
=>
  (halt)
)
