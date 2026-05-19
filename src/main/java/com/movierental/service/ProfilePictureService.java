package com.movierental.service;

import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.util.Locale;
import java.util.Map;
import java.util.Set;
import java.util.stream.Stream;

@Service
public class ProfilePictureService {
    private static final Path UPLOAD_DIR = Paths.get("src/main/resources/static/posters/profiles");
    private static final long MAX_BYTES = 5 * 1024 * 1024;
    private static final Set<String> ALLOWED_CONTENT_TYPES = Set.of(
            "image/jpeg",
            "image/png",
            "image/webp",
            "image/gif"
    );
    private static final Map<String, String> EXTENSION_BY_CONTENT_TYPE = Map.of(
            "image/jpeg", "jpg",
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

        String contentType = file.getContentType();
        if (contentType == null || !ALLOWED_CONTENT_TYPES.contains(contentType.toLowerCase(Locale.ROOT))) {
            throw new IllegalArgumentException("Only JPG, PNG, WEBP, or GIF images are allowed.");
        }

        String extension = EXTENSION_BY_CONTENT_TYPE.get(contentType.toLowerCase(Locale.ROOT));
        Files.createDirectories(UPLOAD_DIR);
        deleteExistingPictures(userId);

        Path destination = UPLOAD_DIR.resolve(userId + "." + extension);
        Files.copy(file.getInputStream(), destination, StandardCopyOption.REPLACE_EXISTING);

        return "/posters/profiles/" + userId + "." + extension;
    }

    private void deleteExistingPictures(String userId) throws IOException {
        if (!Files.exists(UPLOAD_DIR)) {
            return;
        }
        try (Stream<Path> files = Files.list(UPLOAD_DIR)) {
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
