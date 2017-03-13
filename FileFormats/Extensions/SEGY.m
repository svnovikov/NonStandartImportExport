(* ::Package:: *) 

BeginPackage["FileFormats`Extensions`SEGY`"]; 

(* preparation *)
Unprotect["`*"]; 
Clear["`*"]; 

SEGYData::usage = 
"SEGYData[\"TextHeader\" -> \"C 1 ..\", \
\"BinaryHeader\" -> {..}, \
\"Tracks\" -> {\"Headers\" -> {..}, \"Data\" -> {..}}]"; 

SEGYUnloaded::usage = 
"SEGYUnloaded[]"; 

Begin["`Private`"]; (* Begin Private Context *) 

(* SEGYData *)

SEGYData /: 
Part[SEGYData[data_List], key_String] := 
key /. data; 

SEGYData /: 
Part[data_SEGYData, key_String, indexes: (_Integer | Span[__Integer] | {__Integer})] := 
data[[key]][[indexes]]; 

SEGYData /: 
Part[data_SEGYData, key_String, subkey_String] := 
subkey /. (data[[key]]); 

SEGYData /: 
Part[data_SEGYData, key_String, indexes: (_Integer | Span[__Integer] | {__Integer}), subkey_String] := 
subkey /. (data[[key, indexes]]); 

(* /SEGYData *)

(* SEGYUnloaded *)

End[]; (* End Private Context *) 

(* from change protection *)
SetAttributes[Evaluate[Names["`*"]], ReadProtected]; 
Protect["`*"]; 

EndPackage[]; (*`Extensions`SEGY`*) 