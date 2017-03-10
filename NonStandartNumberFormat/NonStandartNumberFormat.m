(* ::Package:: *)

(* :Title: NonStandartNumberFormat *)
(* :Context: NonStandartNumberFormat` *)
(* :Version: 0.0.3 *)
(* :MathematicaVersion: 10.0+ *)
(* :Keywords: Not IEEE; IBM 32 Float *)
(* :Email: KirillBelovTest@gmail.com *)
(* :Creator: Kirill Belov *)

BeginPackage["NonStandartNumberFormat`"]; 

NonStandartNumberByteSize::usage = 
"NonStandartNumberByteSize[format]\
return byte size of the number for this format"; 

FromNonStandartNumberFormat::usage = 
"FromNonStandartNumberFormat[bytes, \"format\"] return list of numbers"; 

ToNonStandartNumberFormat::usage = 
"ToNonStandartNumberFormat[number, \"format\"] return list of bytes"; 

Begin["`Private`"]; 

NonStandartNumberByteSize[1 | "IMB 32 Float"] := 4; 

FromNonStandartNumberFormat[bytes: {__Integer}, 1 | "IBM 32 Float"] := 
FromIBM32Float[bytes]; 

ToNonStandartNumberFormat[numbers: {__Real}, 1 | "IBM 32 Float"] := 
Flatten[ToIBM32Float[numbers]]; 

(* IMB 32 Float *) 

FromIBM32Float = 
Compile[{{bytes, _Integer, 1}}, 
	
	(* return *) 
	Table[

		(* sign of the number *)	
		(-1)^(UnitStep[bytes[[i4th]] - 127.5]) * 

		(* 16th exp *)
		16.0^(BitAnd[127, bytes[[i4th]]] - 64) * 

		(* fraction part *)
		(
			bytes[[i4th + 1]] * 256.0^2 + 
			bytes[[i4th + 2]] * 256.0 + 
			bytes[[i4th + 3]]
		) / (256.0^3), 

		{i4th, 1, Length[bytes], 4}
	]
]; 

ToIBM32Float = 
Compile[{{number, _Real}}, 
    Module[{rsign, exp, firstbyte, fractbytes}, 

        (* bit for the represintation of the sign of the number *)
        rsign = UnitStep[-number]; 

        (* 16-th exponent *)
        exp = Ceiling[Log[16, Abs[number]]]; 

		(* first byte *)
        firstbyte = exp + 64 + rsign * 128; 
        
        (* bytes og the fraction part *)
        fractbytes = IntegerDigits[Floor[256.0^3 number / (16.0^exp)], 256, 3]; 

        (* return *)
        Join[{firstbyte}, fractbytes]
    ], 

	RuntimeAttributes -> {Listable}, 
	Parallelization -> True
]; 

(* /IBM 32 Float *) 

End[]; (*`Private`*)

EndPackage[]; (*`NonStandartNumberFormat`*) 