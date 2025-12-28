/*
 * Copyright © 2017, 2025, 2026 Kathryn A Huxtable
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 *
 */
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
