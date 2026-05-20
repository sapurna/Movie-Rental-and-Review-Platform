# SE1020 – Object Oriented Programming  
# Final Project Report

## Movie Rental and Review Platform (Cinevora)

---

| Field | Details |
|-------|---------|
| **Student Name** | *[Your full name]* |
| **Student ID** | IT22197832 |
| **Module** | SE1020 – Object Oriented Programming |
| **Project Title** | Movie Rental and Review Platform (Cinevora) |
| **Submission Date** | *[Date]* |
| **GitHub Repository** | *[Paste your repository URL here]* |
| **Development Tool** | IntelliJ IDEA |
| **Technologies** | Java 17, Spring Boot 3.3.4, JSP, Bootstrap 5, Maven |

---

## Table of Contents

1. [Introduction](#1-introduction)  
2. [Project Objectives](#2-project-objectives)  
3. [System Overview](#3-system-overview)  
4. [System Architecture](#4-system-architecture)  
5. [Class Diagrams](#5-class-diagrams)  
6. [Object-Oriented Programming Implementation](#6-object-oriented-programming-implementation)  
7. [File Handling and Data Storage](#7-file-handling-and-data-storage)  
8. [CRUD Operations](#8-crud-operations)  
9. [Features and User Workflows](#9-features-and-user-workflows)  
10. [User Interface](#10-user-interface)  
11. [Backend Endpoints](#11-backend-endpoints)  
12. [Project Structure](#12-project-structure)  
13. [How to Run the Application](#13-how-to-run-the-application)  
14. [Testing and Sample Data](#14-testing-and-sample-data)  
15. [Challenges and Solutions](#15-challenges-and-solutions)  
16. [Individual Contribution](#16-individual-contribution)  
17. [Git Repository and Version Control](#17-git-repository-and-version-control)  
18. [Conclusion](#18-conclusion)  
19. [References](#19-references)  
20. [Appendices](#20-appendices)

---

## 1. Introduction

This report documents the design, implementation, and testing of **Cinevora**, a web-based **Movie Rental and Review Platform** developed as the SE1020 individual project. The system allows registered users to browse a catalogue of movies, select cinema seats on an interactive seat map, manage their bookings, write reviews, and maintain a personal profile including a profile photograph.

The application is built using **Java** and **Spring Boot** with **JSP** views for the presentation layer. All persistent data is stored using **file read/write operations** (plain text files) instead of a relational database, as required by the assignment specification. The user interface uses **HTML**, **CSS**, and **Bootstrap 5** for a clean, responsive layout.

Class diagrams for this project are provided separately in **`docs/CLASS_DIAGRAM.md`**. This report focuses on written documentation, implementation details, and evidence of version control.

---

## 2. Project Objectives

The assignment required the following objectives to be met:

| Objective | How it was achieved |
|-----------|---------------------|
| Apply OOP (encapsulation, inheritance, polymorphism) | Domain models with private fields; abstract `Booking` class; `NormalBooking` and `PremiumBooking` with overridden `calculatePrice()` |
| Implement minimum 3 CRUD operations using file handling | Users (Create, Read, Update), Bookings (full CRUD), Reviews (Create, Read, Delete) |
| Build a user-friendly web interface | Six JSP pages with Bootstrap styling |
| Use Java web technologies in IntelliJ IDEA | Maven Spring Boot project developed in IntelliJ |
| Use file storage instead of database | `FileStorage` class reads/writes pipe-separated records in `src/main/resources/data/` |
| Version control with GitHub | Repository with commit history (screenshots in Section 17) |

---

## 3. System Overview

Cinevora is a cinema-style booking platform. After registration and login, a customer can:

- Search and filter movies by genre/type  
- Open a movie details page with description, pricing, reviews, and a **seat layout**  
- Select **Normal** or **Premium** seats and add them to **My Bookings**  
- **Confirm**, **delete**, or **update** a pending booking (re-select seat on the movie page)  
- Post and delete their own **reviews**  
- Update **profile photo** and **password** on the profile page  

The system does not use MySQL or any SQL database. All core entities are stored in `.txt` files. Profile images are stored as files under `uploads/profiles/` with the URL path saved in `users.txt`.

---

## 4. System Architecture

The application follows a **layered architecture** that separates concerns and supports maintainability:

| Layer | Responsibility | Main components |
|-------|----------------|-----------------|
| **Presentation** | Pages shown to the user | JSP files (`login.jsp`, `movies.jsp`, `movie-details.jsp`, `bookings.jsp`, `profile.jsp`, `register.jsp`) |
| **Controller** | HTTP requests, redirects, session | `AuthController`, `MovieController`, `BookingController`, `ReviewController` |
| **Service** | Business rules and validation | `AuthServiceImpl`, `MovieService`, `BookingService`, `ReviewService`, `ProfilePictureService` |
| **Repository** | Load and save entities to files | `UserRepository`, `MovieRepository`, `BookingRepository`, `ReviewRepository` |
| **Persistence utility** | Low-level file I/O | `FileStorage` |
| **Domain model** | Data structures | `User`, `Movie`, `Review`, `Booking`, `BookingRecord`, etc. |

**Request flow example (add booking):**  
Browser → `BookingController.addToCart()` → `BookingService.addMultipleToCart()` → creates `NormalBooking` or `PremiumBooking` → calculates price → `BookingRepository.save()` → `FileStorage.writeAll()` → `bookings.txt`.

**Configuration:** `WebMvcConfig` maps the URL path `/posters/profiles/**` to the folder `uploads/profiles/` so uploaded profile photos can be displayed in the browser.

*[Insert Figure 1: System layer diagram — export from `docs/CLASS_DIAGRAM.md` Section 1]*

---

## 5. Class Diagrams

The complete class diagrams are maintained in **`docs/CLASS_DIAGRAM.md`**. Include the following figures in your printed/PDF report:

| Figure | Content | Source |
|--------|---------|--------|
| Figure 1 | System layers (flowchart) | CLASS_DIAGRAM.md §1 |
| Figure 2 | Full class diagram (all 23 Java classes) | CLASS_DIAGRAM.md §2 |
| Figure 3 | OOP diagram (Booking inheritance) | CLASS_DIAGRAM.md §3 |

**Summary:** The project contains **23 Java classes** organised into packages `controller`, `service`, `repository`, `model`, and `config`, plus `MovieRentalApplication` as the entry point.

---

## 6. Object-Oriented Programming Implementation

### 6.1 Encapsulation

Encapsulation is applied in all main entity classes (`User`, `Movie`, `Review`, `BookingRecord`, and others) by declaring attributes as **private** and providing **public getters and setters** so other layers cannot change data directly. For file storage, classes also use **`toRecord()`** and **`fromRecord()`** to convert objects to and from a single text line. In the `User` class, fields such as `userId`, `email`, and `password` are hidden inside the class; controllers and services use methods to read or update values. This keeps data safe, makes the code easier to maintain, and allows validation rules to be added in one place later.

### 6.2 Inheritance

Inheritance is used in the booking module through an **abstract class `Booking`**, which defines common properties (`bookingId`, `userId`, `movieId`, `seatNumber`, `seatType`, `status`) and a shared constructor. **`NormalBooking`** and **`PremiumBooking`** extend `Booking` and call **`super(...)`** to initialise these fields. The child classes only add behaviour specific to seat type (NORMAL or PREMIUM). This avoids duplicating the same code in two places and follows the “is-a” relationship: a normal booking *is a* booking, and a premium booking *is a* booking.

### 6.3 Polymorphism

Polymorphism appears in the abstract method **`calculatePrice(Movie movie)`** in `Booking`. `NormalBooking` overrides it to return **`movie.getNormalPrice()`**, while `PremiumBooking` overrides it to return **`movie.getPremiumPrice()`**. In `BookingService`, when the user picks a seat, the service creates the correct subclass based on seat type and calls **`booking.calculatePrice(movie)`** on a `Booking` reference. The correct price is chosen at **runtime** without separate if-else blocks for each type. This is the main OOP benefit used when saving booking price to `bookings.txt`.

### 6.4 Abstraction

Abstraction is implemented using the **`AuthService` interface**, which lists authentication operations (`login`, `register`, `getUserById`, `changePassword`, `uploadProfilePicture`) without showing how they work inside. **`AuthServiceImpl`** provides the real logic using `UserRepository` and `ProfilePictureService`. `AuthController` depends on **`AuthService`**, not the implementation class, so the controller only knows *what* operations exist, not *how* they are coded. This separates interface from implementation and makes the design clearer for testing and future changes.

---

## 7. File Handling and Data Storage

### 7.1 FileStorage class

The `FileStorage` class (`com.movierental.repository.FileStorage`) is the single point for all text-file input and output. It reads and writes data under `src/main/resources/data/` using `readAll(fileName)` to load every line of a file and `writeAll(fileName, rows)` to save the full file again. If a file or folder does not exist, it is created automatically. Repository classes (`UserRepository`, `MovieRepository`, and others) use `FileStorage` instead of opening files themselves, which keeps path handling and errors in one place and matches the assignment requirement to use file read/write instead of a database.

### 7.2 Data files

All main application data is stored as plain text under `src/main/resources/data/`: `users.txt` holds registered accounts, `movies.txt` the movie catalogue, `bookings.txt` seat reservations, and `reviews.txt` user ratings and comments. Profile pictures are the only exception—they are image files saved in `uploads/profiles/` (for example `userId.jpg`), while `users.txt` stores only the URL path to that image. This simple layout is easy to demonstrate during the viva by opening the files in Notepad.

### 7.3 Record format (pipe-separated)

Each line in a data file is one record, and fields are separated by the pipe character (`|`). For example, `users.txt` stores `userId|fullName|email|password|phone|accountType|profileImageUrl`; `movies.txt` stores movie details and prices; `bookings.txt` stores `bookingId|userId|movieId|seatNumber|seatType|price|status`; and `reviews.txt` stores `reviewId|userId|movieId|rating|comment`. A sample movie line is: `11329186-8ca0-4380-8469-2489ddbbabd9|Inception|Sci-Fi|148 min|1200.0|1800.0|A dream-heist thriller...|/posters/inception.png`. Every model class provides `toRecord()` to build one line for saving and `fromRecord(String row)` to read a line back into a Java object, which links file storage directly to the domain model.

---

## 8. CRUD Operations

The assignment requires at least **three CRUD operations** using file handling. This project exceeds that minimum by implementing Create, Read, Update, and Delete across bookings, and Create, Read, Update (plus Delete for reviews) on other entities—all persisted through `FileStorage` and pipe-separated text files.

### 8.1 User management

User data is stored in **`users.txt`**. **Create** happens when a new customer registers: `AuthController.register` calls `AuthServiceImpl.register`, which checks the email is unique and saves a new row via `UserRepository.save`. **Read** is used at login and on the profile page—`findByEmail` validates credentials and `findById` loads the logged-in user’s details from the file. **Update** covers changing the password and uploading a profile photo; both update the user record with `UserRepository.update` (the image file itself is saved under `uploads/profiles/`). **Delete** is not implemented for users. Together, Create, Read, and Update meet the assignment’s user-management requirement.

### 8.2 Booking management

Bookings are the only entity with **full CRUD** on **`bookings.txt`**. **Create**: from the movie seat map, `BookingController.addToCart` passes seat selections to `BookingService.addMultipleToCart`, which calculates price using `NormalBooking` or `PremiumBooking` and saves each row with `BookingRepository.save`. **Read**: the My Bookings page loads the current user’s records via `getUserBookings` and `BookingRepository.findAll`. **Update**: a pending booking can change seat on the movie page (`updateBookingSeatFromSelection`) or be marked **CONFIRMED** (`confirmBooking`); both call `BookingRepository.update`. **Delete**: the user removes a booking with `deleteBooking`, which deletes the line from the file. This is the strongest CRUD example in the project.

### 8.3 Review management

Reviews are stored in **`reviews.txt`**. **Create**: on the movie details page, `ReviewController.addReview` saves a new review (rating and comment) through `ReviewRepository.save`. **Read**: when opening a movie, `ReviewService.getReviewsByMovie` filters all reviews from the file and shows them on the page. **Delete**: only the author can remove their review via `ReviewController.deleteOwnReview` and `ReviewRepository.delete`. **Update** is not implemented—users add a new review instead of editing an old one. This gives three file-based operations (Create, Read, Delete) for reviews.

### 8.4 Movie catalogue

Movies live in **`movies.txt`** and are mainly **read-only** for customers. **Read**: `MovieService.getAllMovies` powers the browse/search page and `getMovieById` loads one movie for the details and seat map. **Create** exists only as automatic **seeding**—if `movies.txt` is empty, sample movies are written once so the app can be demonstrated without manual setup. **Update** and **Delete** are not available in the UI; the catalogue is fixed during normal use. Movies therefore support browsing and display, while CRUD for graded features is centred on users, bookings, and reviews.

---

## 9. Features and User Workflows

### 9.1 Registration and login

New users register at `/register` by entering their name, email, password, and phone number. The system rejects duplicate emails, then saves a new `User` record in `users.txt` with a unique UUID and a default profile image. After registration, the user signs in at `/login`; on success, the session stores `userId` and `userName` so the user can access protected pages. Any page that requires authentication (movies, bookings, profile) redirects unauthenticated visitors back to the login screen.

### 9.2 Browse movies

Once logged in, the user opens `/movies` to see the movie catalogue with optional search and genre filters (e.g. Trending, Action, Sci-Fi). Selecting **View Details** opens `/movies/{movieId}`, which shows the poster, description, normal and premium prices, existing customer reviews, and the interactive seat layout for that film.

### 9.3 Seat booking

On the movie details page, the user selects Normal or Premium seats on the seat map and clicks **Proceed to Add to Cart** to confirm in a modal. The form is submitted to `/bookings/add` with each seat encoded as `TYPE:SEATCODE` (for example `NORMAL:A16`). `BookingService` checks that seats are not already taken, calculates the price using `NormalBooking` or `PremiumBooking` (polymorphism), and saves each booking to `bookings.txt` with status `PENDING`. The user can then review all bookings on the **My Bookings** page (`/bookings`).

### 9.4 Manage bookings

From **My Bookings**, the user can **Confirm** a pending booking, which sets the status to `CONFIRMED` and locks the seat so it cannot be changed. **Delete** removes the booking from `bookings.txt`. For pending bookings only, **UPDATE** opens the same movie’s seat map (`/movies/{movieId}?bookingId=...`) so the user can pick a different seat and submit **Update Seat**; the system recalculates seat type and price and updates the record in the file.

### 9.5 Reviews

On the movie details page, logged-in users can submit a star rating (1–5) and a written comment; the review is saved in `reviews.txt` and shown in the reviews list on that page. Each user may **delete** only their own reviews, which removes the corresponding line from the file.

### 9.6 Profile

The profile page (`/profile`) displays the user’s account details. The user can upload a profile photo (up to 5 MB; JPG, PNG, WebP, or GIF), stored under `uploads/profiles/` with the path saved in `users.txt`. Password change requires the current password plus matching new and confirm fields; successful updates are written back to `users.txt`.

---

## 10. User Interface

The application provides **six main JSP pages** (more than the minimum of three required):

| # | Page | File | Purpose |
|---|------|------|---------|
| 1 | Login | `login.jsp` | User authentication |
| 2 | Register | `register.jsp` | New account |
| 3 | Movies | `movies.jsp` | Catalogue with search/filter |
| 4 | Movie details | `movie-details.jsp` | Seat map, reviews, booking |
| 5 | My Bookings | `bookings.jsp` | Booking list and actions |
| 6 | Profile | `profile.jsp` | Account and photo upload |

**Design:** Bootstrap 5, Font Awesome icons, custom styles in `static/css/app.css`, shared navbar and footer fragments.

**Screenshots to insert in your PDF report:**

| Figure | Screenshot |
|--------|------------|
| Figure 4 | Login page |
| Figure 5 | Movies listing |
| Figure 6 | Movie details with seat map |
| Figure 7 | My Bookings table |
| Figure 8 | Profile page |

*[Insert your screenshots here when converting to Word/PDF]*

---

## 11. Backend Endpoints

| Method | URL | Description |
|--------|-----|-------------|
| GET | `/` | Home redirect |
| GET/POST | `/login` | Login form / submit |
| GET/POST | `/register` | Registration |
| GET | `/logout` | End session |
| GET | `/profile` | Profile page |
| POST | `/profile/upload-photo` | Upload profile image |
| POST | `/profile/change-password` | Change password |
| GET | `/movies` | Movie list |
| GET | `/movies/{movieId}` | Movie details (+ optional `?bookingId=` for seat update) |
| POST | `/bookings/add` | Add new bookings |
| GET | `/bookings` | My Bookings |
| POST | `/bookings/update-seat` | Update seat from seat map |
| POST | `/bookings/confirm` | Confirm booking |
| POST | `/bookings/delete` | Delete booking |
| POST | `/reviews/add` | Add review |
| POST | `/reviews/delete` | Delete own review |

Default server port: **8082** (configured in `application.properties`).

---

## 12. Project Structure

```
Movie-Rental-and-Review-Platform/
├── src/main/java/com/movierental/
│   ├── MovieRentalApplication.java
│   ├── config/WebMvcConfig.java
│   ├── controller/     (Auth, Movie, Booking, Review)
│   ├── service/        (Auth, Movie, Booking, Review, ProfilePicture)
│   ├── repository/     (FileStorage, User, Movie, Booking, Review)
│   └── model/          (User, Movie, Review, Booking, BookingRecord, …)
├── src/main/webapp/WEB-INF/jsp/
│   ├── login.jsp, register.jsp, movies.jsp
│   ├── movie-details.jsp, bookings.jsp, profile.jsp
│   └── fragments/      (navbar, footer, site-header)
├── src/main/resources/
│   ├── application.properties
│   ├── data/           (users.txt, movies.txt, bookings.txt, reviews.txt)
│   └── static/css/app.css
├── uploads/profiles/   (profile photos at runtime)
├── docs/
│   ├── CLASS_DIAGRAM.md
│   └── FINAL_REPORT.md
└── pom.xml
```

---

## 13. How to Run the Application

### Prerequisites

- JDK **17** or higher  
- **Maven** 3.6+  
- **IntelliJ IDEA** (recommended)  

### Steps

1. Clone the repository from GitHub.  
2. Open the project folder in IntelliJ IDEA (Open as Maven project).  
3. Wait for Maven to download dependencies.  
4. Run `com.movierental.MovieRentalApplication` (main method).  
5. Open a browser: **http://localhost:8082**  
6. Register a new user or use an existing account from `users.txt` for testing.  

**Command line alternative:**

```bash
mvn spring-boot:run
```

**Note:** Run the application from the **project root** so paths to `src/main/resources/data` and `uploads/profiles` resolve correctly.

---

## 14. Testing and Sample Data

Sample data files are included under `src/main/resources/data/`:

- **movies.txt** – eight movies (e.g. Inception, Interstellar, The Dark Knight) with normal and premium prices  
- **users.txt** – registered test users  
- **bookings.txt** – sample pending and confirmed bookings  
- **reviews.txt** – sample reviews linked to users and movies  

**Suggested test sequence:**

1. Register → Login  
2. Browse movies → Open details → Select seats → Add to cart  
3. Open My Bookings → Confirm or UPDATE seat → Delete  
4. Add and delete a review  
5. Upload profile photo and change password  

---

## 15. Challenges and Solutions

| Challenge | Solution |
|-----------|----------|
| Storing data without a database | Designed `FileStorage` and repository classes with pipe-separated text files |
| Different prices for normal vs premium seats | Abstract `Booking` with polymorphic `calculatePrice(Movie)` |
| Showing booked seats on the map | `BookingService.getBookedSeatsByMovie()` passes booked seat codes to JSP/JavaScript |
| Updating a pending booking seat | UPDATE button links to movie page with `bookingId`; current seat excluded from “booked” list; single-seat update via `/bookings/update-seat` |
| Profile photo upload on Windows | Save to `uploads/profiles/` with `Files.copy`; serve via `WebMvcConfig` |
| JSP and JavaScript conflicts | Avoided `${}` inside JS template strings; used string concatenation for seat codes |

---

## 16. Individual Contribution

*[Choose one option below and edit as needed]*

**Option A – Individual project**

| Student | Student ID | Contribution |
|---------|------------|--------------|
| *[Your name]* | IT22197832 | Complete system: backend, JSP UI, file storage, documentation, testing |

**Option B – Team project**

| Student | Student ID | Contribution |
|---------|------------|--------------|
| Member 1 | | |
| Member 2 | | |

---

## 17. Git Repository and Version Control

Version control was done using **Git** and **GitHub**. Regular commits were made during development (initial setup, models, repositories, booking feature, profile upload, UI fixes, documentation).

**Include the following screenshots in your submitted PDF:**

| # | Screenshot description |
|---|------------------------|
| 1 | GitHub repository main page (showing repo name and URL) |
| 2 | Commits list (`git log --oneline` in terminal OR GitHub **Commits** tab) |
| 3 | Example commit showing commit message and changed files |
| 4 | Optional: GitHub Insights or branch view if used |

**Example commit messages to aim for:**

- Initial Spring Boot project setup  
- Add domain models and FileStorage  
- Implement user registration and login  
- Add movie listing and details page  
- Implement seat booking and BookingService  
- Add reviews CRUD  
- Profile photo upload and WebMvcConfig  
- My Bookings page and confirm/delete/update seat  
- Update documentation and class diagrams  

*[Insert Screenshot 1 here]*  
*[Insert Screenshot 2 here]*  
*[Insert Screenshot 3 here]*  

**Repository URL:** *[Paste link]*

---

## 18. Conclusion

The **Cinevora Movie Rental and Review Platform** successfully meets the SE1020 project requirements. The system demonstrates **object-oriented design** through encapsulation in entity classes, inheritance and polymorphism in the booking hierarchy, and abstraction via the `AuthService` interface. **File-based persistence** implements multiple **CRUD** operations on users, bookings, and reviews without using a database.

The web interface provides a practical user experience for browsing movies, selecting seats, managing bookings, and writing reviews. Future improvements could include admin movie management, email notifications, and password hashing for production use.

---

## 19. References

1. Spring Boot Documentation – https://spring.io/projects/spring-boot  
2. Java SE 17 Documentation – https://docs.oracle.com/en/java/javase/17/  
3. Jakarta Servlet and JSP – https://jakarta.ee/specifications/servlet/  
4. Bootstrap 5 Documentation – https://getbootstrap.com/docs/5.3/  
5. Maven – https://maven.apache.org/guides/  
6. Mermaid (class diagrams) – https://mermaid.live  

---

## 20. Appendices

### Appendix A – Class list (23 classes)

| Package | Class |
|---------|-------|
| `com.movierental` | MovieRentalApplication |
| `config` | WebMvcConfig |
| `controller` | AuthController, MovieController, BookingController, ReviewController |
| `service` | AuthService, AuthServiceImpl, MovieService, BookingService, ReviewService, ProfilePictureService |
| `repository` | FileStorage, UserRepository, MovieRepository, BookingRepository, ReviewRepository |
| `model` | User, Movie, Review, Booking, NormalBooking, PremiumBooking, BookingRecord |

### Appendix B – Assignment compliance checklist

| Requirement | Status |
|-------------|--------|
| Java + Spring Boot + IntelliJ | Yes |
| File read/write storage | Yes |
| Encapsulation | Yes |
| Inheritance | Yes |
| Polymorphism | Yes |
| Minimum 3 CRUD operations | Yes (Users, Bookings, Reviews) |
| Minimum 3 UI pages | Yes (6 JSP pages) |
| Class diagrams | Yes (`docs/CLASS_DIAGRAM.md`) |
| Final report | Yes (this document) |
| Git commit history screenshots | *[Add to Section 17 before submission]* |

### Appendix C – Related documents

- **Class diagrams:** `docs/CLASS_DIAGRAM.md`  
- **Configuration:** `src/main/resources/application.properties`  
- **Sample data:** `src/main/resources/data/*.txt`  

---

*End of Report*
