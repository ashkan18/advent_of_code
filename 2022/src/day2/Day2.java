package day2;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.util.stream.Stream;

public class Day2 {

  public static void main(String[] args) {
    final Path input = Path.of("/Users/ashkann/src/advent_of_code/2022/src/day2/input.dat");

    try (Stream<String> lines = Files.lines(input)) {
      final Integer[] score = lines.map(line -> line.split(" "))
          .map(Day2::addPartTwo)
          .map(Day2::calculateScores)
          .reduce(new Integer[]{ 0, 0 }, (acc, scores) -> new Integer[]{ acc[0] + scores[0],
                                                                         acc[1] + scores[1] });
      System.out.println(score[0] + "---" + score[1]);
    } catch (IOException e) {
      throw new RuntimeException(e);
    }
  }

  public static Integer[] calculateScores(String[] line) {
    final String theirMove = line[0];
    final String ourMove = line[1];
    final String ourMovePartTwo = line[2];
    return new Integer[]{ calculateScore(theirMove, ourMove), calculateScore(theirMove,
        ourMovePartTwo) };
  }

  private static int calculateScore(final String theirMove, final String ourMove) {
    final int shapeScore = switch (ourMove) {
      case "X" -> 1;
      case "Y" -> 2;
      case "Z" -> 3;
      default -> 0;
    };
    final int resultScore = switch (theirMove + ourMove) {
      case "AX", "BY", "CZ" -> 3;
      case "AY", "BZ", "CX" -> 6;
      default -> 0;
    };
    return shapeScore + resultScore;
  }

  public static String[] addPartTwo(String[] line) {
    final String theirMove = line[0];
    final String expectedResult = line[1];
    final String ourMove = switch (expectedResult) {
      case "X" ->
        // lose
          switch (theirMove) {
            case "A" -> "Z";
            case "B" -> "X";
            case "C" -> "Y";
            default -> "U";
          };
      case "Y" ->
        //draw
          switch (theirMove) {
            case "A" -> "X";
            case "B" -> "Y";
            case "C" -> "Z";
            default -> "U";
          };
      case "Z" ->
        // win
          switch (theirMove) {
            case "A" -> "Y";
            case "B" -> "Z";
            case "C" -> "X";
            default -> "U";
          };
      default -> "U";
    };
    return new String[]{ theirMove, expectedResult, ourMove };
  }
}
