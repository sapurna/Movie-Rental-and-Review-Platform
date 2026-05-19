package com.movierental.controller;

import com.movierental.model.Movie;
import com.movierental.service.BookingService;
import com.movierental.service.MovieService;
import com.movierental.service.ReviewService;
import jakarta.servlet.http.HttpSession;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestParam;

@Controller
public class MovieController {
    private final MovieService movieService;
    private final ReviewService reviewService;
    private final BookingService bookingService;

    public MovieController(MovieService movieService, ReviewService reviewService, BookingService bookingService) {
        this.movieService = movieService;
        this.reviewService = reviewService;
        this.bookingService = bookingService;
    }

    @GetMapping("/movies")
    public String movies(
            @RequestParam(required = false) String q,
            @RequestParam(required = false) String type,
            HttpSession session,
            Model model) {
        if (session.getAttribute("userId") == null) {
            return "redirect:/login";
        }
        String selectedType = (type == null || type.isBlank()) ? "Trending" : type.trim();
        model.addAttribute("query", q == null ? "" : q);
        model.addAttribute("selectedType", selectedType);
        model.addAttribute("filterTypes", movieService.getGenreFilterOptions());
        model.addAttribute("movies", movieService.getAllMovies(q, type));
        model.addAttribute("userName", session.getAttribute("userName"));
        return "movies";
    }

    @GetMapping("/movies/{movieId}")
    public String movieDetails(
            @PathVariable String movieId,
            @RequestParam(required = false) String bookingId,
            HttpSession session,
            Model model) {
        if (session.getAttribute("userId") == null) {
            return "redirect:/login";
        }
        Movie movie = movieService.getMovieById(movieId).orElse(null);
        if (movie == null) {
            return "redirect:/movies";
        }
        String userId = (String) session.getAttribute("userId");
        var editingBooking = bookingService.getEditablePendingBooking(userId, bookingId, movieId).orElse(null);
        if (bookingId != null && !bookingId.isBlank() && editingBooking == null) {
            return "redirect:/bookings";
        }
        String excludeBookingId = editingBooking != null ? editingBooking.getBookingId() : null;
        model.addAttribute("movie", movie);
        model.addAttribute("reviews", reviewService.getReviewsByMovie(movieId));
        model.addAttribute("bookedSeats", bookingService.getBookedSeatsByMovie(movieId, excludeBookingId));
        model.addAttribute("editingBooking", editingBooking);
        model.addAttribute("currentUserId", userId);
        return "movie-details";
    }
}
