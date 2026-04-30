package com.movierental.repository;

import com.movierental.model.BookingRecord;
import org.springframework.stereotype.Repository;

import java.util.ArrayList;
import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

@Repository
public class BookingRepository {
    private static final String FILE = "bookings.txt";
    private final FileStorage fileStorage;

    public BookingRepository(FileStorage fileStorage) {
        this.fileStorage = fileStorage;
    }

    public List<BookingRecord> findAll() {
        List<BookingRecord> records = new ArrayList<>();
        for (String row : fileStorage.readAll(FILE)) {
            if (row.isBlank()) {
                continue;
            }
            BookingRecord record = BookingRecord.fromRecord(row);
            if (record != null) {
                records.add(record);
            }
        }
        return records;
    }

    public Optional<BookingRecord> findById(String bookingId) {
        return findAll().stream().filter(r -> r.getBookingId().equals(bookingId)).findFirst();
    }

    public void save(BookingRecord record) {
        List<BookingRecord> records = findAll();
        records.add(record);
        persist(records);
    }

    public void update(BookingRecord record) {
        List<BookingRecord> records = findAll().stream()
                .map(existing -> existing.getBookingId().equals(record.getBookingId()) ? record : existing)
                .collect(Collectors.toList());
        persist(records);
    }

    public void delete(String bookingId) {
        List<BookingRecord> records = findAll().stream()
                .filter(existing -> !existing.getBookingId().equals(bookingId))
                .collect(Collectors.toList());
        persist(records);
    }

    private void persist(List<BookingRecord> records) {
        fileStorage.writeAll(FILE, records.stream().map(BookingRecord::toRecord).toList());
    }
}
