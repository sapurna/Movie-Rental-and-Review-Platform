package com.movierental.service;

import com.movierental.model.User;
import org.springframework.web.multipart.MultipartFile;

import java.util.Optional;

public interface AuthService {
    Optional<User> login(String email, String password);

    String register(String fullName, String email, String password, String phone);

    Optional<User> getUserById(String userId);

    /**
     * @return "SUCCESS" or an error message
     */
    String changePassword(String userId, String oldPassword, String newPassword, String confirmPassword);

    /**
     * @return "SUCCESS" or an error message
     */
    String uploadProfilePicture(String userId, MultipartFile photo);
}
