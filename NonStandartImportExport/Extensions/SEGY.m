(* ::Package:: *)

BeginPackage["NonStandartImportExport`Extensions`SEGY`", 
	{
		"NonStandartCharacterEncoding`", 
		"NonStandartDigitFormat`"
	}
]; 

SEGYData::usage = 
"SEGYData[\"TextHeader\" -> \"C 1 ..\", \
\"BinaryHeader\" -> {..}, \
\"Tracks\" -> {\"Headers\" -> {..}, \"Data\" -> {..}}]"; 

SEGYTextHeader::usage = 
"SEGYTextHeader[data] \
return \"TextHeader\" -> \"C 1 ..\""; 

SEGYBinaryHeader::usage = 
"SEGYBinaryHeader[data] \
return \"BinaryHeader\" -> {h1 -> v1, h2 -> ..}"; 

SEGYTracks::usage = 
"SEGYTracks[data]\
return \"Tracks\" -> {\"Header\" -> {h1, ..}, \"Data\" -> {t1, ..}"; 

SEGYBinTextHeader::usage = 
"SEGYBinTextHeader[segy]\
return binary representation of the text header"; 

SEGYBinBinaryHeader::usage = 
"SEGYBinBinaryHeader[segy]\
return binary representation of the binary header"; 

SEGYBinTracks::usage = 
"SEGYBinTracks[segy]\
return binary representation of tracks"; 

Begin["`Private`"]; 

SEGYData /: 
Part[SEGYData[___, key_String -> value_, ___], key_String] := value; 

SEGYData /: 
Part[
	SEGYData[___, key1_String -> {___, key2_String -> value_, ___}, ___], 
	key1_String, key2_String
] := value; 

SEGYData /: 
Part[
	SEGYData[___, key1_String -> valueList_List, ___], 
	key1_String, part_Integer
] := valueList[[part]]; 

SEGYData /: 
Part[
	segyData_SEGYData, 
	key1_String, key2_String, part_Integer
] := segyData[[key1, key2]][[part]]; 

SEGYTextHeader[data: {__Integer}] := 
"TextHeader" -> FromNonStandartCharacterCode[data[[1 ;; 3200]], "EDCDIC"]; 

SEGYBinaryHeader[data: {__Integer}] := 
With[{binaryHeaderData = data[[3200 + 1 ;; 3200 + 400]]}, 
	"BinaryHeader" -> 
	{
		"DigitFormat" -> FromDigits[binaryHeaderData[[25 ;; 26]], 256], 
		"TrackLength" -> FromDigits[binaryHeaderData[[21 ;; 22]], 256], 
		"StepSize" -> FromDigits[binaryHeaderData[[17 ;; 18]], 256] 
	}
]; 

SEGYTracks[data: {__Integer}] := 
With[
	{
		binaryHeader = SEGYBinaryHeader[data], 
		tracksData = data[[3600 + 1 ;; -1]]
	}, 
	
	Module[
		{
			trackLength, 
			digitFormat, 
			digitLength, 
			length 
		}, 

		trackLength = "TrackLength" /. ("BinaryHeader" /. binaryHeader); 
		digitFormat = "DigitFormat" /. ("BinaryHeader" /. binaryHeader); 
		digitLength = NonStandartDigitLength[digitFormat]; 
		length = digitLength * trackLength + 240; 

		"Tracks" -> 
		{
			"Headers" -> 
			Map[FromNonStandartCharacterCode[#, "EDCDIC"]&,  
			Partition[tracksData, length][[All, 1 ;; 240]]], 
			
			"Data" -> 
			Map[FromNonStandartDigitFormat[#, digitFormat]&, 
			Partition[#, 4]& /@ 
			Partition[tracksData, length][[All, 240 + 1 ;; -1]], {2}]
		}
	]
]; 

SEGYBinTextHeader[data_SEGYData] := 
Join[
	ToNonStandartCharacterCode[data[["TextHeader"]], "EDCDIC"], 
	ConstantArray[0, 3200]
][[1 ;; 3200]]; 

SEGYBinBinaryHeader[data_SEGYData] := 
ReplacePart[
	ConstantArray[0, 400], 
	{
		17 -> IntegerDigits[data[["BinaryHeader", "StepSize"]], 256, 2][[1]], 
		18 -> IntegerDigits[data[["BinaryHeader", "StepSize"]], 256, 2][[2]], 
		21 -> IntegerDigits[data[["BinaryHeader", "TrackLength"]], 256, 2][[1]], 
		22 -> IntegerDigits[data[["BinaryHeader", "TrackLength"]], 256, 2][[2]], 
		25 -> IntegerDigits[data[["BinaryHeader", "DigitFormat"]], 256, 2][[1]], 
		26 -> IntegerDigits[data[["BinaryHeader", "DigitFormat"]], 256, 2][[2]]
	}
]; 

SEGYBinTracks[data_SEGYData] := 
Flatten[MapThread[
	Join[
		Join[ToNonStandartCharacterCode[#1, "EDCDIC"], ConstantArray[0, 240]][[1 ;; 240]], 
		ToNonStandartDigitFormat[#2, data[["BinaryHeader", "DigitFormat"]]]
	]&, 
	{
		data[["Tracks", "Headers"]], 
		data[["Tracks", "Data"]]
	} 
]]; 

End[]; (*`Private`*)

EndPackage[]; (*`SEGY`*) 