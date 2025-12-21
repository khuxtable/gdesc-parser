package org.kathrynhuxtable.gdesc.parser;

import java.lang.reflect.Method;
import java.util.ArrayList;
import java.util.List;

import org.antlr.v4.runtime.tree.TerminalNode;

import org.kathrynhuxtable.gdesc.parser.GameParser.InternalFunctionContext;

@SuppressWarnings("unused")
public class GameInfo {

	public List<String> getInternalFunctionNames() {
		List<String> internalFunctionNames = new ArrayList<>();
		Method[] declaredMethods = InternalFunctionContext.class.getDeclaredMethods();
		for (Method method : declaredMethods) {
			if (method.getReturnType() == TerminalNode.class) {
				internalFunctionNames.add(method.getName());
			}
		}
		return internalFunctionNames;
	}

}
