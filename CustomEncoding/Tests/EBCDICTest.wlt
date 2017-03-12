BeginTestSection["EBCDICTest"]

VerificationTest[(* 1 *)
	Get["CustomEncoding`"]
	,
	Null	
]

VerificationTest[(* 2 *)
	FromCustomCharacterCode[List[0, 1, 2, 3, 4, 5, 6, 7], "EBCDIC"]
	,
	"SOHSTXETXPF\tLCDEL"	
]

VerificationTest[(* 3 *)
	ToCustomCharacterCode["(test)", "EBCDIC"]
	,
	List[77, 163, 133, 162, 163, 93]	
]

EndTestSection[]
