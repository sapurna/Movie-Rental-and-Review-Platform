<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<c:set var="ctx" value="${pageContext.request.contextPath}"/>
<c:set var="avatarPath" value="${not empty profileImageSrc ? profileImageSrc : user.displayProfileImageUrl}"/>
<c:set var="avatarUrl" value="${ctx}${avatarPath}"/>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Profile | Cinevora</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css" rel="stylesheet">
    <link rel="stylesheet" href="${ctx}/css/app.css">
</head>
<body class="profile-page-bg cinevora-page d-flex flex-column min-vh-100">
<%@ include file="/WEB-INF/jsp/fragments/navbar.jspf" %>
<%@ include file="/WEB-INF/jsp/fragments/site-header.jspf" %>
<main class="flex-grow-1">
<div class="container py-4 py-lg-5">
    <div class="row justify-content-center">
        <div class="col-lg-8 col-xl-7">
            <div class="profile-card shadow">
                <div class="profile-card-hero">
                    <h1 class="profile-card-hero-title">User Profile</h1>
                </div>
                <div class="profile-avatar-wrap">
                    <img id="profileAvatarImg" class="profile-avatar"
                         src="${avatarUrl}?v=${profileImageCacheKey}"
                         data-profile-src="${avatarUrl}"
                         alt="Profile picture of ${user.fullName}" width="160" height="160">
                    <button type="button" class="profile-cam-btn" id="profileCamBtn" aria-label="Change profile photo" title="Change profile photo" data-bs-toggle="modal" data-bs-target="#profilePhotoModal">
                        <i class="fa-solid fa-camera fa-xs"></i>
                    </button>
                </div>
                <form id="profilePhotoForm" class="d-none" method="post" action="${ctx}/profile/upload-photo" enctype="multipart/form-data">
                    <input type="file" id="profilePhotoInput" name="photo" accept="image/jpeg,image/png,image/webp,image/gif">
                </form>
                <div class="profile-card-body">
                    <c:if test="${not empty message}">
                        <div class="alert alert-info py-2 small">${message}</div>
                    </c:if>

                    <div class="profile-form">
                        <div class="row g-3 mb-4">
                            <div class="col-md-6">
                                <div class="profile-field-box">
                                    <div class="profile-field-row">
                                        <span class="profile-field-label">Full Name:</span>
                                        <span class="profile-field-static">${user.fullName}</span>
                                    </div>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <div class="profile-field-box">
                                    <div class="profile-field-row">
                                        <span class="profile-field-label">Email:</span>
                                        <span class="profile-field-static">${user.email}</span>
                                    </div>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <div class="profile-field-box">
                                    <div class="profile-field-row">
                                        <span class="profile-field-label">Total Booked Tickets:</span>
                                        <span class="profile-field-static">${totalBookedTickets}</span>
                                    </div>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <div class="profile-field-box">
                                    <div class="profile-field-row">
                                        <span class="profile-field-label">Contact:</span>
                                        <span class="profile-field-static"><c:choose><c:when test="${fn:length(user.phone) == 0}">&mdash;</c:when><c:otherwise>${user.phone}</c:otherwise></c:choose></span>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="text-center mt-3">
                        <button type="button" class="profile-gradient-btn" data-bs-toggle="modal" data-bs-target="#changePasswordModal">
                            Change Password
                        </button>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- Profile photo modal -->
<div class="modal fade pwd-change-modal" id="profilePhotoModal" tabindex="-1" aria-labelledby="profilePhotoModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content pwd-modal-shell border-0">
            <button type="button" class="btn-close pwd-modal-dismiss" data-bs-dismiss="modal" aria-label="Close"></button>
            <div class="modal-body pwd-modal-body">
                <div class="text-center mb-2">
                    <span class="pwd-modal-lock"><i class="fa-solid fa-camera" aria-hidden="true"></i></span>
                </div>
                <h2 class="pwd-modal-title h5 text-center fw-bold mb-2" id="profilePhotoModalLabel">Update profile photo</h2>
                <p class="text-center text-muted small mb-3">Take a new photo or choose one from your device.</p>

                <c:if test="${not empty photoError}">
                    <div class="alert alert-danger py-2 small mb-3">${photoError}</div>
                </c:if>

                <div class="d-grid gap-2">
                    <button type="button" class="btn pwd-modal-submit" id="takePhotoBtn">
                        <i class="fa-solid fa-camera me-2"></i>Take photo
                    </button>
                    <button type="button" class="btn btn-outline-secondary" id="uploadPhotoBtn">
                        <i class="fa-solid fa-image me-2"></i>Upload from device
                    </button>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- Change Password modal -->
<div class="modal fade pwd-change-modal" id="changePasswordModal" tabindex="-1" aria-labelledby="changePasswordModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content pwd-modal-shell border-0">
            <button type="button" class="btn-close pwd-modal-dismiss" data-bs-dismiss="modal" aria-label="Close"></button>
            <div class="modal-body pwd-modal-body">
                <div class="text-center mb-2">
                    <span class="pwd-modal-lock"><i class="fa-solid fa-lock" aria-hidden="true"></i></span>
                </div>
                <h2 class="pwd-modal-title h5 text-center fw-bold mb-3" id="changePasswordModalLabel">Change Password</h2>

                <c:if test="${not empty passwordError}">
                    <div class="alert alert-danger py-2 small mb-3">${passwordError}</div>
                </c:if>

                <form method="post" action="${ctx}/profile/change-password" id="changePasswordForm">
                    <input type="password" name="oldPassword" class="form-control pwd-modal-input mb-2" placeholder="Old Password" required autocomplete="current-password">
                    <input type="password" name="newPassword" class="form-control pwd-modal-input mb-2" placeholder="New Password" required minlength="4" autocomplete="new-password">
                    <input type="password" name="confirmPassword" class="form-control pwd-modal-input mb-3" placeholder="Confirm New Password" required minlength="4" autocomplete="new-password">
                    <button type="submit" class="btn pwd-modal-submit w-100">Submit</button>
                </form>
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script>
    document.addEventListener("DOMContentLoaded", function () {
        const profilePhotoForm = document.getElementById("profilePhotoForm");
        const profilePhotoInput = document.getElementById("profilePhotoInput");
        const avatarImg = document.getElementById("profileAvatarImg");
        const takePhotoBtn = document.getElementById("takePhotoBtn");
        const uploadPhotoBtn = document.getElementById("uploadPhotoBtn");
        const photoModalEl = document.getElementById("profilePhotoModal");

        function hidePhotoModal() {
            if (photoModalEl && typeof bootstrap !== "undefined") {
                const instance = bootstrap.Modal.getInstance(photoModalEl);
                if (instance) {
                    instance.hide();
                }
            }
        }

        function setAvatarSrc(url) {
            if (avatarImg && url) {
                avatarImg.src = url;
            }
        }

        function previewAndSubmit(file) {
            if (!file || !profilePhotoForm) {
                return;
            }
            if (avatarImg) {
                setAvatarSrc(URL.createObjectURL(file));
            }
            hidePhotoModal();
            profilePhotoForm.submit();
        }

        if (avatarImg) {
            const baseSrc = avatarImg.getAttribute("data-profile-src");
            const cacheKey = "${profileImageCacheKey}";
            if (baseSrc) {
                setAvatarSrc(baseSrc + "?v=" + cacheKey);
            }
        }

        if (profilePhotoInput) {
            profilePhotoInput.addEventListener("change", function () {
                const file = profilePhotoInput.files && profilePhotoInput.files[0];
                if (file) {
                    previewAndSubmit(file);
                }
            });
        }

        if (takePhotoBtn && profilePhotoInput) {
            takePhotoBtn.addEventListener("click", function () {
                profilePhotoInput.setAttribute("accept", "image/*");
                profilePhotoInput.setAttribute("capture", "user");
                profilePhotoInput.click();
            });
        }

        if (uploadPhotoBtn && profilePhotoInput) {
            uploadPhotoBtn.addEventListener("click", function () {
                profilePhotoInput.setAttribute("accept", "image/jpeg,image/png,image/webp,image/gif");
                profilePhotoInput.removeAttribute("capture");
                profilePhotoInput.click();
            });
        }
    });
</script>
<c:if test="${openPasswordModal}">
<script>
    document.addEventListener("DOMContentLoaded", function () {
        const passwordModal = document.getElementById("changePasswordModal");
        if (passwordModal && typeof bootstrap !== "undefined") {
            new bootstrap.Modal(passwordModal).show();
        }
    });
</script>
</c:if>
<c:if test="${openPhotoModal}">
<script>
    document.addEventListener("DOMContentLoaded", function () {
        const photoModalEl = document.getElementById("profilePhotoModal");
        if (photoModalEl && typeof bootstrap !== "undefined") {
            new bootstrap.Modal(photoModalEl).show();
        }
    });
</script>
</c:if>
</main>
<%@ include file="/WEB-INF/jsp/fragments/footer.jspf" %>
</body>
</html>
