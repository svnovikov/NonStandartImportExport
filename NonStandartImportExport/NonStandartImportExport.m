(* ::Package:: *)

(* :Title: NonStandartImportExport *)
(* :Context: NonStandartImportExport` *)
(* :Version: 0.0.4 *)
(* :MathematicaVersion: 10.0+ *)
(* :Keywords: non standart file extensions; SEG-Y *)
(* :Email: KirillBelovTest@gmail.com *)
(* :Creator: Kirill Belov *)

BeginPackage["NonStandartImportExport`", 
	{
		"NonStandartImportExport`Extensions`SEGY`"
	}
]; 

Unprotect[{NonStandartImport, NonStandartExport, NonStandartLoad}]; 

NonStandartLoad::usage = 
"NonStandartLoad[Unload[]]"; 

NonStandartImport::usage = 
"NonStandartImport[file, extension]"; 

NonStandartExport::usage = 
"NonStandartImport[file, data, extension]"; 

Begin["`Private`"]; 

NonStandartImport::nofile = 
"File `1` not found during non standart import"; 

NonStandartImport::wrgfl = 
"The wrong file `1`"; 

NonStandartExport::wrgfl = 
"The wrong file `1`"; 

(* SEG-Y *) 

NonStandartImport[file: (_File | _String), "SEGY" | "SGY", opts: OptionsPattern[SEGYImport]] /; 
If[
	FileExistsQ[file], 
	True, 
	If[
		StringMatchQ[FileExtension[file], "sgy" | "segy", IgnoreCase -> True], 
		Message[NonStandartImport::wrgfl, file]; False, 
		Message[NonStandartImport::nofile, file]; False
	]
] := 
SEGYImport[file, opts];

NonStandartExport[file: (_File | _String), data_SEGYData, "SEGY" | "SGY", opts: OptionsPattern[SEGYExport]] /; 
If[
	StringMatchQ[FileExtension[file], "sgy" | "segy", IgnoreCase -> True], 
	True, 
	Message[NonStandartExport::wrgfl, file]; False
] := 
SEGYExport[file, data, opts]; 

(* /SEG-Y *) 

End[]; (*`Private`*) 

SetAttributes[
	{NonStandartImport, NonStandartExport, NonStandartLoad}, 
	{ReadProtected, Protected}
]; 

EndPackage[]; (*NonStandartImportExport`*) 
