structure BooleanLrVals = BooleanLrValsFun(structure Token = LrParser.Token)
structure BooleanLex = BooleanLexFun(structure Tokens = BooleanLrVals.Tokens);
structure BooleanParser =
	  Join(structure LrParser = LrParser
     	       structure ParserData = BooleanLrVals.ParserData
     	       structure Lex = BooleanLex)
     
fun invoke lexstream =
    	     	let fun print_error (s,pos:int,_) =
		    	TextIO.output(TextIO.stdOut, "Error, line " ^ (Int.toString pos) ^ "," ^ s ^ "\n")
		in
		    BooleanParser.parse(0,lexstream,print_error,())
		end

fun stringToLexer str =
    let val done = ref false
    	val lexer=  BooleanParser.makeLexer (fn _ => if (!done) then "" else (done:=true;str))
    in
	lexer
    end	
		
fun parse (lexer) =
    let val dummyEOF = BooleanLrVals.Tokens.EOF(0,0)
    	val (result, lexer) = invoke lexer
	val (nextToken, lexer) = BooleanParser.Stream.get lexer
    in
        if BooleanParser.sameToken(nextToken, dummyEOF) then result
 	else (TextIO.output(TextIO.stdOut, "Warning: Unconsumed input \n"); result)
    end

val parseString = parse o stringToLexer



