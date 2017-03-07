BeginTestSection["NonStandartCharacterEncodingTest"]

VerificationTest[(* 1 *)
	Get["NonStandartCharacterEncoding`"]
	,
	Null	
]

VerificationTest[(* 2 *)
	FromNonStandartCharacterCode[List[0, 1, 2, 3, 4, 5, 6, 7], "EDCDIC"]
	,
	"NULSOHSTXETXPFHTLCDEL"	
]

VerificationTest[(* 3 *)
	ToNonStandartCharacterCode["(test)", "EDCDIC"]
	,
	List[77, 163, 133, 162, 163, 93]	
]

EndTestSection[]
