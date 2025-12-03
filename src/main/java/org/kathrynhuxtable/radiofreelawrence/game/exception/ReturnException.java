package org.kathrynhuxtable.radiofreelawrence.game.exception;

import lombok.Getter;
import lombok.RequiredArgsConstructor;

@Getter
@RequiredArgsConstructor
public class ReturnException extends RuntimeException {
	private final int value;
}
