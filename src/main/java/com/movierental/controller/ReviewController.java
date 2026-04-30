package com.movierental.controller;

import com.movierental.service.ReviewService;
import jakarta.servlet.http.HttpSession;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

@Controller
public class ReviewController {
    private final ReviewService reviewService;

    public ReviewController(ReviewService reviewService) {
        this.reviewService = reviewService;
    }

    @PostMapping("/reviews/add")
    public String addReview(
            @RequestParam String movieId,
            @RequestParam int rating,
            @RequestParam String comment,
            HttpSession session,
            RedirectAttributes redirectAttributes
    ) {
        String userId = (String) session.getAttribute("userId");
        if (userId == null) {
            return "redirect:/login";
        }
        redirectAttributes.addFlashAttribute("message", reviewService.addReview(userId, movieId, rating, comment));
        return "redirect:/movies/" + movieId;
    }

    @PostMapping("/reviews/delete")
    public String deleteOwnReview(
            @RequestParam String reviewId,
            @RequestParam String movieId,
            HttpSession session,
            RedirectAttributes redirectAttributes
    ) {
        String userId = (String) session.getAttribute("userId");
        if (userId == null) {
            return "redirect:/login";
        }
        redirectAttributes.addFlashAttribute("message", reviewService.deleteOwnReview(userId, reviewId));
        return "redirect:/movies/" + movieId;
    }
}
