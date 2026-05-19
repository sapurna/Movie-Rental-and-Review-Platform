package com.movierental.model;

public class BookingRecord {
    private String bookingId;
    private String userId;
    private String movieId;
    private String seatNumber;
    private String seatType;
    private double price;
    private String status;

    public BookingRecord(String bookingId, String userId, String movieId, String seatNumber, String seatType, double price, String status) {
        this.bookingId = bookingId;
        this.userId = userId;
        this.movieId = movieId;
        this.seatNumber = seatNumber;
        this.seatType = seatType;
        this.price = price;
        this.status = status;
    }

    public String toRecord() {
        return String.join("|", bookingId, userId, movieId, seatNumber, seatType, String.valueOf(price), status);
    }

    public static BookingRecord fromRecord(String row) {
        String[] parts = row.split("\\|", -1);
        if (parts.length < 7) {
            return null;
        }
        return new BookingRecord(parts[0], parts[1], parts[2], parts[3], parts[4], Double.parseDouble(parts[5]), parts[6]);
    }

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

    public void setSeatType(String seatType) {
        this.seatType = seatType;
    }

    public double getPrice() {
        return price;
    }

    public void setPrice(double price) {
        this.price = price;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }
}
