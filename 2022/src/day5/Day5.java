package day5;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collections;
import java.util.List;
import java.util.Stack;
import java.util.stream.Collectors;
import java.util.stream.IntStream;
import java.util.stream.Stream;

public class Day5 {
  private final ArrayList<Stack<Character>> stacks;
  public static void main(String[] args) {
    final Path input = Path.of("/Users/ashkann/src/advent_of_code/2022/src/day5/input.dat");
    try (Stream<String> lines = Files.lines(input)) {
      final List<String> allLines = lines.toList();
      final List<Character> characters =
          new Day5(allLines.stream().limit(8), 9, allLines.stream().skip(10)).part1();
      System.out.println("Part 1: " + characters);

      final List<Character> charactersPart2 =
          new Day5(allLines.stream().limit(8), 9, allLines.stream().skip(10)).part2();
      System.out.println("Part 2: " + charactersPart2);
    } catch (IOException ex) {
      System.err.println(ex.getMessage());
    }
  }

  private final Stream<String> moves;
  public Day5(Stream<String> initialState, int numberOfStacks, Stream<String> moves) {
    this.moves = moves;
    stacks = new ArrayList<>();
    IntStream.range(0, numberOfStacks).forEachOrdered(n -> {
      stacks.add(new Stack<>());
    });
    initialState.collect(Collectors.collectingAndThen(Collectors.toList(),list -> {Collections.reverse(list);return list;}))
        .forEach(line -> {
      IntStream.range(0, numberOfStacks).forEachOrdered(n -> {
        final char c = line.charAt((n * 4) + 1);
        if (c != ' ') stacks.get(n).push(c);
      });
    });
  }

  public List<Character> part1() {
    moves.map(this::parseAction)
        .forEach(this::runActionPart1);
    return stacks.stream()
        .map(Stack::pop)
        .collect(Collectors.toList());
  }

  public List<Character> part2() {
    moves.map(this::parseAction)
        .forEach(this::runActionPart2);
    return stacks.stream()
        .map(Stack::pop)
        .collect(Collectors.toList());
  }

  private List<Integer> parseAction(String move) {
    return Arrays.stream(move.split(" "))
        .filter(action -> action.chars().allMatch(Character::isDigit))
        .map(Integer::parseInt)
        .collect(Collectors.toList());
  }

  private void runActionPart1(List<Integer> action) {
    IntStream.range(0, action.get(0)).forEach( integer -> {
      stacks.get(action.get(2) - 1).push(stacks.get(action.get(1) - 1).pop());
    });
  }

  private void runActionPart2(List<Integer> action) {
    Stack<Character> middleStack = new Stack<>();
    for (int i = 0; i < action.get(0); i ++) {
      middleStack.push(stacks.get(action.get(1) - 1).pop());
    }
    while (!middleStack.empty()) {
      stacks.get(action.get(2) - 1).push(middleStack.pop());
    }

  }
}
