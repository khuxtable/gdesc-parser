package org.kathrynhuxtable.radiofreelawrence.game.grammar.tree;

import java.util.ArrayList;
import java.util.List;

import lombok.*;

@Data
@Builder
@AllArgsConstructor
@NoArgsConstructor
public class FlagNode implements BaseNode {

	public enum FlagType { VARIABLE, OBJECT, PLACE }

	List<String> flags = new ArrayList<>();
	FlagType type;
}
