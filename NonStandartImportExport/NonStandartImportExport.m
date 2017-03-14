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

(* preparation *)
Unprotect["`*"]; 
Clear["`*"]; 

$NonStandartImportExportDirectory::usage = 
"$NonStandartImportExportDirectory - NonStandartImportExamport project directory"; 

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

(* definition for the project directory *)
$NonStandartImportExportDirectory = 
FileNameJoin[FileNameSplit[$InputFileName][[1 ;; -3]]]; 

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

NonStandartLoad[unloaded_FileFormats`SEGY`SEGYUnloaded, opts: OptionsPattern[SEGYLoad]] := 
SEGYLoad[unloaded, opts]; 

(* /SEG-Y *) 

End[]; (*`Private`*) 

(* protection from change *) 
SetAttributes[Evaluate[Names["`*"]], ReadProtected]; 
Protect["`*"]; 

EndPackage[]; (*NonStandartImportExport`*)  