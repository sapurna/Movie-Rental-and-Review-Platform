package com.movierental.model;

public abstract class Booking {
    private String bookingId;
    private String userId;
    private String movieId;
    private String seatNumber;
    private String seatType;
    private String status;

    protected Booking(String bookingId, String userId, String movieId, String seatNumber, String seatType, String status) {
        this.bookingId = bookingId;
        this.userId = userId;
        this.movieId = movieId;
        this.seatNumber = seatNumber;
        this.seatType = seatType;
        this.status = status;
    }

    public abstract double calculatePrice(Movie movie);

    public String getBookingId() {
        return bookingId;
    }

    public String getUserId() {
        return userId;
    }

    public String getMovieId() {
        return movieId;
    }

    public String getSeatNumber() {
        return seatNumber;
    }

    public void setSeatNumber(String seatNumber) {
        this.seatNumber = seatNumber;
    }

    public String getSeatType() {
        return seatType;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }
}
