%%
%name Boolean
%term
	EOF | TERM | IF | THEN | ELSE | IMPLIES | NOT | LPAREN | RPAREN | AND | OR | XOR | EQUALS | CONST of string | ID of string
%nonterm
	InputFile of ParseTree.node | program of ParseTree.node | statement of ParseTree.node | formula of ParseTree.node
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
	InputFile:	program (ParseTree.Production ("InputFile -> program", [program]))
	
	program:	statement program (ParseTree.Production ("program -> statement program", [statement, program]))
			|	(ParseTree.Production ("program -> epsilon", []))
	
	statement:	formula TERM (ParseTree.Production ("statement -> formula TERM", [formula, ParseTree.TERM]))

	formula:	NOT formula (ParseTree.Production ("formula -> NOT formula", [ParseTree.NOT, formula]))
			|	formula AND formula (ParseTree.Production ("formula -> formula AND formula", [formula1, ParseTree.AND, formula2]))
			|	formula OR formula (ParseTree.Production ("formula -> formula OR formula", [formula1, ParseTree.OR, formula2]))
			|	formula XOR formula (ParseTree.Production ("formula -> formula XOR formula", [formula1, ParseTree.XOR, formula2]))
			|	formula EQUALS formula (ParseTree.Production ("formula -> formula EQUALS formula", [formula1, ParseTree.EQUALS, formula2]))
			|	formula IMPLIES formula (ParseTree.Production ("formula -> formula IMPLIES formula", [formula1, ParseTree.IMPLIES, formula2]))
			|	IF formula THEN formula ELSE formula (ParseTree.Production ("formula -> IF formula THEN formula ELSE formula", [ParseTree.IF, formula1, ParseTree.THEN, formula2, ParseTree.ELSE, formula3]))
			|	LPAREN formula RPAREN (ParseTree.Production ("formula -> LPAREN formula RPAREN", [ParseTree.LPAREN, formula, ParseTree.RPAREN]))
			|	CONST (ParseTree.CONST CONST)
			|	ID	(ParseTree.ID ID)
