structure BooleanLrVals = BooleanLrValsFun(structure Token = LrParser.Token)
structure BooleanLex = BooleanLexFun(structure Tokens = BooleanLrVals.Tokens);
structure BooleanParser =
	Join(structure LrParser = LrParser
		structure ParserData = BooleanLrVals.ParserData
		structure Lex = BooleanLex);