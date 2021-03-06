(deftemplate producto
    (slot nombre (type SYMBOL))
    (slot tipo (type SYMBOL) (allowed-values fragil pesado normal))
    (slot envuelto (type SYMBOL) (allowed-values Si No))
    (slot volumen (type NUMBER) (range 0 200) (default 0))
    (slot empaquetado (type SYMBOL) (allowed-values Si No) (default No))
)

(deftemplate caja
    (slot espacioLibre (type NUMBER) (default 200))
    (slot tipo (type SYMBOL))
    (slot estado (type SYMBOL) (allowed-values abierta utilizada) (default abierta))
	(multislot listaProductos (default create$) )
)

(deffacts prod_init
    (producto (nombre tomates)(tipo fragil)(envuelto Si)(volumen 60))
    (producto (nombre patatas)(tipo pesado)(envuelto Si)(volumen 150))
    (producto (nombre lubina)(tipo normal)(envuelto No)(volumen 60))

    (producto (nombre avioneta)(tipo fragil)(envuelto Si)(volumen 80))
    (producto (nombre huevos)(tipo fragil)(envuelto Si)(volumen 180))
    (producto (nombre jamon)(tipo pesado)(envuelto No)(volumen 55))

    (producto (nombre colacao)(tipo normal)(envuelto Si)(volumen 195))
    (producto (nombre galletas)(tipo normal)(envuelto Si)(volumen 6))
    (producto (nombre queso)(tipo normal)(envuelto Si)(volumen 3))

    (producto (nombre vasos)(tipo fragil)(envuelto Si)(volumen 30))
    (producto (nombre macarrones)(tipo fragil)(envuelto Si)(volumen 66))
    (producto (nombre neumatico)(tipo pesado)(envuelto Si)(volumen 150))

)

;----------------------------------Reglas----------------------------------

(defrule initCaja 
	?prod <- (producto (nombre ?nom) (tipo ?t) (envuelto Si) (volumen ?v) (empaquetado No) )
	(not (exists  (caja (espacioLibre ?es) (tipo ?t) (estado abierta))))
=>
    (assert (caja (tipo ?t)))
    (printout t "Abrimos caja de tipo " ?t crlf)
)

(defrule abrirCaja 
    ?caja_ <- (caja (espacioLibre ?es) (tipo ?t) (estado abierta))
	
    ?prod_ <- (producto (nombre ?n) (tipo ?t) (envuelto Si) (volumen ?vol) (empaquetado No))
    (forall (producto (nombre ?nom) (tipo ?t) (envuelto Si) (volumen ?v) (empaquetado No)) (test(> ?v ?es)))
=>
    (modify ?caja_ (estado utilizada))
    (assert (caja (tipo ?t)))
    (printout t "Abrimos caja de tipo " ?t crlf)
)

(defrule empaquetar
    ?caja_ <- (caja (espacioLibre ?es) (tipo ?t) (estado abierta) (listaProductos $?listaProductos))
    ?prod <- (producto (nombre ?nom) (tipo ?t) (envuelto Si) (volumen ?v) (empaquetado No) )
    (test (< ?v ?es)) ;; solo ejecuto regla si cumple test
=>
    (modify ?caja_ (espacioLibre (- ?es ?v)) (listaProductos (insert$ $?listaProductos 1 ?prod)))
    (modify ?prod (empaquetado Si))
    (printout t "Empaquetamos " ?nom" en una caja que tenía "?es " unidades de espacio libre." crlf 
		"Ahora dicha caja sólo tiene " (- ?es ?v)  " unidades de espacio libre." crlf) 
)