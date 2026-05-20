package com.movierental.util;

import java.util.regex.Pattern;

public final class RegistrationValidator {

    private static final Pattern FULL_NAME = Pattern.compile(
            "^(?:[A-Z][a-zA-Z'-]*)(?:\\s+(?:[A-Z][a-zA-Z'-]*))+$|^[A-Z][a-zA-Z'-]*$"
    );
    private static final Pattern EMAIL = Pattern.compile(
            "^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]*[a-zA-Z0-9])?(?:\\.[a-zA-Z0-9](?:[a-zA-Z0-9-]*[a-zA-Z0-9])?)*\\.[a-zA-Z]{2,}$"
    );
    private static final Pattern PHONE = Pattern.compile("^0\\d{9}$");

    private RegistrationValidator() {
    }

    public static String validateFullName(String fullName) {
        if (fullName == null || fullName.isBlank()) {
            return "Full name is required.";
        }
        String trimmed = fullName.trim().replaceAll("\\s+", " ");
        if (!FULL_NAME.matcher(trimmed).matches()) {
            return "Each name must start with a capital letter (e.g. John Doe).";
        }
        return null;
    }

    public static String validateEmail(String email) {
        if (email == null || email.isBlank()) {
            return "Email is required.";
        }
        String trimmed = email.trim();
        if (trimmed.length() > 254) {
            return "Email is too long.";
        }
        if (!EMAIL.matcher(trimmed).matches()) {
            return "Please enter a valid email address (e.g. name@example.com).";
        }
        return null;
    }

    public static String validatePhone(String phone) {
        if (phone == null || phone.isBlank()) {
            return "Phone number is required.";
        }
        String digitsOnly = phone.trim().replaceAll("\\s+", "");
        if (!PHONE.matcher(digitsOnly).matches()) {
            return "Phone must be 10 digits and start with 0 (e.g. 0712345678).";
        }
        return null;
    }

    public static String normalizeFullName(String fullName) {
        return fullName.trim().replaceAll("\\s+", " ");
    }

    public static String normalizeEmail(String email) {
        return email.trim().toLowerCase();
    }

    public static String normalizePhone(String phone) {
        return phone.trim().replaceAll("\\s+", "");
    }
}
