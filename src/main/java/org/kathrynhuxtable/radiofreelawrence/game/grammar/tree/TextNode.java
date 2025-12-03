package org.kathrynhuxtable.radiofreelawrence.game.grammar.tree;

import java.util.List;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Builder
@AllArgsConstructor
@NoArgsConstructor
public class TextNode implements BaseNode, HasRefno {

	public enum TextMethod { INCREMENT, CYCLE, RANDOM, ASSIGNED }

	String name;
	List<String> texts;
	TextMethod method;
	boolean fragment;

	int refno;
}
