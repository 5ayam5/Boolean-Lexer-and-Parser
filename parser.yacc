(* User  declarations *)

%%
(* required declarations *)
%name Boolean

%term
	EOF | TERM | IF | THEN | ELSE | IMPLIES | NOT | LPAREN | RPAREN | AND | OR | XOR | EQUALS | TRUE | FALSE | ID of string

%nonterm
	InputFile | program | statement | formula | evaluation | iNfix | unary | eVal | BINOP | CONST

%start InputFile

%pos int

(*optional declarations *)
%eop EOF
%noshift EOF

(* %header *)

%%
	InputFile:	program (program)
			|	()
	
	program:	statement (statement)
			|	statement program (statement; program)
	
	statement:	formula TERM (formula; print(";\n"))

	formula:	IF formula THEN evaluation ELSE formula (print("IF\n"); formula; print("THEN\n"); evaluation; print("ELSE\n"); formula)
			|	evaluation (evaluation)
	
	evaluation:	iNfix IMPLIES evaluation (iNfix; print("IMPLIES\n"); evaluation)
			|	iNfix (iNfix)
	
	iNfix:		iNfix BINOP unary (iNfix; BINOP; unary)
			|	unary (unary)

	unary:		NOT unary (print("NOT\n"); unary)
			|	eVal (eVal)
	
	eVal:		CONST (CONST)
			|	ID	(print(ID ^ "\n"))
			|	LPAREN formula RPAREN (print("(\n"); formula; print(")\n"))
	
	BINOP:		AND (print("AND\n"))
			|	OR (print("OR\n"))
			|	XOR (print("XOR\n"))
			|	EQUALS (print("==\n"))
	
	CONST:		TRUE (print("1\n"))
			|	FALSE (print("0\n"))
