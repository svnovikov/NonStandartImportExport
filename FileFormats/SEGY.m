(* ::Package:: *) 

(* :Title: SEGY *) 
(* :Context: FileFormats`SEGY` *) 
(* :Version: 0.0.2 *) 
(* :MathematicaVersion: 10.0+ *) 
(* :Keywords: SEG-Y; IBM File Formats *) 
(* :Email: KirillBelovTest@gmail.com *) 
(* :Creator: Kirill Belov *) 

BeginPackage["FileFormats`SEGY`"]; 

(* preparation *)
Unprotect["`*"]; 
Clear["`*"]; 

SEGYData::usage = 
"SEGYData[]"; 

SEGYUnloaded::usage = 
"SEGYUnloaded[]"; 

Begin["`Private`"]; (* Begin Private Context *) 

(* SEGYData *) 

SEGYData::argex = 
"Invalid arguments: `1`"; 

object: 
SEGYData[data: {___, key_String -> value_, ___}][key_String] := 
value; 

object: 
SEGYData[
	data: 
	{
		___, 
		key_String -> {___, subkey_String -> value_, ___}, 
		___
	} 
][key_String, subkey_String] := 
value; 

object_SEGYData[key_String, subkeys: {__String}] := 
Table[object[key, subkey], {subkey, subkeys}]; 

object_SEGYData[keys: {__String}] := 
Map[object][keys];

object_SEGYData[
	key_String, 
	indexes: (_Integer | _Span | {__Integer}) ..
] := 
object[key][[indexes]];

object_SEGYData[
	keys_String, subkey_String, 
	indexes: (_Integer | _Span | {__Integer}) ..
] := 
object[keys, subkey][[indexes]];

object: SEGYData[
	___, 
	key_String -> unloaded_SEGYUnloaded, 
	___
][
	key_String, 
	indexes: (_Integer | _Span | {__Integer})
] := 
unloaded[indexes]; 

object_SEGYData[args___] := 
(Message[SEGYData::argex, Row[{args}, "; "]]; $Failed); 

(* /SEGYData *) 

(* SEGYUnloaded *) 

unloaded: SEGYUnloaded[{___Rule, key_String -> value_, ___Rule}][
	key_String
] := value; 

unloaded_SEGYUnloaded[keys: {__String}] := 
Table[unloaded[key], {key, keys}]; 

unloaded: SEGYUnloaded[{datainfo__Rule, poskey_String -> dataposlist: ({__Integer})}][
	index_Integer
] := SEGYUnloaded[{datainfo, poskey -> dataposlist[[index]]}]; 

unloaded: SEGYUnloaded[{datainfo__Rule, poskey_String -> dataposlist: ({__Integer})}][
	indexes: (List | Span)[__Integer] 
] := Table[SEGYUnloaded[{datainfo, poskey -> pos}], {pos, dataposlist[[indexes]]}]; 

(* /SEGYUnloaded *) 

End[]; (* End Private Context *) 

(* from change protection *) 
SetAttributes[Evaluate[Names["`*"]], ReadProtected]; 
Protect["`*"]; 

EndPackage[]; (*`FileFormats`SEGY`*) 