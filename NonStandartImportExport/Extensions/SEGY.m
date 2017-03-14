(* ::Package:: *)

(* :Title: SEGY *)
(* :Context: NonStandartImportExport`Extensions`SEGY` *)
(* :Version: 0.0.4 *)
(* :MathematicaVersion: 10.0+ *)
(* :Keywords: non standart file extensions; SEG-Y *)
(* :Email: KirillBelovTest@gmail.com *)
(* :Creator: Kirill Belov *)

BeginPackage["NonStandartImportExport`Extensions`SEGY`", 
	{
		"NonStandartImportExport`", 
		"CustomEncoding`", 
		"NotIEEENumberFormat`", 
		"FileFormats`SEGY`"
	}
]; 

(* preparation *)
Unprotect["`*"]; 
Clear["`*"]; 

SEGYImport::usage = 
"SEGYImport[file, \"SEGY\"]"; 

SEGYExport::usage = 
"SEGYExport[file, data, \"SEGY\"]"; 

SEGYLoad::usage = 
"SEGYLoad[Unloaded[..]]"; 

Begin["`Private`"]; 

(* /SEGYData *)

(* TextHeader *)

FromSEGYTextHeader::usage = 
"FromSEGYTextHeader[bytes] \
return \"C 1 .. (3200 symbols)\""; 

FromSEGYTextHeader[bytes: {__Integer}] /; 
Length[bytes] == 3200 := 
FromCustomCharacterCode[bytes, "EBCDIC"]; 

ToSEGYTextHeader::usage = 
"ToSEGYTextHeader[text] \
return {b1, b2, .. <3200 bytes> ..}"; 

ToSEGYTextHeader[text_String | ("TextHeader" -> text_String)] := 
Join[ToCustomCharacterCode[text, "EBCDIC"], ConstantArray[0, 3200]][[1 ;; 3200]]; 

(* /TextHeader *) 

(* BinaryHeader *)

SEGYBinaryHeaderTemplate::usage = 
"SEGYBinaryHeaderTemplate[] \
list of pairs of the following form: name - position bytes in title\ 
internal symbol"; 

SEGYBinaryHeaderTemplate[] = 
{
	"JobID" -> {1, 2, 3, 4}, 
	"LineNumber" -> {5, 6, 7, 8},
	"ReelNumber" -> {9, 10, 11, 12},
	"NumberDataTraces" -> {13, 14},
	"NumberAuxTraces" -> {15, 16},
	"IntervalReelRecord" -> {17, 18},
	"IntervalFieldRecord" -> {19, 20},
	"NumberOfSamplesForReel" -> {21, 22},
	"NumberOfSamplesForField" -> {23, 24},
	"SamplesFormatCode" -> {25, 26},
	"CDPFold" -> {27, 28},
	"TraceSortingCode" -> {29, 30},
	"VerticalSumCode" -> {31, 32},
	"SweepFrequencyAtStart" -> {33, 34},
	"SweepFrequencyAtEnd" -> {35, 36},
	"SweepLength" -> {37, 38},
	"SweepTypeCode" -> {39, 40},
	"TraceNumberOfSweepChannel" -> {41, 42},
	"SweepTraceTaperLengthAtStart" -> {43, 44},
	"SweepTraceTaperLength" -> {45, 46},
	"TaperType" -> {47, 48},
	"CorrelatedDataTraces" -> {49, 50},
	"BinaryGainRecovered" -> {51, 52},
	"AmplitudeRecoveryMethod" -> {53, 54},
	"MeasurementSystem" -> {55, 56},
	"ImpulseSignal" -> {57, 58},
	"VibratoryPolarityCode" -> {59, 60}
}; 

FromSEGYBinaryHeader::usage = 
"FromSEGYBinaryHeader[bytes] \
return {<file bin info>}"; 

FromSEGYBinaryHeader[bytes: {__Integer}] /; 
Length[bytes] == 400 := 
Table[elem[[1]] -> FromDigits[bytes[[elem[[2]]]], 256], {elem, SEGYBinaryHeaderTemplate[]}]; 

ToSEGYBinaryHeader::usage = 
"ToSEGYBinaryHeader[{info}] \
return {b1, b2, .. <400 bytes> ..}"; 

ToSEGYBinaryHeader[binaryInfo_List | ("BinaryHeader" -> binaryInfo_List)] := 
Block[{bytes = ConstantArray[0, 400]}, 
	Table[
		bytes[[elem[[2]]]] = 
		IntegerDigits[elem[[1]] /. binaryInfo, 256, Length[elem[[2]]]], 

		{elem, SEGYBinaryHeaderTemplate[]} 
	]; 
	bytes
]; 

(* /BinaryHeader *)

(* SEGYHeaders *) 

FromSEGYHeader::usage = 
"FromSEGYHeader[][bytes] \
return {<track bin data>}"; 

FromSEGYHeader[] := 
FromSEGYHeader[] = 
Function[{bytes}, bytes]; 

ToSEGYHeader::usage = 
"ToSEGYHeader[][bytes] \
return {<240 bytes from bin data>}"; 

ToSEGYHeader[] := 
ToSEGYHeader[] = 
Function[{bytes}, Flatten[{bytes, ConstantArray[0, 240]}][[1 ;; 240]]]; 

(* /SEGYHeaders *)

(* SYGYTracks *)

FromSEGYTrack::usage = 
"FromSEGYTracks[bynaryInfo][bytes] \
return list of numbers"; 

FromSEGYTrack[
	binaryInfo_List | ("BinaryHeader" -> binaryInfo_List)
] := 
FromSEGYTrack["BinaryHeader" -> binaryInfo] = 
FromSEGYTrack[binaryInfo] = 
FromSEGYTrack["SamplesFormatCode" /. binaryInfo]; 

FromSEGYTrack[
	numberFormat: (_Integer | _String)
] := 
FromSEGYTrack[numberFormat] = 
Function[{bytes}, FromNotIEEENumberFormat[bytes, numberFormat]]; 

ToSEGYTrack::usage = 
"ToSEGYTracks[bynaryInfo][numbers] \
return list of numbers"; 

ToSEGYTrack[
	binaryInfo_List | ("BinaryHeader" -> binaryInfo_List)
] := ToSEGYTrack["SamplesFormatCode" /. binaryInfo]; 

ToSEGYTrack[numberFormat: (_String | _Integer)] := 
ToSEGYTrack[numberFormat] = 
ToSEGYTrack[numberFormat] = 
Function[ToNotIEEENumberFormat[#, numberFormat]]; 

(* /SYGYTracks *)

(* SEGYImport *)

(*
	Loading -> Memory  - loading data from the file in RAM
	Loading -> Dump    - loading data from the file, convert and save to damp file .mx (coming soon)
	Loading -> Delayed - loading data only when called 
	
	TrackConverting -> {CompilationTarget -> "MVM"} - using MVM as compilation target  
	TrackConverting -> {CompilationTarget -> "C"} - using C as compilation target 
*)
Options[SEGYImport] = 
{"Loading" -> "Memory"}; 

SEGYImport::erropt = 
"Error option value `1`"; 

SEGYImport[file: (_File | _String), OptionsPattern[]] := 
Module[
	{
		Loading = OptionValue["Loading"], 
		stream = OpenRead[file, BinaryFormat -> True], 
		
		filebytecount = FileByteCount[file], 
		tracksbytecount = FileByteCount[file] - 3600, 
		tracklength, numbersize, trackscount, numberformat, 
		trackbytecount, 

		TextHeader, BinaryHeader, Headers, Tracks
	}, 

	SetStreamPosition[stream, 0]; 
	TextHeader = 
	"TextHeader" -> FromSEGYTextHeader[BinaryReadList[stream, "Byte", 3200]]; 

	SetStreamPosition[stream, 3200]; 
	BinaryHeader = 
	"BinaryHeader" -> FromSEGYBinaryHeader[BinaryReadList[stream, "Byte", 400]]; 

	tracklength = "NumberOfSamplesForReel" /. Last[BinaryHeader]; 
	numberformat = "SamplesFormatCode" /. Last[BinaryHeader]; 
	numbersize = NotIEEENumberSize[numberformat]; 
	trackbytecount = 240 + tracklength * numbersize; 
	
	trackscount = tracksbytecount / trackbytecount; 

	Headers = "Headers" -> Switch[Loading, 
		"Memory", 
			Table[
				SetStreamPosition[stream, pos]; 
				FromSEGYHeader[][BinaryReadList[stream, "Byte", 240]], 

				{pos, 3600, filebytecount - trackbytecount, trackbytecount}
			], 
		
		"Dump", 
			$Failed, 
		
		"Delayed",
			SEGYUnloaded[{
				"ConvertFunction" -> FromSEGYHeader[], 
				"DataFile" -> file, 
				"DataSize" -> 240, 
				"Positions" -> Table[ 
					pos, 
					{pos, 3600, filebytecount - trackbytecount, trackbytecount}
				]
			}], 

		_, 
			Message[SEGYImport::erropt, Loading]; Abort[]
	]; 

	Tracks = "Tracks" -> Switch[Loading, 
		"Memory", 
			Table[
				SetStreamPosition[stream, pos + 240]; 
				FromSEGYTrack[BinaryHeader][BinaryReadList[stream, "Byte", trackbytecount - 240]], 

				{pos, 3600, filebytecount - trackbytecount, trackbytecount}
			], 
		
		"Dump", 
			$Failed, 
		
		"Delayed", 
			SEGYUnloaded[{
				"ConvertFunction" -> FromSEGYTrack[BinaryHeader], 
				"DataFile" -> file, 
				"DataSize" -> trackbytecount - 240, 
				"Positions" -> Table[
					pos + 240, 
					{pos, 3600, filebytecount - trackbytecount, trackbytecount}
				] 
			}], 

		_, 
			Message[SEGYImport::erropt, Loading]; Abort[]
	]; 

	Close[stream]; 

	(* return *) 
	SEGYData[{TextHeader, BinaryHeader, Headers, Tracks}]
]; 

(* /SEGYImport *) 

(* SEGYLoad *) 

SEGYLoad[unloaded: SEGYUnloaded[{__Rule}]] := 
Module[
	{
		convertfunction = unloaded["ConvertFunction"], 
		stream = OpenRead[unloaded["DataFile"], BinaryFormat -> True], 
		datasize = unloaded["DataSize"], 
		position = unloaded["Positions"]
	}, 

	Switch[position, 
		_Integer, 
			Reap[
				SetStreamPosition[stream, position]; 
				Sow[convertfunction[BinaryReadList[stream, "Byte", datasize]]]; 
				Close[stream]; 
			][[-1, -1, -1]], 
		{__Integer}, 
			Reap[
				Sow[
					Table[
						SetStreamPosition[stream, i]; 
						convertfunction[BinaryReadList[stream, "Byte", datasize]], 
						{i, position}
					]
				]; 
				Close[stream]; 
			][[-1, -1, -1]]
	]
]; 


(* SEGYExport *)

SEGYExport[file_String, data_SEGYData] := 
(
	BinaryWrite[file, ToSEGYTextHeader[data["TextHeader"]]]; 
	BinaryWrite[file, ToSEGYBinaryHeader[data["BinaryHeader"]]]; 
	Do[
		BinaryWrite[file, ToSEGYHeader[][data["Headers", i]]]; 
		BinaryWrite[file, ToSEGYTrack[data["BinaryHeader"]][data["Tracks", i]]];, 
		{i, 1, Length[data["Headers"]]}
	]; 
	Close[file]; 
	Return[file] 
);

(* /SEGYExport *)

End[]; (*`Private`*) 

(* protection from change *) 
SetAttributes[Evaluate[Names["`*"]], ReadProtected]; 
Protect["`*"]; 

EndPackage[]; (*`SEGY`*) 