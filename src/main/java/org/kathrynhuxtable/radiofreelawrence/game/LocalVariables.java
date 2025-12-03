package org.kathrynhuxtable.radiofreelawrence.game;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.kathrynhuxtable.radiofreelawrence.game.exception.GameRuntimeException;

public class LocalVariables {

	private final List<List<Map<String, Integer>>> localVariables = new ArrayList<>();

	public void newFunctionScope() {
		localVariables.add(new ArrayList<>());
		// Always start a new block scope with a function.
		newBlockScope();
	}

	public void closeFunctionScope() {
		if (!localVariables.isEmpty()) {
			localVariables.remove(localVariables.size() - 1);
		}
	}

	private List<Map<String, Integer>> getFunctionScope() {
		return localVariables.get(localVariables.size() - 1);
	}

	public void newBlockScope() {
		getFunctionScope().add(new HashMap<>());
	}

	public void closeBlockScope() {
		List<Map<String, Integer>> functionScope = getFunctionScope();
		functionScope.remove(functionScope.size() - 1);
	}

	public void addVariable(String identifier, int value) {
		if (localVariables.isEmpty() || localVariables.get(localVariables.size() - 1).isEmpty()) {
			throw new GameRuntimeException("No block scope defined");
		}

		List<Map<String, Integer>> functionScope = getFunctionScope();
		// Get innermost scope.
		Map<String, Integer> blockScope = functionScope.get(functionScope.size() - 1);

		blockScope.put(identifier, value);
	}

	public Integer getLocalVariableValue(String variable) {
		if (!localVariables.isEmpty()) {
			List<Map<String, Integer>> functionScope = getFunctionScope();
			if (!functionScope.isEmpty()) {
				for (int i = functionScope.size() - 1; i >= 0; i--) {
					if (functionScope.get(i).containsKey(variable)) {
						return functionScope.get(i).get(variable);
					}
				}
			}
		}
		return null;
	}

	public boolean setLocalVariableValue(String variable, int value) {
		if (!localVariables.isEmpty()) {
			if (!getFunctionScope().isEmpty()) {
				for (int i = getFunctionScope().size() - 1; i >= 0; i--) {
					Map<String, Integer> blockScope = getFunctionScope().get(i);
					if (blockScope.containsKey(variable)) {
						blockScope.put(variable, value);
						return true;
					}
				}
			}
		}
		return false;
	}
}
