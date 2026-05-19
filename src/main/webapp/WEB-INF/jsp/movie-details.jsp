<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="ctx" value="${pageContext.request.contextPath}"/>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Movie Details | Cinevora</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css" rel="stylesheet">
    <link rel="stylesheet" href="${ctx}/css/app.css">
</head>
<body class="bg-light cinevora-page d-flex flex-column min-vh-100">
<%@ include file="/WEB-INF/jsp/fragments/navbar.jspf" %>
<%@ include file="/WEB-INF/jsp/fragments/site-header.jspf" %>
<main class="flex-grow-1">
<div class="container-fluid px-4 py-4">
    <c:if test="${not empty message}">
        <div class="alert alert-info">${message}</div>
    </c:if>
    <div class="row g-4 align-items-stretch">
        <div class="col-lg-8">
            <div class="card border-0 shadow-sm h-100">
                <img src="${ctx}${movie.imageUrl}" class="card-img-top" style="height:320px; object-fit:cover;" alt="poster">
                <div class="card-body">
                    <h2 class="h4">${movie.title}</h2>
                    <p class="text-muted">${movie.genre} &bull; ${movie.duration}</p>
                    <p>${movie.description}</p>
                    <div class="d-flex gap-3">
                        <span class="badge text-bg-dark">Normal: LKR ${movie.normalPrice}</span>
                        <span class="badge text-bg-secondary">Premium: LKR ${movie.premiumPrice}</span>
                    </div>
                </div>
            </div>
        </div>
        <div class="col-lg-4">
            <div class="card border-0 shadow-sm h-100">
                <div class="card-body d-flex flex-column">
                    <h3 class="h5 mb-3">Write a Review</h3>
                    <form method="post" action="${ctx}/reviews/add">
                        <input type="hidden" name="movieId" value="${movie.movieId}">
                        <div class="mb-3">
                            <label class="form-label">Rating</label>
                            <select class="form-select" name="rating">
                                <option value="5">5 - Excellent</option>
                                <option value="4">4 - Very Good</option>
                                <option value="3">3 - Good</option>
                                <option value="2">2 - Average</option>
                                <option value="1">1 - Poor</option>
                            </select>
                        </div>
                        <div class="mb-3">
                            <label class="form-label">Comment</label>
                            <textarea class="form-control" name="comment" rows="3" required></textarea>
                        </div>
                        <button class="btn btn-outline-dark w-100">Submit Review</button>
                    </form>
                    <hr class="my-4">
                    <h3 class="h5">Customer Reviews</h3>
                    <div class="review-scroll pe-1">
                        <c:forEach items="${reviews}" var="review">
                        <div class="border rounded p-3 mb-2 bg-white">
                            <div class="d-flex justify-content-between">
                                <div>
                                    <div class="rating-stars">
                                        <c:forEach begin="1" end="5" var="star">
                                            <span class="${star le review.rating ? ' star-filled' : ' star-empty'}">${star le review.rating ? '★' : '☆'}</span>
                                        </c:forEach>
                                    </div>
                                    <small class="text-muted">${review.rating} out of 5</small>
                                </div>
                                <c:if test="${review.userId == currentUserId}">
                                <form method="post" action="${ctx}/reviews/delete">
                                    <input type="hidden" name="reviewId" value="${review.reviewId}">
                                    <input type="hidden" name="movieId" value="${movie.movieId}">
                                    <button class="btn btn-sm btn-outline-danger">Delete</button>
                                </form>
                                </c:if>
                            </div>
                            <p class="mb-0 mt-1">${review.comment}</p>
                        </div>
                        </c:forEach>
                        <c:if test="${empty reviews}">
                        <p class="text-muted mb-0">No reviews yet. Be the first to review.</p>
                        </c:if>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <div class="card border-0 shadow-sm mt-4">
        <div class="card-body">
            <div class="d-flex justify-content-between align-items-center flex-wrap gap-2 mb-3">
                <h3 class="h5 mb-0">Select Seat</h3>
                <div class="d-flex gap-2 align-items-center small">
                    <span class="seat-legend seat-legend-premium"></span><span>Premium</span>
                    <span class="seat-legend seat-legend-normal ms-2"></span><span>Normal</span>
                    <span class="seat-legend seat-legend-selected ms-2"></span><span>Selected</span>
                    <span class="seat-legend seat-legend-booked ms-2"></span><span>Booked</span>
                </div>
            </div>
            <div class="seat-layout-shell" id="seat-layout-shell">
                <div class="screen-shape"></div>
                <div class="screen-caption">All eyes this way please!</div>
                <div id="seat-grid-main" class="seat-grid"></div>
                <div class="balcony-divider"></div>
                <div id="seat-grid-front" class="seat-grid mt-2"></div>
                <div class="balcony-caption">Balcony</div>
            </div>
            <div class="seat-selection-summary mt-3 p-3 border rounded bg-white">
                <p class="mb-1 small text-muted">Selected seats</p>
                <p class="mb-2 fw-semibold" id="selectedSeatLabels">No seats selected</p>
                <p class="mb-1 small text-muted">Total amount</p>
                <p class="mb-0 fw-semibold" id="selectedSeatAmount">LKR 0.00</p>
            </div>
            <div class="seat-debug-panel mt-3 p-3 border border-warning rounded bg-warning-subtle">
                <div class="d-flex justify-content-between align-items-center mb-2">
                    <strong class="small text-danger">Seat booking debug (copy &amp; paste to report)</strong>
                    <button type="button" class="btn btn-sm btn-outline-dark" id="copySeatDebugBtn">Copy log</button>
                </div>
                <pre id="seatDebugLog" class="small mb-0 bg-white border rounded p-2" style="max-height:220px;overflow:auto;white-space:pre-wrap;">Waiting for seat script...</pre>
            </div>
            <div class="d-flex justify-content-end mt-3">
                <button type="button" class="btn btn-dark" id="openCartModalBtn"
                        data-bs-toggle="modal" data-bs-target="#addToCartModal">Proceed to Add to Cart</button>
            </div>
        </div>
    </div>
</div>

<div class="modal fade" id="addToCartModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content">
            <form method="post" action="${ctx}/bookings/add" id="booking-form">
                <div class="modal-header">
                    <h5 class="modal-title" id="addToCartModalLabel">Add to Cart</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <input type="hidden" name="movieId" value="${movie.movieId}">
                    <div id="seatSelectionsContainer"></div>
                    <div class="mb-3">
                        <label class="form-label">Selected Seats</label>
                        <div class="form-control bg-light" id="selectedSeatView">No seats selected</div>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Calculated Total</label>
                        <div class="form-control bg-light fw-semibold" id="calculatedPrice">LKR 0.00</div>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-outline-secondary" data-bs-dismiss="modal">Cancel</button>
                    <button type="submit" class="btn btn-dark">Add to Cart</button>
                </div>
            </form>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script id="seat-booking-data" type="application/json">
{
    "normalPrice": <c:out value="${movie.normalPrice}" default="0"/>,
    "premiumPrice": <c:out value="${movie.premiumPrice}" default="0"/>,
    "bookedSeats": [
        <c:forEach items="${bookedSeats}" var="seat" varStatus="st">
        "<c:out value="${seat}" escapeXml="true"/>"<c:if test="${!st.last}">,</c:if>
        </c:forEach>
    ]
}
</script>
<script>
(function () {
    const debugLines = [];
    const debugEl = () => document.getElementById("seatDebugLog");

    function seatDebug(msg, level) {
        const line = "[" + new Date().toISOString().slice(11, 23) + "] " + (level || "INFO") + ": " + msg;
        debugLines.push(line);
        const el = debugEl();
        if (el) {
            el.textContent = debugLines.join("\n");
            el.scrollTop = el.scrollHeight;
        }
        if (level === "ERROR") {
            console.error(line);
        } else {
            console.log(line);
        }
    }

    window.seatDebug = seatDebug;

    window.onerror = function (message, source, lineno, colno, error) {
        seatDebug("window.onerror: " + message + " at " + source + ":" + lineno + ":" + colno + (error && error.stack ? "\n" + error.stack : ""), "ERROR");
        return false;
    };

    window.addEventListener("unhandledrejection", function (e) {
        seatDebug("unhandledrejection: " + (e.reason && e.reason.stack ? e.reason.stack : e.reason), "ERROR");
    });

    function initSeatBooking() {
    seatDebug("initSeatBooking started (readyState=" + document.readyState + ")");
    seatDebug("bootstrap loaded: " + (typeof bootstrap !== "undefined"));
    seatDebug("userAgent: " + navigator.userAgent);

    try {
    const dataEl = document.getElementById("seat-booking-data");
    if (!dataEl) {
        throw new Error("Missing #seat-booking-data element");
    }
    const rawJson = dataEl.textContent.trim();
    seatDebug("JSON length: " + rawJson.length);
    let seatData;
    try {
        seatData = JSON.parse(rawJson);
        seatDebug("JSON parse OK: normalPrice=" + seatData.normalPrice + ", premiumPrice=" + seatData.premiumPrice + ", bookedSeats=" + (seatData.bookedSeats || []).length);
    } catch (parseErr) {
        seatDebug("JSON parse FAILED: " + parseErr.message, "ERROR");
        seatDebug("Raw JSON:\n" + rawJson, "ERROR");
        throw parseErr;
    }
    const bookedSeats = new Set(seatData.bookedSeats || []);
    const normalPrice = Number(seatData.normalPrice) || 0;
    const premiumPrice = Number(seatData.premiumPrice) || 0;

    const mainRows = [
        {row: "A", left: [16,15,14,13,12,11,10,9], right: [8,7,6,5,4,3,2,1], premium: false},
        {row: "B", left: [16,15,14,13,12,11,10,9], right: [8,7,6,5,4,3,2,1], premium: false},
        {row: "C", left: [16,15,14,13,12,11,10,9], right: [8,7,6,5,4,3,2,1], premium: false},
        {row: "D", left: [16,15,14,13,12,11,10,9], right: [8,7,6,5,4,3,2,1], premium: false},
        {row: "E", left: [16,15,14,13,12,11,10,9], right: [8,7,6,5,4,3,2,1], premium: false},
        {row: "F", left: [16,15,14,13,12,11,10,9], right: [8,7,6,5,4,3,2,1], premium: false},
        {row: "G", left: [16,15,14,13,12,11,10,9], right: [8,7,6,5,4,3,2,1], premium: false},
        {row: "H", left: [16,15,14,13,12,11,10,9], right: [8,7,6,5,4,3,2,1], premium: false},
        {row: "I", left: [18,17,16,15,14,13,12,11,10], right: [9,8,7,6,5,4,3,2,1], premium: true},
        {row: "J", left: [18,17,16,15,14,13,12,11,10], right: [9,8,7,6,5,4,3,2,1], premium: true},
        {row: "K", left: [18,17,16,15,14,13,12,11,10], right: [9,8,7,6,5,4,3,2,1], premium: true},
        {row: "L", left: [18,17,16,15,14,13,12,11,10], right: [9,8,7,6,5,4,3,2,1], premium: true}
    ];

    const frontRows = [
        {row: "M", left: [18,17,16,15,14,13,12,11,10], right: [9,8,7,6,5,4,3,2,1], premium: true},
        {row: "N", left: [18,17,16,15,14,13,12,11,10], right: [9,8,7,6,5,4,3,2,1], premium: true},
        {row: "BOX", left: [20,19,18,17,16,15,14,13,12,11], right: [10,9,8,7,6,5,4,3,2,1], premium: true}
    ];

    const seatGridMain = document.getElementById("seat-grid-main");
    const seatGridFront = document.getElementById("seat-grid-front");
    const seatLayoutShell = document.getElementById("seat-layout-shell");
    const seatSelectionsContainer = document.getElementById("seatSelectionsContainer");
    const selectedSeatLabels = document.getElementById("selectedSeatLabels");
    const selectedSeatAmount = document.getElementById("selectedSeatAmount");
    const selectedSeatView = document.getElementById("selectedSeatView");
    const calculatedPrice = document.getElementById("calculatedPrice");
    const bookingForm = document.getElementById("booking-form");
    const modalElement = document.getElementById("addToCartModal");
    const copySeatDebugBtn = document.getElementById("copySeatDebugBtn");

    const domCheck = {
        "seat-grid-main": !!seatGridMain,
        "seat-grid-front": !!seatGridFront,
        "seat-layout-shell": !!seatLayoutShell,
        "selectedSeatLabels": !!selectedSeatLabels,
        "selectedSeatAmount": !!selectedSeatAmount,
        "seatSelectionsContainer": !!seatSelectionsContainer,
        "booking-form": !!bookingForm,
        "addToCartModal": !!modalElement
    };
    seatDebug("DOM elements: " + JSON.stringify(domCheck));
    Object.keys(domCheck).forEach(function (id) {
        if (!domCheck[id]) {
            seatDebug("MISSING element: #" + id, "ERROR");
        }
    });

    if (copySeatDebugBtn) {
        copySeatDebugBtn.addEventListener("click", function () {
            const text = debugLines.join("\n");
            if (navigator.clipboard && navigator.clipboard.writeText) {
                navigator.clipboard.writeText(text).then(function () {
                    seatDebug("Log copied to clipboard");
                }).catch(function (err) {
                    seatDebug("Clipboard failed: " + err, "ERROR");
                });
            } else {
                seatDebug("Clipboard API not available — select text in box and copy manually", "ERROR");
            }
        });
    }

    const selectedSeats = new Map();

    function getSeatInfo(btn) {
        const seatCode = (btn.getAttribute("data-seat-code") || "").trim().toUpperCase();
        const seatType = (btn.getAttribute("data-seat-type") || "NORMAL").trim().toUpperCase();
        return { seatCode, seatType };
    }

    function updateSelectionSummary() {
        const seatTokens = [];
        let total = 0;
        for (const [seatCode, seatType] of selectedSeats.entries()) {
            seatTokens.push(seatCode + " (" + seatType + ")");
            total += seatType === "PREMIUM" ? premiumPrice : normalPrice;
        }
        const seatsText = seatTokens.length ? seatTokens.join(", ") : "No seats selected";
        const totalText = "LKR " + total.toFixed(2);
        if (selectedSeatLabels) selectedSeatLabels.textContent = seatsText;
        if (selectedSeatAmount) selectedSeatAmount.textContent = totalText;
        if (selectedSeatView) selectedSeatView.textContent = seatsText;
        if (calculatedPrice) calculatedPrice.textContent = totalText;
        seatDebug("updateSelectionSummary: count=" + selectedSeats.size + " text=\"" + seatsText + "\" total=\"" + totalText + "\"");
    }

    function renderHiddenSelections() {
        if (!seatSelectionsContainer) return;
        seatSelectionsContainer.innerHTML = "";
        for (const [seatCode, seatType] of selectedSeats.entries()) {
            const input = document.createElement("input");
            input.type = "hidden";
            input.name = "seatSelections";
            input.value = seatType + ":" + seatCode;
            seatSelectionsContainer.appendChild(input);
        }
    }

    function createSeatButton(row, seatNumber, premium) {
        const seatCode = row + seatNumber;
        const btn = document.createElement("button");
        btn.type = "button";
        btn.className = "seat-btn " + (premium ? "seat-premium" : "seat-normal");
        btn.textContent = seatNumber;
        btn.setAttribute("data-seat-code", seatCode);
        btn.setAttribute("data-seat-type", premium ? "PREMIUM" : "NORMAL");

        if (bookedSeats.has(seatCode)) {
            btn.classList.add("seat-booked");
            btn.disabled = true;
        }
        return btn;
    }

    function toggleSingleSeat(btn) {
        const { seatCode, seatType } = getSeatInfo(btn);
        if (!seatCode) {
            seatDebug("toggleSingleSeat: missing data-seat-code on button", "ERROR");
            return;
        }
        if (selectedSeats.has(seatCode)) {
            selectedSeats.delete(seatCode);
            btn.classList.remove("seat-selected");
        } else {
            selectedSeats.set(seatCode, seatType);
            btn.classList.add("seat-selected");
        }
        updateSelectionSummary();
    }

    function createBoxSeatPair(row, seatNumberOne, seatNumberTwo, premium) {
        const pairWrap = document.createElement("div");
        pairWrap.className = "box-seat-pair";

        const first = createSeatButton(row, seatNumberOne, premium);
        const second = createSeatButton(row, seatNumberTwo, premium);
        pairWrap.appendChild(first);
        pairWrap.appendChild(second);

        const seats = [first, second];
        const pairHasBookedSeat = seats.some((seat) => seat.disabled);

        if (pairHasBookedSeat) {
            seats.forEach((seat) => {
                seat.disabled = true;
                seat.classList.add("seat-booked");
            });
            pairWrap.classList.add("box-seat-pair-booked");
            return pairWrap;
        }

        return pairWrap;
    }

    function renderSection(grid, rowsToRender) {
        rowsToRender.forEach(({row, left, right, premium}) => {
            const rowWrap = document.createElement("div");
            rowWrap.className = "seat-row-wrap";

            const rowLabel = document.createElement("div");
            rowLabel.className = "seat-row-label";
            rowLabel.textContent = row;
            rowWrap.appendChild(rowLabel);

            const seatRow = document.createElement("div");
            seatRow.className = "seat-row split-row";
            if (row === "BOX") {
                seatRow.classList.add("box-row");
            }

            const leftBlock = document.createElement("div");
            leftBlock.className = "seat-block";
            if (row === "BOX") {
                for (let i = 0; i < left.length; i += 2) {
                    leftBlock.appendChild(createBoxSeatPair(row, left[i], left[i + 1], premium));
                }
            } else {
                left.forEach((seatNumber) => {
                    leftBlock.appendChild(createSeatButton(row, seatNumber, premium));
                });
            }

            const rightBlock = document.createElement("div");
            rightBlock.className = "seat-block";
            if (row === "BOX") {
                for (let i = 0; i < right.length; i += 2) {
                    rightBlock.appendChild(createBoxSeatPair(row, right[i], right[i + 1], premium));
                }
            } else {
                right.forEach((seatNumber) => {
                    rightBlock.appendChild(createSeatButton(row, seatNumber, premium));
                });
            }

            seatRow.appendChild(leftBlock);
            seatRow.appendChild(rightBlock);
            rowWrap.appendChild(seatRow);
            grid.appendChild(rowWrap);
        });
    }
    if (seatGridMain) renderSection(seatGridMain, mainRows);
    if (seatGridFront) renderSection(seatGridFront, frontRows);
    const seatBtnCount = document.querySelectorAll(".seat-btn").length;
    const sampleBtn = document.querySelector(".seat-btn");
    seatDebug("Seat buttons rendered: " + seatBtnCount);
    if (sampleBtn) {
        seatDebug("Sample seat data-seat-code=" + sampleBtn.getAttribute("data-seat-code"));
    }
    if (seatBtnCount === 0) {
        seatDebug("No seat buttons in DOM — grid did not render", "ERROR");
    }

    function toggleBoxPair(pair) {
        const seats = Array.from(pair.querySelectorAll(".seat-btn:not(:disabled)"));
        if (seats.length === 0) return;
        const allSelected = seats.every((seat) => selectedSeats.has(getSeatInfo(seat).seatCode));
        if (allSelected) {
            seats.forEach((seat) => {
                const { seatCode } = getSeatInfo(seat);
                if (seatCode) {
                    selectedSeats.delete(seatCode);
                }
                seat.classList.remove("seat-selected");
            });
        } else {
            seats.forEach((seat) => {
                const { seatCode, seatType } = getSeatInfo(seat);
                if (!seatCode) return;
                selectedSeats.set(seatCode, seatType);
                seat.classList.add("seat-selected");
            });
        }
        updateSelectionSummary();
    }

    if (seatLayoutShell) {
        seatLayoutShell.addEventListener("click", (event) => {
            const seatBtn = event.target.closest(".seat-btn");
            if (!seatBtn) {
                seatDebug("click ignored — not a seat");
                return;
            }
            if (seatBtn.disabled) {
                seatDebug("click ignored — seat booked/disabled");
                return;
            }
            const pair = seatBtn.closest(".box-seat-pair");
            const inBoxRow = !!seatBtn.closest(".box-row");
            seatDebug("seat click: " + getSeatInfo(seatBtn).seatCode + " boxRow=" + inBoxRow);
            if (pair && inBoxRow && !pair.classList.contains("box-seat-pair-booked")) {
                toggleBoxPair(pair);
                return;
            }
            toggleSingleSeat(seatBtn);
        });
        seatDebug("Click listener attached on #seat-layout-shell");
    } else {
        seatDebug("Cannot attach click listener — #seat-layout-shell missing", "ERROR");
    }

    if (modalElement) {
        modalElement.addEventListener("show.bs.modal", (event) => {
            seatDebug("modal show.bs.modal — selected count=" + selectedSeats.size);
            if (selectedSeats.size < 1) {
                event.preventDefault();
                seatDebug("modal blocked — no seats", "ERROR");
                alert("Please select at least one seat to proceed.");
                return;
            }
            updateSelectionSummary();
            renderHiddenSelections();
            const hiddenCount = seatSelectionsContainer ? seatSelectionsContainer.querySelectorAll('input[name="seatSelections"]').length : 0;
            seatDebug("hidden inputs before submit: " + hiddenCount);
        });
    } else {
        seatDebug("Modal element missing", "ERROR");
    }

    if (bookingForm) {
        bookingForm.addEventListener("submit", (event) => {
            seatDebug("form submit — selected count=" + selectedSeats.size);
            if (selectedSeats.size < 1) {
                event.preventDefault();
                seatDebug("submit blocked — no seats", "ERROR");
                alert("Please select at least one seat before adding to bookings.");
                return;
            }
            renderHiddenSelections();
        });
    }

    updateSelectionSummary();
    seatDebug("Init complete — click a seat and watch this log");
    } catch (err) {
        seatDebug("INIT FAILED: " + err.message, "ERROR");
        if (err.stack) {
            seatDebug(err.stack, "ERROR");
        }
    }
    }

    if (document.readyState === "loading") {
        document.addEventListener("DOMContentLoaded", initSeatBooking);
        seatDebug("Waiting for DOMContentLoaded (registered listener)");
    } else {
        seatDebug("Document already loaded — running init immediately");
        initSeatBooking();
    }
})();
</script>
</main>
<%@ include file="/WEB-INF/jsp/fragments/footer.jspf" %>
</body>
</html>
