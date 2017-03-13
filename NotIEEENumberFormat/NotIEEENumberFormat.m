(* ::Package:: *)

(* :Title: NotIEEENumberFormat *)
(* :Context: NotIEEENumberFormat` *)
(* :Version: 0.0.4 *)
(* :MathematicaVersion: 10.0+ *)
(* :Keywords: Not IEEE; IBM 32 Float *)
(* :Email: KirillBelovTest@gmail.com *)
(* :Creator: Kirill Belov *) 

BeginPackage["NotIEEENumberFormat`"]; 

(* preparation *)
Unprotect["`*"]; 
Clear["`*"]; 

NotIEEENumberSize::usage = 
"NotIEEENumberSize[format]\
return byte size of the number for this format"; 

FromNotIEEENumberFormat::usage = 
"FromNotIEEENumberFormat[bytes, \"format\"] return list of numbers"; 

ToNotIEEENumberFormat::usage = 
"ToNotIEEENumberFormat[number, \"format\"] return list of bytes"; 

Begin["`Private`"]; 

NotIEEENumberSize[1 | "IMB 32 Float"] := 4; 

FromNotIEEENumberFormat[bytes: {__Integer}, 1 | "IBM 32 Float"] := 
FromIBM32Float[bytes]; 

ToNotIEEENumberFormat[numbers: {__Real}, 1 | "IBM 32 Float"] := 
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
	
		If[number >= 7.2370051459731155`*^75, Return[{127, 255, 255, 255}]]; 
		If[number <= - 7.2370051459731155`*^75, Return[{255, 255, 255, 255}]]; 
		If[0.0 <= number <= 8.636168040338686`*^-78, Return[{0, 255, 255, 255}]]; 
		If[0.0 > number >= - 8.636168040338686`*^-78, Return[{128, 255, 255, 255}]]; 

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

(* protection from change *) 
SetAttributes[Evaluate[Names["`*"]], ReadProtected]; 
Protect["`*"]; 

EndPackage[]; (*`NonStandartNumberFormat`*) 