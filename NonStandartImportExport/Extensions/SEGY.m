(* ::Package:: *)

BeginPackage["NonStandartImportExport`Extensions`SEGY`", 
	{
		"NonStandartCharacterEncoding`", 
		"NonStandartNumberFormat`"
	}
]; 

SEGYData::usage = 
"SEGYData[\"TextHeader\" -> \"C 1 ..\", \
\"BinaryHeader\" -> {..}, \
\"Tracks\" -> {\"Headers\" -> {..}, \"Data\" -> {..}}]"; 

SEGYImport::usage = 
"SEGYImport[file, \"SEGY\"]"; 

SEGYExport::usage = 
"SEGYExport[file, data, \"SEGY\"]"; 

Begin["`Private`"]; 

(* TextHeader *)

FromSEGYTextHeader::usage = 
"FromSEGYTextHeader[bytes] \
return \"TextHeader\" -> \"C 1 .. (3200 symbols)\""; 

FromSEGYTextHeader[bytes: {__Integer}] /; 
Length[bytes] == 3200 := 
FromNonStandartCharacterCode[bytes, "EDCDIC"]; 

ToSEGYTextHeader::usage = 
"ToSEGYTextHeader[text] \
return {b1, b2, .. <3200 bytes> ..}"; 

ToSEGYTextHeader[text_String | "TextHeader" -> text_String] := 
Join[ToNonStandartCharacterCode[text, "EDCDIC"], ConstantArray[0, 3200]][[1 ;; 3200]]; 

(* /TextHeader *) 

(* BinaryHeader *)

FromSEGYBinaryHeader::usage = 
"FromSEGYBinaryHeader[bytes] \
return \"BinaryHeader\" -> {<file bin info>}"; 

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

ToSEGYBinaryHeader[binaryInfo_List | "BinaryHeader" -> binaryInfo_List] := 
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

(* BinaryHeader *)

(* SEGYHeaders *) 

FromSEGYHeader::usage = 
"FromSEGYHeader[][bytes]"; 

FromSEGYHeader[] := 
FromSEGYHeader[] = 
Function[{bytes}, bytes]; 

ToSEGYHeader::usage = 
"ToSEGYHeader[][bytes]"; 

ToSEGYHeader[] := 
ToSEGYHeader[] = 
Function[{bytes}, bytes]; 

(* /SEGYHeaders *)

(* SYGYTracks *)

FromSEGYTrack::usage = 
"FromSEGYTracks[bynaryInfo][bytes] \
return list of numbers"; 

FromSEGYTrack["BinaryHeader" -> binaryInfo_List] := 
FromSEGYTrack["BinaryHeader" -> binaryInfo] = 
Function[{bytes}, FromNonStandartNumberFormat[bytes, "NumberFormat" /. binaryInfo]]; 

ToSEGYTrack::usage = 
"ToSEGYTracks[bynaryInfo][numbers] \
return list of numbers"; 

ToSEGYTrack["BinaryHeader" -> binaryInfo_List] := 
ToSEGYTrack["BinaryHeader" -> binaryInfo] = 
Function[{numbers}, ToNonStandartNumberFormat[numbers, "NumberFormat" /. binaryInfo]]; 

(* /SYGYTracks *)

(* SEGYImport *)

(*
	Loading -> Memory  - loading data from the file in RAM
	Loading -> Damp    - loading data from the file, convert and save to damp file .mx
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
	numbersize = NonStandartNumberByteSize[numberformat]; 
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
							"Strart" -> pos, 
							"Bytes" -> 240, 
							"Functions" -> FromSEGYHeader[]
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
							"Strart" -> pos + 240, 
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
SEGYLoad[
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
		function[BinaryReadList[#1, "Byte", #3]]; 
		Close[#1]
	][[-1, -1, -1]];	
][OpenRead[file, BinaryFormat -> True], start, bytes]; 

(* /SEGYUnloaded *)

(* SEGYExport *)



(* /SEGYExport *)

End[]; (*`Private`*)

EndPackage[]; (*`SEGY`*) 