# Domain Model — Full Class Diagram (Main Models)

**Project:** Cinevora — Movie Rental and Review Platform  
**Package:** `com.movierental.model`  
**Classes:** `User`, `Movie`, `Booking`, `NormalBooking`, `PremiumBooking`, `BookingRecord`, `Review`

This diagram covers **only** the seven core domain classes and every main relationship between them (inheritance, association, dependency, and many-to-many via `Review`).

---

## 1. UML relationship legend

| Notation | Relationship | Example in this project |
|----------|--------------|-------------------------|
| `△` solid line, empty triangle | **Generalization (inheritance)** | `NormalBooking` IS-A `Booking` |
| `──` solid line + multiplicity | **Association** | `User` places many `BookingRecord` rows (linked by `userId`) |
| `..>` dashed arrow | **Dependency (uses)** | `calculatePrice(Movie)` at booking time |
| `1` | Exactly one | Each `Review` belongs to one `User` and one `Movie` |
| `0..*` | Zero or more | A `User` may have zero or many bookings |
| `*` | Many (zero or more) | Many users review many movies |
| `*..*` | **Many-to-many** | `User` ↔ `Movie` through `Review` (association / link class) |

**Note:** Classes store foreign keys (`userId`, `movieId`) in text files, not JPA. Multiplicities describe the **business domain**, not database FK constraints.

---

## 2. Complete class diagram (all classes & relationships)

Paste into [Mermaid Live Editor](https://mermaid.live) to export PNG/SVG for your report.

```mermaid
classDiagram
    direction TB

    %% ===================== CLASSES (full attributes & main methods) =====================

    class User {
        <<entity>>
        +DEFAULT_PROFILE_IMAGE : String$
        -String userId
        -String fullName
        -String email
        -String password
        -String phone
        -String accountType
        -String profileImageUrl
        +User()
        +User(userId, fullName, email, password, phone, accountType)
        +toRecord() String
        +fromRecord(row)$ User
        +getDisplayProfileImageUrl() String
        +getUserId() String
        +setUserId(userId) void
        +getFullName() String
        +setFullName(fullName) void
        +getEmail() String
        +getPassword() String
        +getPhone() String
        +getAccountType() String
        +getProfileImageUrl() String
        +setProfileImageUrl(url) void
    }

    class Movie {
        <<entity>>
        -String movieId
        -String title
        -String genre
        -String duration
        -double normalPrice
        -double premiumPrice
        -String description
        -String imageUrl
        +Movie()
        +Movie(movieId, title, genre, duration, normalPrice, premiumPrice, description, imageUrl)
        +toRecord() String
        +fromRecord(row)$ Movie
        +getMovieId() String
        +getTitle() String
        +getGenre() String
        +getDuration() String
        +getNormalPrice() double
        +getPremiumPrice() double
        +getDescription() String
        +getImageUrl() String
    }

    class Booking {
        <<abstract>>
        #String bookingId
        #String userId
        #String movieId
        #String seatNumber
        #String seatType
        #String status
        #Booking(bookingId, userId, movieId, seatNumber, seatType, status)
        +calculatePrice(movie)* double
        +getBookingId() String
        +getUserId() String
        +getMovieId() String
        +getSeatNumber() String
        +setSeatNumber(seatNumber) void
        +getSeatType() String
        +getStatus() String
        +setStatus(status) void
    }

    class NormalBooking {
        <<entity>>
        +NormalBooking(bookingId, userId, movieId, seatNumber, status)
        +calculatePrice(movie) double
    }

    class PremiumBooking {
        <<entity>>
        +PremiumBooking(bookingId, userId, movieId, seatNumber, status)
        +calculatePrice(movie) double
    }

    class BookingRecord {
        <<persistence / DTO>>
        -String bookingId
        -String userId
        -String movieId
        -String seatNumber
        -String seatType
        -double price
        -String status
        +BookingRecord(bookingId, userId, movieId, seatNumber, seatType, price, status)
        +toRecord() String
        +fromRecord(row)$ BookingRecord
        +getBookingId() String
        +getUserId() String
        +getMovieId() String
        +getSeatNumber() String
        +setSeatNumber(seatNumber) void
        +getSeatType() String
        +setSeatType(seatType) void
        +getPrice() double
        +setPrice(price) void
        +getStatus() String
        +setStatus(status) void
    }

    class Review {
        <<association entity>>
        -String reviewId
        -String userId
        -String movieId
        -int rating
        -String comment
        +Review(reviewId, userId, movieId, rating, comment)
        +toRecord() String
        +fromRecord(row)$ Review
        +getReviewId() String
        +getUserId() String
        +getMovieId() String
        +getRating() int
        +getComment() String
    }

    %% ===================== INHERITANCE (Generalization) =====================

    Booking <|-- NormalBooking : extends
    Booking <|-- PremiumBooking : extends

    %% ===================== DEPENDENCY (uses at runtime) =====================

    Booking ..> Movie : «uses» calculatePrice()
    NormalBooking ..> Movie : normalPrice
    PremiumBooking ..> Movie : premiumPrice

    %% ===================== ASSOCIATIONS (1 : 0..*) by userId / movieId =====================

    User "1" --> "0..*" BookingRecord : places «userId»
    Movie "1" --> "0..*" BookingRecord : booked for «movieId»

    User "1" --> "0..*" Review : writes «userId»
    Movie "1" --> "0..*" Review : receives «movieId»

    %% Logical link on transient Booking (same IDs as BookingRecord)
    User "1" --> "0..*" Booking : creates «userId»
    Movie "1" --> "0..*" Booking : targets «movieId»

    %% ===================== BOOKING → BOOKINGRECORD (persist) =====================

    Booking ..> BookingRecord : «persisted as»\n(price + status stored)

    %% ===================== MANY-TO-MANY (via Review) =====================

    User "0..*" -- "0..*" Movie : reviews\n* — * via Review

    %% ===================== NOTES =====================

    note for Booking "Polymorphism:\nPREMIUM → PremiumBooking\nNORMAL → NormalBooking"
    note for BookingRecord "Stored in bookings.txt;\none row per seat booking"
    note for Review "Link class:\nresolves User *—* Movie"
```

---

## 3. Relationship summary table

| From | To | UML type | Multiplicity | How it is implemented |
|------|-----|----------|--------------|------------------------|
| **NormalBooking** | **Booking** | Generalization (inheritance) | IS-A | `extends Booking` |
| **PremiumBooking** | **Booking** | Generalization (inheritance) | IS-A | `extends Booking` |
| **Booking** | **Movie** | Dependency | uses | `calculatePrice(Movie movie)` |
| **User** | **BookingRecord** | Association | **1 : 0..*** | `BookingRecord.userId` |
| **Movie** | **BookingRecord** | Association | **1 : 0..*** | `BookingRecord.movieId` |
| **User** | **Review** | Association | **1 : 0..*** | `Review.userId` |
| **Movie** | **Review** | Association | **1 : 0..*** | `Review.movieId` |
| **User** | **Movie** | **Many-to-many** | ***** : ***** | Via **Review** (each review links one user to one movie; many reviews = M:N) |
| **User** | **Booking** | Association (transient) | **1 : 0..*** | `Booking.userId` during cart flow |
| **Movie** | **Booking** | Association (transient) | **1 : 0..*** | `Booking.movieId` during cart flow |
| **Booking** | **BookingRecord** | Dependency | 1 → 1 per save | `BookingService` builds `Booking`, then saves `BookingRecord` with computed `price` |

---

## 4. ASCII overview (quick reference)

```
                    ┌─────────────────┐
                    │  Booking        │◄──────┐
                    │  (abstract)     │       │ inheritance
                    └────────┬────────┘       │
                             │                │
              ┌──────────────┼──────────────┐ │
              │              │              │ │
     ┌────────▼────────┐    │    ┌─────────▼─────────┐
     │  NormalBooking   │    │    │  PremiumBooking   │
     │  seatType=NORMAL │    │    │  seatType=PREMIUM │
     └────────┬─────────┘    │    └─────────┬─────────┘
              │              │              │
              └──────────────┼──────────────┘
                             │ depends on
                             ▼
                    ┌─────────────────┐
                    │     Movie       │
                    └────────┬────────┘
                             │
         ┌───────────────────┼───────────────────┐
         │ 1                 │ 1                 │ 1
         │                   │                   │
         ▼ *                 ▼ *                 ▼ *
┌────────────────┐  ┌───────────────┐  ┌──────────────┐
│ BookingRecord  │  │    Review     │  │   (same)     │
│ (persisted)    │  │  (M:N link)   │  │              │
└───────┬────────┘  └───────┬───────┘  └──────────────┘
        │ *                 │ *
        │ 1                 │ 1
        ▼                   ▼
┌────────────────┐          │
│     User       │◄─────────┘  User *——* Movie (many-to-many via Review)
└────────────────┘
```

---

## 5. Main functions per model class

| Class | Main responsibility |
|-------|---------------------|
| **User** | Account identity, profile image URL, serialization to `users.txt` |
| **Movie** | Catalog item (title, genre, normal/premium seat prices, poster) |
| **Booking** | Abstract seat booking; defines pricing contract |
| **NormalBooking** | Normal seat price = `movie.getNormalPrice()` |
| **PremiumBooking** | Premium seat price = `movie.getPremiumPrice()` |
| **BookingRecord** | Persisted booking row (seat, type, computed price, PENDING/CONFIRMED) |
| **Review** | User rating and comment for a movie; implements User–Movie **many-to-many** |

---

## 6. Export for report / viva

1. Open [https://mermaid.live](https://mermaid.live).
2. Paste the Mermaid block from **Section 2**.
3. Export as **PNG** or **SVG**.
4. Cite relationship types from **Section 3** in your written explanation.

---

*Derived from `src/main/java/com/movierental/model/*.java` — Movie Rental and Review Platform.*
