<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>Welcome to ECommerce</title>
<style>
    body {
        margin: 0;
        background: #fffdf5;
        color: #302700;
        font-family: Arial, sans-serif;
    }

    .welcome-hero {
        position: relative;
        display: flex;
        min-height: calc(100vh - 76px);
        align-items: center;
        justify-content: center;
        overflow: hidden;
        padding: 3rem 1.25rem;
        text-align: center;
        background:
            radial-gradient(circle at 12% 18%, rgba(255, 212, 59, 0.2), transparent 25%),
            radial-gradient(circle at 88% 82%, rgba(255, 193, 7, 0.16), transparent 27%),
            linear-gradient(135deg, #fffdf5, #fff6cf);
    }

    .welcome-content {
        position: relative;
        z-index: 1;
        width: min(100%, 680px);
    }

    .shopping-logo {
        display: grid;
        width: 150px;
        height: 150px;
        margin: 0 auto 1.75rem;
        place-items: center;
        border: 1px solid rgba(135, 101, 0, 0.12);
        border-radius: 42px;
        background: linear-gradient(145deg, #ffe16b, #ffc928);
        box-shadow: 0 18px 38px rgba(145, 105, 0, 0.2);
        transform: rotate(-4deg);
    }

    .shopping-logo svg {
        width: 78px;
        height: 78px;
        transform: rotate(4deg);
    }

    .welcome-eyebrow {
        margin-bottom: 0.7rem;
        color: #987000;
        font-size: 0.82rem;
        font-weight: 800;
        letter-spacing: 0.18em;
        text-transform: uppercase;
    }

    .welcome-title {
        margin-bottom: 1rem;
        color: #302700;
        font-size: clamp(2.2rem, 7vw, 4.25rem);
        font-weight: 800;
        letter-spacing: -0.045em;
    }

    .welcome-description {
        max-width: 520px;
        margin: 0 auto 1.8rem;
        color: #655b3c;
        font-size: clamp(1rem, 2.5vw, 1.2rem);
        line-height: 1.7;
    }

    .welcome-shop-button {
        padding: 0.85rem 1.7rem;
        border: 0;
        border-radius: 999px;
        background: #302700;
        box-shadow: 0 8px 18px rgba(48, 39, 0, 0.18);
        color: #fff;
        font-weight: 700;
        transition: background-color 0.2s ease, transform 0.2s ease;
    }

    .welcome-shop-button:hover,
    .welcome-shop-button:focus {
        background: #594700;
        color: #fff;
        transform: translateY(-2px);
    }

    @media (max-width: 576px) {
        .welcome-hero {
            min-height: calc(100vh - 64px);
        }

        .shopping-logo {
            width: 122px;
            height: 122px;
            border-radius: 34px;
        }

        .shopping-logo svg {
            width: 64px;
            height: 64px;
        }
    }
</style>
</head>
<body>
    <%@ include file="Header.jsp" %>
    <main class="welcome-hero">
        <section class="welcome-content" aria-labelledby="welcomeTitle">
            <div class="shopping-logo" aria-hidden="true">
                <svg viewBox="0 0 64 64" fill="none" xmlns="http://www.w3.org/2000/svg">
                    <path d="M15 23h34l-3 32H18l-3-32Z" fill="#FFF9E6" stroke="#382D00" stroke-width="3.5" stroke-linejoin="round"/>
                    <path d="M24 25v-7a8 8 0 0 1 16 0v7" stroke="#382D00" stroke-width="3.5" stroke-linecap="round"/>
                    <path d="M25 35v2m14-2v2" stroke="#D69E00" stroke-width="4" stroke-linecap="round"/>
                </svg>
            </div>
            <p class="welcome-eyebrow">A little joy in every purchase</p>
            <h1 class="welcome-title" id="welcomeTitle">Welcome to ECommerce</h1>
            <p class="welcome-description">
                Discover something you'll love. Browse our collection and make your next find a great one.
            </p>
            <a class="btn welcome-shop-button" href="<%=request.getContextPath()%>/ProductListCtl">
                Explore products
                <span aria-hidden="true">&rarr;</span>
            </a>
        </section>
    </main>
    <%@ include file="Footer.jsp" %>
</body>
</html>