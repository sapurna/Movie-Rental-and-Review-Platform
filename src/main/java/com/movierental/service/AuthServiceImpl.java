package com.movierental.service;

import com.movierental.model.User;
import com.movierental.repository.UserRepository;
import com.movierental.util.RegistrationValidator;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import java.util.Optional;
import java.util.UUID;

@Service
public class AuthServiceImpl implements AuthService {
    private final UserRepository userRepository;
    private final ProfilePictureService profilePictureService;

    public AuthServiceImpl(UserRepository userRepository, ProfilePictureService profilePictureService) {
        this.userRepository = userRepository;
        this.profilePictureService = profilePictureService;
    }

    @Override
    public Optional<User> login(String email, String password) {
        return userRepository.findByEmail(email)
                .filter(user -> user.getPassword().equals(password));
    }

    @Override
    public String register(String fullName, String email, String password, String phone) {
        String nameError = RegistrationValidator.validateFullName(fullName);
        if (nameError != null) {
            return nameError;
        }
        String emailError = RegistrationValidator.validateEmail(email);
        if (emailError != null) {
            return emailError;
        }
        String phoneError = RegistrationValidator.validatePhone(phone);
        if (phoneError != null) {
            return phoneError;
        }
        if (password == null || password.length() < 4) {
            return "Password must be at least 4 characters.";
        }
        String normalizedEmail = RegistrationValidator.normalizeEmail(email);
        if (userRepository.findByEmail(normalizedEmail).isPresent()) {
            return "Email is already registered.";
        }
        User user = new User(
                UUID.randomUUID().toString(),
                RegistrationValidator.normalizeFullName(fullName),
                normalizedEmail,
                password,
                RegistrationValidator.normalizePhone(phone),
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
    public String uploadProfilePicture(String userId, MultipartFile photo) {
        Optional<User> userOptional = userRepository.findById(userId);
        if (userOptional.isEmpty()) {
            return "User not found.";
        }
        try {
            String imageUrl = profilePictureService.saveProfilePicture(userId, photo);
            User user = userOptional.get();
            user.setProfileImageUrl(imageUrl);
            userRepository.update(user);
            return "SUCCESS";
        } catch (IllegalArgumentException ex) {
            return ex.getMessage();
        } catch (java.io.IOException ex) {
            return "Unable to save profile photo. Please check the uploads/profiles folder is writable.";
        } catch (Exception ex) {
            return "Unable to save profile photo. Please try again.";
        }
    }

    @Override
    public String changePassword(String userId, String oldPassword, String newPassword, String confirmPassword) {
        if (oldPassword == null || oldPassword.isBlank()) {
            return "Please enter your current password.";
        }
        if (newPassword == null || newPassword.length() < 4) {
            return "New password must be at least 4 characters.";
        }
        if (!newPassword.equals(confirmPassword)) {
            return "New password and confirmation do not match.";
        }
        Optional<User> userOptional = userRepository.findById(userId);
        if (userOptional.isEmpty()) {
            return "User not found.";
        }
        User user = userOptional.get();
        if (!user.getPassword().equals(oldPassword)) {
            return "Current password is incorrect.";
        }
        user.setPassword(newPassword);
        userRepository.update(user);
        return "SUCCESS";
    }
}
