package org.kathrynhuxtable.radiofreelawrence.game.grammar.tree;

import java.util.*;

import lombok.*;

@Data
@Builder
@AllArgsConstructor
@NoArgsConstructor
public class StateNode implements BaseNode {

	Map<String, StateClauseNode> states = new LinkedHashMap<>();
}
