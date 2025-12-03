package org.kathrynhuxtable.radiofreelawrence.game.grammar.tree;

import lombok.AllArgsConstructor;
import lombok.Data;

import org.kathrynhuxtable.radiofreelawrence.game.GameData;
import org.kathrynhuxtable.radiofreelawrence.game.GameData.IdentifierType;

@Data
@AllArgsConstructor
public class InstanceofNode implements ExprNode {

	private IdentifierNode identifier;
	private IdentifierType identifierType;

	@Override
	public int evaluate(GameData gameData) {
		return identifierType == gameData.getIdentifierType(identifier.getName()) ? 1 : 0;
	}
}
