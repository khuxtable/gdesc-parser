package org.kathrynhuxtable.radiofreelawrence.game.grammar.tree;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import org.kathrynhuxtable.radiofreelawrence.game.GameData;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class ArrayAccessNode implements ExprNode {
	private String arrayName;
	private ExprNode index;

	@Override
	public int evaluate(GameData gameData) {
		return gameData.getArrayValue(arrayName, index.evaluate(gameData));
	}
}
