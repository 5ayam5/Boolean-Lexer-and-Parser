structure Boolean =
struct
	fun invoke (lexstream, fileName) =
			let fun print_error (s,svalue:int,pos:int) =
						TextIO.output(TextIO.stdOut, "Error, line " ^ (Int.toString pos) ^ ", col: "^ (Int.toString svalue) ^ "," ^ s ^ "\n");
			in
				BooleanParser.parse(0,lexstream,print_error,fileName)
			end

	fun stringToLexer fileName =
			let val inStream = TextIO.openIn fileName
				val grab : int -> string = fn
					n => if TextIO.endOfStream inStream
						then ""
						else TextIO.inputN (inStream,n);
				val done = ref false
				val lexer=  (BooleanParser.makeLexer grab fileName, fileName)
			in
				lexer
			end	
		
	fun parse lexer =
			let val dummyEOF = BooleanLrVals.Tokens.EOF(0,0)
				val (result, lexer) = invoke lexer
				val (nextToken, lexer) = BooleanParser.Stream.get lexer
			in
				if BooleanParser.sameToken(nextToken, dummyEOF) then result
				else (TextIO.output(TextIO.stdOut, "Warning: Unconsumed input \n"); result)
			end
	
	fun parseFile fileName = parse (stringToLexer fileName)
end;
