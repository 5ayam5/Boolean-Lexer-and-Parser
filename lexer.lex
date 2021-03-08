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
	val eof = fn fileName => Tokens.EOF(!line, !col);
	val error = fn (fileName, e, line, col) => TextIO.output(TextIO.stdOut, "Unknown token:" ^ (Int.toString line) ^ ":" ^ (Int.toString col) ^ ":" ^ e ^ "\n")

%%
%header (functor BooleanLexFun(structure Tokens:Boolean_TOKENS));
%arg (fileName: string);
alpha=[A-Za-z];
ws = [\ \t];
%%
\n			=> (line := (!line) + 1; eolpos := yypos + size yytext; continue());
{ws}+		=> (continue());
";"			=> (col := yypos - (!eolpos); BTokens.TERM(!line,!col));
"IF"		=> (col := yypos - (!eolpos); BTokens.IF(!line, !col));
"THEN"		=> (col := yypos - (!eolpos); BTokens.THEN(!line, !col));
"ELSE"		=> (col := yypos - (!eolpos); BTokens.ELSE(!line, !col));
"IMPLIES"	=> (col := yypos - (!eolpos); BTokens.IMPLIES(!line, !col));
"NOT"		=> (col := yypos - (!eolpos); BTokens.NOT(!line, !col));
"("			=> (col := yypos - (!eolpos); BTokens.LPAREN(!line, !col));
")"			=> (col := yypos - (!eolpos); BTokens.RPAREN(!line, !col));
"AND"		=> (col := yypos - (!eolpos); BTokens.AND(!line, !col));
"OR"		=> (col := yypos - (!eolpos); BTokens.OR(!line, !col));
"XOR"		=> (col := yypos - (!eolpos); BTokens.XOR(!line, !col));
"EQUALS"	=> (col := yypos - (!eolpos); BTokens.EQUALS(!line, !col));
"TRUE"		=> (col := yypos - (!eolpos); BTokens.TRUE(!line, !col));
"FALSE"		=> (col := yypos - (!eolpos); BTokens.FALSE(!line, !col));
{alpha}+	=> (col := yypos - (!eolpos); BTokens.ID(yytext, !line, !col));
.			=> (error(fileName, yytext, !line, !col); continue());