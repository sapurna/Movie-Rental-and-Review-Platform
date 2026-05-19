package com.movierental.service;

import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.stream.Stream;

@Service
public class ProfilePictureService {
    private static final String UPLOAD_FOLDER = "uploads/profiles";
    private static final List<Path> LEGACY_DIRS = List.of(
            Paths.get("src/main/resources/static/posters/profiles"),
            Paths.get("target/classes/static/posters/profiles")
    );
    private static final List<String> KNOWN_EXTENSIONS = List.of("jpg", "jpeg", "png", "webp", "gif");
    private static final long MAX_BYTES = 5 * 1024 * 1024;
    private static final Map<String, String> EXTENSION_BY_CONTENT_TYPE = Map.of(
            "image/jpeg", "jpg",
            "image/jpg", "jpg",
            "image/pjpeg", "jpg",
            "image/png", "png",
            "image/webp", "webp",
            "image/gif", "gif"
    );

    public String saveProfilePicture(String userId, MultipartFile file) throws IOException {
        if (file == null || file.isEmpty()) {
            throw new IllegalArgumentException("Please select a photo to upload.");
        }
        if (file.getSize() > MAX_BYTES) {
            throw new IllegalArgumentException("Photo must be 5 MB or smaller.");
        }

        String extension = resolveExtension(file);
        if (extension == null) {
            throw new IllegalArgumentException("Only JPG, PNG, WEBP, or GIF images are allowed.");
        }

        String fileName = userId + "." + extension;
        deleteAllProfilePictures(userId);

        Path uploadDir = Paths.get(UPLOAD_FOLDER).toAbsolutePath().normalize();
        Files.createDirectories(uploadDir);
        Path destination = uploadDir.resolve(fileName);

        try (InputStream inputStream = file.getInputStream()) {
            Files.copy(inputStream, destination, StandardCopyOption.REPLACE_EXISTING);
        }

        return "/posters/profiles/" + fileName;
    }

    private String resolveExtension(MultipartFile file) {
        String contentType = normalizeContentType(file.getContentType());
        if (EXTENSION_BY_CONTENT_TYPE.containsKey(contentType)) {
            return EXTENSION_BY_CONTENT_TYPE.get(contentType);
        }

        if ("application/octet-stream".equals(contentType)) {
            String fromName = extensionFromFileName(file.getOriginalFilename());
            if (fromName != null) {
                return fromName;
            }
        }

        return extensionFromFileName(file.getOriginalFilename());
    }

    private String extensionFromFileName(String fileName) {
        if (fileName == null || fileName.isBlank()) {
            return null;
        }
        String lower = fileName.toLowerCase(Locale.ROOT);
        if (lower.endsWith(".jpeg") || lower.endsWith(".jpg")) {
            return "jpg";
        }
        if (lower.endsWith(".png")) {
            return "png";
        }
        if (lower.endsWith(".webp")) {
            return "webp";
        }
        if (lower.endsWith(".gif")) {
            return "gif";
        }
        return null;
    }

    private String normalizeContentType(String contentType) {
        if (contentType == null) {
            return "";
        }
        return contentType.toLowerCase(Locale.ROOT).split(";")[0].trim();
    }

    private void deleteAllProfilePictures(String userId) {
        try {
            Path uploadDir = Paths.get(UPLOAD_FOLDER).toAbsolutePath().normalize();
            deleteInDirectory(uploadDir, userId);
            for (Path legacyDir : LEGACY_DIRS) {
                deleteInDirectory(legacyDir.toAbsolutePath().normalize(), userId);
            }
        } catch (IOException ignored) {
            // do not block upload if old file cleanup fails
        }
    }

    private void deleteInDirectory(Path directory, String userId) throws IOException {
        if (!Files.exists(directory)) {
            return;
        }
        for (String ext : KNOWN_EXTENSIONS) {
            Files.deleteIfExists(directory.resolve(userId + "." + ext));
        }
        try (Stream<Path> files = Files.list(directory)) {
            files.filter(path -> path.getFileName().toString().startsWith(userId + "."))
                    .forEach(path -> {
                        try {
                            Files.deleteIfExists(path);
                        } catch (IOException ignored) {
                            // best effort cleanup
                        }
                    });
        }
    }
}
