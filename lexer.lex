exception LexError;
val TokenList = ref []
structure BTokens = Tokens
	type pos = int
	(* Position in file *)
	type svalue = BTokens.svalue
	type ('a,'b) token = ('a,'b) BTokens.token
	type lexresult = (svalue,pos) token
	type lexarg = string
	type arg = lexarg

	val line = ref 1;
	val col = ref 0;
	val eolpos = ref 0;
	val eof = fn () => 
		let
			fun revAndPrint nil = print("[")
			|	revAndPrint (h::t) = (revAndPrint t; print (h ^ ", "))
			val _ = (revAndPrint (!TokenList); print("EOF]\n"))
		in
			Tokens.EOF(!line, !col)
		end
	val error = fn (e, line, col) => print("Unknown token:" ^ (Int.toString line) ^ ":" ^ (Int.toString col) ^ ":" ^ e ^ "\n")


%%
%header (functor BooleanLexFun(structure Tokens:Boolean_TOKENS));
alpha=[A-Za-z];
ws = [\ \t];
%%
\n			=> (line := (!line) + 1; eolpos := yypos + size yytext; lex());
{ws}+		=> (lex());
";"			=> (col := yypos - (!eolpos); TokenList := "TERM \";\""::(!TokenList); BTokens.TERM(!line,!col));
"IF"		=> (col := yypos - (!eolpos); TokenList := "IF \"IF\""::(!TokenList); BTokens.IF(!line, !col));
"THEN"		=> (col := yypos - (!eolpos); TokenList := "THEN \"THEN\""::(!TokenList); BTokens.THEN(!line, !col));
"ELSE"		=> (col := yypos - (!eolpos); TokenList := "ELSE \"ELSE\""::(!TokenList); BTokens.ELSE(!line, !col));
"IMPLIES"	=> (col := yypos - (!eolpos); TokenList := "IMPLIES \"IMPLIES\""::(!TokenList); BTokens.IMPLIES(!line, !col));
"NOT"		=> (col := yypos - (!eolpos); TokenList := "NOT \"NOT\""::(!TokenList); BTokens.NOT(!line, !col));
"("			=> (col := yypos - (!eolpos); TokenList := "LPAREN \"(\""::(!TokenList); BTokens.LPAREN(!line, !col));
")"			=> (col := yypos - (!eolpos); TokenList := "RPAREN \")\""::(!TokenList); BTokens.RPAREN(!line, !col));
"AND"		=> (col := yypos - (!eolpos); TokenList := "AND \"AND\""::(!TokenList); BTokens.AND(!line, !col));
"OR"		=> (col := yypos - (!eolpos); TokenList := "OR \"OR\""::(!TokenList); BTokens.OR(!line, !col));
"XOR"		=> (col := yypos - (!eolpos); TokenList := "XOR \"XOR\""::(!TokenList); BTokens.XOR(!line, !col));
"EQUALS"	=> (col := yypos - (!eolpos); TokenList := "EQUALS \"EQUALS\""::(!TokenList); BTokens.EQUALS(!line, !col));
"TRUE"		=> (col := yypos - (!eolpos); TokenList := "CONST \"TRUE\""::(!TokenList); BTokens.CONST(yytext, !line, !col));
"FALSE"		=> (col := yypos - (!eolpos); TokenList := "CONST \"FALSE\""::(!TokenList); BTokens.CONST(yytext, !line, !col));
{alpha}+	=> (col := yypos - (!eolpos); TokenList := ("ID \"" ^ yytext ^ "\"")::(!TokenList); BTokens.ID(yytext, !line, !col));
.			=> (col := yypos - (!eolpos); error(yytext, !line, !col); raise LexError);
