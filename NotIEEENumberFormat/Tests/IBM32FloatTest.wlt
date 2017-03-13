BeginTestSection["IBM32FloatTest"]

VerificationTest[(* 1 *)
	Get["NotIEEENumberFormat`"]
	,
	Null	
]

VerificationTest[(* 2 *)
	List[NotIEEENumberSize[1], NotIEEENumberSize["IMB 32 Float"]]
	,
	List[4, 4]	
	,
	TestID->"IBM 32 Float: 01 Check byte size"
]

VerificationTest[(* 3 *)
	FromNotIEEENumberFormat[List[64, 255, 255, 255], 1]
	,
	List[Times[Plus[Power[256.`, 3], -1.`], Power[Power[256.`, 3], -1]]]	
	,
	TestID->"IBM 32 Float: 02 Check simple converting from the list of bytes"
]

VerificationTest[(* 4 *)
	ToNotIEEENumberFormat[List[Times[Plus[Power[256.`, 3], -1], Power[Power[256.`, 3], -1]]], 1]
	,
	List[64, 255, 255, 255]	
	,
	TestID->"IBM 32 Float: 03 Check simple converting number to the list of bytes"
]

VerificationTest[(* 5 *)
	CompoundExpression[Set[bytesIn, List[0, 255, 255, 255, 1, 255, 255, 254, 63, 255, 255, 255, 64, 255, 255, 255, 65, 255, 255, 254, 127, 255, 255, 255, 128, 255, 255, 255]], Set[numsIn, List[Times[Times[Plus[Power[256.`, 3], -1], Power[Power[256.`, 3], -1]], Power[16.`, -64]], Times[Times[Plus[Power[256.`, 3], -2], Power[Power[256.`, 3], -1]], Power[16.`, -63]], Times[Times[Plus[Power[256.`, 3], -1], Power[Power[256.`, 3], -1]], Power[16.`, -1]], Times[Plus[Power[256.`, 3], -1], Power[Power[256.`, 3], -1]], Times[Times[Plus[Power[256.`, 3], -2], Power[Power[256.`, 3], -1]], 16.`], Times[Times[Plus[Power[256.`, 3], -1], Power[Power[256.`, 3], -1]], Power[16.`, 63]], Times[Times[-1, Times[Plus[Power[256.`, 3], -1], Power[Power[256.`, 3], -1]]], Power[16.`, -64]]]], List[FromNotIEEENumberFormat[bytesIn, 1], ToNotIEEENumberFormat[numsIn, 1]]]
	,
	List[numsIn, bytesIn]	
	,
	TestID->"IBM 32 Float: 04 Boundary conditions test"
]

EndTestSection[]
