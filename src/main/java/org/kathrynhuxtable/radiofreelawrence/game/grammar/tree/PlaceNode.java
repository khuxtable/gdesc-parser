package org.kathrynhuxtable.radiofreelawrence.game.grammar.tree;

import java.util.List;

import lombok.*;
import org.springframework.javapoet.CodeBlock;

@Data
@Builder
@AllArgsConstructor
@NoArgsConstructor
public class PlaceNode implements BaseNode,  HasRefno {
	@Singular
	List<String> names;
	boolean inVocabulary;
	
	String briefDescription;
	String longDescription;
	BlockNode code;

	int refno;
}
