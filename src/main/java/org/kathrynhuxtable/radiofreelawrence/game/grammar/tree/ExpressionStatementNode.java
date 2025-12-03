package org.kathrynhuxtable.radiofreelawrence.game.grammar.tree;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import org.kathrynhuxtable.radiofreelawrence.game.GameData;
import org.kathrynhuxtable.radiofreelawrence.game.exception.GameRuntimeException;

@Data
@Builder
@AllArgsConstructor
@NoArgsConstructor
public class ExpressionStatementNode implements StatementNode {
	private ExprNode expression;
	private String label;

	@Override
	public void execute(GameData gameData) throws GameRuntimeException {
		expression.evaluate(gameData);
	}
}
