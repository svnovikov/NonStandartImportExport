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
		"NotIEEENumberFormat`" 
	}
]; 

(* preparation *)
Unprotect["`*"]; 
Clear["`*"]; 

SEGYData::usage = 
"SEGYData[\"TextHeader\" -> \"C 1 ..\", \
\"BinaryHeader\" -> {..}, \
\"Tracks\" -> {\"Headers\" -> {..}, \"Data\" -> {..}}]"; 

SEGYUnloaded::usage = 
"SEGYUnloaded[]"; 

SEGYImport::usage = 
"SEGYImport[file, \"SEGY\"]"; 

SEGYExport::usage = 
"SEGYExport[file, data, \"SEGY\"]"; 

Begin["`Private`"]; 

(* SEGYData *)

SEGYData /: 
Part[SEGYData[data_List], key_String] := 
key /. data; 

SEGYData /: 
Part[data_SEGYData, key_String, indexes: (_Integer | Span[__Integer])] := 
data[[key]][[indexes]]; 

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

FromSEGYBinaryHeader::usage = 
"FromSEGYBinaryHeader[bytes] \
return {<file bin info>}"; 

FromSEGYBinaryHeader[bytes: {__Integer}] /; 
Length[bytes] == 400 := 
{
	"TimeInterval" -> FromDigits[bytes[[17 ;; 18]], 256] / 10^6, 
	"TrackLength" -> FromDigits[bytes[[21 ;; 22]], 256], 
	"NumberFormat" -> FromDigits[bytes[[25 ;; 26]], 256] 
}; 

ToSEGYBinaryHeader::usage = 
"ToSEGYBinaryHeader[{info}] \
return {b1, b2, .. <400 bytes> ..}"; 

ToSEGYBinaryHeader[binaryInfo_List | ("BinaryHeader" -> binaryInfo_List)] := 
Module[{binaryHeader = ConstantArray[0, 400]}, 

	binaryHeader[[17 ;; 18]] = 
	IntegerDigits[Round[("TimeInterval" /. binaryInfo)  * 10^6], 256, 2]; 

	binaryHeader[[21 ;; 22]] = 
	IntegerDigits["TrackLength" /. binaryInfo, 256, 2]; 
	
	binaryHeader[[25 ;; 26]] = 
	IntegerDigits["NumberFormat" /. binaryInfo, 256, 2]; 

	(* return *)
	binaryHeader
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

FromSEGYTrack[binaryInfo_List | ("BinaryHeader" -> binaryInfo_List)] := 
FromSEGYTrack["BinaryHeader" -> binaryInfo] = 
FromSEGYTrack[binaryInfo] = 
Function[{bytes}, FromNotIEEENumberFormat[bytes, "NumberFormat" /. binaryInfo]]; 

ToSEGYTrack::usage = 
"ToSEGYTracks[bynaryInfo][numbers] \
return list of numbers"; 

ToSEGYTrack[("BinaryHeader" -> binaryInfo_List) | binaryInfo_List] := 
ToSEGYTrack["BinaryHeader" -> binaryInfo] = 
ToSEGYTrack[binaryInfo] = 
Function[{numbers}, ToNotIEEENumberFormat[numbers, "NumberFormat" /. binaryInfo]]; 

(* /SYGYTracks *)

(* SEGYImport *)

(*
	Loading -> Memory  - loading data from the file in RAM
	Loading -> Dump    - loading data from the file, convert and save to damp file .mx (coming soon)
	Loading -> Delayed - loading data only when called 
*)
Options[SEGYImport] = {"Loading" -> "Memory"}; 

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

	tracklength = "TrackLength" /. BinaryHeader[[-1]]; 
	numberformat = "NumberFormat" /. BinaryHeader[[-1]]; 
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
		
		"Damp", 
			2, 
		
		"Delayed", 
			Table[
				With[
					{pos = pos}, 
					
					SEGYUnloaded[
						{
							"File" -> file, 
							"Start" -> pos, 
							"Bytes" -> 240, 
							"Function" -> FromSEGYHeader[]
						}
					]
				], 

				{pos, 3600, filebytecount - trackbytecount, trackbytecount}
			], 
		
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
		
		"Damp", 
			2, 
		
		"Delayed", 
			Table[
				With[
					{pos = pos, bytecount = trackbytecount}, 
					
					SEGYUnloaded[
						{
							"File" -> file, 
							"Start" -> pos + 240, 
							"Bytes" -> bytecount - 240, 
							"Function" -> FromSEGYTrack[BinaryHeader]
						}
					]
				], 

				{pos, 3600, filebytecount - trackbytecount, trackbytecount}
			], 

		_, 
			Message[SEGYImport::erropt, Loading]; Abort[]
	]; 

	Close[stream]; 

	(* return *) 
	SEGYData[{TextHeader, BinaryHeader, Headers, Tracks}]
]; 

(* /SEGYImport *) 

(* SEGYUnloaded *) 

SEGYUnloaded /: 
NonStandartImportExport`NonStandartLoad[
	SEGYUnloaded[
		{
			"File" -> file: (_File | _String), 
			"Start" -> start_Integer, 
			"Bytes" -> bytes_Integer, 
			"Function" -> function_
		}
	]
] := 
Function[
	Reap[
		SetStreamPosition[#1, #2]; 
		Sow[function[BinaryReadList[#1, "Byte", #3]]]; 
		Close[#1]; 
	][[-1, -1, -1]] 
][OpenRead[file, BinaryFormat -> True], start, bytes]; 

(* /SEGYUnloaded *)

(* SEGYExport *)

SEGYExport[file_String, data_SEGYData] := 
(
	BinaryWrite[file, ToSEGYTextHeader[data[["TextHeader"]]]]; 
	BinaryWrite[file, ToSEGYBinaryHeader[data[["BinaryHeader"]]]]; 
	Do[
		BinaryWrite[file, ToSEGYHeader[][data[["Headers", i]]]]; 
		BinaryWrite[file, ToSEGYTrack[data[["BinaryHeader"]]][data[["Tracks", i]]]];, 
		{i, 1, Length[data[["Headers"]]]}
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