package com.movierental.repository;

import com.movierental.model.User;
import org.springframework.stereotype.Repository;

import java.util.ArrayList;
import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

@Repository
public class UserRepository {
    private static final String FILE = "users.txt";
    private final FileStorage fileStorage;

    public UserRepository(FileStorage fileStorage) {
        this.fileStorage = fileStorage;
    }

    public List<User> findAll() {
        List<User> users = new ArrayList<>();
        for (String row : fileStorage.readAll(FILE)) {
            if (row.isBlank()) {
                continue;
            }
            User user = User.fromRecord(row);
            if (user != null) {
                users.add(user);
            }
        }
        return users;
    }

    public Optional<User> findByEmail(String email) {
        return findAll().stream().filter(u -> u.getEmail().equalsIgnoreCase(email)).findFirst();
    }

    public Optional<User> findById(String userId) {
        return findAll().stream().filter(u -> u.getUserId().equals(userId)).findFirst();
    }

    public void save(User user) {
        List<User> users = findAll();
        users.add(user);
        persist(users);
    }

    public void update(User updatedUser) {
        List<User> users = findAll().stream()
                .map(existing -> existing.getUserId().equals(updatedUser.getUserId()) ? updatedUser : existing)
                .collect(Collectors.toList());
        persist(users);
    }

    private void persist(List<User> users) {
        fileStorage.writeAll(FILE, users.stream().map(User::toRecord).toList());
    }
}
