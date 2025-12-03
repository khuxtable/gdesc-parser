package org.kathrynhuxtable.radiofreelawrence.game.grammar.tree;

import org.kathrynhuxtable.radiofreelawrence.game.GameData;

public interface ExprNode extends BaseNode {
	int evaluate(GameData gameData);
}
