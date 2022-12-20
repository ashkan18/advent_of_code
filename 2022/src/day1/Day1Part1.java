package day1;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.util.concurrent.atomic.AtomicReference;
import java.util.stream.Collectors;
import java.util.stream.Stream;

class Day1Part1 {

  public static void main(String[] args) {

    final Path input = Path.of("/Users/ashkann/src/ac/src/day1/input.data");
    try (Stream<String> lines = Files.lines(input)) {
      final AtomicReference<Integer> current = new AtomicReference<>(0);
      Integer max = lines.collect(Collectors.toMap(
              line -> current.get(),
              line -> {
                if (line.isEmpty()) {
                  current.getAndSet(current.get() + 1);
                  return 0;
                } else {
                  return Integer.parseInt(line);
                }
              },
              (curr, line) -> curr + line))
          .entrySet()
          .stream()
          .max((entry1, entry2) -> entry1.getValue() > entry2.getValue() ? 1 : -1)
          .get().getValue();
      System.out.println("---->" + max);
    } catch (IOException e) {
      throw new RuntimeException(e);
    }
  }
}