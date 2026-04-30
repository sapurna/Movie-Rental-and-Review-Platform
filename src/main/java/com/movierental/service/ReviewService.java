package com.movierental.service;

import com.movierental.model.Review;
import com.movierental.repository.ReviewRepository;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.UUID;

@Service
public class ReviewService {
    private final ReviewRepository reviewRepository;

    public ReviewService(ReviewRepository reviewRepository) {
        this.reviewRepository = reviewRepository;
    }

    public List<Review> getReviewsByMovie(String movieId) {
        return reviewRepository.findAll().stream()
                .filter(review -> review.getMovieId().equals(movieId))
                .toList();
    }

    public String addReview(String userId, String movieId, int rating, String comment) {
        if (rating < 1 || rating > 5 || comment == null || comment.isBlank()) {
            return "Please provide valid rating and comment.";
        }
        Review review = new Review(UUID.randomUUID().toString(), userId, movieId, rating, comment.trim());
        reviewRepository.save(review);
        return "Review added.";
    }

    public String deleteOwnReview(String userId, String reviewId) {
        Review review = reviewRepository.findAll().stream()
                .filter(r -> r.getReviewId().equals(reviewId))
                .findFirst()
                .orElse(null);
        if (review == null || !review.getUserId().equals(userId)) {
            return "Review not found.";
        }
        reviewRepository.delete(reviewId);
        return "Review deleted.";
    }
}
