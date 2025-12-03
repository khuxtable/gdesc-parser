package org.kathrynhuxtable.radiofreelawrence.game.grammar.tree;

import java.util.ArrayList;
import java.util.List;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
public class ActionNode implements BaseNode {
	String arg1;
	List<ActionCode> actionCodes = new ArrayList<>();

	@Data
	@Builder
	@AllArgsConstructor
	@NoArgsConstructor
	public static class ActionCode implements BaseNode {
		String arg2;
		BlockNode code;
	}
}
