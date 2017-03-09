(* ::Package:: *)

BeginPackage["NonStandartImportExport`", 
	{
		"NonStandartImportExport`Extensions`SEGY`"
	}
]; 

NonStandartImport::usage = 
"NonStandartImport[file, extension]"; 

NonStandartExport::usage = 
"NonStandartImport[file, data, extension]"; 

Begin["`Private`"]; 

NonStandartImport::nofile = 
"File `1` not found during non standart import"; 

NonStandartExport::wrgfl = 
"The wrong file `1`"; 

(* SEG-Y *) 

NonStandartImport[file: (_File | _String), "SEGY" | "SGY", opts: OptionsPattern[SEGYImport]] /; 
If[
	FileExistsQ[file] && StringMatchQ[FileExtension[file], "sgy" | "segy", IgnoreCase -> True], 
	True, 
	Message[NonStandartImport::nofile, file]; False
] := 
SEGYImport[file, opts]; 

NonStandartExport[file: (_File | _String), data_SEGYData, "SEGY" | "SGY", opts: OptionsPattern[SEGYExport]] /; 
If[
	StringMatchQ[FileExtension[file], "sgy" | "segy", IgnoreCase -> True], 
	True, 
	Message[NonStandartExport::wrgfl, file]; False
] := 
SEGYExport[file, opts]; 

End[]; (*`Private`*) 

EndPackage[]; (*NonStandartImportExport`*) 
