package com.movierental.model;

public class Review {
    private String reviewId;
    private String userId;
    private String movieId;
    private int rating;
    private String comment;

    public Review(String reviewId, String userId, String movieId, int rating, String comment) {
        this.reviewId = reviewId;
        this.userId = userId;
        this.movieId = movieId;
        this.rating = rating;
        this.comment = comment;
    }

    public String toRecord() {
        return String.join("|", reviewId, userId, movieId, String.valueOf(rating), comment);
    }

    public static Review fromRecord(String row) {
        String[] parts = row.split("\\|", -1);
        if (parts.length < 5) {
            return null;
        }
        return new Review(parts[0], parts[1], parts[2], Integer.parseInt(parts[3]), parts[4]);
    }

    public String getReviewId() {
        return reviewId;
    }

    public String getUserId() {
        return userId;
    }

    public String getMovieId() {
        return movieId;
    }

    public int getRating() {
        return rating;
    }

    public String getComment() {
        return comment;
    }
}
