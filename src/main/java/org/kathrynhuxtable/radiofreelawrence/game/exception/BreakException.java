package org.kathrynhuxtable.radiofreelawrence.game.exception;

import lombok.Getter;

@Getter
public class BreakException extends LoopControlException {

	public BreakException(String label) {
		super(label);
	}

	public BreakException(ControlType controlType) {
		super(controlType);
	}
}
