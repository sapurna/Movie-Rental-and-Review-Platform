<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="ctx" value="${pageContext.request.contextPath}"/>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Login | Cinevora</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css" rel="stylesheet">
    <link rel="stylesheet" href="${ctx}/css/app.css">
</head>
<body class="auth-split-bg auth-split-bg--login cinevora-page d-flex flex-column min-vh-100">
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
<div class="container-fluid px-0 auth-split-wrap auth-login-hero">
    <div class="login-hero-bg" aria-hidden="true">
        <img class="login-hero-bg__img" src="${ctx}/posters/movie_bg_3.jpg" alt="" width="1600" height="900" fetchpriority="high">
        <div class="login-hero-bg__scrim"></div>
    </div>
    <div class="auth-login-foreground">
        <div class="auth-split-left auth-split-left--spacer" aria-hidden="true"></div>
        <div class="auth-split-right">
        <div class="auth-panel">
            <div class="text-center mb-4">
                <div class="auth-logo"><i class="fa-solid fa-link"></i></div>
                <h1 class="h2 fw-bold mb-2">Welcome back!</h1>
                <p class="text-muted mb-0">Sign in to Cinevora to browse movies, book tickets, and share your reviews.</p>
            </div>

            <c:if test="${not empty error}">
                <div class="alert alert-danger">${error}</div>
            </c:if>
            <c:if test="${not empty success}">
                <div class="alert alert-success">${success}</div>
            </c:if>

            <form method="post" action="${ctx}/login">
                <div class="auth-role mb-3">
                    <span class="auth-role-pill active">Customer</span>
                </div>
                <div class="mb-3">
                    <input class="form-control auth-input" type="email" name="email" placeholder="Email address" required>
                </div>
                <div class="mb-2 auth-password-wrap">
                    <input id="passwordInput" class="form-control auth-input auth-password-input" type="password" name="password" placeholder="Password" required>
                    <button id="passwordPeekBtn" class="auth-password-toggle" type="button" aria-label="Press and hold to show password">
                        <i class="fa-regular fa-eye"></i>
                    </button>
                </div>
                <div class="text-end mb-3">
                    <span class="small text-danger fw-semibold">Forgot password?</span>
                </div>
                <button class="btn auth-login-btn w-100 mb-3" type="submit">Login</button>
            </form>

            <p class="text-center mb-3">
                Don't have an account? <a href="${ctx}/register" class="text-danger fw-semibold text-decoration-none">Sign up</a>
            </p>

            <div class="auth-divider"><span>Or continue with</span></div>
            <div class="social-row">
                <a class="social-btn social-google" href="https://mail.google.com/" target="_blank" rel="noopener noreferrer" aria-label="Continue with Gmail">
                    <i class="fa-brands fa-google"></i>
                </a>
                <a class="social-btn social-apple" href="https://www.apple.com/" target="_blank" rel="noopener noreferrer" aria-label="Continue with Apple">
                    <i class="fa-brands fa-apple"></i>
                </a>
                <a class="social-btn social-facebook" href="https://www.facebook.com/" target="_blank" rel="noopener noreferrer" aria-label="Continue with Facebook">
                    <i class="fa-brands fa-facebook-f"></i>
                </a>
            </div>
        </div>
        </div>
    </div>
    </div>
</div>
<script>
    const passwordInput = document.getElementById("passwordInput");
    const passwordPeekBtn = document.getElementById("passwordPeekBtn");
    if (passwordInput && passwordPeekBtn) {
        const showPassword = () => { passwordInput.type = "text"; };
        const hidePassword = () => { passwordInput.type = "password"; };
        passwordPeekBtn.addEventListener("mousedown", showPassword);
        passwordPeekBtn.addEventListener("mouseup", hidePassword);
        passwordPeekBtn.addEventListener("mouseleave", hidePassword);
        passwordPeekBtn.addEventListener("touchstart", showPassword);
        passwordPeekBtn.addEventListener("touchend", hidePassword);
        passwordPeekBtn.addEventListener("touchcancel", hidePassword);
    }
</script>
</main>
<%@ include file="/WEB-INF/jsp/fragments/footer.jspf" %>
</body>
</html>
