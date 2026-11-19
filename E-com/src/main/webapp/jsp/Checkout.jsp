<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.util.List, in.co.rays.bean.CartBean, in.co.rays.bean.UserBean"%>
<%
    String error = (String) request.getAttribute("error");
    List<CartBean> list = (List<CartBean>) request.getAttribute("list");
    Double grandTotal = (Double) request.getAttribute("grandTotal");
    boolean buyNow = request.getAttribute("buyNow") != null;
    Object buyProductId = request.getAttribute("buyProductId");

    UserBean u = (UserBean) session.getAttribute("user");
    String fullName = request.getParameter("fullName") != null ? request.getParameter("fullName")
            : (u != null ? u.getFirstName() + " " + u.getLastName() : "");
    String mobile = request.getParameter("mobile") != null ? request.getParameter("mobile")
            : (u != null && u.getMobile() != null ? u.getMobile() : "");
    String address = request.getParameter("address") == null ? "" : request.getParameter("address");
    String city = request.getParameter("city") == null ? "" : request.getParameter("city");
    String pincode = request.getParameter("pincode") == null ? "" : request.getParameter("pincode");
%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>Checkout | ECommerce</title>
<style>
    body {
        margin: 0;
        background: #f7f6f2;
        color: #292536;
        font-family: Arial, sans-serif;
    }

    .checkout-page {
        width: min(100% - 2rem, 1120px);
        margin: 2rem auto 4rem;
    }

    .checkout-hero {
        position: relative;
        overflow: hidden;
        display: flex;
        align-items: flex-end;
        justify-content: space-between;
        gap: 1.5rem;
        margin-bottom: 1.5rem;
        padding: clamp(1.5rem, 5vw, 2.5rem);
        border-radius: 1.25rem;
        background: linear-gradient(115deg, #302342, #513d70 68%, #6d4e94);
        color: #fff;
        box-shadow: 0 16px 38px rgba(48, 35, 66, 0.18);
    }

    .checkout-hero::after {
        position: absolute;
        top: -5rem;
        right: 12%;
        width: 14rem;
        height: 14rem;
        border: 1px solid rgba(255, 222, 150, 0.26);
        border-radius: 50%;
        box-shadow: 0 0 0 2rem rgba(255, 222, 150, 0.05), 0 0 0 4rem rgba(255, 222, 150, 0.035);
        content: "";
        pointer-events: none;
    }

    .checkout-hero-copy,
    .checkout-steps {
        position: relative;
        z-index: 1;
    }

    .checkout-kicker {
        margin: 0 0 0.6rem;
        color: #f6d78e;
        font-size: 0.75rem;
        font-weight: 800;
        letter-spacing: 0.16em;
        text-transform: uppercase;
    }

    .checkout-hero h1 {
        margin: 0 0 0.45rem;
        font-size: clamp(2rem, 5vw, 2.8rem);
        letter-spacing: -0.05em;
    }

    .checkout-hero-copy > p:last-child {
        max-width: 34rem;
        margin: 0;
        color: #e0d9eb;
        line-height: 1.55;
    }

    .checkout-steps {
        display: flex;
        align-items: center;
        gap: 0.55rem;
        flex: 0 0 auto;
        color: #e5dfec;
        font-size: 0.78rem;
        font-weight: 700;
    }

    .checkout-step {
        display: inline-flex;
        align-items: center;
        gap: 0.4rem;
        white-space: nowrap;
    }

    .checkout-step-number {
        display: grid;
        width: 1.65rem;
        height: 1.65rem;
        place-items: center;
        border: 1px solid rgba(255, 255, 255, 0.35);
        border-radius: 50%;
        font-size: 0.72rem;
    }

    .checkout-step.active {
        color: #ffe4a0;
    }

    .checkout-step.active .checkout-step-number {
        border-color: #f2c65d;
        background: #f2c65d;
        color: #392b49;
    }

    .checkout-step-line {
        width: 1.2rem;
        height: 1px;
        background: rgba(255, 255, 255, 0.35);
    }

    .checkout-error {
        margin: 0 0 1.25rem;
        padding: 0.9rem 1rem;
        border: 1px solid #efc3bd;
        border-radius: 0.75rem;
        background: #fff0ee;
        color: #a32d22;
        line-height: 1.5;
    }

    .checkout-layout {
        display: grid;
        grid-template-columns: minmax(0, 1.2fr) minmax(300px, 0.8fr);
        align-items: start;
        gap: 1.25rem;
    }

    .checkout-main {
        display: grid;
        gap: 1.1rem;
        min-width: 0;
    }

    .checkout-card {
        min-width: 0;
        padding: clamp(1.1rem, 3vw, 1.6rem);
        border: 1px solid #ebe8e2;
        border-radius: 1rem;
        background: #fff;
        box-shadow: 0 5px 20px rgba(45, 37, 55, 0.045);
    }

    .checkout-card-heading {
        display: flex;
        align-items: flex-start;
        gap: 0.8rem;
        margin-bottom: 1.35rem;
    }

    .checkout-heading-mark {
        display: grid;
        width: 2.4rem;
        height: 2.4rem;
        flex: 0 0 auto;
        place-items: center;
        border-radius: 0.75rem;
        background: #f1e9fb;
        color: #714aa2;
        font-size: 1rem;
        font-weight: 800;
    }

    .checkout-card-heading h2 {
        margin: 0 0 0.25rem;
        color: #302342;
        font-size: 1.15rem;
    }

    .checkout-card-heading p {
        margin: 0;
        color: #77727f;
        font-size: 0.86rem;
        line-height: 1.45;
    }

    .checkout-fields {
        display: grid;
        grid-template-columns: repeat(2, minmax(0, 1fr));
        gap: 1rem;
    }

    .checkout-field {
        display: grid;
        min-width: 0;
        gap: 0.42rem;
    }

    .checkout-field.full-width {
        grid-column: 1 / -1;
    }

    .checkout-field label {
        color: #494452;
        font-size: 0.83rem;
        font-weight: 750;
    }

    .checkout-field input {
        box-sizing: border-box;
        width: 100%;
        min-height: 48px;
        padding: 0.75rem 0.85rem;
        border: 1px solid #dedbe4;
        border-radius: 0.65rem;
        outline: none;
        background: #fdfcfe;
        color: #302b39;
        font: inherit;
        font-size: 0.92rem;
        transition: border-color 0.18s ease, box-shadow 0.18s ease, background-color 0.18s ease;
    }

    .checkout-field input:focus {
        border-color: #9c78c5;
        background: #fff;
        box-shadow: 0 0 0 3px rgba(156, 120, 197, 0.15);
    }

    .payment-choice {
        display: flex;
        align-items: center;
        gap: 0.9rem;
        padding: 1rem;
        border: 1px solid #e8e1f1;
        border-radius: 0.8rem;
        background: linear-gradient(110deg, #fcfaff, #fffdf7);
    }

    .payment-icon {
        display: grid;
        width: 2.6rem;
        height: 2.6rem;
        flex: 0 0 auto;
        place-items: center;
        border-radius: 0.75rem;
        background: #fff1c9;
        color: #8a6413;
        font-size: 1.2rem;
    }

    .payment-choice strong {
        display: block;
        margin-bottom: 0.2rem;
        color: #302342;
        font-size: 0.9rem;
    }

    .payment-choice span {
        color: #77727f;
        font-size: 0.82rem;
    }

    .checkout-back-link {
        display: inline-flex;
        align-items: center;
        gap: 0.4rem;
        margin: 0.1rem 0.25rem;
        color: #69478f;
        font-size: 0.88rem;
        font-weight: 750;
        text-decoration: none;
    }

    .checkout-back-link:hover,
    .checkout-back-link:focus {
        color: #3d2859;
        text-decoration: underline;
    }

    .checkout-summary {
        position: sticky;
        top: 1rem;
    }

    .checkout-summary .checkout-card-heading {
        margin-bottom: 1rem;
    }

    .checkout-item-list {
        display: grid;
        gap: 0.85rem;
    }

    .checkout-item {
        display: grid;
        grid-template-columns: 68px minmax(0, 1fr) auto;
        align-items: center;
        gap: 0.75rem;
        padding-bottom: 0.85rem;
        border-bottom: 1px solid #f0edf2;
    }

    .checkout-item-image,
    .checkout-item-placeholder {
        display: grid;
        box-sizing: border-box;
        width: 68px;
        height: 68px;
        place-items: center;
        overflow: hidden;
        border-radius: 0.75rem;
        background: #f7f4fa;
        color: #8c8494;
        font-size: 0.68rem;
        text-align: center;
    }

    .checkout-item-image {
        object-fit: contain;
    }

    .checkout-item-info {
        min-width: 0;
    }

    .checkout-item-name {
        display: block;
        margin-bottom: 0.35rem;
        color: #352e40;
        font-size: 0.9rem;
        font-weight: 750;
        line-height: 1.35;
        overflow-wrap: anywhere;
    }

    .checkout-item-unit {
        color: #77727f;
        font-size: 0.78rem;
    }

    .checkout-item-unit s {
        margin-left: 0.25rem;
        color: #a5a0aa;
    }

    .checkout-item-total {
        color: #49365f;
        font-size: 0.88rem;
        font-weight: 800;
        white-space: nowrap;
    }

    .checkout-quantity {
        display: flex;
        flex-wrap: wrap;
        align-items: center;
        gap: 0.55rem;
        padding: 0.1rem 0 0.9rem;
        border-bottom: 1px solid #f0edf2;
    }

    .checkout-quantity label {
        margin-right: auto;
        color: #5d5666;
        font-size: 0.82rem;
        font-weight: 700;
    }

    .checkout-quantity input[type="number"] {
        box-sizing: border-box;
        width: 76px;
        min-height: 38px;
        padding: 0.4rem;
        border: 1px solid #dedbe4;
        border-radius: 0.55rem;
        font: inherit;
        text-align: center;
    }

    .update-quantity-button {
        min-height: 38px;
        padding: 0.4rem 0.65rem;
        border: 1px solid #ded3ec;
        border-radius: 0.55rem;
        background: #f8f3ff;
        color: #69478f;
        font-size: 0.78rem;
        font-weight: 750;
        cursor: pointer;
    }

    .update-quantity-button:hover {
        background: #eee3fb;
    }

    .checkout-totals {
        display: grid;
        gap: 0.7rem;
        padding: 1rem 0;
    }

    .checkout-total-row {
        display: flex;
        justify-content: space-between;
        gap: 1rem;
        color: #746e7c;
        font-size: 0.86rem;
    }

    .checkout-total-row strong {
        color: #40394a;
        font-weight: 750;
    }

    .checkout-grand-total {
        display: flex;
        align-items: baseline;
        justify-content: space-between;
        gap: 1rem;
        padding-top: 0.9rem;
        border-top: 1px dashed #ded9e3;
    }

    .checkout-grand-total span {
        color: #393244;
        font-size: 0.95rem;
        font-weight: 800;
    }

    .checkout-grand-total strong {
        color: #39264f;
        font-size: 1.35rem;
        letter-spacing: -0.03em;
    }

    .place-order-button {
        width: 100%;
        min-height: 52px;
        padding: 0.8rem 1rem;
        border: 0;
        border-radius: 0.75rem;
        background: linear-gradient(110deg, #f3cb6b, #eab94e);
        box-shadow: 0 8px 18px rgba(201, 151, 44, 0.2);
        color: #3f2b0d;
        font: inherit;
        font-size: 0.95rem;
        font-weight: 850;
        cursor: pointer;
        transition: transform 0.18s ease, box-shadow 0.18s ease, opacity 0.18s ease;
    }

    .place-order-button:hover,
    .place-order-button:focus {
        transform: translateY(-2px);
        box-shadow: 0 11px 22px rgba(201, 151, 44, 0.28);
    }

    .place-order-button.is-submitting {
        cursor: wait;
        opacity: 0.7;
        pointer-events: none;
    }

    .order-submit-status {
        display: block;
        min-height: 1.2em;
        margin-top: 0.45rem;
        color: #594700;
        font-size: 0.82rem;
        text-align: center;
    }

    .checkout-assurance {
        display: flex;
        align-items: center;
        justify-content: center;
        gap: 0.4rem;
        margin: 0.8rem 0 0;
        color: #817b87;
        font-size: 0.76rem;
        text-align: center;
    }

    @media (max-width: 900px) {
        .checkout-layout {
            grid-template-columns: minmax(0, 1fr) minmax(280px, 0.85fr);
        }

        .checkout-hero {
            align-items: flex-start;
            flex-direction: column;
        }
    }

    @media (max-width: 700px) {
        .checkout-page {
            width: min(100% - 1rem, 620px);
            margin: 1rem auto 2.5rem;
        }

        .checkout-hero {
            gap: 1.2rem;
            padding: 1.35rem;
            border-radius: 1rem;
        }

        .checkout-steps {
            width: 100%;
            justify-content: space-between;
            gap: 0.25rem;
            font-size: 0.69rem;
        }

        .checkout-step {
            gap: 0.3rem;
        }

        .checkout-step-number {
            width: 1.45rem;
            height: 1.45rem;
        }

        .checkout-step-line {
            flex: 1;
            max-width: 1.2rem;
        }

        .checkout-layout {
            grid-template-columns: minmax(0, 1fr);
        }

        .checkout-summary {
            position: static;
        }
    }

    @media (max-width: 420px) {
        .checkout-fields {
            grid-template-columns: minmax(0, 1fr);
        }

        .checkout-field.full-width {
            grid-column: auto;
        }

        .checkout-item {
            grid-template-columns: 56px minmax(0, 1fr) auto;
            gap: 0.55rem;
        }

        .checkout-item-image,
        .checkout-item-placeholder {
            width: 56px;
            height: 56px;
        }

        .checkout-item-total {
            font-size: 0.8rem;
        }
    }
</style>
</head>
<body>
    <%@ include file="Header.jsp" %>

    <main class="checkout-page">
        <header class="checkout-hero">
            <div class="checkout-hero-copy">
                <p class="checkout-kicker">One last step</p>
                <h1>Make it yours</h1>
                <p>Confirm your delivery details and we'll take care of the rest.</p>
            </div>
            <div class="checkout-steps" aria-label="Checkout progress">
                <span class="checkout-step"><span class="checkout-step-number">1</span> Cart</span>
                <span class="checkout-step-line" aria-hidden="true"></span>
                <span class="checkout-step active" aria-current="step"><span class="checkout-step-number">2</span> Details</span>
                <span class="checkout-step-line" aria-hidden="true"></span>
                <span class="checkout-step"><span class="checkout-step-number">3</span> Done</span>
            </div>
        </header>

        <% if (error != null) { %>
            <p class="checkout-error" role="alert"><%=error%></p>
        <% } %>

        <form id="checkoutForm" action="<%=request.getContextPath()%>/OrderCtl" method="post">
            <% if (buyNow && list != null && !list.isEmpty()) { %>
                <input type="hidden" name="productId" value="<%=buyProductId%>">
            <% } %>

            <div class="checkout-layout">
                <div class="checkout-main">
                    <section class="checkout-card" aria-labelledby="delivery-title">
                        <div class="checkout-card-heading">
                            <span class="checkout-heading-mark" aria-hidden="true">01</span>
                            <div>
                                <h2 id="delivery-title">Delivery details</h2>
                                <p>Where should we send your order?</p>
                            </div>
                        </div>

                        <div class="checkout-fields">
                            <div class="checkout-field full-width">
                                <label for="fullName">Full name</label>
                                <input id="fullName" type="text" name="fullName" autocomplete="name" value="<%=fullName%>">
                            </div>
                            <div class="checkout-field">
                                <label for="mobile">Mobile number</label>
                                <input id="mobile" type="tel" name="mobile" maxlength="10" inputmode="numeric"
                                       autocomplete="tel" value="<%=mobile%>">
                            </div>
                            <div class="checkout-field">
                                <label for="pincode">Pincode</label>
                                <input id="pincode" type="text" name="pincode" maxlength="6" inputmode="numeric"
                                       autocomplete="postal-code" value="<%=pincode%>">
                            </div>
                            <div class="checkout-field full-width">
                                <label for="address">Street address</label>
                                <input id="address" type="text" name="address" autocomplete="street-address"
                                       placeholder="House number, street, area" value="<%=address%>">
                            </div>
                            <div class="checkout-field full-width">
                                <label for="city">City</label>
                                <input id="city" type="text" name="city" autocomplete="address-level2" value="<%=city%>">
                            </div>
                        </div>
                    </section>

                    <section class="checkout-card" aria-labelledby="payment-title">
                        <div class="checkout-card-heading">
                            <span class="checkout-heading-mark" aria-hidden="true">02</span>
                            <div>
                                <h2 id="payment-title">Payment method</h2>
                                <p>Simple, secure, and ready when your order arrives.</p>
                            </div>
                        </div>
                        <div class="payment-choice">
                            <span class="payment-icon" aria-hidden="true">Rs</span>
                            <div>
                                <strong>Cash on Delivery</strong>
                                <span>Pay in cash when your order reaches you</span>
                            </div>
                        </div>
                    </section>

                    <a class="checkout-back-link" href="<%=request.getContextPath()%>/<%=buyNow ? "ShopCtl" : "CartCtl"%>">
                        <span aria-hidden="true">&larr;</span>
                        <%=buyNow ? "Back to shop" : "Back to cart"%>
                    </a>
                </div>

                <aside class="checkout-card checkout-summary" aria-labelledby="summary-title">
                    <div class="checkout-card-heading">
                        <span class="checkout-heading-mark" aria-hidden="true">03</span>
                        <div>
                            <h2 id="summary-title">Your order</h2>
                            <p><%=list == null ? 0 : list.size()%> item<%=list != null && list.size() == 1 ? "" : "s"%> in your bag</p>
                        </div>
                    </div>

                    <div class="checkout-item-list">
                        <% if (list != null) {
                            for (CartBean c : list) { %>
                                <article class="checkout-item">
                                    <% if (c.getImage() != null && !c.getImage().isEmpty()) { %>
                                        <img class="checkout-item-image"
                                             src="<%=request.getContextPath()%>/ImageCtl?name=<%=c.getImage()%>"
                                             alt="<%=c.getProductName()%>">
                                    <% } else { %>
                                        <div class="checkout-item-placeholder" aria-hidden="true">Image<br>coming soon</div>
                                    <% } %>
                                    <div class="checkout-item-info">
                                        <strong class="checkout-item-name"><%=c.getProductName()%></strong>
                                        <span class="checkout-item-unit">
                                            Qty <%=c.getQuantity()%> &middot; Rs. <%=c.getDiscountPrice()%> each
                                            <% if (c.getDiscountPercent() > 0) { %>
                                                <s>Rs. <%=c.getPrice()%></s>
                                            <% } %>
                                        </span>
                                    </div>
                                    <strong class="checkout-item-total">Rs. <%=c.getTotal()%></strong>
                                </article>
                            <% }
                        } %>
                    </div>

                    <% if (buyNow && list != null && !list.isEmpty()) { %>
                        <div class="checkout-quantity">
                            <label for="quantity">Adjust quantity</label>
                            <input id="quantity" type="number" name="quantity" min="1"
                                   max="<%=list.get(0).getStock()%>" value="<%=list.get(0).getQuantity()%>">
                            <button class="update-quantity-button" type="submit" name="operation" value="Update Qty">
                                Update
                            </button>
                        </div>
                    <% } %>

                    <div class="checkout-totals">
                        <div class="checkout-total-row">
                            <span>Items subtotal</span>
                            <strong>Rs. <%=grandTotal == null ? 0 : grandTotal%></strong>
                        </div>
                        <div class="checkout-total-row">
                            <span>Delivery</span>
                            <strong>Free</strong>
                        </div>
                        <div class="checkout-grand-total">
                            <span>Total</span>
                            <strong>Rs. <%=grandTotal == null ? 0 : grandTotal%></strong>
                        </div>
                    </div>

                    <input class="place-order-button" type="submit" name="operation" value="Place Order">
                    <span class="order-submit-status" id="orderSubmitStatus" role="status" aria-live="polite"></span>
                    <p class="checkout-assurance"><span aria-hidden="true">&#10003;</span> Your order is safe and secure</p>
                </aside>
            </div>
        </form>
    </main>

    <%@ include file="Footer.jsp" %>

    <script>
        (function () {
            var form = document.getElementById("checkoutForm");
            var submittingOrder = false;

            form.addEventListener("submit", function (event) {
                var button = event.submitter;
                if (!button || button.name !== "operation" || button.value !== "Place Order") {
                    return;
                }
                if (submittingOrder) {
                    event.preventDefault();
                    return;
                }

                submittingOrder = true;
                button.classList.add("is-submitting");
                button.setAttribute("aria-disabled", "true");
                document.getElementById("orderSubmitStatus").textContent = "Placing order...";
            });
        }());
    </script>
</body>
</html>
