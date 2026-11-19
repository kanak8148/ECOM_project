<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
    String error = (String) request.getAttribute("error");
    String success = (String) request.getAttribute("success");
    String firstName = request.getParameter("firstName") == null ? "" : request.getParameter("firstName");
    String lastName = request.getParameter("lastName") == null ? "" : request.getParameter("lastName");
    String email = request.getParameter("email") == null ? "" : request.getParameter("email");
    String mobile = request.getParameter("mobile") == null ? "" : request.getParameter("mobile");
%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>Create Account</title>
<style>
    body {
        margin: 0;
        background: #fffdf6;
        color: #302700;
        font-family: Arial, sans-serif;
    }

    .registration-page {
        display: grid;
        min-height: calc(100vh - 70px);
        place-items: center;
        padding: 2rem 1rem;
        background:
            radial-gradient(circle at 12% 18%, rgba(255, 212, 59, 0.18), transparent 25%),
            radial-gradient(circle at 90% 85%, rgba(255, 193, 7, 0.14), transparent 25%),
            #fffdf6;
    }

    .registration-card {
        display: grid;
        grid-template-columns: minmax(0, 0.8fr) minmax(0, 1.2fr);
        width: min(100%, 950px);
        overflow: hidden;
        border: 1px solid #f0e9ce;
        border-radius: 1.25rem;
        background: #fff;
        box-shadow: 0 20px 55px rgba(75, 58, 0, 0.12);
    }

    .registration-welcome {
        display: flex;
        flex-direction: column;
        align-items: flex-start;
        justify-content: center;
        padding: clamp(2rem, 5vw, 3.5rem);
        background: linear-gradient(145deg, #ffe16b, #ffc928);
    }

    .registration-logo {
        display: grid;
        width: 72px;
        height: 72px;
        margin-bottom: 2rem;
        place-items: center;
        border: 1px solid rgba(56, 45, 0, 0.12);
        border-radius: 1.25rem;
        background: rgba(255, 255, 255, 0.65);
    }

    .registration-logo svg {
        width: 42px;
        height: 42px;
    }

    .registration-welcome h1 {
        margin: 0 0 0.8rem;
        color: #302700;
        font-size: clamp(1.8rem, 4vw, 2.5rem);
        font-weight: 800;
        letter-spacing: -0.04em;
    }

    .registration-welcome p {
        margin: 0;
        color: #594700;
        font-size: 1rem;
        line-height: 1.7;
    }

    .registration-form-panel {
        padding: clamp(2rem, 5vw, 3.5rem);
    }

    .registration-form-panel h2 {
        margin: 0 0 0.5rem;
        color: #302700;
        font-size: 1.75rem;
        font-weight: 750;
    }

    .registration-subtitle {
        margin: 0 0 1.5rem;
        color: #777;
    }

    .registration-grid {
        display: grid;
        grid-template-columns: repeat(2, minmax(0, 1fr));
        gap: 1rem;
    }

    .registration-field {
        display: block;
        min-width: 0;
        color: #443a1a;
        font-size: 0.92rem;
        font-weight: 700;
    }

    .registration-field input {
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

    .registration-field input:focus {
        border-color: #d6a900;
        outline: none;
        box-shadow: 0 0 0 3px rgba(255, 212, 59, 0.25);
    }

    .registration-message {
        margin: 0 0 1rem;
        padding: 0.8rem 0.9rem;
        border-radius: 0.65rem;
        font-size: 0.92rem;
    }

    .registration-error {
        border: 1px solid #f4c7c3;
        background: #fff1f0;
        color: #a4261a;
    }

    .registration-success {
        border: 1px solid #b9e3c5;
        background: #effaf2;
        color: #216e39;
    }

    .registration-actions {
        display: flex;
        gap: 0.75rem;
        margin-top: 1.5rem;
    }

    .registration-actions input {
        flex: 1;
        padding: 0.9rem 1rem;
        border: 0;
        border-radius: 0.7rem;
        font: inherit;
        font-weight: 700;
        cursor: pointer;
        transition: background-color 0.18s ease, transform 0.18s ease;
    }

    .registration-actions input[name="operation"][value="Save"] {
        background: #302700;
        color: #fff;
    }

    .registration-actions input[name="operation"][value="Save"]:hover {
        background: #594700;
        transform: translateY(-1px);
    }

    .registration-actions input[name="operation"][value="Reset"] {
        background: #f0f0ed;
        color: #443a1a;
    }

    .registration-actions input[name="operation"][value="Reset"]:hover {
        background: #e4e3dc;
    }

    .registration-login {
        margin: 1.4rem 0 0;
        color: #686868;
        text-align: center;
    }

    .registration-login a {
        color: #785d00;
        font-weight: 700;
        text-decoration: none;
    }

    .registration-login a:hover {
        text-decoration: underline;
    }

    @media (max-width: 640px) {
        .registration-page {
            min-height: calc(100vh - 64px);
            padding: 1rem;
        }

        .registration-card {
            grid-template-columns: 1fr;
            border-radius: 1rem;
        }

        .registration-welcome {
            align-items: center;
            padding: 1.5rem;
            text-align: center;
        }

        .registration-logo {
            width: 58px;
            height: 58px;
            margin-bottom: 1rem;
            border-radius: 1rem;
        }

        .registration-logo svg {
            width: 34px;
            height: 34px;
        }

        .registration-form-panel {
            padding: 1.5rem;
        }
    }

    @media (max-width: 440px) {
        .registration-grid {
            grid-template-columns: 1fr;
            gap: 0.9rem;
        }
    }
</style>
</head>
<body>

    <%@ include file="Header.jsp" %>

    <main class="registration-page">
        <section class="registration-card" aria-label="Create an account">
            <div class="registration-welcome">
                <div class="registration-logo" aria-hidden="true">
                    <svg viewBox="0 0 64 64" fill="none" xmlns="http://www.w3.org/2000/svg">
                        <path d="M15 23h34l-3 32H18l-3-32Z" fill="#FFF9E6" stroke="#382D00" stroke-width="3.5" stroke-linejoin="round"/>
                        <path d="M24 25v-7a8 8 0 0 1 16 0v7" stroke="#382D00" stroke-width="3.5" stroke-linecap="round"/>
                    </svg>
                </div>
                <h1>Join our store</h1>
                <p>Create your account to discover great finds and enjoy a smoother shopping experience.</p>
            </div>

            <div class="registration-form-panel">
                <h2>Create account</h2>
                <p class="registration-subtitle">Fill in your details to get started.</p>

                <% if (error != null) { %>
                    <p class="registration-message registration-error" role="alert"><%=error%></p>
                <% } %>
                <% if (success != null) { %>
                    <p class="registration-message registration-success" role="status"><%=success%></p>
                <% } %>

                <form action="<%=request.getContextPath()%>/UserRegistrationCtl" method="post">
                    <div class="registration-grid">
                        <label class="registration-field">
                            First Name
                            <input type="text" name="firstName" placeholder="Enter your first name" value="<%=firstName%>">
                        </label>
                        <label class="registration-field">
                            Last Name
                            <input type="text" name="lastName" placeholder="Enter your last name" value="<%=lastName%>">
                        </label>
                        <label class="registration-field">
                            Email
                            <input type="email" name="email" placeholder="you@example.com" value="<%=email%>">
                        </label>
                        <label class="registration-field">
                            Mobile No
                            <input type="text" name="mobile" maxlength="10" placeholder="10-digit mobile number" value="<%=mobile%>">
                        </label>
                        <label class="registration-field">
                            Password
                            <input type="password" name="password" placeholder="Create a password" autocomplete="new-password">
                        </label>
                        <label class="registration-field">
                            Confirm Password
                            <input type="password" name="confirmPassword" placeholder="Re-enter your password" autocomplete="new-password">
                        </label>
                    </div>

                    <div class="registration-actions">
                        <input type="submit" name="operation" value="Save">
                        <input type="submit" name="operation" value="Reset">
                    </div>
                </form>

                <p class="registration-login">
                    Already registered?
                    <a href="<%=request.getContextPath()%>/LoginCtl">Login here</a>
                </p>
            </div>
        </section>
    </main>

    <%@ include file="Footer.jsp" %>
</body>
</html>
