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
"TextHeader" -> FromNonStandartCharacterCode[bytes, "EDCDIC"]; 

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
"BinaryHeader" -> 
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

(* SYGYTracks *)

FromSEGYTrack::usage = 
"FromSEGYTracks[bynaryInfo][bytes] \
return list of numbers"; 

FromSEGYTrack["BinaryHeader" -> binaryInfo_List] := 
FromSEGYTrack["BinaryHeader" -> binaryInfo] = 
Module[
	{
		timeInterval, 
		trackLength, 
		numberFormat, 
		numberbutesize
	}, 

	timeInterval = "TimeInterval" /. binaryInfo; 
	trackLength = "TrackLength" /. binaryInfo; 
	numberFormat = "NumberFormat" /. binaryInfo; 
	numberbutesize = NonStandartNumberByteSize[numberFormat]; 

	(* Return *) 
	Function[{bytes}, FromNonStandartNumberFormat[bytes[[240 + 1 ;; -1]], numberFormat]]
]; 

(* /SYGYTracks *)

(* SEGYImport *)

SEGYImport[file: (_File | _String)] := 
Module[
	{
		textHeader, 
		binaryHeader, 
		tracks, 
		trackcount, 
		tracklength, 
		numberformat, 
		numbersize, 
		trackbytecount
	}, 

	textHeader = FromSEGYTextHeader[Table[BinaryRead[file], {3200}]]; 
	binaryHeader = FromSEGYBinaryHeader[Table[BinaryRead[file], {400}]]; 
	
	tracklength = "TrackLength" /. binaryHeader[[-1]]; 
	numberformat = "NumberFormat" /. binaryHeader[[-1]]; 
	numbersize = NonStandartNumberByteSize[numberformat]; 
	trackbytecount = 240 + numbersize * tracklength; 
	
	trackcount = (FileByteCount[file] - 3600) / trackbytecount; 

	tracks = Table[
		FromSEGYTrack[binaryHeader][Table[BinaryRead[file], {trackbytecount}]], 
		{trackcount}
	]; 

	Close[file]; 
	
	(* return *)
	SEGYData[{textHeader, binaryHeader, tracks}]
]; 

(* /SEGYImport *)

End[]; (*`Private`*)

EndPackage[]; (*`SEGY`*) 