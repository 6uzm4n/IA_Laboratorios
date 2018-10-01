;LABORATORIO 4 INTELIGENCIA ARTIFICIAL

;El espacio de estados se definirá como un múlticampo con 3 campos, todos binarios:
; 1- posición de la aspiradora (0: izquierda/1: derecha)
; 2- estado de la habitación izquierda (0: limpia/1: sucia)
; 3- estado de la habitación derecha (0: limpia/1: sucia)

;Estado inicial
(defglobal ?*estadoI* = (create$ 0 1 1))
;Estados finales
(defglobal ?*estadoF* = (create$ "0 0 0" "1 0 0"))
;Estados visitados
(defglobal ?*estadosV* = (create$))
;Camino recorrido (L=limpiar, I=moverse izquierda, D=moverse derecha)
(defglobal ?*camino* = (create$ ""))


(deffunction limpiar (?estado)
  ;La aspiradora limpia la habitación en la que se encuentra.
  (switch (getAspiradora ?estado)
    (case 0 then
      (return (implode$ (replace$ (explode$ ?estado) 2 2 0)))
    )
    (case 1 then
      (return (implode$ (replace$ (explode$ ?estado) 3 3 0)))
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
  (if (member$ (implode$ ?estado) ?*estadoV*) then
    (return TRUE)
  else
    (return FALSE)
  )
)

(deffunction start ()
  (bind ?arbol (implode$ ?*estadoI));TODO CAMBIAR A STRING???
  (while (not (finalizado (explode$ (nth$ 1 ?arbol)))
    (bind ?actual (nth$ 1 ?arbol))
    ;Probamos a aspirar.
    (bind ?aux (limpiar ?actual))
    
    ;Probamos a ir a la izquierda.


    ;Probamos a ir a la derecha.
  )

)

-------------------------------------------------------------------------------
(deffunction getAspiradora (?estado)
  ;Devuelve la posición de la aspiradora.
  (return (nth$ 1 (explode$ ?estado)))
)

(deffunction getHabitacionI (?estado)
  ;Devuelve el estado de la habitación izquierda.
  (return (nth$ 2 ?estado))
)

(deffunction getHabitacionD (?estado)
  ;Devuelve el estado de la habitación derecha.
  (return (nth$ 3 ?estado))
)
