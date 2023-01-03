package day7;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.util.ArrayList;
import java.util.List;
import java.util.Stack;
import java.util.UUID;
import java.util.stream.Stream;

public class Day7 {

  public static void main(String[] args) {
    final Path input = Path.of("/Users/ashkann/src/advent_of_code/2022/src/day7/input.dat");
    try (Stream<String> lines = Files.lines(input)) {
      Integer result = new Day7(lines).part1(100_000);
      System.out.println(result);
    } catch (IOException ex) {
      System.err.println(ex);
    }
  }
  private class Directory {
    private final String name;
    private final UUID uuid;
    private Integer totalFileSize;
    private final Directory parent;

    private Directory(final String name, final Directory parent) {
      this.uuid = UUID.randomUUID();
      this.name = name;
      this.parent = parent;
      this.totalFileSize = 0;
    }

    private void addFileSize(final Integer fileSize) {
      this.totalFileSize += fileSize;
      if (parent != null) {
        parent.addFileSize(fileSize);
      }
    }

    private Integer getTotalFileSize() {
      return totalFileSize;
    }
  }
  private final Stream<String> commands;
  private final Stack<Directory> currentDirectory;
  private final List<Directory> allDirectories;
  private final Directory rootDir;

  public Day7(final Stream<String> commands) {
    this.commands = commands;
    currentDirectory = new Stack<>();
    // add root directory
    rootDir = new Directory("/", null);
    currentDirectory.push(rootDir);
    allDirectories = new ArrayList<>();
    allDirectories.add(rootDir);
  }

  public Integer part1(Integer sizeLimit) {
    commands.forEach(this::processCommand);
    Integer result = allDirectories.stream()
        .mapToInt(Directory::getTotalFileSize)
        .filter(total -> total < sizeLimit)
        .sum();
    return result;
  }

  private void processCommand(final String command) {
    if (command.startsWith("$ cd ")) {
      // cd command, update the current directory
      final String newDir = command.split(" ")[2];
      switch (newDir) {
        case "..":  currentDirectory.pop();
        case "/" :
          currentDirectory.clear();
          currentDirectory.push(rootDir);
          break;
        default:
          // this is going to a new directory,
          // create a new directory and add it to the current directory
          final Directory newDirectory = new Directory(newDir, currentDirectory.peek());
          currentDirectory.push(newDirectory);
          allDirectories.add(newDirectory);
      }
    } else if (! command.equals("$ ls")){
      // assuming it's ls results
      String[] lsResult = command.split(" ");
      if (!lsResult[0].equals("dir")) {
        // it's a file, add it's size to the current directory files
        final Directory currentDir = this.currentDirectory.peek();
        currentDir.addFileSize(Integer.parseInt(lsResult[0]));
      }
    }
  }
}
