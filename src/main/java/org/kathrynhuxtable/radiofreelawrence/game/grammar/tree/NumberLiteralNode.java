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
public class NumberLiteralNode implements ExprNode {
	private int number;

	@Override
	public int evaluate(GameData gameData) {
		return number;
	}
}
