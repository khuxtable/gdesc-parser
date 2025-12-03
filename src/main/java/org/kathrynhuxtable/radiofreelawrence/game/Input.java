package org.kathrynhuxtable.radiofreelawrence.game;

import java.nio.charset.StandardCharsets;
import java.util.List;
import java.util.Scanner;

import lombok.RequiredArgsConstructor;

import org.kathrynhuxtable.radiofreelawrence.game.grammar.tree.HasRefno;

@RequiredArgsConstructor
public class Input {

	private final GameData gameData;

	private final Scanner scanner = new Scanner(System.in, StandardCharsets.UTF_8);

	public void input() {
			System.out.print("? ");
			String text = scanner.nextLine();

			parseInput(text);
	}

	private void parseInput(String input) {
		int arg1 = 0;
		int arg2 = 0;
		int status = 0;

		String[] words = input.split("\\s+");
		int index = 1;
		for (String word : words) {
			if (!gameData.gameNode.getNoise().contains(word)) {
				int arg;
				if (gameData.gameNode.getVerbs().containsKey(word)) {
					HasRefno wordNode = (HasRefno) gameData.gameNode.getVerbs().get(word);
					arg = wordNode.getRefno();
					if (status >= 0) {
						status = index;
					}
				} else {
					List<String> possibleKeys = gameData.gameNode.getVerbs().keySet().stream()
							.filter(v -> v.startsWith(word))
							.toList();
					if (possibleKeys.isEmpty()) {
						arg = gameData.getIntIdentifierValue("badword");
						status = gameData.getIntIdentifierValue("badsyntax");
					} else if (possibleKeys.size() > 1) {
						arg = gameData.getIntIdentifierValue("ambigword");
						status = gameData.getIntIdentifierValue("badsyntax");
					} else {
						HasRefno wordNode = (HasRefno) gameData.gameNode.getVerbs().get(possibleKeys.get(0));
						arg = wordNode.getRefno();
						if (status >= 0) {
							status = index;
						}
					}
				}
				if (index == 1) {
					arg1 = arg;
				} else {
					arg2 = arg;
				}
				index++;
			}
			if (index > 2) {
				break;
			}
		}

		gameData.setIntIdentifierValue("arg1", arg1);
		gameData.setIntIdentifierValue("arg2", arg2);
		gameData.setIntIdentifierValue("status", status);
	}

}
