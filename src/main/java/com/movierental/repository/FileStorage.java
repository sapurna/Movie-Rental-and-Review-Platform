package com.movierental.repository;

import org.springframework.stereotype.Component;

import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.List;

@Component
public class FileStorage {
    private static final String BASE_PATH = "src/main/resources/data";

    public List<String> readAll(String fileName) {
        Path path = resolve(fileName);
        try {
            ensureExists(path);
            return Files.readAllLines(path, StandardCharsets.UTF_8);
        } catch (IOException e) {
            throw new RuntimeException("Unable to read " + fileName, e);
        }
    }

    public void writeAll(String fileName, List<String> rows) {
        Path path = resolve(fileName);
        try {
            ensureExists(path);
            Files.write(path, rows, StandardCharsets.UTF_8);
        } catch (IOException e) {
            throw new RuntimeException("Unable to write " + fileName, e);
        }
    }

    private Path resolve(String fileName) {
        return Paths.get(BASE_PATH, fileName);
    }

    private void ensureExists(Path path) throws IOException {
        Path parent = path.getParent();
        if (parent != null && Files.notExists(parent)) {
            Files.createDirectories(parent);
        }
        if (Files.notExists(path)) {
            Files.write(path, new ArrayList<>(), StandardCharsets.UTF_8);
        }
    }
}
