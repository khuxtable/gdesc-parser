package org.kathrynhuxtable.gdesc.parser;

import java.lang.reflect.Method;
import java.util.HashSet;
import java.util.Set;

import org.antlr.v4.runtime.tree.TerminalNode;

import org.kathrynhuxtable.gdesc.parser.GameParser.InternalFunctionContext;

@SuppressWarnings("unused")
public class GameInfo {

	public Set<String> getInternalFunctionNames() {
		Set<String> internalFunctionNames = new HashSet<>();
		Method[] declaredMethods = InternalFunctionContext.class.getDeclaredMethods();
		for (Method method : declaredMethods) {
			if (method.getReturnType() == TerminalNode.class) {
				internalFunctionNames.add(method.getName().toLowerCase());
			}
		}
		return internalFunctionNames;
	}

}
