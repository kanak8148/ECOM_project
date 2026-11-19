<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
    String footerCtx = request.getContextPath();
    int footerYear = java.time.Year.now().getValue();
%>

<style>
    .store-footer {
        background: linear-gradient(110deg, #ffd43b, #ffec99);
        box-shadow: 0 -3px 14px rgba(80, 60, 0, 0.14);
        color: #493900;
        margin-top: 48px;
        padding: 24px 0 12px;
    }

    .store-footer h6 {
        color: #382d00;
        font-weight: 800;
        letter-spacing: 0.03em;
    }

    .store-footer a {
        color: #493900;
        font-weight: 600;
        text-decoration: none;
    }

    .store-footer a:hover {
        color: #1f2937;
        text-decoration: underline;
    }

    .store-footer ul {
        list-style: none;
        padding-left: 0;
        margin-bottom: 0;
    }

    .store-footer ul li {
        margin-bottom: 6px;
    }

    .store-footer .footer-bottom {
        border-top: 1px solid rgba(56, 45, 0, 0.2);
        margin-top: 16px;
        padding-top: 12px;
        text-align: center;
        font-size: 0.9rem;
        color: #594700;
    }
</style>

<footer class="store-footer">
    <div class="container">
        <div class="row">

            <div class="col-md-4 mb-3">
                <h6>ECommerce</h6>
                <p class="mb-0"></p>
            </div>

            <div class="col-md-4 mb-3">
                <h6>Quick Links</h6>
                <ul>
                    <li><a href="<%=footerCtx%>/ShopCtl">Shop</a></li>
                    <li><a href="<%=footerCtx%>/CartCtl">My Cart</a></li>
                    <li><a href="<%=footerCtx%>/LoginCtl">Login</a></li>
                    <li><a href="<%=footerCtx%>/UserRegistrationCtl">Register</a></li>
                </ul>
            </div>

            <div class="col-md-4 mb-3">
                <h6>Contact</h6>
                <ul>
                    <li>Email: support@ecommerce.com</li>
                    <li>Phone: +91 98765 43210</li>
                </ul>
            </div>

        </div>

        <div class="footer-bottom">
            &copy; <%=footerYear%> Powerd by Kanak. All rights reserved.
        </div>
    </div>
</footer>