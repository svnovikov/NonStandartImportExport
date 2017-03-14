(* ::Package:: *) 

BeginPackage["FileFormats`Extensions`SEGY`"]; 

(* preparation *)
Unprotect["`*"]; 
Clear["`*"]; 

SEGYData::usage = 
"SEGYData[]"; 

SEGYUnloaded::usage = 
"SEGYUnloaded[]"; 

Begin["`Private`"]; (* Begin Private Context *) 

(* SEGYData *) 


(* /SEGYData *)

(* SEGYUnloaded *)

End[]; (* End Private Context *) 

(* from change protection *)
SetAttributes[Evaluate[Names["`*"]], ReadProtected]; 
Protect["`*"]; 

EndPackage[]; (*`Extensions`SEGY`*) 