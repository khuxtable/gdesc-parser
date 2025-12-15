package org.kathrynhuxtable.radiofreelawrence.game.grammar.tree;

import java.util.List;

import lombok.*;

@Data
@Builder
@AllArgsConstructor
@NoArgsConstructor
public class ObjectNode implements BaseNode, HasRefno {
	@Singular
	List<String> names;
	boolean inVocabulary;

	String inventoryDescription;
	String briefDescription;
	String longDescription;
	BlockNode code;

	int refno;
}
