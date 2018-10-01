;LABORATORIO 4 INTELIGENCIA ARTIFICIAL

;El espacio de estados se definirá como un múlticampo con 3 campos, todos binarios:
; 1- posición de la aspiradora (0: izquierda/1: derecha)
; 2- estado de la habitación izquierda (0: limpia/1: sucia)
; 3- estado de la habitación derecha (0: limpia/1: sucia)

;Estado inicial
(defglobal ?*estadoI* = (create$ 1 1 1))
;Estados finales
(defglobal ?*estadoF* = (create$ "0 0 0" "1 0 0"))
;Estados visitados
(defglobal ?*estadosV* = (create$))
;Camino recorrido (A=aspirar, I=moverse izquierda, D=moverse derecha)
(defglobal ?*camino* = (create$ ""))


(deffunction aspirar (?estado)
  ;La aspiradora limpia la habitación en la que se encuentra.
  (switch (getAspiradora ?estado)
    (case 0 then
      (return (implode$ (replace$ (explode$ ?estado) 2 2 0)))
    )
    (case 1 then
      (return (implode$ (replace$ (explode$ ?estado) 3 3 0)))
    )
  )
)

(deffunction moverseI (?estado)
  ;La aspiradora se mueve hacia la derecha.
  (return (implode$ (replace$ (explode$ ?estado) 1 1 0)))
)

(deffunction moverseD (?estado)
  ;La aspiradora se mueve hacia la izquierda.
  (return (implode$ (replace$ (explode$ ?estado) 1 1 1)))
)

(deffunction finalizado (?estado)
  (if (member$ (implode$ ?estado) ?*estadoF*) then
    (return TRUE)
  else
    (return FALSE)
  )
)

(deffunction visitado (?estado)
  (if (member$ ?estado ?*estadosV*) then
    (return TRUE)
  else
    (return FALSE)
  )
)

(deffunction append (?multicampo ?simple)
  ;
  (return (insert$ ?multicampo (+ 1 (length$ ?multicampo)) ?simple))
)

(deffunction start ()
  (bind ?arbol (create$ (implode$ ?*estadoI*)))
  (while (not (finalizado (explode$ (nth$ 1 ?arbol))))
    (printout t ?arbol crlf)
    (bind ?actual (nth$ 1 ?arbol))
    ;Probamos a aspirar.
    (bind ?aux (aspirar ?actual))
    (if (not (visitado ?aux)) then
      (bind ?arbol (append ?arbol ?aux))
      (bind ?*estadosV* (append ?*estadosV* ?aux))
      (bind ?*camino* (append ?*camino* (str-cat (nth$ 1 ?*camino*) A)))
    )
    ;Probamos a ir a la izquierda.
    (bind ?aux (moverseI ?actual))
    (if (not (visitado ?aux)) then
      (bind ?arbol (append ?arbol ?aux))
      (bind ?*estadosV* (append ?*estadosV* ?aux))
      (bind ?*estadosV* (append ?*estadosV* ?aux))
      (bind ?*camino* (append ?*camino* (str-cat (nth$ 1 ?*camino*) I)))
    )
    ;Probamos a ir a la derecha.
    (bind ?aux (moverseD ?actual))
    (if (not (visitado ?aux)) then
      (bind ?arbol (append ?arbol ?aux))
      (bind ?*estadosV* (append ?*estadosV* ?aux))
      (bind ?*camino* (append ?*camino* (str-cat (nth$ 1 ?*camino*) D)))
    )
    ;Eliminamos primera posición del arbol.
    (bind ?arbol (delete$ ?arbol 1 1))
    (bind ?*camino* (delete$ ?*camino* 1 1))
  )

  (printout t "Se ha llegado al estado final " (nth$ 1 ?arbol) " por el camino " (nth$ 1 ?*camino*) crlf)
)

-------------------------------------------------------------------------------
(deffunction getAspiradora (?estado)
  ;Devuelve la posición de la aspiradora.
  (return (nth$ 1 (explode$ ?estado)))
)

;Sin usar
(deffunction getHabitacionI (?estado)
  ;Devuelve el estado de la habitación izquierda.
  (return (nth$ 2 ?estado))
)

;Sin usar
(deffunction getHabitacionD (?estado)
  ;Devuelve el estado de la habitación derecha.
  (return (nth$ 3 ?estado))
)
