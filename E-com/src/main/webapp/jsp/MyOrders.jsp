<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.util.List, in.co.rays.bean.OrderBean, in.co.rays.bean.OrderItemBean"%>
<%
    String error = (String) request.getAttribute("error");
    List<OrderBean> list = (List<OrderBean>) request.getAttribute("list");
    String placed = request.getParameter("placed");
    String celebrationOrderId = null;
    if (placed != null && list != null) {
        for (OrderBean order : list) {
            if (String.valueOf(order.getId()).equals(placed)) {
                celebrationOrderId = placed;
                break;
            }
        }
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>My Orders | ECommerce</title>
<style>
    body {
        margin: 0;
        background: #f7f6f2;
        color: #24251f;
        font-family: Arial, sans-serif;
    }

    .orders-page {
        width: min(100% - 2rem, 1020px);
        margin: 2.5rem auto 4rem;
    }

    .orders-hero {
        position: relative;
        overflow: hidden;
        margin-bottom: 1.5rem;
        padding: clamp(1.5rem, 5vw, 3rem);
        border-radius: 1.25rem;
        background: #282719;
        color: #fffdf5;
        box-shadow: 0 16px 38px rgba(39, 38, 27, 0.13);
    }

    .orders-hero::after {
        position: absolute;
        top: -5rem;
        right: -2rem;
        width: 18rem;
        height: 18rem;
        border: 1px solid rgba(255, 212, 59, 0.24);
        border-radius: 50%;
        box-shadow: 0 0 0 2.5rem rgba(255, 212, 59, 0.05), 0 0 0 5rem rgba(255, 212, 59, 0.035);
        content: "";
        pointer-events: none;
    }

    .orders-kicker {
        margin: 0 0 0.75rem;
        color: #ffd43b;
        font-size: 0.76rem;
        font-weight: 800;
        letter-spacing: 0.16em;
        text-transform: uppercase;
    }

    .orders-hero h1 {
        position: relative;
        z-index: 1;
        margin: 0 0 0.55rem;
        font-size: clamp(2rem, 5vw, 3rem);
        letter-spacing: -0.045em;
    }

    .orders-hero p:last-child {
        position: relative;
        z-index: 1;
        max-width: 34rem;
        margin: 0;
        color: #d3d1c5;
        line-height: 1.6;
    }

    .orders-alert {
        margin: 0 0 1rem;
        padding: 1rem 1.15rem;
        border: 1px solid transparent;
        border-radius: 0.8rem;
        line-height: 1.5;
    }

    .orders-alert.success {
        border-color: #b7dfc2;
        background: #edf8ef;
        color: #236239;
    }

    .orders-alert.error {
        border-color: #f0c4be;
        background: #fff0ee;
        color: #9c3025;
    }

    .orders-section-heading {
        display: flex;
        flex-wrap: wrap;
        align-items: baseline;
        justify-content: space-between;
        gap: 0.5rem 1rem;
        margin: 2rem 0 1rem;
    }

    .orders-section-heading h2 {
        margin: 0;
        font-size: 1.2rem;
    }

    .orders-count {
        color: #77776e;
        font-size: 0.9rem;
    }

    .order-card {
        overflow: hidden;
        margin-bottom: 1.15rem;
        border: 1px solid #e8e6dc;
        border-radius: 1rem;
        background: #fff;
        box-shadow: 0 5px 18px rgba(42, 40, 28, 0.045);
    }

    .order-topline {
        display: flex;
        flex-wrap: wrap;
        align-items: center;
        justify-content: space-between;
        gap: 0.75rem;
        padding: 1.15rem 1.35rem;
        background: #fcfbf7;
        border-bottom: 1px solid #efeee8;
    }

    .order-id {
        margin: 0;
        font-size: 1rem;
        font-weight: 800;
    }

    .order-date {
        display: block;
        margin-top: 0.3rem;
        color: #77776e;
        font-size: 0.85rem;
    }

    .order-status {
        display: inline-flex;
        align-items: center;
        gap: 0.45rem;
        padding: 0.42rem 0.7rem;
        border-radius: 999px;
        background: #fff4bf;
        color: #594700;
        font-size: 0.8rem;
        font-weight: 750;
    }

    .order-status::before {
        width: 0.42rem;
        height: 0.42rem;
        border-radius: 50%;
        background: #d49a00;
        content: "";
    }

    .order-meta {
        display: grid;
        grid-template-columns: minmax(0, 1fr) minmax(0, 1.4fr);
        gap: 1.25rem;
        padding: 1.15rem 1.35rem;
        border-bottom: 1px solid #efeee8;
    }

    .order-meta-label {
        display: block;
        margin-bottom: 0.4rem;
        color: #85847a;
        font-size: 0.72rem;
        font-weight: 800;
        letter-spacing: 0.08em;
        text-transform: uppercase;
    }

    .order-meta-value {
        color: #35352d;
        font-size: 0.9rem;
        line-height: 1.55;
        overflow-wrap: anywhere;
    }

    .order-items-wrap {
        overflow-x: auto;
        padding: 0 1.35rem;
    }

    .order-items {
        width: 100%;
        min-width: 470px;
        border-collapse: collapse;
        text-align: left;
    }

    .order-items th {
        padding: 0.9rem 0.45rem;
        color: #85847a;
        font-size: 0.7rem;
        font-weight: 800;
        letter-spacing: 0.08em;
        text-transform: uppercase;
    }

    .order-items td {
        padding: 0.85rem 0.45rem;
        border-top: 1px solid #f0efe9;
        font-size: 0.9rem;
    }

    .order-items th:not(:first-child),
    .order-items td:not(:first-child) {
        text-align: right;
        white-space: nowrap;
    }

    .order-items .item-name {
        font-weight: 700;
        overflow-wrap: anywhere;
    }

    .order-total {
        display: flex;
        align-items: center;
        justify-content: space-between;
        gap: 1rem;
        margin: 0 1.35rem;
        padding: 1rem 0 1.2rem;
        border-top: 1px solid #efeee8;
    }

    .order-total span {
        color: #68685f;
        font-size: 0.9rem;
        font-weight: 650;
    }

    .order-total strong {
        color: #282719;
        font-size: 1.15rem;
    }

    .orders-empty {
        padding: 3.5rem 1.5rem;
        border: 1px dashed #d8d5c8;
        border-radius: 1rem;
        background: #fff;
        text-align: center;
    }

    .empty-mark {
        display: grid;
        width: 3.5rem;
        height: 3.5rem;
        margin: 0 auto 1rem;
        place-items: center;
        border-radius: 1.1rem;
        background: #fff4bf;
        color: #594700;
        font-size: 1.65rem;
    }

    .orders-empty h2 {
        margin: 0 0 0.45rem;
        font-size: 1.25rem;
    }

    .orders-empty p {
        margin: 0 0 1.25rem;
        color: #77776e;
        line-height: 1.5;
    }

    .orders-shop-link {
        display: inline-block;
        padding: 0.75rem 1.1rem;
        border-radius: 0.65rem;
        background: #ffd43b;
        color: #302700;
        font-weight: 800;
        text-decoration: none;
        transition: background-color 0.18s ease, transform 0.18s ease;
    }

    .orders-shop-link:hover,
    .orders-shop-link:focus {
        transform: translateY(-1px);
        background: #ffca13;
        color: #302700;
    }

    .celebration-overlay {
        position: fixed;
        z-index: 2000;
        inset: 0;
        display: grid;
        overflow-y: auto;
        place-items: center;
        padding: 1rem;
        background: rgba(25, 19, 39, 0.62);
        backdrop-filter: blur(8px);
        animation: celebration-fade-in 0.35s ease both;
    }

    .celebration-overlay[hidden] {
        display: none;
    }

    .celebration-modal {
        position: relative;
        z-index: 2;
        width: min(100%, 500px);
        overflow: hidden;
        padding: 2rem clamp(1.25rem, 5vw, 2.5rem) 2rem;
        border: 1px solid rgba(255, 255, 255, 0.75);
        border-radius: 1.65rem;
        background:
            radial-gradient(ellipse at 50% 0, rgba(255, 231, 173, 0.45), transparent 42%),
            linear-gradient(145deg, #fffdfa 0%, #fff8f1 52%, #f8f2ff 100%);
        box-shadow: 0 28px 90px rgba(20, 12, 35, 0.32);
        text-align: center;
        animation: celebration-pop-in 0.55s cubic-bezier(0.18, 0.85, 0.25, 1.2) both;
    }

    .celebration-close {
        position: absolute;
        z-index: 2;
        top: 0.85rem;
        right: 0.85rem;
        display: grid;
        width: 2.4rem;
        height: 2.4rem;
        place-items: center;
        border: 1px solid #eee7dc;
        border-radius: 50%;
        background: rgba(255, 255, 255, 0.8);
        color: #5f5969;
        font-size: 1.4rem;
        line-height: 1;
        cursor: pointer;
        transition: background-color 0.18s ease, transform 0.18s ease;
    }

    .celebration-close:hover {
        transform: rotate(90deg);
        background: #fff;
    }

    .celebration-art {
        position: relative;
        display: grid;
        height: 205px;
        margin: 0 auto 0.4rem;
        place-items: center;
        isolation: isolate;
    }

    .celebration-glow {
        position: absolute;
        z-index: -1;
        width: 170px;
        height: 170px;
        border-radius: 50%;
        background: radial-gradient(circle, rgba(255, 213, 107, 0.44), rgba(207, 183, 255, 0.18) 58%, transparent 72%);
        animation: celebration-glow 2.8s ease-in-out infinite;
    }

    .celebration-check {
        position: absolute;
        z-index: 1;
        top: 0.15rem;
        left: calc(50% + 45px);
        display: grid;
        width: 58px;
        height: 58px;
        place-items: center;
        border: 4px solid #fffdfa;
        border-radius: 50%;
        background: linear-gradient(145deg, #a879ff, #7044d8);
        box-shadow: 0 8px 20px rgba(112, 68, 216, 0.32);
        animation: check-pop-in 0.5s 0.42s cubic-bezier(0.2, 1.4, 0.4, 1) both;
    }

    .celebration-check svg {
        width: 29px;
        height: 29px;
        overflow: visible;
    }

    .celebration-check path {
        fill: none;
        stroke: #fff;
        stroke-dasharray: 30;
        stroke-dashoffset: 30;
        stroke-linecap: round;
        stroke-linejoin: round;
        stroke-width: 3.5;
        animation: draw-check 0.4s 0.82s ease forwards;
    }

    .gift {
        position: relative;
        width: 128px;
        height: 112px;
        margin-top: 40px;
        animation: gift-bounce 0.85s 0.15s cubic-bezier(0.2, 0.8, 0.3, 1.2) both;
    }

    .gift-box {
        position: absolute;
        right: 8px;
        bottom: 0;
        left: 8px;
        height: 76px;
        overflow: hidden;
        border: 1px solid rgba(85, 46, 153, 0.25);
        border-radius: 10px 10px 15px 15px;
        background: linear-gradient(115deg, #a981ed 0%, #8759d9 48%, #7046be 100%);
        box-shadow: 0 13px 22px rgba(106, 69, 175, 0.22);
    }

    .gift-box::before {
        position: absolute;
        inset: 0 auto 0 50%;
        width: 19px;
        transform: translateX(-50%);
        background: linear-gradient(90deg, #ffd978, #ffe9a8, #f3bd45);
        content: "";
    }

    .gift-box::after {
        position: absolute;
        inset: 13px 0 auto;
        height: 4px;
        background: rgba(255, 255, 255, 0.19);
        content: "";
    }

    .gift-lid {
        position: absolute;
        z-index: 2;
        top: 17px;
        right: 1px;
        left: 1px;
        height: 24px;
        border: 1px solid rgba(85, 46, 153, 0.28);
        border-radius: 7px;
        background: linear-gradient(110deg, #b997f4, #9068e1 62%, #8054d0);
        box-shadow: 0 5px 8px rgba(75, 43, 125, 0.16);
        transform-origin: 12% 100%;
        animation: gift-open 0.72s 0.65s cubic-bezier(0.2, 0.75, 0.2, 1) both;
    }

    .gift-lid::after {
        position: absolute;
        top: 0;
        bottom: 0;
        left: 50%;
        width: 19px;
        transform: translateX(-50%);
        background: linear-gradient(90deg, #ffd978, #ffe9a8, #f3bd45);
        content: "";
    }

    .gift-bow {
        position: absolute;
        z-index: 3;
        top: 0;
        left: 50%;
        width: 56px;
        height: 27px;
        transform: translateX(-50%);
    }

    .gift-bow::before,
    .gift-bow::after {
        position: absolute;
        top: 3px;
        width: 28px;
        height: 19px;
        border: 5px solid #f3bd45;
        border-radius: 50% 50% 45% 45%;
        content: "";
    }

    .gift-bow::before {
        left: 0;
        transform: rotate(25deg);
    }

    .gift-bow::after {
        right: 0;
        transform: rotate(-25deg);
    }

    .gift-burst {
        position: absolute;
        z-index: 4;
        top: 50px;
        left: 50%;
        width: 7px;
        height: 11px;
        border-radius: 2px;
        background: var(--burst-color);
        opacity: 0;
        animation: gift-burst 1s 0.95s ease-out both;
        animation-delay: calc(0.95s + var(--burst-delay));
    }

    .celebration-caption {
        margin: 0 0 0.65rem;
        color: #8251c8;
        font-size: 0.72rem;
        font-weight: 850;
        letter-spacing: 0.16em;
        text-transform: uppercase;
    }

    .celebration-modal h2 {
        margin: 0 auto 0.55rem;
        color: #2e2342;
        font-size: clamp(1.8rem, 6vw, 2.35rem);
        letter-spacing: -0.05em;
        line-height: 1.1;
    }

    .celebration-subtitle {
        margin: 0 0 1.2rem;
        color: #765d90;
        font-size: 1.05rem;
        font-weight: 650;
    }

    .celebration-order {
        display: inline-flex;
        align-items: center;
        gap: 0.5rem;
        max-width: 100%;
        margin-bottom: 0.8rem;
        padding: 0.58rem 0.9rem;
        border: 1px solid #eadcfb;
        border-radius: 999px;
        background: rgba(255, 255, 255, 0.78);
        color: #644291;
        font-size: 0.88rem;
        font-weight: 800;
        overflow-wrap: anywhere;
    }

    .celebration-order::before {
        width: 0.5rem;
        height: 0.5rem;
        flex: 0 0 auto;
        border-radius: 50%;
        background: #b98af2;
        content: "";
    }

    .celebration-message {
        max-width: 340px;
        margin: 0 auto 1.5rem;
        color: #70687b;
        font-size: 0.93rem;
        line-height: 1.6;
    }

    .celebration-actions {
        display: grid;
        grid-template-columns: 1fr 1fr;
        gap: 0.7rem;
    }

    .celebration-button {
        display: inline-flex;
        min-height: 48px;
        align-items: center;
        justify-content: center;
        padding: 0.7rem 0.8rem;
        border: 1px solid transparent;
        border-radius: 0.75rem;
        font-size: 0.9rem;
        font-weight: 800;
        text-decoration: none;
        transition: transform 0.18s ease, box-shadow 0.18s ease, background-color 0.18s ease;
    }

    .celebration-button:hover,
    .celebration-button:focus {
        transform: translateY(-2px);
        box-shadow: 0 9px 18px rgba(80, 52, 127, 0.15);
    }

    .celebration-button.primary {
        background: linear-gradient(110deg, #f5cb67, #f1b94c);
        color: #49320b;
    }

    .celebration-button.secondary {
        border-color: #dfd1f3;
        background: rgba(255, 255, 255, 0.72);
        color: #69469b;
    }

    .celebration-confetti {
        position: fixed;
        z-index: 1;
        top: -12vh;
        left: var(--confetti-x);
        width: var(--confetti-size);
        height: calc(var(--confetti-size) * 1.65);
        border-radius: 2px;
        background: var(--confetti-color);
        opacity: 0;
        pointer-events: none;
        animation: confetti-fall var(--confetti-duration) var(--confetti-delay) cubic-bezier(0.2, 0.65, 0.4, 1) both;
    }

    .celebration-confetti.strip {
        width: calc(var(--confetti-size) * 0.55);
        height: calc(var(--confetti-size) * 2.8);
        border-radius: 999px;
    }

    .celebration-confetti.star {
        width: auto;
        height: auto;
        background: none;
        color: var(--confetti-color);
        font-size: calc(var(--confetti-size) * 2.2);
    }

    .celebration-confetti.star::before {
        content: "✦";
    }

    .celebration-confetti.heart {
        width: auto;
        height: auto;
        background: none;
        color: var(--confetti-color);
        font-size: calc(var(--confetti-size) * 1.8);
    }

    .celebration-confetti.heart::before {
        content: "♥";
    }

    @keyframes celebration-fade-in {
        from { opacity: 0; }
        to { opacity: 1; }
    }

    @keyframes celebration-pop-in {
        from { opacity: 0; transform: translateY(24px) scale(0.94); }
        to { opacity: 1; transform: translateY(0) scale(1); }
    }

    @keyframes celebration-glow {
        0%, 100% { transform: scale(0.92); opacity: 0.7; }
        50% { transform: scale(1.08); opacity: 1; }
    }

    @keyframes gift-bounce {
        0% { opacity: 0; transform: translateY(16px) scale(0.8); }
        65% { opacity: 1; transform: translateY(-5px) scale(1.04); }
        100% { transform: translateY(0) scale(1); }
    }

    @keyframes gift-open {
        0% { transform: translate(0, 0) rotate(0); }
        70% { transform: translate(-8px, -38px) rotate(-17deg); }
        100% { transform: translate(-5px, -30px) rotate(-12deg); }
    }

    @keyframes gift-burst {
        0% { opacity: 1; transform: translate(0, 0) rotate(0) scale(1); }
        100% { opacity: 0; transform: translate(var(--burst-x), var(--burst-y)) rotate(220deg) scale(0.55); }
    }

    @keyframes check-pop-in {
        from { opacity: 0; transform: scale(0.3) rotate(-24deg); }
        to { opacity: 1; transform: scale(1) rotate(0); }
    }

    @keyframes draw-check {
        to { stroke-dashoffset: 0; }
    }

    @keyframes confetti-fall {
        0% { opacity: 0; transform: translate3d(0, -5vh, 0) rotate(0); }
        8% { opacity: 1; }
        100% { opacity: 0.9; transform: translate3d(var(--confetti-drift), 118vh, 0) rotate(var(--confetti-rotate)); }
    }

    @media (max-width: 600px) {
        .orders-page {
            width: min(100% - 1rem, 1020px);
            margin: 1rem auto 2.5rem;
        }

        .orders-hero {
            border-radius: 1rem;
        }

        .order-topline,
        .order-meta {
            padding-right: 1rem;
            padding-left: 1rem;
        }

        .order-meta {
            grid-template-columns: 1fr;
            gap: 0.9rem;
        }

        .order-items-wrap {
            padding: 0 1rem;
        }

        .order-total {
            margin-right: 1rem;
            margin-left: 1rem;
        }

        .celebration-modal {
            padding: 1.5rem 1.1rem 1.2rem;
            border-radius: 1.25rem;
        }

        .celebration-art {
            height: 178px;
        }

        .celebration-actions {
            grid-template-columns: 1fr;
        }

        .celebration-button {
            min-height: 46px;
        }
    }

    @media (prefers-reduced-motion: reduce) {
        .celebration-overlay,
        .celebration-modal,
        .celebration-glow,
        .celebration-check,
        .celebration-check path,
        .gift,
        .gift-lid,
        .gift-burst,
        .celebration-confetti {
            animation: none !important;
        }
    }
</style>
</head>
<body>
    <%@ include file="Header.jsp" %>

    <main class="orders-page">
        <section class="orders-hero" aria-labelledby="orders-title">
            <p class="orders-kicker">Your shopping story</p>
            <h1 id="orders-title">My orders</h1>
            <p>Every order, all in one place. Check what you bought and where it's headed.</p>
        </section>

        <% if (error != null) { %>
            <p class="orders-alert error" role="alert"><%=error%></p>
        <% } %>

        <% if (celebrationOrderId != null) { %>
            <div class="celebration-overlay" id="orderCelebration" role="presentation">
                <section class="celebration-modal" role="dialog" aria-modal="true"
                         aria-labelledby="celebration-title" aria-describedby="celebration-message">
                    <button class="celebration-close" type="button" aria-label="Close order confirmation">&times;</button>
                    <div class="celebration-art" aria-hidden="true">
                        <span class="celebration-glow"></span>
                        <span class="celebration-check">
                            <svg viewBox="0 0 32 32" focusable="false">
                                <path d="M7 16.5l6 6L25 10"></path>
                            </svg>
                        </span>
                        <div class="gift">
                            <span class="gift-bow"></span>
                            <span class="gift-lid"></span>
                            <span class="gift-box"></span>
                        </div>
                    </div>
                    <p class="celebration-caption">A little joy is on its way</p>
                    <h2 id="celebration-title">Yay! Your Order is Placed!</h2>
                    <p class="celebration-subtitle">Your happiness is on its way!</p>
                    <p class="celebration-order">Order ID: <strong><%=celebrationOrderId%></strong></p>
                    <p class="celebration-message" id="celebration-message">
                        Your order is confirmed. We're getting everything ready for its journey to you.
                    </p>
                    <nav class="celebration-actions" aria-label="Order confirmation actions">
                        <a class="celebration-button primary" href="<%=request.getContextPath()%>/ShopCtl">Continue Shopping</a>
                        <a class="celebration-button secondary" href="<%=request.getContextPath()%>/MyOrdersCtl">View My Orders</a>
                    </nav>
                </section>
            </div>
        <% } %>

        <% if (list != null && !list.isEmpty()) { %>
            <div class="orders-section-heading">
                <h2>Your order history</h2>
                <span class="orders-count"><%=list.size()%> order<%=list.size() == 1 ? "" : "s"%></span>
            </div>

            <% for (OrderBean o : list) { %>
                <article class="order-card" aria-label="Order <%=o.getId()%>">
                    <header class="order-topline">
                        <div>
                            <h3 class="order-id">Order #<%=o.getId()%></h3>
                            <span class="order-date"><%=o.getCreatedDatetime()%></span>
                        </div>
                        <span class="order-status"><%=o.getStatus()%></span>
                    </header>

                    <div class="order-meta">
                        <div>
                            <span class="order-meta-label">Payment</span>
                            <div class="order-meta-value"><%=o.getPaymentMethod()%></div>
                        </div>
                        <div>
                            <span class="order-meta-label">Delivering to</span>
                            <div class="order-meta-value">
                                <strong><%=o.getFullName()%></strong><br>
                                <%=o.getAddress()%>, <%=o.getCity()%> - <%=o.getPincode()%><br>
                                <%=o.getMobile()%>
                            </div>
                        </div>
                    </div>

                    <div class="order-items-wrap">
                        <table class="order-items">
                            <thead>
                                <tr>
                                    <th scope="col">Product</th>
                                    <th scope="col">Price</th>
                                    <th scope="col">Qty</th>
                                    <th scope="col">Total</th>
                                </tr>
                            </thead>
                            <tbody>
                                <% for (OrderItemBean item : o.getItems()) { %>
                                    <tr>
                                        <td class="item-name"><%=item.getProductName()%></td>
                                        <td>Rs. <%=item.getPrice()%></td>
                                        <td><%=item.getQuantity()%></td>
                                        <td>Rs. <%=item.getTotal()%></td>
                                    </tr>
                                <% } %>
                            </tbody>
                        </table>
                    </div>

                    <div class="order-total">
                        <span>Order total</span>
                        <strong>Rs. <%=o.getTotalAmount()%></strong>
                    </div>
                </article>
            <% } %>
        <% } else { %>
            <section class="orders-empty">
                <span class="empty-mark" aria-hidden="true">&gt;</span>
                <h2>Your next favorite is out there</h2>
                <p>No orders yet. Browse the collection and make your first one.</p>
                <a class="orders-shop-link" href="<%=request.getContextPath()%>/ShopCtl">Explore the shop</a>
            </section>
        <% } %>

        <% if (list != null && !list.isEmpty()) { %>
            <p class="orders-section-heading">
                <a class="orders-shop-link" href="<%=request.getContextPath()%>/ShopCtl">Continue shopping</a>
            </p>
        <% } %>
    </main>

    <%@ include file="Footer.jsp" %>
    <% if (celebrationOrderId != null) { %>
        <script>
            (function () {
                var overlay = document.getElementById("orderCelebration");
                var modal = overlay.querySelector(".celebration-modal");
                var closeButton = overlay.querySelector(".celebration-close");
                var gift = overlay.querySelector(".gift");
                var previousFocus = document.activeElement;
                var previousBodyOverflow = document.body.style.overflow;
                var colors = ["#f3bf52", "#aa78e7", "#f38db2", "#81cfc2", "#ffd77a", "#8a75e7"];

                for (var burstIndex = 0; burstIndex < 14; burstIndex++) {
                    var burst = document.createElement("span");
                    var angle = (Math.PI * 2 * burstIndex) / 14;
                    burst.className = "gift-burst";
                    burst.style.setProperty("--burst-color", colors[burstIndex % colors.length]);
                    burst.style.setProperty("--burst-delay", (burstIndex * 0.025) + "s");
                    burst.style.setProperty("--burst-x", (Math.cos(angle) * (45 + Math.random() * 30)) + "px");
                    burst.style.setProperty("--burst-y", (Math.sin(angle) * (40 + Math.random() * 30) - 25) + "px");
                    gift.appendChild(burst);
                }

                for (var confettiIndex = 0; confettiIndex < 64; confettiIndex++) {
                    var confetti = document.createElement("span");
                    var kind = confettiIndex % 11 === 0 ? "star"
                        : (confettiIndex % 13 === 0 ? "heart"
                            : (confettiIndex % 3 === 0 ? "strip" : "piece"));
                    confetti.className = "celebration-confetti " + kind;
                    confetti.style.setProperty("--confetti-x", (Math.random() * 100) + "vw");
                    confetti.style.setProperty("--confetti-size", (5 + Math.random() * 8) + "px");
                    confetti.style.setProperty("--confetti-color", colors[confettiIndex % colors.length]);
                    confetti.style.setProperty("--confetti-duration", (3.4 + Math.random() * 3) + "s");
                    confetti.style.setProperty("--confetti-delay", (Math.random() * 1.4) + "s");
                    confetti.style.setProperty("--confetti-drift", ((Math.random() - 0.5) * 28) + "vw");
                    confetti.style.setProperty("--confetti-rotate", ((Math.random() * 900) - 450) + "deg");
                    overlay.appendChild(confetti);
                }

                document.body.style.overflow = "hidden";
                closeButton.focus();

                function closeCelebration() {
                    overlay.querySelectorAll(".celebration-confetti, .gift-burst").forEach(function (piece) {
                        piece.remove();
                    });
                    overlay.hidden = true;
                    document.body.style.overflow = previousBodyOverflow;
                    if (previousFocus && typeof previousFocus.focus === "function") {
                        previousFocus.focus();
                    }

                    var currentUrl = new URL(window.location.href);
                    currentUrl.searchParams.delete("placed");
                    window.history.replaceState(null, "", currentUrl.pathname + currentUrl.search + currentUrl.hash);
                }

                closeButton.addEventListener("click", closeCelebration);
                overlay.addEventListener("click", function (event) {
                    if (event.target === overlay) {
                        closeCelebration();
                    }
                });
                document.addEventListener("keydown", function (event) {
                    if (event.key === "Escape" && !overlay.hidden) {
                        closeCelebration();
                    }
                });
                modal.addEventListener("keydown", function (event) {
                    if (event.key !== "Tab") {
                        return;
                    }
                    var focusable = modal.querySelectorAll("a[href], button:not([disabled])");
                    var first = focusable[0];
                    var last = focusable[focusable.length - 1];
                    if (event.shiftKey && document.activeElement === first) {
                        event.preventDefault();
                        last.focus();
                    } else if (!event.shiftKey && document.activeElement === last) {
                        event.preventDefault();
                        first.focus();
                    }
                });
            }());
        </script>
    <% } %>
</body>
</html>
