<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="ctx" value="${pageContext.request.contextPath}"/>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Register | Cinevora</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css" rel="stylesheet">
    <link rel="stylesheet" href="${ctx}/css/app.css">
</head>
<body class="auth-bg cinevora-page d-flex flex-column min-vh-100">
<header class="cinevora-auth-heading">
    <a href="${ctx}/login" class="cinevora-brand">
        <span class="cinevora-brand__icon" aria-hidden="true"><i class="fa-solid fa-clapperboard"></i></span>
        <span class="cinevora-brand__text">
            <span class="cinevora-brand__name">Cinevora</span>
            <span class="cinevora-brand__tagline">Movie Rental &amp; Reviews</span>
        </span>
    </a>
</header>
<main class="flex-grow-1">
<div class="container py-5">
    <div class="row justify-content-center">
        <div class="col-lg-6">
            <div class="card shadow-lg border-0 rounded-4">
                <div class="card-body p-4 p-md-5">
                    <h1 class="h3 fw-bold mb-1">Create Account</h1>
                    <p class="text-muted mb-4">Join Cinevora to discover films and book your next show.</p>
                    <c:if test="${not empty error}">
                        <div class="alert alert-danger">${error}</div>
                    </c:if>
                    <form method="post" action="${ctx}/register">
                        <div class="mb-3">
                            <label class="form-label">Full Name</label>
                            <input class="form-control" name="fullName" required>
                        </div>
                        <div class="mb-3">
                            <label class="form-label">Email</label>
                            <input class="form-control" type="email" name="email" required>
                        </div>
                        <div class="mb-3">
                            <label class="form-label">Phone</label>
                            <input class="form-control" name="phone">
                        </div>
                        <div class="mb-4">
                            <label class="form-label">Password</label>
                            <input class="form-control" type="password" name="password" minlength="4" required>
                        </div>
                        <button class="btn btn-dark w-100" type="submit">Register</button>
                    </form>
                    <p class="text-center text-muted mt-4 mb-0">
                        Already registered? <a href="${ctx}/login" class="text-decoration-none fw-semibold">Login</a>
                    </p>
                </div>
            </div>
        </div>
    </div>
</div>
</main>
<%@ include file="/WEB-INF/jsp/fragments/footer.jspf" %>
</body>
</html>
