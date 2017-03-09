(* ::Package:: *)

(* :Title: NonStandartNumberFormat *)
(* :Context: NonStandartNumberFormat` *)
(* :Version: 0.0.3 *)
(* :MathematicaVersion: 10.0+ *)
(* :Keywords: IBM 32 Float *)
(* :Email: KirillBelovTest@gmail.com *)
(* :Creator: Kirill Belov *)

BeginPackage["NonStandartNumberFormat`"]; 

FromNonStandartNumberFormat::usage = 
"FromNonStandartNumberFormat[bytes, \"format\"] return number"; 

ToNonStandartNumberFormat::usage = 
"ToNonStandartNumberFormat[number, \"format\"] return bytes"; 

NonStandartNumberByteSize::usage = 
"NonStandartNumberByteSize[format]\
return byte size of the digit for this format"; 

Begin["`Private`"]; 

NonStandartDigitByteSize[1 | "IMB 32 Float"] := 4; 

(* IMB 32 Float *) 

ToIBM32Float = 
Compile[{{number, _Real}}, 
    Module[{sign, exp, firstbits, fractbits}, 

        (* sign of the nimber *)
        sign = UnitStep[number]; 

        (* 16-th exponent *)
        exp = Ceiling[Log[16, Abs[number]]]; 

        firstbits = If[sign == 0, 
            BitOr[exp + 64, 128], 
            exp + 64
        ]; 
        fractbits = IntegerDigits[Floor[16.0^exp number 256.0^3], 256]; 
        Join[{firstbits}, fractbits]
    ]
]; 

(* /IBM 32 Float *) 

End[]; (*`Private`*)

EndPackage[]; (*`NonStandartNumberFormat`*) 