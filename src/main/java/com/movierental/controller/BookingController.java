package com.movierental.controller;

import com.movierental.service.BookingService;
import com.movierental.service.MovieService;
import jakarta.servlet.http.HttpSession;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

@Controller
public class BookingController {
    private final BookingService bookingService;
    private final MovieService movieService;

    public BookingController(BookingService bookingService, MovieService movieService) {
        this.bookingService = bookingService;
        this.movieService = movieService;
    }

    @PostMapping("/bookings/add")
    public String addToCart(
            @RequestParam String movieId,
            @RequestParam(name = "seatSelections", required = false) java.util.List<String> seatSelections,
            HttpSession session,
            RedirectAttributes redirectAttributes
    ) {
        String userId = (String) session.getAttribute("userId");
        if (userId == null) {
            return "redirect:/login";
        }
        redirectAttributes.addFlashAttribute("message", bookingService.addMultipleToCart(userId, movieId, seatSelections));
        return "redirect:/movies/" + movieId;
    }

    @GetMapping("/bookings")
    public String viewBookings(HttpSession session, Model model) {
        String userId = (String) session.getAttribute("userId");
        if (userId == null) {
            return "redirect:/login";
        }
        model.addAttribute("bookings", bookingService.getUserBookings(userId));
        model.addAttribute("movies", movieService.getAllMovies("", null));
        return "bookings";
    }

    @PostMapping("/bookings/update")
    public String updateSeat(@RequestParam String bookingId, @RequestParam String seatNumber, HttpSession session, RedirectAttributes redirectAttributes) {
        String userId = (String) session.getAttribute("userId");
        if (userId == null) {
            return "redirect:/login";
        }
        redirectAttributes.addFlashAttribute("message", bookingService.updateSeat(userId, bookingId, seatNumber));
        return "redirect:/bookings";
    }

    @PostMapping("/bookings/update-seat")
    public String updateSeatFromMap(
            @RequestParam String bookingId,
            @RequestParam String movieId,
            @RequestParam(name = "seatSelections", required = false) java.util.List<String> seatSelections,
            HttpSession session,
            RedirectAttributes redirectAttributes) {
        String userId = (String) session.getAttribute("userId");
        if (userId == null) {
            return "redirect:/login";
        }
        redirectAttributes.addFlashAttribute("message",
                bookingService.updateBookingSeatFromSelection(userId, bookingId, seatSelections));
        return "redirect:/bookings";
    }

    @PostMapping("/bookings/delete")
    public String deleteBooking(@RequestParam String bookingId, HttpSession session, RedirectAttributes redirectAttributes) {
        String userId = (String) session.getAttribute("userId");
        if (userId == null) {
            return "redirect:/login";
        }
        redirectAttributes.addFlashAttribute("message", bookingService.deleteBooking(userId, bookingId));
        return "redirect:/bookings";
    }

    @PostMapping("/bookings/confirm")
    public String confirmBooking(@RequestParam String bookingId, HttpSession session, RedirectAttributes redirectAttributes) {
        String userId = (String) session.getAttribute("userId");
        if (userId == null) {
            return "redirect:/login";
        }
        redirectAttributes.addFlashAttribute("message", bookingService.confirmBooking(userId, bookingId));
        return "redirect:/bookings";
    }
}
