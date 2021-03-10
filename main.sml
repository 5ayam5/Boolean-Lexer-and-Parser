structure BooleanLrVals = BooleanLrValsFun(structure Token = LrParser.Token);
structure BooleanLex = BooleanLexFun(structure Tokens = BooleanLrVals.Tokens);
structure BooleanParser =
	Join(structure LrParser = LrParser
		structure ParserData = BooleanLrVals.ParserData
		structure Lex = BooleanLex);

fun main () =
		let
			fun invoke lexstream =
					let
						fun print_error (s, line, col) =
								TextIO.output(TextIO.stdErr, "Syntax Error:" ^ (Int.toString line) ^ ":" ^ (Int.toString col) ^ ":" ^ s ^ "\n");
					in
						BooleanParser.parse(0,lexstream,print_error,())
					end

			fun stringToLexer str =
					let
						val done = ref false
						val lexer =  BooleanParser.makeLexer (fn _ => if (!done) then "" else (done := true; str))
					in
						lexer
					end	
		
			fun parse lexer =
					let
						val dummyEOF = BooleanLrVals.Tokens.EOF(0,0)
						val (result, lexer) = invoke lexer
						val (nextToken, lexer) = BooleanParser.Stream.get lexer
					in
						if BooleanParser.sameToken(nextToken, dummyEOF) then result
						else (print("Warning: Unconsumed input \n"); result)
					end

			val fileName = case CommandLine.arguments() of h::t => h | nil => "in"
			val inputStream = TextIO.openIn fileName
			val str = TextIO.input inputStream
			val _ = TextIO.closeIn inputStream

			val tree = parse (stringToLexer str)
			val _ = ParseTree.postOrder tree
		in
			()
		end
		handle Exception => ();

val _ = main ();
