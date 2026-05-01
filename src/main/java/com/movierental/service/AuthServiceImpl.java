package com.movierental.service;

import com.movierental.model.User;
import com.movierental.repository.UserRepository;
import org.springframework.stereotype.Service;

import java.util.Optional;
import java.util.UUID;

@Service
public class AuthServiceImpl implements AuthService {
    private final UserRepository userRepository;

    public AuthServiceImpl(UserRepository userRepository) {
        this.userRepository = userRepository;
    }

    @Override
    public Optional<User> login(String email, String password) {
        return userRepository.findByEmail(email)
                .filter(user -> user.getPassword().equals(password));
    }

    @Override
    public String register(String fullName, String email, String password, String phone) {
        if (fullName == null || fullName.isBlank() || email == null || email.isBlank() || password == null || password.length() < 4) {
            return "Please provide valid registration details.";
        }
        if (userRepository.findByEmail(email).isPresent()) {
            return "Email is already registered.";
        }
        User user = new User(
                UUID.randomUUID().toString(),
                fullName.trim(),
                email.trim().toLowerCase(),
                password,
                phone == null ? "" : phone.trim(),
                "CUSTOMER"
        );
        userRepository.save(user);
        return "SUCCESS";
    }

    @Override
    public Optional<User> getUserById(String userId) {
        return userRepository.findById(userId);
    }

    @Override
    public String updateProfile(String userId, String fullName, String phone) {
        Optional<User> userOptional = userRepository.findById(userId);
        if (userOptional.isEmpty()) {
            return "User not found.";
        }
        User user = userOptional.get();
        user.setFullName(fullName == null ? user.getFullName() : fullName.trim());
        user.setPhone(phone == null ? user.getPhone() : phone.trim());
        userRepository.update(user);
        return "SUCCESS";
    }
}
