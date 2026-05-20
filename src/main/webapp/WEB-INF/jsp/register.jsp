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
                    <form method="post" action="${ctx}/register" id="register-form" novalidate>
                        <div class="mb-3">
                            <label class="form-label" for="fullName">Full Name</label>
                            <input class="form-control" id="fullName" name="fullName" required
                                   value="${fullName}"
                                   autocomplete="name"
                                   pattern="^(?:[A-Z][a-zA-Z'-]*)(?:\s+(?:[A-Z][a-zA-Z'-]*))+$|^[A-Z][a-zA-Z'-]*$"
                                   title="Each name must start with a capital letter (e.g. John Doe).">
                            <div class="form-text">Each part of your name must start with a capital letter.</div>
                            <div class="invalid-feedback">Enter a valid full name (e.g. John Doe).</div>
                        </div>
                        <div class="mb-3">
                            <label class="form-label" for="email">Email</label>
                            <input class="form-control" id="email" name="email" type="email" required
                                   value="${email}"
                                   autocomplete="email"
                                   maxlength="254"
                                   pattern="[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}"
                                   title="Enter a valid email address (e.g. name@example.com).">
                            <div class="invalid-feedback">Enter a valid email address.</div>
                        </div>
                        <div class="mb-3">
                            <label class="form-label" for="phone">Phone</label>
                            <input class="form-control" id="phone" name="phone" required
                                   value="${phone}"
                                   inputmode="numeric"
                                   maxlength="10"
                                   pattern="0[0-9]{9}"
                                   title="10 digits starting with 0 (e.g. 0712345678).">
                            <div class="form-text">10 digits, must start with 0 (e.g. 0712345678).</div>
                            <div class="invalid-feedback">Phone must be 10 digits and start with 0.</div>
                        </div>
                        <div class="mb-4">
                            <label class="form-label" for="password">Password</label>
                            <input class="form-control" id="password" name="password" type="password" minlength="4" required>
                            <div class="invalid-feedback">Password must be at least 4 characters.</div>
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
<script>
(function () {
    var form = document.getElementById("register-form");
    if (!form) return;

    var fullNamePattern = /^(?:[A-Z][a-zA-Z'-]*)(?:\s+(?:[A-Z][a-zA-Z'-]*))+$|^[A-Z][a-zA-Z'-]*$/;
    var emailPattern = /^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]*[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]*[a-zA-Z0-9])?)*\.[a-zA-Z]{2,}$/;
    var phonePattern = /^0\d{9}$/;

    function setValidity(field, valid, message) {
        field.setCustomValidity(valid ? "" : (message || "Invalid value."));
        field.classList.toggle("is-invalid", !valid);
        field.classList.toggle("is-valid", valid && field.value.length > 0);
    }

    function validateFullName() {
        var field = document.getElementById("fullName");
        var value = field.value.trim().replace(/\s+/g, " ");
        if (!value) {
            setValidity(field, false, "Full name is required.");
            return false;
        }
        if (!fullNamePattern.test(value)) {
            setValidity(field, false, "Each name must start with a capital letter.");
            return false;
        }
        setValidity(field, true);
        return true;
    }

    function validateEmail() {
        var field = document.getElementById("email");
        var value = field.value.trim();
        if (!value) {
            setValidity(field, false, "Email is required.");
            return false;
        }
        if (!emailPattern.test(value)) {
            setValidity(field, false, "Please enter a valid email address.");
            return false;
        }
        setValidity(field, true);
        return true;
    }

    function validatePhone() {
        var field = document.getElementById("phone");
        var value = field.value.trim().replace(/\s+/g, "");
        if (!phonePattern.test(value)) {
            setValidity(field, false, "Phone must be 10 digits and start with 0.");
            return false;
        }
        field.value = value;
        setValidity(field, true);
        return true;
    }

    document.getElementById("fullName").addEventListener("input", validateFullName);
    document.getElementById("email").addEventListener("input", validateEmail);
    document.getElementById("phone").addEventListener("input", function () {
        var field = document.getElementById("phone");
        field.value = field.value.replace(/\D/g, "").slice(0, 10);
        validatePhone();
    });

    form.addEventListener("submit", function (e) {
        var ok = validateFullName() & validateEmail() & validatePhone();
        if (!form.checkValidity() || !ok) {
            e.preventDefault();
            e.stopPropagation();
        }
        form.classList.add("was-validated");
    });
})();
</script>
</body>
</html>
