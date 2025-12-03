package org.kathrynhuxtable.radiofreelawrence.game.exception;

import lombok.Getter;

@Getter
public class ContinueException extends LoopControlException {

	public ContinueException(String label) {
		super(label);
	}

	public ContinueException(ControlType controlType) {
		super(controlType);
	}
}
