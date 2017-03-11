BeginTestSection["SEGYImportExport"]

VerificationTest[(* 1 *)
	Get["NonStandartImportExport`Extensions`SEGY`"]
	,
	Null	
]

VerificationTest[(* 2 *)
	CompoundExpression[Set[fileIn, FileNameJoin[List[NotebookDirectory[], "TestData", "segy_data_input.segy"]]], Null]
	,
	Null	
]

VerificationTest[(* 3 *)
	List[CompoundExpression[Set[data, SEGYImport[fileIn]], Head[data]], Head[Part[data, 1, 1, 2]]]
	,
	List[SEGYData, String]	
]

EndTestSection[]
