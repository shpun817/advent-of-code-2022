import java.io.File;
import java.io.FileNotFoundException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;
import java.util.Optional;
import java.util.Scanner;
import java.util.function.Predicate;

class Directory {
    HashMap<String, Integer> files;
    HashMap<String, Directory> subdirectories;
    Optional<Directory> parent;

    Directory() {
        files = new HashMap<>();
        subdirectories = new HashMap<>();
        parent = Optional.empty();
    }

    Directory(Directory parent) {
        files = new HashMap<>();
        subdirectories = new HashMap<>();
        this.parent = Optional.of(parent);
    }

    String toString(int level) {
        final StringBuilder builder = new StringBuilder();
        for (Map.Entry<String, Integer> entry : files.entrySet()) {
            final String name = entry.getKey();
            final int size = entry.getValue();
            builder.append("  ".repeat(level));
            builder.append(String.format("- %s (file, size=%d)\n", name, size));
        }
        for (Map.Entry<String, Directory> entry : subdirectories.entrySet()) {
            final String name = entry.getKey();
            final Directory subdir = entry.getValue();
            builder.append("  ".repeat(level));
            builder.append(String.format("- %s (dir)\n", name));
            builder.append(subdir.toString(level+1));
        }
        return builder.toString();
    }

    int getTotalFileSize() {
        int totalFileSize = 0;
        for (int size : files.values()) {
            totalFileSize += size;
        }
        return totalFileSize;
    }
}

class FileSystemBuilder {
    Directory rootDir;
    Directory currentDir;

    FileSystemBuilder() {
        rootDir = new Directory();
        currentDir = rootDir;
    }

    void changeDirectory(String subdirectoryName) {
        if (subdirectoryName.equals("/")) {
            currentDir = rootDir;
            return;
        }
        if (subdirectoryName.equals("..")) {
            if (currentDir == rootDir) {
                System.err.println("Trying to go back past root directory");
                System.exit(1);
            }
            currentDir = currentDir.parent.get();
            return;
        }
        currentDir = currentDir.subdirectories.get(subdirectoryName);
    }

    void addFile(String name, int size) {
        currentDir.files.put(name, size);
    }

    void addDirectory(String name) {
        currentDir.subdirectories.put(name, new Directory(currentDir));
    }

    Directory build() {
        final Directory rootDir = this.rootDir;
        this.rootDir = new Directory();
        currentDir = rootDir;
        return rootDir;
    }
}

public class Main {
    static void parseLine(String line, FileSystemBuilder builder) {
        if (line.equals("$ ls") || line.isBlank()) {
            return;
        }
        final char firstChar = line.charAt(0);
        final String[] tokens = line.split(" ");
        if (firstChar == '$') {
            final String dirName = tokens[2];
            builder.changeDirectory(dirName);
            return;
        }
        if (firstChar == 'd') {
            final String dirName = tokens[1];
            builder.addDirectory(dirName);
            return;
        }
        if (Character.isDigit(firstChar)) {
            final int size = Integer.parseInt(tokens[0]);
            final String filename = tokens[1];
            builder.addFile(filename, size);
            return;
        }
    }

    static int solveP1(Directory dir) {
        final ArrayList<Integer> directoriesToSum = new ArrayList<>();
        findTotalSizeAndRegisterConditionally(dir, i -> (i <= 100000), directoriesToSum);
        int ans = 0;
        for (int item : directoriesToSum) {
            ans += item;
        }
        return ans;
    }

    static int solveP2(Directory dir) {
        final int totalDiskSpaceAvailable = 70000000;
        final int freeSpaceRequired = 30000000;
        final int totalUsedSpace = findTotalSize(dir);
        final int unusedSpace = totalDiskSpaceAvailable - totalUsedSpace;
        final int minSpaceToFree = freeSpaceRequired - unusedSpace;

        final ArrayList<Integer> bigEnoughDirectories = new ArrayList<>();
        findTotalSizeAndRegisterConditionally(dir, i -> (i >= minSpaceToFree), bigEnoughDirectories);
        if (bigEnoughDirectories.isEmpty()) {
            return totalUsedSpace;
        }
        int min = bigEnoughDirectories.get(0);
        for (int i = 1; i < bigEnoughDirectories.size(); ++i) {
            int size = bigEnoughDirectories.get(i);
            if (min > size) {
                min = size;
            }
        }
        return min;
    }

    static int findTotalSize(Directory dir) {
        int acc = dir.getTotalFileSize();

        for (Directory subdir : dir.subdirectories.values()) {
            acc += findTotalSize(subdir);
        }

        return acc;
    }

    static int findTotalSizeAndRegisterConditionally(Directory dir, Predicate<Integer> pred, ArrayList<Integer> registry) {
        int acc = dir.getTotalFileSize();

        for (Directory subdir : dir.subdirectories.values()) {
            acc += findTotalSizeAndRegisterConditionally(subdir, pred, registry);
        }

        if (pred.test(acc)) {
            registry.add(acc);
        }

        return acc;
    }

    public static void main(String[] argv) {
        // final String filename = "dummy_input.txt";
        final String filename = "input.txt";

        final FileSystemBuilder builder = new FileSystemBuilder();
        try {
            final Scanner scanner = new Scanner(new File(filename));
            while (scanner.hasNextLine()) {
                parseLine(scanner.nextLine(), builder);
            }
            scanner.close();
        } catch (FileNotFoundException e) {
            e.printStackTrace();
            System.exit(1);
        }
        
        Directory rootDir = builder.build();
        // System.out.println(rootDir.toString(0));
        System.out.println("Part 1: " + solveP1(rootDir));
        System.out.println("Part 2: " + solveP2(rootDir));
    }
}
