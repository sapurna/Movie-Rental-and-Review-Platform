package com.movierental.controller;

import com.movierental.model.User;
import com.movierental.service.AuthService;
import com.movierental.service.BookingService;
import jakarta.servlet.http.HttpSession;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

@Controller
public class AuthController {
    private final AuthService authService;
    private final BookingService bookingService;

    public AuthController(AuthService authService, BookingService bookingService) {
        this.authService = authService;
        this.bookingService = bookingService;
    }

    @GetMapping("/")
    public String home(HttpSession session) {
        return session.getAttribute("userId") == null ? "redirect:/login" : "redirect:/movies";
    }

    @GetMapping("/login")
    public String loginPage(HttpSession session) {
        return session.getAttribute("userId") == null ? "login" : "redirect:/movies";
    }

    @PostMapping("/login")
    public String login(
            @RequestParam String email,
            @RequestParam String password,
            Model model,
            HttpSession session
    ) {
        User user = authService.login(email, password).orElse(null);
        if (user == null) {
            model.addAttribute("error", "Invalid email or password.");
            return "login";
        }
        String userAccountType = user.getAccountType() == null ? "CUSTOMER" : user.getAccountType().toUpperCase();
        if (!"CUSTOMER".equals(userAccountType)) {
            model.addAttribute("error", "Only customer login is supported.");
            return "login";
        }
        session.setAttribute("userId", user.getUserId());
        session.setAttribute("userName", user.getFullName());
        session.setAttribute("accountType", "CUSTOMER");
        return "redirect:/movies";
    }

    @GetMapping("/register")
    public String registerPage(HttpSession session) {
        return session.getAttribute("userId") == null ? "register" : "redirect:/movies";
    }

    @PostMapping("/register")
    public String register(
            @RequestParam String fullName,
            @RequestParam String email,
            @RequestParam String password,
            @RequestParam(required = false) String phone,
            Model model
    ) {
        String result = authService.register(fullName, email, password, phone);
        if (!"SUCCESS".equals(result)) {
            model.addAttribute("error", result);
            return "register";
        }
        model.addAttribute("success", "Registration successful. Please log in.");
        return "login";
    }

    @GetMapping("/profile")
    public String profile(Model model, HttpSession session) {
        String userId = (String) session.getAttribute("userId");
        if (userId == null) {
            return "redirect:/login";
        }
        User user = authService.getUserById(userId).orElse(null);
        if (user == null) {
            return "redirect:/logout";
        }
        model.addAttribute("user", user);
        model.addAttribute("totalBookedTickets", bookingService.getUserBookings(userId).size());
        return "profile";
    }

    @GetMapping("/profile/update")
    public String updateProfileGet() {
        return "redirect:/profile";
    }

    @PostMapping("/profile/update")
    public String updateProfile(
            @RequestParam String fullName,
            @RequestParam String phone,
            RedirectAttributes redirectAttributes,
            HttpSession session) {
        String userId = (String) session.getAttribute("userId");
        if (userId == null) {
            return "redirect:/login";
        }
        String result = authService.updateProfile(userId, fullName, phone);
        redirectAttributes.addFlashAttribute("message",
                "SUCCESS".equals(result) ? "Profile updated successfully." : result);
        return "redirect:/profile";
    }

    /**
     * Avoids 404 when the browser issues a GET (e.g. refresh) after a POST to change-password.
     */
    @GetMapping("/profile/change-password")
    public String changePasswordPage() {
        return "redirect:/profile";
    }

    @PostMapping("/profile/change-password")
    public String changePassword(
            @RequestParam String oldPassword,
            @RequestParam String newPassword,
            @RequestParam String confirmPassword,
            RedirectAttributes redirectAttributes,
            HttpSession session) {
        String userId = (String) session.getAttribute("userId");
        if (userId == null) {
            return "redirect:/login";
        }
        String result = authService.changePassword(userId, oldPassword, newPassword, confirmPassword);
        if (!"SUCCESS".equals(result)) {
            redirectAttributes.addFlashAttribute("passwordError", result);
            redirectAttributes.addFlashAttribute("openPasswordModal", true);
        } else {
            redirectAttributes.addFlashAttribute("message", "Password updated successfully.");
        }
        return "redirect:/profile";
    }

    @GetMapping("/logout")
    public String logout(HttpSession session) {
        session.invalidate();
        return "redirect:/login";
    }
}
