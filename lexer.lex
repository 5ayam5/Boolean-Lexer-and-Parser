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
	val eof = fn () => Tokens.EOF(!line, !col);
	val error = fn (e, line, col) => print("Unknown token:" ^ (Int.toString line) ^ ":" ^ (Int.toString col) ^ ":" ^ e ^ "\n")

%%
%header (functor BooleanLexFun(structure Tokens:Boolean_TOKENS));
alpha=[A-Za-z];
ws = [\ \t];
%%
\n			=> (line := (!line) + 1; eolpos := yypos + size yytext; lex());
{ws}+		=> (lex());
";"			=> (print("TERM \";\", "); col := yypos - (!eolpos); BTokens.TERM(!line,!col));
"IF"		=> (print("IF \"IF\", "); col := yypos - (!eolpos); BTokens.IF(!line, !col));
"THEN"		=> (print("THEN \"THEN\", "); col := yypos - (!eolpos); BTokens.THEN(!line, !col));
"ELSE"		=> (print("ELSE \"ELSE\", "); col := yypos - (!eolpos); BTokens.ELSE(!line, !col));
"IMPLIES"	=> (print("IMPLIES \"IMPLIES\", "); col := yypos - (!eolpos); BTokens.IMPLIES(!line, !col));
"NOT"		=> (print("NOT \"NOT\", "); col := yypos - (!eolpos); BTokens.NOT(!line, !col));
"("			=> (print("LPAREN \"(\", "); col := yypos - (!eolpos); BTokens.LPAREN(!line, !col));
")"			=> (print("RPAREN \")\", "); col := yypos - (!eolpos); BTokens.RPAREN(!line, !col));
"AND"		=> (print("AND \"AND\", "); col := yypos - (!eolpos); BTokens.AND(!line, !col));
"OR"		=> (print("OR \"OR\", "); col := yypos - (!eolpos); BTokens.OR(!line, !col));
"XOR"		=> (print("XOR \"XOR\", "); col := yypos - (!eolpos); BTokens.XOR(!line, !col));
"EQUALS"	=> (print("EQUALS \"EQUALS\", "); col := yypos - (!eolpos); BTokens.EQUALS(!line, !col));
"TRUE"		=> (print("CONST \"TRUE\", "); col := yypos - (!eolpos); BTokens.TRUE(!line, !col));
"FALSE"		=> (print("CONST \"FALSE\", "); col := yypos - (!eolpos); BTokens.FALSE(!line, !col));
{alpha}+	=> (print("ID \"" ^ yytext ^ "\", "); col := yypos - (!eolpos); BTokens.ID(yytext, !line, !col));
.			=> (error(yytext, !line, !col); lex());