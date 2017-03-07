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

NonStandartImport[file: (_File | _String), "SEGY" | "SGY"] /; 
If[
	FileExistsQ[file] && StringMatchQ[ToUpperCase[FileExtension[file]], "SGY" | "SEGY"], 
	True, 
	Message[NonStandartImport::nofile, ToString[file]]; False
]:= 
Through[SEGYData[SEGYTextHeader, SEGYBinaryHeader, SEGYTracks][BinaryReadList[file]]]; 

NonStandartExport[file: (_File | _String), data_SEGYData, "SEGY" | "SGY"] /; 
If[
	StringMatchQ[ToUpperCase[FileExtension[file]], "SGY" | "SEGY"], 
	True, 
	Message[NonStandartExport::wrgfl, ToString[file]]; False
]:= 
BinaryWrite[file, Through[Join[SEGYBinTextHeader, SEGYBinBinaryHeader, SEGYBinTracks][data]]];  

End[]; (*`Private`*) 

EndPackage[]; (*NonStandartImportExport`*) 
