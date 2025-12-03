package org.kathrynhuxtable.radiofreelawrence.game.grammar.tree;

import lombok.AllArgsConstructor;
import lombok.Data;

import org.kathrynhuxtable.radiofreelawrence.game.GameData;

@Data
@AllArgsConstructor
public class IdentifierNode implements ExprNode {
	private String name;

	@Override
	public int evaluate(GameData gameData) {
		return gameData.getIntIdentifierValue(name);
	}

	public void setIntValue(int value, GameData gameData) {
		gameData.setIntIdentifierValue(name, value);
	}
}
