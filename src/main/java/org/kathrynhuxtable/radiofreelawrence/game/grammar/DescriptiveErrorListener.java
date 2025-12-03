package org.kathrynhuxtable.radiofreelawrence.game.grammar;

import org.antlr.v4.runtime.BaseErrorListener;
import org.antlr.v4.runtime.IntStream;
import org.antlr.v4.runtime.RecognitionException;
import org.antlr.v4.runtime.Recognizer;

// Example of a custom error listener including filename
public class DescriptiveErrorListener extends BaseErrorListener {
	public static final DescriptiveErrorListener INSTANCE = new DescriptiveErrorListener();

	@Override
	public void syntaxError(Recognizer<?, ?> recognizer,
	                        Object offendingSymbol,
	                        int line, int charPositionInLine,
	                        String msg,
	                        RecognitionException e) {
		String sourceName = recognizer.getInputStream().getSourceName();
		if (!sourceName.isEmpty() && !sourceName.equals(IntStream.UNKNOWN_SOURCE_NAME)) {
			System.err.println(sourceName + ":" + line + ":" + charPositionInLine + ": " + msg);
		} else {
			System.err.println("line " + line + ":" + charPositionInLine + ": " + msg);
		}
	}
}
