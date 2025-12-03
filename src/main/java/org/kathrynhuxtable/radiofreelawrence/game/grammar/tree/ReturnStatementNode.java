package org.kathrynhuxtable.radiofreelawrence.game.grammar.tree;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import org.kathrynhuxtable.radiofreelawrence.game.GameData;
import org.kathrynhuxtable.radiofreelawrence.game.exception.GameRuntimeException;
import org.kathrynhuxtable.radiofreelawrence.game.exception.ReturnException;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class ReturnStatementNode implements StatementNode {
	private ExprNode expression;
	private String label;

	@Override
	public void execute(GameData gameData) throws GameRuntimeException {
		throw new ReturnException(expression.evaluate(gameData));
	}
}
