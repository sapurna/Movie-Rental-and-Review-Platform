<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="ctx" value="${pageContext.request.contextPath}"/>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Movies | Cinevora</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css" rel="stylesheet">
    <link rel="stylesheet" href="${ctx}/css/app.css">
    <style>
        .genre-scroll {
            overflow-x: auto;
            -webkit-overflow-scrolling: touch;
            scrollbar-width: thin;
            padding-bottom: 0.25rem;
        }
        .genre-scroll .chip-row {
            flex-wrap: nowrap;
            width: max-content;
            min-width: 100%;
        }
        .genre-chip {
            border-radius: 999px;
            padding: 0.45rem 1rem;
            font-size: 0.9rem;
            white-space: nowrap;
            text-decoration: none;
            border: none;
            transition: background-color .15s ease, color .15s ease;
        }
        .genre-chip-inactive {
            background-color: #e9ecef;
            color: #212529;
        }
        .genre-chip-inactive:hover {
            background-color: #dee2e6;
            color: #111;
        }
        .genre-chip-active {
            background-color: #212529;
            color: #fff;
        }
        .movie-card {
            background-color: #fff;
            border: 1px solid #e9ecef;
            border-radius: 12px;
            overflow: hidden;
            cursor: pointer;
            transition:
                transform 0.28s cubic-bezier(0.22, 1, 0.36, 1),
                box-shadow 0.28s cubic-bezier(0.22, 1, 0.36, 1),
                border-color 0.28s ease;
            will-change: transform, box-shadow;
        }
        .movie-card:hover {
            transform: translateY(-8px);
            border-color: #cbd5e1;
            box-shadow:
                0 12px 28px rgba(15, 23, 42, 0.12),
                0 4px 10px rgba(15, 23, 42, 0.06);
        }
        .movie-card:active {
            transform: translateY(-4px);
            box-shadow:
                0 8px 18px rgba(15, 23, 42, 0.1),
                0 2px 6px rgba(15, 23, 42, 0.05);
        }
        .movie-card .card-img-top {
            border-radius: 12px 12px 0 0;
            transition: transform 0.35s cubic-bezier(0.22, 1, 0.36, 1);
        }
        .movie-card:hover .card-img-top {
            transform: scale(1.05);
        }
        .movie-card .card-title {
            transition: color 0.2s ease;
        }
        .movie-card:hover .card-title {
            color: #3730a3 !important;
        }
        @media (prefers-reduced-motion: reduce) {
            .movie-card,
            .movie-card .card-img-top {
                transition: none;
            }
            .movie-card:hover {
                transform: none;
            }
            .movie-card:hover .card-img-top {
                transform: none;
            }
        }
        .genre-section-label {
            letter-spacing: 0.06em;
        }
    </style>
</head>
<body class="bg-white text-dark cinevora-page d-flex flex-column min-vh-100">
<%@ include file="/WEB-INF/jsp/fragments/navbar.jspf" %>
<%@ include file="/WEB-INF/jsp/fragments/site-header.jspf" %>
<main class="flex-grow-1">
<div class="container py-4">
    <div class="d-flex justify-content-between align-items-center flex-wrap gap-2 mb-3">
        <div>
            <h1 class="h3 fw-bold mb-0">Discover Movies</h1>
            <p class="text-secondary mb-0">Welcome, ${userName}</p>
        </div>
        <form class="d-flex gap-2" method="get" action="${ctx}/movies">
            <c:if test="${selectedType != null and selectedType != 'Trending'}">
                <input type="hidden" name="type" value="${selectedType}">
            </c:if>
            <input class="form-control" name="q" value="${query}" placeholder="Search by title or genre">
            <button type="submit" class="btn btn-dark">Search</button>
        </form>
    </div>

    <p class="genre-section-label text-secondary text-uppercase small fw-semibold mb-2">Movies by genre</p>
    <div class="genre-scroll mb-4">
        <div class="d-flex gap-2 chip-row">
            <c:forEach items="${filterTypes}" var="ft">
                <c:choose>
                    <c:when test="${ft == 'Trending'}">
                        <a href="${ctx}/movies?q=${query}"
                           class="genre-chip ${ft == selectedType ? 'genre-chip-active' : 'genre-chip-inactive'}">${ft}</a>
                    </c:when>
                    <c:otherwise>
                        <a href="${ctx}/movies?q=${query}&amp;type=${ft}"
                           class="genre-chip ${ft == selectedType ? 'genre-chip-active' : 'genre-chip-inactive'}">${ft}</a>
                    </c:otherwise>
                </c:choose>
            </c:forEach>
        </div>
    </div>

    <div class="row g-4">
        <c:forEach items="${movies}" var="movie">
        <div class="col-md-6 col-lg-4">
            <div class="card movie-card h-100 shadow-sm">
                <img src="${ctx}${movie.imageUrl}" class="card-img-top" style="height:220px; object-fit:cover;" alt="poster">
                <div class="card-body d-flex flex-column">
                    <h5 class="card-title text-dark">${movie.title}</h5>
                    <p class="text-secondary small mb-2">${movie.genre} &bull; ${movie.duration}</p>
                    <p class="card-text small text-secondary">${movie.description}</p>
                    <div class="mt-auto d-flex justify-content-between align-items-center">
                        <span class="fw-semibold text-dark">LKR ${movie.normalPrice}</span>
                        <a class="btn btn-dark btn-sm" href="${ctx}/movies/${movie.movieId}">View Details</a>
                    </div>
                </div>
            </div>
        </div>
        </c:forEach>
        <c:if test="${empty movies}">
        <div class="col-12">
            <div class="alert alert-secondary border-0">No movies found for your search.</div>
        </div>
        </c:if>
    </div>
</div>
</main>
<%@ include file="/WEB-INF/jsp/fragments/footer.jspf" %>
</body>
</html>
