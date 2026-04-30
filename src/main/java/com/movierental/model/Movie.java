package com.movierental.model;

public class Movie {
    private String movieId;
    private String title;
    private String genre;
    private String duration;
    private double normalPrice;
    private double premiumPrice;
    private String description;
    private String imageUrl;

    public Movie() {
    }

    public Movie(String movieId, String title, String genre, String duration, double normalPrice, double premiumPrice, String description, String imageUrl) {
        this.movieId = movieId;
        this.title = title;
        this.genre = genre;
        this.duration = duration;
        this.normalPrice = normalPrice;
        this.premiumPrice = premiumPrice;
        this.description = description;
        this.imageUrl = imageUrl;
    }

    public String toRecord() {
        return String.join("|", movieId, title, genre, duration, String.valueOf(normalPrice), String.valueOf(premiumPrice), description, imageUrl);
    }

    public static Movie fromRecord(String record) {
        String[] parts = record.split("\\|", -1);
        if (parts.length < 8) {
            return null;
        }
        return new Movie(parts[0], parts[1], parts[2], parts[3], Double.parseDouble(parts[4]), Double.parseDouble(parts[5]), parts[6], parts[7]);
    }

    public String getMovieId() {
        return movieId;
    }

    public void setMovieId(String movieId) {
        this.movieId = movieId;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getGenre() {
        return genre;
    }

    public void setGenre(String genre) {
        this.genre = genre;
    }

    public String getDuration() {
        return duration;
    }

    public void setDuration(String duration) {
        this.duration = duration;
    }

    public double getNormalPrice() {
        return normalPrice;
    }

    public void setNormalPrice(double normalPrice) {
        this.normalPrice = normalPrice;
    }

    public double getPremiumPrice() {
        return premiumPrice;
    }

    public void setPremiumPrice(double premiumPrice) {
        this.premiumPrice = premiumPrice;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getImageUrl() {
        return imageUrl;
    }

    public void setImageUrl(String imageUrl) {
        this.imageUrl = imageUrl;
    }
}
