package com.movierental.service;

import com.movierental.model.Movie;
import com.movierental.repository.MovieRepository;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.Arrays;
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

    /**
     * Category chips on the movies page (order matches UI). "Trending" shows all movies.
     */
    private static final List<String> GENRE_FILTER_OPTIONS = Arrays.asList(
            "Trending",
            "Action",
            "Romantic",
            "Comedy",
            "Adventure",
            "Biography",
            "Crime",
            "Drama",
            "Family",
            "Fantasy",
            "Historical",
            "Musical",
            "Mystery",
            "Sci-Fi",
            "Thriller");

    public List<String> getGenreFilterOptions() {
        return GENRE_FILTER_OPTIONS;
    }

    public List<Movie> getAllMovies(String query, String type) {
        List<Movie> movies = movieRepository.findAll();
        String t = type == null ? "" : type.trim();
        if (!t.isEmpty() && !t.equalsIgnoreCase("Trending")) {
            movies = movies.stream()
                    .filter(movie -> movie.getGenre() != null
                            && movie.getGenre().equalsIgnoreCase(t))
                    .toList();
        }
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
        movies.add(new Movie(UUID.randomUUID().toString(), "The Grand Budapest Hotel", "Comedy", "99 min", 900, 1400, "A quirky concierge and lobby boy embroiled in a theft.", "https://images.unsplash.com/photo-1536440136628-849c177e76a1?w=600"));
        movies.add(new Movie(UUID.randomUUID().toString(), "The Godfather", "Crime", "175 min", 1000, 1500, "The saga of the Corleone family.", "https://images.unsplash.com/photo-1489599849927-2ee91cede3ba?w=600"));
        movies.add(new Movie(UUID.randomUUID().toString(), "Parasite", "Drama", "132 min", 950, 1450, "Class divide erupts in unexpected ways.", "https://images.unsplash.com/photo-1517602302552-471fe67acf66?w=600"));
        movies.add(new Movie(UUID.randomUUID().toString(), "The Lord of the Rings", "Fantasy", "178 min", 1250, 1850, "An epic quest to destroy a powerful ring.", "https://images.unsplash.com/photo-1536440136628-849c177e76a1?w=600"));
        movies.add(new Movie(UUID.randomUUID().toString(), "Hereditary", "Horror", "127 min", 1050, 1550, "A family unravels after tragedy.", "https://images.unsplash.com/photo-1509248961158-e54f6934749c?w=600"));
        movieRepository.saveAll(movies);
    }
}
