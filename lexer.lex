structure BTokens = Tokens
	type pos = int
	(* Position in file *)
	type svalue = BTokens.svalue
	type ('a,'b) token = ('a,'b) BTokens.token
	type lexresult = (svalue,pos) token
	type lexarg = string
	type arg = lexarg

	val pos = ref 0
	val eof = fn () => Tokens.EOF(!pos, !pos)
	val error = fn (e,l1,l2) => ()

%%
%header (functor BooleanLexFun(structure Tokens:Boolean_TOKENS));
alpha=[A-Za-z];
ws = [\ \t];
%%
\n			=> (pos := (!pos) + 1; lex());
{ws}+		=> (lex());
";"			=> (BTokens.TERM(!pos,!pos));
"IF"		=> (BTokens.IF(!pos, !pos));
"THEN"		=> (BTokens.THEN(!pos, !pos));
"ELSE"		=> (BTokens.ELSE(!pos, !pos));
"IMPLIES"	=> (BTokens.IMPLIES(!pos, !pos));
"NOT"		=> (BTokens.NOT(!pos, !pos));
"("			=> (BTokens.LPAREN(!pos, !pos));
")"			=> (BTokens.RPAREN(!pos, !pos));
"AND"		=> (BTokens.AND(!pos, !pos));
"OR"		=> (BTokens.OR(!pos, !pos));
"XOR"		=> (BTokens.XOR(!pos, !pos));
"EQUALS"	=> (BTokens.EQUALS(!pos, !pos));
"TRUE"		=> (BTokens.TRUE(!pos, !pos));
"FALSE"		=> (BTokens.FALSE(!pos, !pos));
{alpha}+	=> (BTokens.ID(yytext, !pos, !pos));
.			=> (error(yytext, !pos, !pos); lex());