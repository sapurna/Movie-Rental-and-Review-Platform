package com.movierental.repository;

import com.movierental.model.Movie;
import org.springframework.stereotype.Repository;

import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

@Repository
public class MovieRepository {
    private static final String FILE = "movies.txt";
    private final FileStorage fileStorage;

    public MovieRepository(FileStorage fileStorage) {
        this.fileStorage = fileStorage;
    }

    public List<Movie> findAll() {
        List<Movie> movies = new ArrayList<>();
        for (String row : fileStorage.readAll(FILE)) {
            if (row.isBlank()) {
                continue;
            }
            Movie movie = Movie.fromRecord(row);
            if (movie != null) {
                movies.add(movie);
            }
        }
        return movies;
    }

    public Optional<Movie> findById(String movieId) {
        return findAll().stream().filter(m -> m.getMovieId().equals(movieId)).findFirst();
    }

    public void saveAll(List<Movie> movies) {
        fileStorage.writeAll(FILE, movies.stream().map(Movie::toRecord).toList());
    }
}
