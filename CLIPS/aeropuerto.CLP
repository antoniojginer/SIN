(deffacts aeropuerto	
	(camino puerta1 puerta3)
	(camino puerta1 puerta5)
	(camino puerta1 puertaF)
	
	(camino puerta2 puerta4)
	(camino puerta2 puertaP)
	
	(camino puerta3 puerta1)
	(camino puerta3 puerta4)
	
	(camino puerta4 puerta3)
	(camino puerta4 puerta2)	
	
	(camino puertaF puerta2)
	(camino puertaF puerta1)
	
	(camino puertaR puerta5)
	(camino puertaR puerta6)
	
	(camino puerta5 puertaR)
	(camino puerta5 puerta7)
	(camino puerta5 puerta6)
	
	(camino puerta6 puerta8)
	(camino puerta6 puertaR)
	
	(camino puerta7 puerta5)
	(camino puerta7 puerta8)
	
	(camino puerta8 puerta7)
	(camino puerta8 puerta6)
	
	(vagon n1 tipo T1)
	(vagon n2 tipo T2)
	
	(maleta m1 origen puertaF destino puerta3 peso 12)
	(maleta m2 origen puertaF destino puerta5 peso 18)
	(maleta m3 origen puerta1 destino puertaR peso 20)
	(maleta m4 origen puerta6 destino puertaR peso 14)
	
	(total 4)
)	

(deffunction inicio ()
    (reset)
    (printout t "Profundidad Maxima:= " )
    (bind ?prof (read))
    (printout t "Tipo de Búsqueda " crlf "1.- Anchura" crlf "2.- Profundidad" crlf)
    (bind ?a (read))
    (if (eq ?a 1)
        then (set-strategy breadth)
        else (set-strategy depth))
    (assert (aeropuerto maq_trans puerta6 n1 puerta6 n2 puerta2 enganchado n1 maletas entregadas cargadas 0 nivel 0))
    (assert (profundidad-maxima ?prof))
)

(defrule objetivo  
	(declare (salience 100))
	?f <- (aeropuerto $?x1 entregadas $?x2 cargadas ?c nivel ?n)
	(profundidad-maxima ?pro)
	(total ?t)
	
	(test (> ?pro ?n))
	
	(test (= ?t (length$ $?x2)))
	
	=>
	(printout t "SOLUCION ENCONTRADA EN EL NIVEL " ?n crlf)
	(printout t "HECHO OBJETIVO " ?f crlf)
	(halt)
)

(defrule cargar
	(aeropuerto maq_trans ?p $?x1 enganchado ?v maletas $?x2 entregadas $?x3 cargadas ?c nivel ?n)
	(maleta ?nom origen ?p $?x4 peso ?pes)
	(vagon ?v tipo ?t)
	(profundidad-maxima ?pro)
	
	(test (not (member$ ?nom $?x2)))
	
	(test (not (member$ ?nom $?x3)))
	
	(test (> ?pro ?n))
	
	(test (or (and (eq ?t T1) (<= ?pes 15)) (and (eq ?t T2) (> ?pes 15)))) 
	=> 
	(assert (aeropuerto maq_trans ?p $?x1 enganchado ?v maletas $?x2 ?nom entregadas $?x3 cargadas (+ ?c 1) nivel (+ ?n 1)))
)

(defrule descargar
	(aeropuerto maq_trans ?p $?x1 enganchado ?v maletas $?x2 entregadas $?x3 cargadas ?c nivel ?n)
	(maleta ?nom $?x4 destino ?p peso ?pes)
	(profundidad-maxima ?pro)
	
	(test (member$ ?nom $?x2))	
	
	(test (> ?pro ?n))
	
	=> 
	(assert (aeropuerto maq_trans ?p $?x1 enganchado ?v maletas (delete-member$ $?x2 ?nom) entregadas $?x3 ?nom cargadas (- ?c 1) nivel (+ ?n 1)))
)

(defrule mover
	(aeropuerto maq_trans ?p $?x1 nivel ?n)
	(camino ?p ?d)
	(profundidad-maxima ?pro)
	
	(test (> ?pro ?n))
	
	=>
	(assert (aeropuerto maq_trans ?d $?x1 nivel (+ ?n 1)))	
)


(defrule desenganchar
	(aeropuerto maq_trans ?m $?x1 ?e ?pos $?x2 enganchado ?e $?x3 cargadas 0 nivel ?n)
	(profundidad-maxima ?pro)
	
	(test (> ?pro ?n))
	
	=>
	(assert (aeropuerto maq_trans ?m $?x1 ?e ?m $?x2 enganchado NULO $?x3 cargadas 0 nivel (+ ?n 1)))
)

(defrule enganchar 
	(aeropuerto maq_trans ?m $?x1 ?v ?m $?x2 enganchado NULO $?x3 nivel ?n)
	(profundidad-maxima ?pro)
	
	(test (> ?pro ?n))
	
	=>
	(assert (aeropuerto maq_trans ?m $?x1 ?v ?m $?x2 enganchado ?v $?x3 nivel (+ ?n 1)))
)









