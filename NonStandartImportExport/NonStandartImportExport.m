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
Module[
	{
		textHeader, binaryHeader, tracks, 
	
		textHeaderBin, binaryHeaderBin, 
		
		textheaderbytecount, binaryheaderbytecount, 
		trackheaderbytecount, tracksbytecount, filebytecount, 
		
		tracklength, digitsize, trakscount, 
		
		stream
	}, 

	filebytecount = FileByteCount[file]; 
	
	textheaderbytecount = 3200; 
	binaryheaderbytecount = 400; 
	trackheaderbytecount = 240; 

	tracksbytecount = filebytecount - 3600; 

	stream = OpenRead[file]; 

	textHeaderBin = Reap[Do[Sow[BinaryRead[stream]], {3200}]][[2, 1]]; 
	textHeader = SEGYTextHeader[textHeaderBin]; 
	
	binaryHeaderBin = Reap[Do[Sow[BinaryRead[stream]], {400}]][[2, 1]]; 
	binaryHeader = SEGYBinaryHeader[binaryHeaderBin]; 
	
	tracklength = "TrackLength" /. binaryHeader; 
	digitsize = "DigitSize" /. binaryHeader; 
	
	trakscount = tracksbytecount/(digitsize tracklength + trackheaderbytecount); 
	
	Do[
		
		1 + 1
		
		; ,
		{trakscount}
	]; 
	
	tracks = SEGYTrack; 
	
	Close[stream]; 

	(* return *)
	{textHeader, binaryHeader, tracks}
]; 

NonStandartExport[file: (_File | _String), data_SEGYData, "SEGY" | "SGY"] /; 
If[
	StringMatchQ[ToUpperCase[FileExtension[file]], "SGY" | "SEGY"], 
	True, 
	Message[NonStandartExport::wrgfl, ToString[file]]; False
]:= 
BinaryWrite[file, Through[Join[SEGYBinTextHeader, SEGYBinBinaryHeader, SEGYBinTracks][data]]];  

End[]; (*`Private`*) 

EndPackage[]; (*NonStandartImportExport`*) 
