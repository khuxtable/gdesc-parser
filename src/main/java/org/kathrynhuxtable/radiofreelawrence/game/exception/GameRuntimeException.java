package org.kathrynhuxtable.radiofreelawrence.game.exception;

public class GameRuntimeException extends RuntimeException {
	public GameRuntimeException(String message) {
		super(message);
	}

	public GameRuntimeException(String message, Throwable cause) {
		super(message, cause);
	}
}
