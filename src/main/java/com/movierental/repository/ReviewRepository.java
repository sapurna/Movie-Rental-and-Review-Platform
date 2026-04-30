package com.movierental.repository;

import com.movierental.model.Review;
import org.springframework.stereotype.Repository;

import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;

@Repository
public class ReviewRepository {
    private static final String FILE = "reviews.txt";
    private final FileStorage fileStorage;

    public ReviewRepository(FileStorage fileStorage) {
        this.fileStorage = fileStorage;
    }

    public List<Review> findAll() {
        List<Review> reviews = new ArrayList<>();
        for (String row : fileStorage.readAll(FILE)) {
            if (row.isBlank()) {
                continue;
            }
            Review review = Review.fromRecord(row);
            if (review != null) {
                reviews.add(review);
            }
        }
        return reviews;
    }

    public void save(Review review) {
        List<Review> reviews = findAll();
        reviews.add(review);
        persist(reviews);
    }

    public void delete(String reviewId) {
        List<Review> reviews = findAll().stream()
                .filter(r -> !r.getReviewId().equals(reviewId))
                .collect(Collectors.toList());
        persist(reviews);
    }

    private void persist(List<Review> reviews) {
        fileStorage.writeAll(FILE, reviews.stream().map(Review::toRecord).toList());
    }
}
