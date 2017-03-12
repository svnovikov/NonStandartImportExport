BeginTestSection["IBM32FloatTest"]

VerificationTest[(* 1 *)
	Get["NonStandartNumberFormat`"]
	,
	Null	
]

VerificationTest[(* 2 *)
	List[NonStandartNumberByteSize[1], NonStandartNumberByteSize["IMB 32 Float"]]
	,
	List[4, 4]	
	,
	TestID->"IBM 32 Float: 01 Check byte size"
]

VerificationTest[(* 3 *)
	FromNonStandartNumberFormat[List[64, 255, 255, 255], 1]
	,
	List[Times[Plus[Power[256.`, 3], -1.`], Power[Power[256.`, 3], -1]]]	
	,
	TestID->"IBM 32 Float: 02 Check simple converting from the list of bytes"
]

VerificationTest[(* 4 *)
	ToNonStandartNumberFormat[List[Times[Plus[Power[256.`, 3], -1], Power[Power[256.`, 3], -1]]], 1]
	,
	List[64, 255, 255, 255]	
	,
	TestID->"IBM 32 Float: 03 Check simple converting number to the list of bytes"
]

VerificationTest[(* 5 *)
	CompoundExpression[Set[bytesIn, List[0, 255, 255, 255, 1, 255, 255, 255, 63, 255, 255, 255, 64, 255, 255, 255, 65, 255, 255, 255, 126, 255, 255, 255, 127, 255, 255, 255, 128, 255, 255, 255, 129, 255, 255, 255, 191, 255, 255, 255, 192, 255, 255, 255, 193, 255, 255, 255, 254, 255, 255, 255, 255, 255, 255, 255]], Set[numsIn, List[Times[Times[Plus[Power[256.`, 3], -1], Power[Power[256.`, 3], -1]], Power[16.`, -64]], Times[Times[Plus[Power[256.`, 3], -1], Power[Power[256.`, 3], -1]], Power[16.`, -63]], Times[Times[Plus[Power[256.`, 3], -1], Power[Power[256.`, 3], -1]], Power[16.`, -1]], Times[Plus[Power[256.`, 3], -1], Power[Power[256.`, 3], -1]], Times[Times[Plus[Power[256.`, 3], -1], Power[Power[256.`, 3], -1]], 16.`], Times[Times[Plus[Power[256.`, 3], -1], Power[Power[256.`, 3], -1]], Power[16.`, 62]], Times[Times[Plus[Power[256.`, 3], -1], Power[Power[256.`, 3], -1]], Power[16.`, 63]], Times[Times[-1, Times[Plus[Power[256.`, 3], -1], Power[Power[256.`, 3], -1]]], Power[16.`, -64]], Times[Times[-1, Times[Plus[Power[256.`, 3], -1], Power[Power[256.`, 3], -1]]], Power[16.`, -63]], Times[Times[-1, Times[Plus[Power[256.`, 3], -1], Power[Power[256.`, 3], -1]]], Power[16.`, -1]], Times[-1, Times[Plus[Power[256.`, 3], -1], Power[Power[256.`, 3], -1]]], Times[Times[-1, Times[Plus[Power[256.`, 3], -1], Power[Power[256.`, 3], -1]]], 16.`], Times[Times[-1, Times[Plus[Power[256.`, 3], -1], Power[Power[256.`, 3], -1]]], Power[16.`, 62]], Times[Times[-1, Times[Plus[Power[256.`, 3], -1], Power[Power[256.`, 3], -1]]], Power[16.`, 63]]]], List[FromNonStandartNumberFormat[bytesIn, 1], ToNonStandartNumberFormat[numsIn, 1]]]
	,
	List[numsIn, bytesIn]	
	,
	TestID->"IBM 32 Float: 04 Boundary conditions test"
]

EndTestSection[]
