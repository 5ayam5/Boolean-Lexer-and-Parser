%%
%name Boolean
%term
	EOF | TERM | IF | THEN | ELSE | IMPLIES | NOT | LPAREN | RPAREN | AND | OR | XOR | EQUALS | CONST of string | ID of string | ERR of string
%nonterm
	InputFile | program | statement | formula
%pos int

%start InputFile

%eop EOF
%noshift EOF

%right IF THEN ELSE
%right IMPLIES
%left AND OR XOR EQUALS
%right NOT

%verbose

%%
	InputFile:	program (print("InputFile -> program EOF\n"))
	
	program:	statement program (print("program -> statement program\n"))
			|	()
	
	statement:	formula TERM (print("statement -> formula TERM\n"))

	formula:	NOT formula (print("formula -> NOT formula\n"))
			|	formula AND formula (print("formula -> formula AND formula\n"))
			|	formula OR formula (print("formula -> formula OR formula\n"))
			|	formula XOR formula (print("formula -> formula XOR formula\n"))
			|	formula EQUALS formula (print("formula -> formula EQUALS formula\n"))
			|	formula IMPLIES formula (print("formula -> formula IMPLIES formula\n"))
			|	IF formula THEN formula ELSE formula (print("formula -> IF formula THEN formula ELSE formula\n"))
			|	LPAREN formula RPAREN (print("formula -> LPAREN formula RPAREN\n"))
			|	CONST (print("formula -> CONST " ^ CONST ^ "\n"))
			|	ID	(print("formula -> ID " ^ ID ^ "\n"))
