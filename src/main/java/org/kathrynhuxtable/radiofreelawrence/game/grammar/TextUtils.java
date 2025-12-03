package org.kathrynhuxtable.radiofreelawrence.game.grammar;

public class TextUtils {

	public static char cleanCharLiteral(String text) {
		if (text.startsWith("'") && text.endsWith("'")) {
			text = unescape(text);
		}
		return text.charAt(0);
	}

	public static String cleanStringLiteral(String text) {
		if (text.startsWith("\"") && text.endsWith("\"")) {
			text = unescape(text);
		}
		return text;
	}

	private static String unescape(String text) {
		text = text.substring(1, text.length() - 1);
		text = text.replaceAll("\\\\'", "'");
		text = text.replaceAll("\\\\\"", "\"");
		text = text.replaceAll("\\\\n", "\n");
		text = text.replaceAll("\\\\t", "\t");
		text = text.replaceAll("\\\\\\\\", "\\\\");
		return text;
	}

	public static String cleanTextBlock(String text) {
		text = text.replaceFirst("^\"\"\"\\s*\n", "");
		text = text.replaceFirst("\"\"\"$", "");
		text = text.replaceAll("\r\n?", "\n");
		int minSpaces = -1;
		String[] lines = text.split("\n");
		for (int i = 0; i < lines.length; i++) {
			String textLine = lines[i];
			if (i < lines.length - 1 && textLine.trim().isEmpty()) continue;
			int numSpaces = 0;
			for (int c = 0; c < textLine.length(); c++) {
				if (Character.isWhitespace(text.charAt(c))) {
					numSpaces++;
				} else {
					break;
				}
			}
			if (minSpaces == -1 || numSpaces < minSpaces) {
				minSpaces = numSpaces;
			}
		}
		StringBuilder result = new StringBuilder();
		for (String line : lines) {
			String textLine = line.replaceAll("\\s*$", "");
			if (textLine.isEmpty()) {
				result.append("\n");
			} else {
				result.append(textLine.substring(minSpaces)).append("\n");
			}
		}
		// Remove extra newline at end
		return result.substring(0, result.length() - 1);
	}
}
