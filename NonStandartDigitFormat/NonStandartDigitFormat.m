(* ::Package:: *)

BeginPackage["NonStandartDigitFormat`"]; 

FromNonStandartDigitFormat::usage = 
"FromNonStandartDigitFormat[bytes, \"format\"]"; 

ToNonStandartDigitFormat::usage = 
"FromNonStandartDigitFormat[digit, \"format\"]"; 

NonStandartDigitLength::usage = 
"NonStandartDigitLength[format]\
return byte size of the digit for this format"; 

Begin["`Private`"]; 

(* IMB 32 Float *) 

NonStandartDigitLength[1 | "IMB 32 Float"] := 4; 

IBM32FloatSign::usage = 
"IBM32FloatSign[b1]\
return sign of the digit\
internal symbol"; 

IBM32FloatSign = 
Function[b1, (-1)^BitGet[b1, 7]]; 

IBM32FloatExp::usage = 
"IBM32FloatExp[b1]\
return exponent of the digit\
internal symbol"; 

IBM32FloatExp = 
Function[b1, 16^(BitClear[b1, 7] - 64)]; 

IBM32FloatFraction::usage = 
"IBM32FloatFraction[b1, b3, b4]\
return fraction part of the digit\
internal symbol"; 

IBM32FloatFraction = 
Function[{b2, b3, b4}, FromDigits[{b2, b3, b4}, 256] / 16777216.0]; 

IBM32BinSign::usage = 
"IBM32FloatSign[digit]\
return  binary representation of the sign\
internal symbol"; 

IBM32BinSign = 
Function[{digit}, UnitStep[-digit]]; 

IBM32BinExp::usage = 
"IBM32FloatExp[digit]\
return binary representation of the exponent\
internal symbol"; 

IBM32BinExp = 
Function[{digit}, IntegerDigits[RealDigits[digit, 16][[-1]] + 64, 2, 7]]; 

IBM32BinFraction::usage = 
"IBM32FloatFraction[digit]\
return binary representation of the fraction part\
internal symbol"; 

IBM32BinFraction = 
Function[{digit}, IntegerDigits[RealDigits[digit, 16][[1, 1 ;; 6]], 2, 4]]; 

(* /IBM 32 Float *) 

FromNonStandartDigitFormat[
	{b1_Integer, b2_Integer, b3_Integer, b4_Integer}, 
	1 | "IBM 32 Float"
] := 
IBM32FloatSign[b1] IBM32FloatExp[b1] IBM32FloatFraction[b2, b3, b4]; 

Attributes[ToNonStandartDigitFormat] = {Listable}; 

ToNonStandartDigitFormat[digit_Real, 1 | "IBM 32 Float"] := 
FromDigits[#, 2]& /@ Partition[Flatten[{
	Prepend[IBM32BinExp[digit], IBM32BinSign[digit]], 
	IBM32BinFraction[digit] 
}], 8]; 

End[]; (*`Private`*)

EndPackage[]; (*`NonStandartDigitFormat`*) 