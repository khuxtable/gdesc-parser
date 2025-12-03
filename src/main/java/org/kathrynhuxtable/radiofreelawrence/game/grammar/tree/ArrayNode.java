package org.kathrynhuxtable.radiofreelawrence.game.grammar.tree;

import lombok.*;

@Data
@Builder
@AllArgsConstructor
@NoArgsConstructor
public class ArrayNode implements BaseNode {
	String name;
	int size;
}
