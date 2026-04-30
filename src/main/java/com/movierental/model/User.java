package com.movierental.model;

public class User {
    private String userId;
    private String fullName;
    private String email;
    private String password;
    private String phone;
    private String accountType;

    public User() {
    }

    public User(String userId, String fullName, String email, String password, String phone, String accountType) {
        this.userId = userId;
        this.fullName = fullName;
        this.email = email;
        this.password = password;
        this.phone = phone;
        this.accountType = accountType;
    }

    public String toRecord() {
        return String.join("|", userId, fullName, email, password, phone, accountType == null ? "CUSTOMER" : accountType);
    }

    public static User fromRecord(String record) {
        String[] parts = record.split("\\|", -1);
        if (parts.length < 5) {
            return null;
        }
        String accountType = parts.length >= 6 ? parts[5] : "CUSTOMER";
        return new User(parts[0], parts[1], parts[2], parts[3], parts[4], accountType);
    }

    public String getUserId() {
        return userId;
    }

    public void setUserId(String userId) {
        this.userId = userId;
    }

    public String getFullName() {
        return fullName;
    }

    public void setFullName(String fullName) {
        this.fullName = fullName;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }

    public String getAccountType() {
        return accountType;
    }

    public void setAccountType(String accountType) {
        this.accountType = accountType;
    }
}
