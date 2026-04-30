package com.movierental.service;

import com.movierental.model.Booking;
import com.movierental.model.BookingRecord;
import com.movierental.model.Movie;
import com.movierental.model.NormalBooking;
import com.movierental.model.PremiumBooking;
import com.movierental.repository.BookingRepository;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Set;
import java.util.UUID;
import java.util.stream.Collectors;

@Service
public class BookingService {
    private final BookingRepository bookingRepository;
    private final MovieService movieService;

    public BookingService(BookingRepository bookingRepository, MovieService movieService) {
        this.bookingRepository = bookingRepository;
        this.movieService = movieService;
    }

    public List<BookingRecord> getUserBookings(String userId) {
        return bookingRepository.findAll().stream()
                .filter(r -> r.getUserId().equals(userId))
                .toList();
    }

    public Set<String> getBookedSeatsByMovie(String movieId) {
        return bookingRepository.findAll().stream()
                .filter(r -> r.getMovieId().equals(movieId))
                .map(r -> r.getSeatNumber().toUpperCase())
                .collect(Collectors.toSet());
    }

    public String addToCart(String userId, String movieId, String seatNumber, String seatType) {
        return addMultipleToCart(userId, movieId, List.of(seatType + ":" + seatNumber));
    }

    public String addMultipleToCart(String userId, String movieId, List<String> seatSelections) {
        if (seatSelections == null || seatSelections.isEmpty()) {
            return "Please select at least one seat.";
        }
        Movie movie = movieService.getMovieById(movieId).orElse(null);
        if (movie == null) {
            return "Movie not found.";
        }
        Set<String> alreadyBookedSeats = getBookedSeatsByMovie(movieId);

        for (String selection : seatSelections) {
            String[] parts = selection.split(":", 2);
            if (parts.length < 2) {
                return "Invalid seat selection.";
            }
            String normalizedSeat = parts[1].trim().toUpperCase();
            if (normalizedSeat.isBlank()) {
                return "Invalid seat number.";
            }
            if (alreadyBookedSeats.contains(normalizedSeat)) {
                return "One or more selected seats are already booked.";
            }
        }

        for (String selection : seatSelections) {
            String[] parts = selection.split(":", 2);
            String seatType = parts[0].trim().toUpperCase();
            String normalizedSeat = parts[1].trim().toUpperCase();
            Booking booking = "PREMIUM".equalsIgnoreCase(seatType)
                    ? new PremiumBooking(UUID.randomUUID().toString(), userId, movieId, normalizedSeat, "PENDING")
                    : new NormalBooking(UUID.randomUUID().toString(), userId, movieId, normalizedSeat, "PENDING");
            double price = booking.calculatePrice(movie);
            BookingRecord record = new BookingRecord(
                    booking.getBookingId(),
                    booking.getUserId(),
                    booking.getMovieId(),
                    booking.getSeatNumber(),
                    booking.getSeatType(),
                    price,
                    booking.getStatus()
            );
            bookingRepository.save(record);
        }
        return seatSelections.size() + " seat(s) added to bookings successfully.";
    }

    public String updateSeat(String userId, String bookingId, String seatNumber) {
        BookingRecord record = bookingRepository.findById(bookingId).orElse(null);
        if (record == null || !record.getUserId().equals(userId)) {
            return "Booking not found.";
        }
        if (seatNumber == null || seatNumber.isBlank()) {
            return "Seat number is required.";
        }
        String normalizedSeat = seatNumber.trim().toUpperCase();
        boolean isSeatAlreadyBooked = bookingRepository.findAll().stream()
                .anyMatch(r -> !r.getBookingId().equals(bookingId)
                        && r.getMovieId().equals(record.getMovieId())
                        && r.getSeatNumber().equalsIgnoreCase(normalizedSeat));
        if (isSeatAlreadyBooked) {
            return "Selected seat is already booked. Please choose another seat.";
        }
        record.setSeatNumber(normalizedSeat);
        bookingRepository.update(record);
        return "Seat updated.";
    }

    public String deleteBooking(String userId, String bookingId) {
        BookingRecord record = bookingRepository.findById(bookingId).orElse(null);
        if (record == null || !record.getUserId().equals(userId)) {
            return "Booking not found.";
        }
        bookingRepository.delete(bookingId);
        return "Booking removed.";
    }

    public String confirmBooking(String userId, String bookingId) {
        BookingRecord record = bookingRepository.findById(bookingId).orElse(null);
        if (record == null || !record.getUserId().equals(userId)) {
            return "Booking not found.";
        }
        record.setStatus("CONFIRMED");
        bookingRepository.update(record);
        return "Booking confirmed.";
    }
}
