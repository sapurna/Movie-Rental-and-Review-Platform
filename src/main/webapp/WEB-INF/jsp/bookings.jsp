<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="ctx" value="${pageContext.request.contextPath}"/>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>My Bookings | Cinevora</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css" rel="stylesheet">
    <link rel="stylesheet" href="${ctx}/css/app.css">
</head>
<body class="bg-light cinevora-page d-flex flex-column min-vh-100">
<%@ include file="/WEB-INF/jsp/fragments/navbar.jspf" %>
<%@ include file="/WEB-INF/jsp/fragments/site-header.jspf" %>
<main class="flex-grow-1">
<div class="container py-4">
    <h1 class="h3 fw-bold">My Bookings</h1>
    <c:if test="${not empty message}">
        <div class="alert alert-info">${message}</div>
    </c:if>
    <div class="card border-0 shadow-sm">
        <div class="card-body table-responsive">
            <table class="table align-middle">
                <thead>
                <tr>
                    <th>Booking ID</th>
                    <th>Movie</th>
                    <th>Seat No</th>
                    <th>Type</th>
                    <th>Price</th>
                    <th>Status</th>
                    <th>Actions</th>
                    <th>Payment</th>
                </tr>
                </thead>
                <tbody>
                <c:forEach items="${bookings}" var="b">
                <tr>
                    <td>${b.bookingId}</td>
                    <td>
                        <c:set var="movieTitle" value="${b.movieId}"/>
                        <c:forEach items="${movies}" var="m">
                            <c:if test="${m.movieId == b.movieId}">
                                <c:set var="movieTitle" value="${m.title}"/>
                            </c:if>
                        </c:forEach>
                        ${movieTitle}
                    </td>
                    <td>
                        <div class="d-flex align-items-center gap-2 flex-wrap">
                            <span class="fw-semibold">${b.seatNumber}</span>
                            <c:if test="${b.status == 'PENDING'}">
                                <a class="btn btn-sm btn-outline-primary"
                                   href="${ctx}/movies/${b.movieId}?bookingId=${b.bookingId}">
                                    UPDATE
                                </a>
                            </c:if>
                        </div>
                    </td>
                    <td>${b.seatType}</td>
                    <td>LKR ${b.price}</td>
                    <td><span class="badge text-bg-secondary">${b.status}</span></td>
                    <td class="d-flex flex-wrap gap-1">
                        <c:if test="${b.status == 'PENDING'}">
                            <form method="post" action="${ctx}/bookings/confirm">
                                <input type="hidden" name="bookingId" value="${b.bookingId}">
                                <button class="btn btn-sm btn-success">Confirm</button>
                            </form>
                        </c:if>
                        <form method="post" action="${ctx}/bookings/delete">
                            <input type="hidden" name="bookingId" value="${b.bookingId}">
                            <button class="btn btn-sm btn-danger">Delete</button>
                        </form>
                    </td>
                    <td>
                        <c:choose>
                            <c:when test="${b.status == 'CONFIRMED'}">
                                <button type="button"
                                        class="btn btn-sm btn-primary"
                                        disabled
                                        title="Proceed to payment — not available yet">
                                    Proceed
                                </button>
                            </c:when>
                            <c:otherwise>
                                <button type="button"
                                        class="btn btn-sm btn-outline-secondary"
                                        disabled
                                        title="Confirm booking before payment">
                                    Proceed
                                </button>
                            </c:otherwise>
                        </c:choose>
                    </td>
                </tr>
                </c:forEach>
                <c:if test="${empty bookings}">
                <tr>
                    <td colspan="8" class="text-center text-muted py-4">No bookings yet.</td>
                </tr>
                </c:if>
                </tbody>
            </table>
        </div>
    </div>
</div>
</main>
<%@ include file="/WEB-INF/jsp/fragments/footer.jspf" %>
</body>
</html>
