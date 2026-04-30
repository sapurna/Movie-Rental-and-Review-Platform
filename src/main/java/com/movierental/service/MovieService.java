package com.movierental.service;

import com.movierental.model.Movie;
import com.movierental.repository.MovieRepository;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.List;
import java.util.Locale;
import java.util.Optional;
import java.util.UUID;

@Service
public class MovieService {
    private final MovieRepository movieRepository;

    public MovieService(MovieRepository movieRepository) {
        this.movieRepository = movieRepository;
        seedMoviesIfEmpty();
    }

    public List<Movie> getAllMovies(String query) {
        List<Movie> movies = movieRepository.findAll();
        if (query == null || query.isBlank()) {
            return movies;
        }
        String lower = query.toLowerCase(Locale.ROOT);
        return movies.stream()
                .filter(movie -> movie.getTitle().toLowerCase(Locale.ROOT).contains(lower)
                        || movie.getGenre().toLowerCase(Locale.ROOT).contains(lower))
                .toList();
    }

    public Optional<Movie> getMovieById(String movieId) {
        return movieRepository.findById(movieId);
    }

    private void seedMoviesIfEmpty() {
        List<Movie> existing = movieRepository.findAll();
        if (!existing.isEmpty()) {
            return;
        }
        List<Movie> movies = new ArrayList<>();
        movies.add(new Movie(UUID.randomUUID().toString(), "Inception", "Sci-Fi", "148 min", 1200, 1800, "A dream-heist thriller with layered storytelling.", "https://images.unsplash.com/photo-1489599849927-2ee91cede3ba?w=600"));
        movies.add(new Movie(UUID.randomUUID().toString(), "Interstellar", "Adventure", "169 min", 1300, 1900, "A journey across space and time to save humanity.", "https://images.unsplash.com/photo-1536440136628-849c177e76a1?w=600"));
        movies.add(new Movie(UUID.randomUUID().toString(), "The Dark Knight", "Action", "152 min", 1100, 1700, "Batman faces chaos in Gotham City.", "https://images.unsplash.com/photo-1517602302552-471fe67acf66?w=600"));
        movieRepository.saveAll(movies);
    }
}
