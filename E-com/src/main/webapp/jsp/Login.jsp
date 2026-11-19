<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>Login</title>
<style>
    body {
        margin: 0;
        background: #fffdf6;
        color: #302700;
        font-family: Arial, sans-serif;
    }

    .login-page {
        display: grid;
        min-height: calc(100vh - 70px);
        place-items: center;
        padding: 2rem 1rem;
        background:
            radial-gradient(circle at 12% 18%, rgba(255, 212, 59, 0.18), transparent 25%),
            radial-gradient(circle at 90% 85%, rgba(255, 193, 7, 0.14), transparent 25%),
            #fffdf6;
    }

    .login-card {
        display: grid;
        grid-template-columns: minmax(0, 0.9fr) minmax(0, 1.1fr);
        width: min(100%, 850px);
        overflow: hidden;
        border: 1px solid #f0e9ce;
        border-radius: 1.25rem;
        background: #fff;
        box-shadow: 0 20px 55px rgba(75, 58, 0, 0.12);
    }

    .login-welcome {
        display: flex;
        flex-direction: column;
        align-items: flex-start;
        justify-content: center;
        padding: clamp(2rem, 5vw, 3.5rem);
        background: linear-gradient(145deg, #ffe16b, #ffc928);
    }

    .login-logo {
        display: grid;
        width: 72px;
        height: 72px;
        margin-bottom: 2rem;
        place-items: center;
        border: 1px solid rgba(56, 45, 0, 0.12);
        border-radius: 1.25rem;
        background: rgba(255, 255, 255, 0.65);
    }

    .login-logo svg {
        width: 42px;
        height: 42px;
    }

    .login-welcome h1 {
        margin: 0 0 0.8rem;
        color: #302700;
        font-size: clamp(1.8rem, 4vw, 2.5rem);
        font-weight: 800;
        letter-spacing: -0.04em;
    }

    .login-welcome p {
        margin: 0;
        color: #594700;
        font-size: 1rem;
        line-height: 1.7;
    }

    .login-form-panel {
        padding: clamp(2rem, 5vw, 3.5rem);
    }

    .login-form-panel h2 {
        margin: 0 0 0.5rem;
        color: #302700;
        font-size: 1.75rem;
        font-weight: 750;
    }

    .login-subtitle {
        margin: 0 0 1.75rem;
        color: #777;
    }

    .login-field {
        display: block;
        margin-bottom: 1.15rem;
        color: #443a1a;
        font-size: 0.92rem;
        font-weight: 700;
    }

    .login-field input {
        display: block;
        width: 100%;
        box-sizing: border-box;
        margin-top: 0.5rem;
        padding: 0.85rem 1rem;
        border: 1px solid #dedede;
        border-radius: 0.7rem;
        background: #fff;
        color: #242424;
        font: inherit;
        font-weight: 400;
        transition: border-color 0.18s ease, box-shadow 0.18s ease;
    }

    .login-field input:focus {
        border-color: #d6a900;
        outline: none;
        box-shadow: 0 0 0 3px rgba(255, 212, 59, 0.25);
    }

    .login-error {
        margin: 0 0 1rem;
        padding: 0.8rem 0.9rem;
        border: 1px solid #f4c7c3;
        border-radius: 0.65rem;
        background: #fff1f0;
        color: #a4261a;
        font-size: 0.92rem;
    }

    .login-submit {
        width: 100%;
        margin-top: 0.25rem;
        padding: 0.9rem 1rem;
        border: 0;
        border-radius: 0.7rem;
        background: #302700;
        color: #fff;
        font: inherit;
        font-weight: 700;
        cursor: pointer;
        transition: background-color 0.18s ease, transform 0.18s ease;
    }

    .login-submit:hover,
    .login-submit:focus {
        background: #594700;
        transform: translateY(-1px);
    }

    .login-register {
        margin: 1.4rem 0 0;
        color: #686868;
        text-align: center;
    }

    .login-register a {
        color: #785d00;
        font-weight: 700;
        text-decoration: none;
    }

    .login-register a:hover {
        text-decoration: underline;
    }

    @media (max-width: 640px) {
        .login-page {
            min-height: calc(100vh - 64px);
            padding: 1rem;
        }

        .login-card {
            grid-template-columns: 1fr;
            border-radius: 1rem;
        }

        .login-welcome {
            align-items: center;
            padding: 1.5rem;
            text-align: center;
        }

        .login-logo {
            width: 58px;
            height: 58px;
            margin-bottom: 1rem;
            border-radius: 1rem;
        }

        .login-logo svg {
            width: 34px;
            height: 34px;
        }

        .login-form-panel {
            padding: 1.5rem;
        }
    }
</style>
</head>
<body>

    <%@ include file="Header.jsp" %>

    <main class="login-page">
        <section class="login-card" aria-label="Sign in">
            <div class="login-welcome">
                <div class="login-logo" aria-hidden="true">
                    <svg viewBox="0 0 64 64" fill="none" xmlns="http://www.w3.org/2000/svg">
                        <path d="M15 23h34l-3 32H18l-3-32Z" fill="#FFF9E6" stroke="#382D00" stroke-width="3.5" stroke-linejoin="round"/>
                        <path d="M24 25v-7a8 8 0 0 1 16 0v7" stroke="#382D00" stroke-width="3.5" stroke-linecap="round"/>
                    </svg>
                </div>
                <h1>Welcome back!</h1>
                <p>Sign in to pick up where you left off and discover something you'll love.</p>
            </div>

            <div class="login-form-panel">
                <h2>Sign in</h2>
                <p class="login-subtitle">Enter your details to access your account.</p>

                <% if (request.getAttribute("error") != null) { %>
                    <p class="login-error" role="alert"><%= request.getAttribute("error") %></p>
                <% } %>

                <form action="<%= request.getContextPath() %>/LoginCtl" method="post">
                    <label class="login-field">
                        Email
                        <input type="email" name="email" placeholder="Enter your email" autocomplete="email" required>
                    </label>
                    <label class="login-field">
                        Password
                        <input type="password" name="password" placeholder="Enter your password" autocomplete="current-password" required>
                    </label>
                    <button class="login-submit" type="submit" name="operation" value="SignIn">Sign in</button>
                </form>

                <p class="login-register">
                    New user?
                    <a href="<%= request.getContextPath() %>/UserRegistrationCtl">Register here</a>
                </p>
            </div>
        </section>
    </main>
    <%@ include file="Footer.jsp" %>

</body>
</html>