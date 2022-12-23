package day4;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.util.Arrays;
import java.util.HashSet;
import java.util.List;
import java.util.Set;
import java.util.stream.Collectors;
import java.util.stream.IntStream;
import java.util.stream.Stream;

public class Day4 {

  public static void main(String[] args) {
    final Path input = Path.of("/Users/ashkann/src/advent_of_code/2022/src/day4/input.dat");
    try (Stream<String> lines = Files.lines(input)) {
      final long part1 = new Day4(lines).part1();
      System.out.println("part1: " + part1);
      final long part2 = new Day4(lines).part2();
      System.out.println("part2: " + part2);
    } catch (IOException ex) {
      System.out.println(ex.getMessage());
    }
  }

  private final Stream<String> lines;

  public Day4(Stream<String> lines) {
    this.lines = lines;
  }

  public long part1() {
    return lines.map(this::generateSets)
        .map(sets -> this.hasFullOverlap(sets.get(0), sets.get(1)))
        .filter(b -> b)
        .count();

  }

  public long part2() {
    return lines.map(this::generateSets)
        .map(sets -> this.hasAnyOverlap(sets.get(0), sets.get(1)))
        .filter(b -> b)
        .count();
  }


  private List<Set<Integer>> generateSets(String line) {
    return Arrays.stream(line.split(","))
        .map(this::assignmentSet)
        .collect(Collectors.toList());
  }

  private boolean hasFullOverlap(Set<Integer> first, Set<Integer> second) {
    Set<Integer> intersection = new HashSet<>(first);
    intersection.retainAll(second);
    return intersection.size() == first.size() || intersection.size() == second.size();
  }

  private boolean hasAnyOverlap(Set<Integer> first, Set<Integer> second) {
    Set<Integer> intersection = new HashSet<>(first);
    intersection.retainAll(second);
    return intersection.size() > 0;
  }

  private Set<Integer> assignmentSet(String assignmentStr) {
    // assignment str is in format of x-y
    final String[] startEnd = assignmentStr.split("-");
    return IntStream.rangeClosed(Integer.parseInt(startEnd[0]),
        Integer.parseInt(startEnd[1])).boxed().collect(Collectors.toSet());
  }
}
