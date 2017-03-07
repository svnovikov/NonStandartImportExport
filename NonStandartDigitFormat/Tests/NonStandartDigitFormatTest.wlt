BeginTestSection["NonStandartDigitFormatTest"]

VerificationTest[(* 1 *)
	Get["NonStandartDigitFormat`"]
	,
	Null	
]

VerificationTest[(* 2 *)
	List[FromNonStandartDigitFormat[List[0, 255, 255, 255], "IBM 32 Float"], ToNonStandartDigitFormat[Times[Power[16, -64], Times[Plus[Power[256, 3], -1.`], Power[Power[256, 3], -1]]], "IBM 32 Float"]]
	,
	List[Times[Power[16, -64], Times[Plus[Power[256, 3], -1.`], Power[Power[256, 3], -1]]], List[0, 255, 255, 255]]	
]

VerificationTest[(* 3 *)
	List[FromNonStandartDigitFormat[List[64, 255, 255, 255], "IBM 32 Float"], ToNonStandartDigitFormat[Times[Plus[Power[256, 3], -1.`], Power[Power[256, 3], -1]], "IBM 32 Float"]]
	,
	List[Times[Plus[Power[256, 3], -1.`], Power[Power[256, 3], -1]], List[64, 255, 255, 255]]	
]

VerificationTest[(* 4 *)
	List[FromNonStandartDigitFormat[List[127, 255, 255, 255], "IBM 32 Float"], ToNonStandartDigitFormat[Times[Power[16, 63], Times[Plus[Power[256, 3], -1.`], Power[Power[256, 3], -1]]], "IBM 32 Float"]]
	,
	List[Times[Power[16, 63], Times[Plus[Power[256, 3], -1.`], Power[Power[256, 3], -1]]], List[127, 255, 255, 255]]	
]

VerificationTest[(* 5 *)
	List[FromNonStandartDigitFormat[List[192, 255, 255, 255], "IBM 32 Float"], ToNonStandartDigitFormat[Times[Times[-1, Plus[Power[256, 3], -1.`]], Power[Power[256, 3], -1]], "IBM 32 Float"]]
	,
	List[Times[Times[-1, Plus[Power[256, 3], -1.`]], Power[Power[256, 3], -1]], List[192, 255, 255, 255]]	
]

VerificationTest[(* 6 *)
	List[FromNonStandartDigitFormat[List[255, 255, 255, 255], "IBM 32 Float"], ToNonStandartDigitFormat[Times[Times[-1, Power[16, 63]], Times[Plus[Power[256, 3], -1.`], Power[Power[256, 3], -1]]], "IBM 32 Float"]]
	,
	List[Times[Times[-1, Power[16, 63]], Times[Plus[Power[256, 3], -1.`], Power[Power[256, 3], -1]]], List[255, 255, 255, 255]]	
]

EndTestSection[]
