# Cinevora — Movie Rental and Review Platform  
## Class Diagrams (SE1020)

Simple diagrams for your report. Paste any block into [Mermaid Live](https://mermaid.live) to export as PNG/SVG.

---

## 1. System layers (overview)

```mermaid
flowchart TB
    Browser --> JSP["JSP Pages"]
    JSP --> Controller["Controllers"]
    Controller --> Service["Services"]
    Service --> Repository["Repositories"]
    Repository --> FileStorage
    FileStorage --> TXT["users.txt, movies.txt,\nbookings.txt, reviews.txt"]
    Service --> Model["Domain Models"]
    ProfilePictureService --> Uploads["uploads/profiles/"]
```

---

## 2. Full class diagram (all classes)

Shows every class and main relationships. Methods are summarized to keep the chart readable.

```mermaid
classDiagram
    direction TB

    %% --- Entry ---
    class MovieRentalApplication {
        +main()
    }

    %% --- Controllers ---
    class AuthController {
        -authService
        -bookingService
        +login()
        +register()
        +profile()
        +uploadProfilePhoto()
        +changePassword()
        +logout()
    }

    class MovieController {
        -movieService
        -reviewService
        -bookingService
        +movies()
        +movieDetails()
    }

    class BookingController {
        -bookingService
        -movieService
        +addToCart()
        +viewBookings()
        +updateSeat()
        +updateSeatFromMap()
        +confirmBooking()
        +deleteBooking()
    }

    class ReviewController {
        -reviewService
        +addReview()
        +deleteOwnReview()
    }

    class WebMvcConfig {
        +addResourceHandlers()
    }

    %% --- Services ---
    class AuthService {
        <<interface>>
        +login()
        +register()
        +getUserById()
        +changePassword()
        +uploadProfilePicture()
    }

    class AuthServiceImpl {
        -userRepository
        -profilePictureService
    }

    class MovieService {
        -movieRepository
        +getAllMovies()
        +getMovieById()
    }

    class BookingService {
        -bookingRepository
        -movieService
        +getUserBookings()
        +getBookedSeatsByMovie()
        +addMultipleToCart()
        +updateBookingSeatFromSelection()
        +confirmBooking()
        +deleteBooking()
    }

    class ReviewService {
        -reviewRepository
        +getReviewsByMovie()
        +addReview()
        +deleteOwnReview()
    }

    class ProfilePictureService {
        +saveProfilePicture()
    }

    %% --- Repositories ---
    class FileStorage {
        +readAll()
        +writeAll()
    }

    class UserRepository {
        +findAll()
        +findByEmail()
        +findById()
        +save()
        +update()
    }

    class MovieRepository {
        +findAll()
        +findById()
        +saveAll()
    }

    class BookingRepository {
        +findAll()
        +findById()
        +save()
        +update()
        +delete()
    }

    class ReviewRepository {
        +findAll()
        +save()
        +delete()
    }

    %% --- Models ---
    class User {
        -userId
        -fullName
        -email
        -password
        -phone
        -profileImageUrl
        +toRecord()
        +fromRecord()
    }

    class Movie {
        -movieId
        -title
        -genre
        -normalPrice
        -premiumPrice
        +toRecord()
        +fromRecord()
    }

    class Review {
        -reviewId
        -userId
        -movieId
        -rating
        -comment
        +toRecord()
        +fromRecord()
    }

    class Booking {
        <<abstract>>
        #bookingId
        #seatNumber
        #seatType
        +calculatePrice()*
    }

    class NormalBooking {
        +calculatePrice()
    }

    class PremiumBooking {
        +calculatePrice()
    }

    class BookingRecord {
        -bookingId
        -userId
        -movieId
        -seatNumber
        -price
        -status
        +toRecord()
        +fromRecord()
    }

    %% --- Inheritance & interfaces ---
    AuthServiceImpl ..|> AuthService
    NormalBooking --|> Booking
    PremiumBooking --|> Booking
    Booking ..> Movie : uses for price

    %% --- Controller uses Service ---
    AuthController --> AuthService
    AuthController --> BookingService
    MovieController --> MovieService
    MovieController --> ReviewService
    MovieController --> BookingService
    BookingController --> BookingService
    BookingController --> MovieService
    ReviewController --> ReviewService

    %% --- Service uses Repository ---
    AuthServiceImpl --> UserRepository
    AuthServiceImpl --> ProfilePictureService
    MovieService --> MovieRepository
    BookingService --> BookingRepository
    BookingService --> MovieService
    ReviewService --> ReviewRepository

    %% --- Repository uses FileStorage ---
    UserRepository --> FileStorage
    MovieRepository --> FileStorage
    BookingRepository --> FileStorage
    ReviewRepository --> FileStorage

    %% --- Repository maps to Model ---
    UserRepository ..> User
    MovieRepository ..> Movie
    BookingRepository ..> BookingRecord
    ReviewRepository ..> Review

    %% --- Domain links (by ID in files) ---
    User "1" --> "*" BookingRecord
    User "1" --> "*" Review
    Movie "1" --> "*" BookingRecord
    Movie "1" --> "*" Review
```

---

## 3. OOP diagram (inheritance & polymorphism)

Required for SE1020 — shows **encapsulation** (private fields), **inheritance**, and **polymorphism**.

```mermaid
classDiagram
    class Movie {
        -normalPrice
        -premiumPrice
    }

    class Booking {
        <<abstract>>
        +calculatePrice(movie)*
    }

    class NormalBooking {
        +calculatePrice(movie)
    }

    class PremiumBooking {
        +calculatePrice(movie)
    }

    NormalBooking --|> Booking
    PremiumBooking --|> Booking
    Booking ..> Movie

    note for Booking "BookingService creates\nNormalBooking or PremiumBooking,\nthen calls calculatePrice(movie)\nto get seat price"
```

---

## 4. Data files

| File | What it stores |
|------|----------------|
| `users.txt` | Registered users |
| `movies.txt` | Movie catalogue |
| `bookings.txt` | Seat bookings |
| `reviews.txt` | Movie reviews |
| `uploads/profiles/` | Profile photos (images) |

All text files use **pipe-separated** values (`|`). Example booking row:  
`bookingId|userId|movieId|seatNumber|seatType|price|status`

---

## 5. Class list (23 classes)

| Package | Class | Role |
|---------|-------|------|
| root | `MovieRentalApplication` | Starts the app |
| `config` | `WebMvcConfig` | Serves profile images |
| `controller` | `AuthController` | Login, register, profile |
| `controller` | `MovieController` | Movie list & details |
| `controller` | `BookingController` | Bookings CRUD |
| `controller` | `ReviewController` | Reviews |
| `service` | `AuthService` | Auth interface |
| `service` | `AuthServiceImpl` | Auth logic |
| `service` | `MovieService` | Movie logic |
| `service` | `BookingService` | Booking logic |
| `service` | `ReviewService` | Review logic |
| `service` | `ProfilePictureService` | Upload profile photo |
| `repository` | `FileStorage` | Read/write files |
| `repository` | `UserRepository` | User data |
| `repository` | `MovieRepository` | Movie data |
| `repository` | `BookingRepository` | Booking data |
| `repository` | `ReviewRepository` | Review data |
| `model` | `User` | User entity |
| `model` | `Movie` | Movie entity |
| `model` | `Review` | Review entity |
| `model` | `Booking` | Abstract booking |
| `model` | `NormalBooking` | Normal seat price |
| `model` | `PremiumBooking` | Premium seat price |
| `model` | `BookingRecord` | Saved booking row |

---

*Cinevora — SE1020 Movie Rental and Review Platform*
