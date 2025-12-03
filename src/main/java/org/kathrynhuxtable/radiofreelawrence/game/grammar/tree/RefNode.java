package org.kathrynhuxtable.radiofreelawrence.game.grammar.tree;

import lombok.AllArgsConstructor;
import lombok.Data;

import org.kathrynhuxtable.radiofreelawrence.game.GameData;

@Data
@AllArgsConstructor
public class RefNode implements ExprNode {

	private IdentifierNode identifier;

	@Override
	public int evaluate(GameData gameData) {
		return gameData.getIdentifierRefno(identifier.getName());
	}
}
