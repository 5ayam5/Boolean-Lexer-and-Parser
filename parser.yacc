%%
%name Boolean
%term
	EOF | TERM | IF | THEN | ELSE | IMPLIES | NOT | LPAREN | RPAREN | AND | OR | XOR | EQUALS | TRUE | FALSE | ID of string
%nonterm
	InputFile | program | statement | formula | CONST
%pos int

%start InputFile

%eop EOF
%noshift EOF

%arg (fileName) : string

%right IF THEN ELSE
%right IMPLIES
%left AND OR XOR EQUALS
%right NOT

%verbose

%%
	InputFile:	program (program)
			|	()
	
	program:	statement ()
			|	statement program ()
	
	statement:	formula TERM ()

	formula:	NOT formula (print("NOT production\n"))
			|	formula AND formula (print("AND production\n"))
			|	formula OR formula (print("OR production\n"))
			|	formula XOR formula (print("XOR production\n"))
			|	formula EQUALS formula (print("EQUALS production\n"))
			|	formula IMPLIES formula (print("IMPLIES production\n"))
			|	IF formula THEN formula ELSE formula (print("ITE production\n"))
			|	LPAREN formula RPAREN (print("parens\n"))
			|	CONST (print(" CONST\n"))
			|	ID	(print(ID ^ "\n"))
	
	CONST:		TRUE (print("1"))
			|	FALSE (print("0"))
