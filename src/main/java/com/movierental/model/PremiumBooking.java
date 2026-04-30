package com.movierental.model;

public class PremiumBooking extends Booking {

    public PremiumBooking(String bookingId, String userId, String movieId, String seatNumber, String status) {
        super(bookingId, userId, movieId, seatNumber, "PREMIUM", status);
    }

    @Override
    public double calculatePrice(Movie movie) {
        return movie.getPremiumPrice();
    }
}
