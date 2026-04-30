package com.movierental.model;

public class NormalBooking extends Booking {

    public NormalBooking(String bookingId, String userId, String movieId, String seatNumber, String status) {
        super(bookingId, userId, movieId, seatNumber, "NORMAL", status);
    }

    @Override
    public double calculatePrice(Movie movie) {
        return movie.getNormalPrice();
    }
}
