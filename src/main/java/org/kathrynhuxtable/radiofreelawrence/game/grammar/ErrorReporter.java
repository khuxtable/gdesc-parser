package org.kathrynhuxtable.radiofreelawrence.game.grammar;

import java.util.ArrayList;
import java.util.List;

import lombok.Getter;
import org.antlr.v4.runtime.ParserRuleContext;

@Getter
public class ErrorReporter {
	private final List<String> errors = new ArrayList<>();

	public void reportError(ParserRuleContext context, String message) {
		int line = context == null ? 0 : context.start.getLine();
		int charPositionInLine = context == null ? 0 : context.start.getCharPositionInLine();
		errors.add("Error at line " + line + ":" + charPositionInLine + " - " + message);
	}
}
