(defmodule MAIN)
(defrule MAIN::start => (focus Extracting))
(defmodule Extracting)
 
(deftemplate Extracting::basesoftgoal (slot value))
 
(deffacts Extracting::initial
   (basesoftgoal (value eat))
   (basesoftgoal (value sleep))
   (basesoftgoal (value work)))
 
(defrule Extracting::ruleSaveBl1
   =>
   (save-facts "softgoalFile.fct"))
