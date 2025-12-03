package org.kathrynhuxtable.radiofreelawrence.game;

import java.lang.reflect.Method;
import java.util.Arrays;
import java.util.HashMap;
import java.util.Map;

import lombok.RequiredArgsConstructor;

import org.kathrynhuxtable.radiofreelawrence.game.exception.BreakException;
import org.kathrynhuxtable.radiofreelawrence.game.exception.GameRuntimeException;
import org.kathrynhuxtable.radiofreelawrence.game.exception.LoopControlException.ControlType;
import org.kathrynhuxtable.radiofreelawrence.game.grammar.tree.ExprNode;
import org.kathrynhuxtable.radiofreelawrence.game.grammar.tree.IdentifierNode;
import org.kathrynhuxtable.radiofreelawrence.game.grammar.tree.TextElementNode;

@RequiredArgsConstructor
public class InternalFunctions {

	private final GameData gameData;

	private Map<String, Method> internalFunctions;

	public Method getInternalFunction(String name) {
		if (internalFunctions == null) {
			internalFunctions = new HashMap<>();
			for (Method method : InternalFunctions.class.getDeclaredMethods()) {
				if (method.isAnnotationPresent(GameName.class)) {
					GameName annotation = method.getAnnotation(GameName.class);
					internalFunctions.put(annotation.name(), method);
				}
			}
		}
		return internalFunctions.get(name);
	}

	// Internal functions here.

	@GameName(name = "input")
	public int input(ExprNode... parameters) {
		gameData.clearFlag(gameData.getIdentifierRefno("status"), gameData.getIntIdentifierValue("moved"));
		gameData.getInput().input();
		return 0;
	}

	@GameName(name = "inrange")
	public int inrange(ExprNode... parameters) {
		int value = parameters[0].evaluate(gameData);
		return (value >= parameters[1].evaluate(gameData) && value <= parameters[2].evaluate(gameData)) ? 1 : 0;
	}

	@GameName(name = "chance")
	public int chance(ExprNode... parameters) {
		return Math.random() * 100 < parameters[0].evaluate(gameData) ? 1 : 0;
	}

	@GameName(name = "ishave")
	public int have(ExprNode... parameters) {
		int refno = parameters[0].evaluate(gameData);
		// The inhand location (inventory) is always refno floc.
		if (refno >= gameData.fobj && refno < gameData.lobj) {
			if (gameData.locations[refno - gameData.fobj] == gameData.floc) {
				return 1;
			}
		}
		return 0;
	}

	@GameName(name = "ishere")
	public int here(ExprNode... parameters) {
		int refno = parameters[0].evaluate(gameData);
		if (refno >= gameData.fobj && refno < gameData.lobj) {
			if (gameData.locations[refno - gameData.fobj] == gameData.getIntIdentifierValue("here")) {
				return 1;
			}
		}
		return 0;
	}

	@GameName(name = "isnear")
	public int near(ExprNode... parameters) {
		return have(parameters) != 0 || here(parameters) != 0 ? 1 : 0;
	}

	@GameName(name = "isflag")
	public int isflag(ExprNode... parameters) {
		long flag = parameters[1].evaluate(gameData);
		return gameData.testFlag(parameters[0], flag) ? 1 : 0;
	}

	@GameName(name = "setflag")
	public int setflag(ExprNode... parameters) {
		int refno = parameters[0].evaluate(gameData);
		long flag = parameters[1].evaluate(gameData);
		gameData.setFlag(refno, flag);
		return 0;
	}

	@GameName(name = "clearflag")
	public int clearflag(ExprNode... parameters) {
		int refno = parameters[0].evaluate(gameData);
		long flag = parameters[1].evaluate(gameData);
		gameData.clearFlag(refno, flag);
		return 0;
	}

	@GameName(name = "isat")
	public int isat(ExprNode... parameters) {
		int here = gameData.getIntIdentifierValue("here");
		for (ExprNode node : parameters) {
			int place = node.evaluate(gameData);
			if (place == here) {
				return 1;
			}
		}
		return 0;
	}

	@GameName(name = "atplace")
	public int atplace(ExprNode... parameters) {
		int obj = gameData.getIntIdentifierValue("here");
		int loc = gameData.locations[obj - gameData.fobj];
		for (int i = 1; i < parameters.length; i++) {
			int place = parameters[i].evaluate(gameData);
			if (place == loc) {
				return 1;
			}
		}
		return 0;
	}

	@GameName(name = "varis")
	public int varis(ExprNode... parameters) {
		int refno = parameters[0].evaluate(gameData);
		if (refno < gameData.fvar || refno >= gameData.lvar) {
			return 0;
		}
		int value = gameData.variables[refno - gameData.fvar];
		for (int i = 1; i < parameters.length; i++) {
			int other = parameters[i].evaluate(gameData);
			if (other == refno) {
				return 1;
			}
		}
		return 0;
	}

	@GameName(name = "key")
	public int iskey(ExprNode... parameters) {
		int verb = gameData.getIntIdentifierValue("arg1");
		for (ExprNode parameter : parameters) {
			int value = parameter.evaluate(gameData);
			if (value != verb) {
				return 0;
			}
		}
		return 1;
	}

	@GameName(name = "anyof")
	public int anyof(ExprNode... parameters) {
		int verb = gameData.getIntIdentifierValue("arg1");
		for (ExprNode parameter : parameters) {
			int value = parameter.evaluate(gameData);
			if (value == verb) {
				return 1;
			}
		}
		return 0;
	}

	@GameName(name = "query")
	public int query(ExprNode... parameters) {
		// FIXME Implement this
		return 0;
	}

	@GameName(name = "typed")
	public int typed(ExprNode... parameters) {
		// FIXME Implement this
		return 0;
	}

	@GameName(name = "needcmd")
	public int needcmd(ExprNode... parameters) {
		// FIXME Implement this
		return 0;
	}

	/*
	 * Abort the do-all loop if one executing and flush the command line buffer.
	 */
	@GameName(name = "flush")
	public int flush(ExprNode... parameters) {
		// FIXME Implement this
		return 0;
	}

	@GameName(name = "apport")
	public int apport(ExprNode... parameters) {
		int object = parameters[0] instanceof TextElementNode ?
				gameData.getIntIdentifierValue(((TextElementNode) parameters[0]).getText().toLowerCase()) :
				parameters[0].evaluate(gameData);
		int place = parameters[1] instanceof TextElementNode ?
				gameData.getIntIdentifierValue(((TextElementNode) parameters[1]).getText().toLowerCase()) :
				parameters[1].evaluate(gameData);
		gameData.locations[object - gameData.fobj] = place;
		return 0;
	}

	@GameName(name = "get")
	public int get(ExprNode... parameters) {
		int object = parameters[0] instanceof TextElementNode ?
				gameData.getIntIdentifierValue(((TextElementNode) parameters[0]).getText().toLowerCase()) :
				parameters[0].evaluate(gameData);
		if (object > 0) {
			gameData.locations[object - gameData.fobj] = gameData.floc;
		}
		return 0;
	}

	@GameName(name = "drop")
	public int drop(ExprNode... parameters) {
		int object = parameters[0] instanceof TextElementNode ?
				gameData.getIntIdentifierValue(((TextElementNode) parameters[0]).getText().toLowerCase()) :
				parameters[0].evaluate(gameData);
		if (object > 0) {
			gameData.locations[object - gameData.fobj] = gameData.getIntIdentifierValue("here");
		}
		return 0;
	}

	@GameName(name = "goto")
	public int goto_(ExprNode... parameters) {
		int place = parameters[0] instanceof TextElementNode ?
				gameData.getIntIdentifierValue(((TextElementNode) parameters[0]).getText().toLowerCase()) :
				parameters[0].evaluate(gameData);
		gameData.setIntIdentifierValue("there", gameData.getIntIdentifierValue("here"));
		gameData.setIntIdentifierValue("here", place);
		gameData.setFlag(gameData.getIdentifierRefno("status"), gameData.getIntIdentifierValue("moved"));
		return 0;
	}

	@GameName(name = "move")
	public int move(ExprNode... parameters) {
		int place = parameters[parameters.length - 1] instanceof TextElementNode ?
				gameData.getIntIdentifierValue(((TextElementNode) parameters[parameters.length - 1]).getText().toLowerCase()) :
				parameters[parameters.length - 1].evaluate(gameData);
		if (parameters.length > 1) {
			if (iskey(Arrays.copyOfRange(parameters, 0, parameters.length - 1)) == 0) {
				return 0;
			}
		}
		gameData.setIntIdentifierValue("there", gameData.getIntIdentifierValue("here"));
		gameData.setIntIdentifierValue("here", place);
		gameData.setFlag(gameData.getIdentifierRefno("status"), gameData.getIntIdentifierValue("moved"));
		throw new BreakException(ControlType.REPEAT);
	}

	@GameName(name = "smove")
	public int smove(ExprNode... parameters) {
		// FIXME Implement this
		return 0;
	}

	@GameName(name = "say")
	public int say(ExprNode... parameters) {
		try {
			if (parameters.length == 0) return 0;
			String text = "";
			if (parameters[0] instanceof IdentifierNode) {
				text = gameData.getTextIdentifierValue(((IdentifierNode) parameters[0]).getName(), 0);
			} else if (parameters[0] instanceof TextElementNode) {
				text = ((TextElementNode) parameters[0]).getText();
			}

			Integer qualifier = null;
			if (parameters.length > 1) {
				qualifier = parameters[1].evaluate(gameData);
			}

			System.out.println(gameData.expandText(text, qualifier));
		} catch (Exception e) {
			throw new GameRuntimeException("exception in 'say'", e);
		}

		return 0;
	}

	@GameName(name = "append")
	public int append(ExprNode... text) {
		// FIXME Implement this
		// Not sure how to implement this, since we typically generate the newline after the text.
		// Maybe need to generate it before. Not sure.
		return 0;
	}

	@GameName(name = "quip")
	public int quip(ExprNode... text) {
		say(text);
		throw new BreakException(ControlType.REPEAT);
	}

	@GameName(name = "respond")
	public int respond(ExprNode... parameters) {
		if (anyof(parameters) != 0) {
			quip(Arrays.copyOfRange(parameters, parameters.length - 1, parameters.length));
		}
		return 0;
	}

	@GameName(name = "describe")
	public int describe(ExprNode... parameters) {
		if (parameters.length == 0) return 0;
		int var = parameters[0] instanceof IdentifierNode ?
				gameData.getIntIdentifierValue(((IdentifierNode) parameters[0]).getName()) :
				parameters[0].evaluate(gameData);
		if (var >= gameData.fvar && var < gameData.lvar) {
			var = gameData.variables[var - gameData.fvar];
		}
		System.out.println(gameData.getTextIdentifierValue(var, parameters.length > 1 ? 1 : 0));
		return 0;
	}

	@GameName(name = "vocab")
	public int vocab(ExprNode... text) {
		// FIXME Implement this
		return 0;
	}

	@GameName(name = "tie")
	public int tie(ExprNode... parameters) {
		// FIXME Implement this
		return 0;
	}

	@GameName(name = "stop")
	public int stop(ExprNode... parameters) {
		System.exit(0);
		return 0;
	}
}
