# Movie Rental and Review Platform — Full Class Diagram

**Project:** Cinevora (Spring Boot 3.3 · JSP · File-based persistence)  
**Scope:** All application classes and **main** operations for authentication, movies, seat booking, and reviews.

---

## 1. UML Legend (Relationships)

| Symbol / Notation | Meaning | Used in this project |
|-------------------|---------|----------------------|
| `△` (empty triangle) | **Generalization / Inheritance** | `NormalBooking`, `PremiumBooking` extend `Booking` |
| `△` (dashed) | **Interface realization** | `AuthServiceImpl` implements `AuthService` |
| `──>` solid arrow | **Association / uses** | Controller → Service, Service → Repository |
| `..>` dashed arrow | **Dependency** | `Booking.calculatePrice(Movie)`, `FileStorage` I/O |
| `1` | Exactly one | One `User` per booking row (by `userId`) |
| `0..1` | Zero or one | Optional `Movie` lookup when booking |
| `1..*` / `*` | One-to-many / many | User has many bookings and reviews |
| `*..*` | **Many-to-many** | Users ↔ Movies via `Review` (association entity) |

**Persistence note:** `BookingRecord`, `Review`, `User`, and `Movie` are linked by **ID fields** (`userId`, `movieId`) in flat files—not JPA entities. Multiplicities describe the **domain model**, not database foreign keys.

---

## 2. Complete Class Diagram (All Classes & Main Relationships)

Copy the diagram below into [Mermaid Live Editor](https://mermaid.live) or any Markdown viewer that supports Mermaid for export to PNG/SVG.

```mermaid
classDiagram
    direction TB

    %% ========== DOMAIN MODEL ==========
    class User {
        -String userId
        -String fullName
        -String email
        -String password
        -String phone
        -String accountType
        -String profileImageUrl
        +getDisplayProfileImageUrl() String
        +toRecord() String
        +fromRecord(row) User$
    }

    class Movie {
        -String movieId
        -String title
        -String genre
        -String duration
        -double normalPrice
        -double premiumPrice
        -String description
        -String imageUrl
        +toRecord() String
        +fromRecord(row) Movie$
    }

    class Booking {
        <<abstract>>
        #String bookingId
        #String userId
        #String movieId
        #String seatNumber
        #String seatType
        #String status
        +calculatePrice(movie) double*
        +getBookingId() String
        +getSeatType() String
    }

    class NormalBooking {
        +calculatePrice(movie) double
    }

    class PremiumBooking {
        +calculatePrice(movie) double
    }

    class BookingRecord {
        -String bookingId
        -String userId
        -String movieId
        -String seatNumber
        -String seatType
        -double price
        -String status
        +toRecord() String
        +fromRecord(row) BookingRecord$
        +setSeatNumber(seat) void
        +setStatus(status) void
    }

    class Review {
        -String reviewId
        -String userId
        -String movieId
        -int rating
        -String comment
        +toRecord() String
        +fromRecord(row) Review$
    }

    %% Inheritance (polymorphism for pricing)
    Booking <|-- NormalBooking : extends
    Booking <|-- PremiumBooking : extends

    %% Domain associations (by ID)
    User "1" --> "0..*" BookingRecord : places
    Movie "1" --> "0..*" BookingRecord : booked for
    User "1" --> "0..*" Review : writes
    Movie "1" --> "0..*" Review : receives

    Booking ..> Movie : calculatePrice()
  BookingRecord ..> User : userId
  BookingRecord ..> Movie : movieId
  Review ..> User : userId
  Review ..> Movie : movieId

    %% ========== SERVICE LAYER ==========
    class AuthService {
        <<interface>>
        +login(email, password) Optional~User~
        +register(...) String
        +getUserById(userId) Optional~User~
        +changePassword(...) String
        +uploadProfilePicture(userId, photo) String
    }

    class AuthServiceImpl {
        -UserRepository userRepository
        -ProfilePictureService profilePictureService
        +login(...)
        +register(...)
        +changePassword(...)
        +uploadProfilePicture(...)
    }

    class ProfilePictureService {
        +saveProfilePicture(userId, file) String
    }

    class MovieService {
        -MovieRepository movieRepository
        +getAllMovies(query, type) List~Movie~
        +getMovieById(movieId) Optional~Movie~
        +getGenreFilterOptions() List~String~
        -seedMoviesIfEmpty() void
    }

    class BookingService {
        -BookingRepository bookingRepository
        -MovieService movieService
        +getUserBookings(userId) List~BookingRecord~
        +getBookedSeatsByMovie(movieId) Set~String~
        +addMultipleToCart(...) String
        +updateSeat(...) String
        +confirmBooking(...) String
        +deleteBooking(...) String
    }

    class ReviewService {
        -ReviewRepository reviewRepository
        +getReviewsByMovie(movieId) List~Review~
        +addReview(...) String
        +deleteOwnReview(...) String
    }

    AuthService <|.. AuthServiceImpl : implements
    AuthServiceImpl --> UserRepository : uses
    AuthServiceImpl --> ProfilePictureService : uses
    MovieService --> MovieRepository : uses
    BookingService --> BookingRepository : uses
    BookingService --> MovieService : uses
    BookingService ..> Booking : creates
    BookingService ..> NormalBooking : creates
    BookingService ..> PremiumBooking : creates
    BookingService ..> BookingRecord : persists
    ReviewService --> ReviewRepository : uses

    %% ========== REPOSITORY LAYER ==========
    class FileStorage {
        +readAll(fileName) List~String~
        +writeAll(fileName, rows) void
    }

    class UserRepository {
        -FileStorage fileStorage
        +findAll() List~User~
        +findByEmail(email) Optional~User~
        +findById(userId) Optional~User~
        +save(user) void
        +update(user) void
    }

    class MovieRepository {
        -FileStorage fileStorage
        +findAll() List~Movie~
        +findById(movieId) Optional~Movie~
        +saveAll(movies) void
    }

    class BookingRepository {
        -FileStorage fileStorage
        +findAll() List~BookingRecord~
        +findById(bookingId) Optional~BookingRecord~
        +save(record) void
        +update(record) void
        +delete(bookingId) void
    }

    class ReviewRepository {
        -FileStorage fileStorage
        +findAll() List~Review~
        +save(review) void
        +delete(reviewId) void
    }

    UserRepository --> FileStorage : users.txt
    MovieRepository --> FileStorage : movies.txt
    BookingRepository --> FileStorage : bookings.txt
    ReviewRepository --> FileStorage : reviews.txt

    UserRepository ..> User : maps
    MovieRepository ..> Movie : maps
    BookingRepository ..> BookingRecord : maps
    ReviewRepository ..> Review : maps

    %% ========== CONTROLLER LAYER ==========
    class AuthController {
        -AuthService authService
        -BookingService bookingService
        +login() String
        +register() String
        +profile() String
        +uploadProfilePhoto() String
        +changePassword() String
        +logout() String
    }

    class MovieController {
        -MovieService movieService
        -ReviewService reviewService
        -BookingService bookingService
        +movies() String
        +movieDetails(movieId) String
    }

    class BookingController {
        -BookingService bookingService
        -MovieService movieService
        +addToCart() String
        +viewBookings() String
        +updateSeat() String
        +confirmBooking() String
        +deleteBooking() String
    }

    class ReviewController {
        -ReviewService reviewService
        +addReview() String
        +deleteOwnReview() String
    }

    class WebMvcConfig {
        <<configuration>>
        +addResourceHandlers(registry) void
    }

    class MovieRentalApplication {
        <<SpringBootApplication>>
        +main(args) void$
    }

    AuthController --> AuthService : depends
    AuthController --> BookingService : depends
    MovieController --> MovieService : depends
    MovieController --> ReviewService : depends
    MovieController --> BookingService : depends
    BookingController --> BookingService : depends
    BookingController --> MovieService : depends
    ReviewController --> ReviewService : depends

    %% Controllers use domain via services (indirect)
    AuthController ..> User : session/profile
    MovieController ..> Movie : view
    MovieController ..> Review : view
    BookingController ..> BookingRecord : view
```

---

## 3. Domain Model Only (7 Main Classes — Full Diagram)

**See also:** [`MODEL_CLASS_DIAGRAM.md`](MODEL_CLASS_DIAGRAM.md) — complete attributes, methods, inheritance, **1 : 0..***, **\* : \***, and dependency chart for:

`User` · `Movie` · `Booking` · `NormalBooking` · `PremiumBooking` · `BookingRecord` · `Review`

**Cardinality summary**

| Relationship | Type | Multiplicity |
|--------------|------|--------------|
| User → BookingRecord | Association | **1 : 0..*** |
| Movie → BookingRecord | Association | **1 : 0..*** |
| User → Review | Association | **1 : 0..*** |
| Movie → Review | Association | **1 : 0..*** |
| User ↔ Movie | **Many-to-many** | ***** : ***** (via `Review`) |
| NormalBooking / PremiumBooking → Booking | **Inheritance** | IS-A |
| Booking → Movie | Dependency | `calculatePrice(Movie)` |
| Booking → BookingRecord | Dependency | persisted after pricing |

---

## 4. Layered Architecture (Main Functions by Module)

```mermaid
flowchart TB
    subgraph Presentation["Presentation Layer (Controllers)"]
        AC[AuthController<br/>login · register · profile · password · photo]
        MC[MovieController<br/>browse · movie details]
        BC[BookingController<br/>add cart · list · update · confirm · delete]
        RC[ReviewController<br/>add · delete review]
    end

    subgraph Business["Business Layer (Services)"]
        AS[AuthService / AuthServiceImpl]
        MS[MovieService]
        BS[BookingService]
        RS[ReviewService]
        PS[ProfilePictureService]
    end

    subgraph Data["Data Access Layer (Repositories)"]
        UR[UserRepository]
        MR[MovieRepository]
        BR[BookingRepository]
        RR[ReviewRepository]
        FS[FileStorage]
    end

    subgraph Domain["Domain Model"]
        U[User]
        M[Movie]
        BRc[BookingRecord]
        Rv[Review]
        B[Booking hierarchy]
    end

    subgraph Files["Flat Files"]
        F1[(users.txt)]
        F2[(movies.txt)]
        F3[(bookings.txt)]
        F4[(reviews.txt)]
        F5[(uploads/profiles/)]
    end

    AC --> AS
    AC --> BS
    MC --> MS
    MC --> RS
    MC --> BS
    BC --> BS
    BC --> MS
    RC --> RS

    AS --> UR
    AS --> PS
    MS --> MR
    BS --> BR
    BS --> B
    RS --> RR

    UR --> FS
    MR --> FS
    BR --> FS
    RR --> FS

    FS --> F1
    FS --> F2
    FS --> F3
    FS --> F4
    PS --> F5

    UR -.-> U
    MR -.-> M
    BR -.-> BRc
    RR -.-> Rv
```

---

## 5. Main Functions per Class (Quick Reference)

### 5.1 Authentication & profile

| Class | Main functions |
|-------|----------------|
| **AuthController** | `login`, `register`, `profile`, `uploadProfilePhoto`, `changePassword`, `logout` |
| **AuthService** | `login`, `register`, `getUserById`, `changePassword`, `uploadProfilePicture` |
| **AuthServiceImpl** | Implements auth; delegates photo save to **ProfilePictureService** |
| **ProfilePictureService** | `saveProfilePicture` → writes `uploads/profiles/{userId}.ext` |
| **UserRepository** | `findByEmail`, `findById`, `save`, `update` |
| **User** | Registration data, profile image URL, `toRecord` / `fromRecord` |

### 5.2 Movies & browsing

| Class | Main functions |
|-------|----------------|
| **MovieController** | `movies` (search + genre filter), `movieDetails` (seats + reviews) |
| **MovieService** | `getAllMovies`, `getMovieById`, `getGenreFilterOptions`, seed data |
| **MovieRepository** | `findAll`, `findById`, `saveAll` |
| **Movie** | Catalog entity (title, genre, prices, poster) |

### 5.3 Booking (seat rental)

| Class | Main functions |
|-------|----------------|
| **BookingController** | `addToCart`, `viewBookings`, `updateSeat`, `confirmBooking`, `deleteBooking` |
| **BookingService** | Cart CRUD, seat conflict checks, price via **Booking** polymorphism |
| **Booking** *(abstract)* | `calculatePrice(Movie)` — strategy pattern |
| **NormalBooking** | Price = `movie.normalPrice` |
| **PremiumBooking** | Price = `movie.premiumPrice` |
| **BookingRecord** | Persisted booking row (PENDING / CONFIRMED) |
| **BookingRepository** | `save`, `update`, `delete`, `findById` |

### 5.4 Reviews

| Class | Main functions |
|-------|----------------|
| **ReviewController** | `addReview`, `deleteOwnReview` |
| **ReviewService** | `getReviewsByMovie`, `addReview`, `deleteOwnReview` |
| **ReviewRepository** | `findAll`, `save`, `delete` |
| **Review** | Links `userId` + `movieId` + rating + comment |

### 5.5 Infrastructure

| Class | Role |
|-------|------|
| **FileStorage** | Read/write pipe-delimited lines under `src/main/resources/data/` |
| **WebMvcConfig** | Serves `/posters/profiles/**` from disk |
| **MovieRentalApplication** | Spring Boot entry point |

---

## 6. Design Patterns Used

| Pattern | Where | Purpose |
|---------|--------|---------|
| **MVC** | Controllers → Services → JSP views | Separation of concerns |
| **Repository** | `*Repository` + `FileStorage` | Hide file persistence |
| **Strategy / Polymorphism** | `NormalBooking` / `PremiumBooking` | Different seat pricing |
| **DTO / persistence model** | `Booking` (logic) vs `BookingRecord` (storage) | Calculate in memory, store flat record |
| **Dependency injection** | Spring `@Service`, `@Repository`, constructors | Loose coupling |
| **Association entity** | `Review` | Many users review many movies |

---

## 7. Class Inventory (24 classes)

| Package | Classes |
|---------|---------|
| `com.movierental` | `MovieRentalApplication` |
| `com.movierental.config` | `WebMvcConfig` |
| `com.movierental.controller` | `AuthController`, `MovieController`, `BookingController`, `ReviewController` |
| `com.movierental.service` | `AuthService`, `AuthServiceImpl`, `MovieService`, `BookingService`, `ReviewService`, `ProfilePictureService` |
| `com.movierental.repository` | `FileStorage`, `UserRepository`, `MovieRepository`, `BookingRepository`, `ReviewRepository` |
| `com.movierental.model` | `User`, `Movie`, `Booking`, `NormalBooking`, `PremiumBooking`, `BookingRecord`, `Review` |

---

## 8. Exporting for Your Report

1. Open [https://mermaid.live](https://mermaid.live).
2. Paste **Section 2** (full application) or **`MODEL_CLASS_DIAGRAM.md` Section 2** (domain models only).
3. Export as **PNG** or **SVG** for Word/PDF.
4. For PlantUML tools, use the same structure: packages `model`, `service`, `repository`, `controller` with the relationships above.

---

*Generated from source code in `src/main/java/com/movierental/` — Movie Rental and Review Platform (Cinevora).*
