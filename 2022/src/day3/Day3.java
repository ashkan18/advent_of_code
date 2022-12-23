package day3;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Objects;
import java.util.Optional;
import java.util.stream.Stream;

public class Day3 {

  public static void main(String[] args) {
    final Path input = Path.of("/Users/ashkann/src/advent_of_code/2022/src/day3/input.dat");
    try (Stream<String> lines = Files.lines(input)) {
      final int part1 = new Day3(lines).part1();
      System.out.println("Part 1: " + part1);
      final int part2 = new Day3(lines).part2(3);
      System.out.println("Part 1: " + part2);
    } catch (IOException e) {
      System.out.println(e.getMessage());
    }
  }

  private final Stream<String> lines;

  public Day3(final Stream<String> lines1) {
    this.lines = lines1;
  }

  public int part1() {
    return this.lines.map(this::getRucksackPriority)
        .mapToInt(Integer::intValue).sum();
  }

  public int part2(final Integer groupSize) {
    return this.getGroups(groupSize)
        .stream()
        .map(this::findGroupItem)
        .filter(Optional::isPresent)
        .map(Optional::get)
        .map(this::calculateScore)
        .mapToInt(Integer::intValue).sum();
  }

  private List<List<String>> getGroups(Integer groupSize) {
    List<List<String>> all = new ArrayList<>();
    List<String> original = lines.toList();
    for (int i = 0; i < original.size(); i += groupSize) {
      List<String> thisGroup = new ArrayList<>();
      for (int j = 0; j < groupSize; j++) {
        thisGroup.add(original.get(i + j));
      }
      all.add(thisGroup);
    }
    return all;
  }

  private int getRucksackPriority(String rucksack) {
    final int midPoint = rucksack.length() / 2;
    final HashSet<Integer> firstHalf = new HashSet<>();
    for (int c : rucksack.substring(0, midPoint).toCharArray()) {
      firstHalf.add(c);
    }

    for (int c : rucksack.substring(midPoint).toCharArray()) {
      if (firstHalf.contains(c)) {
        return calculateScore(c);
      }
    }
    return 0; // no matches
  }

  private Optional<Integer> findGroupItem(List<String> group) {
    final HashMap<Integer, Integer> allChars = new HashMap<>();
    group.stream()
        .map(line -> {
          HashSet<Integer> lineChars = new HashSet<>();
          for (int c : line.toCharArray()) {
            lineChars.add(c);
          }
          return lineChars;
        })
        .forEach(charSet -> {
          for (int c : charSet.stream().toList()) {
            allChars.put(c, allChars.getOrDefault(c, 0) + 1);
          }
        });
    return Optional.of(Objects.requireNonNull(allChars.entrySet().stream()
        .max((entry1, entry2) -> entry1.getValue() >= entry2.getValue() ? 1 : -1)
        .orElse(null)).getKey());
  }

  private int calculateScore(int c) {
    if (c >= 97) {
      // lower case a is 97
      return c - 96;
    } else {
      return c - 38;
    }
  }

}
