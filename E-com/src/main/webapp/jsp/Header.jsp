<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="in.co.rays.bean.UserBean, in.co.rays.model.CartModel"%>
<%
UserBean headerUser = (UserBean) session.getAttribute("user");
String ctx = request.getContextPath();

// role_id 1 = admin, 2 = customer (apne roles table ke hisaab se badlo)
boolean isAdmin = headerUser != null && headerUser.getRoleId() == 1L;

int cartCount = 0;
if (headerUser != null) {
	try {
		cartCount = new CartModel().findByUser(headerUser.getId()).size();
	} catch (Exception e) {
		cartCount = 0;
	}
}
%>

<link
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
	rel="stylesheet">
<style>
.store-navbar {
	background: linear-gradient(110deg, #ffd43b, #ffec99);
	box-shadow: 0 3px 14px rgba(80, 60, 0, 0.14);
}

.store-navbar .navbar-brand {
	color: #382d00;
	font-weight: 800;
	letter-spacing: 0.03em;
}

.store-navbar .nav-link {
	color: #493900;
	font-weight: 600;
	border-radius: 0.5rem;
	padding: 0.55rem 0.85rem;
}

.store-navbar .nav-link:hover, .store-navbar .nav-link:focus {
	color: #1f2937;
	background-color: rgba(255, 255, 255, 0.45);
}

.store-navbar .navbar-toggler {
	border-color: rgba(56, 45, 0, 0.35);
}

.store-navbar .navbar-toggler:focus {
	box-shadow: 0 0 0 0.2rem rgba(56, 45, 0, 0.2);
}

.store-navbar .welcome-label {
	color: #594700;
	font-weight: 600;
}

.store-navbar .cart-badge {
	background-color: #d63384;
	color: #fff;
	font-size: 0.75rem;
	font-weight: 700;
	border-radius: 999px;
	padding: 0.15rem 0.5rem;
	margin-left: 0.25rem;
}
</style>

<nav class="navbar navbar-expand-lg store-navbar"
	aria-label="Main navigation">
	<div class="container">
		<a class="navbar-brand" href="<%=ctx%>/WelcomeCtl">ECommerce</a>
		<button class="navbar-toggler" type="button" data-bs-toggle="collapse"
			data-bs-target="#storeNavbar" aria-controls="storeNavbar"
			aria-expanded="false" aria-label="Toggle navigation">
			<span class="navbar-toggler-icon"></span>
		</button>
		<div class="collapse navbar-collapse" id="storeNavbar">
			<div class="navbar-nav ms-auto align-items-lg-center">
				<a class="nav-link" href="<%=ctx%>/ShopCtl">Shop</a>
				<%
				if (headerUser != null) {
				%>
				<span class="welcome-label nav-link">Hi, <%=headerUser.getFirstName()%></span>
				<a class="nav-link" href="<%=ctx%>/WelcomeCtl">Home</a>

				<%
				if (isAdmin) {
				%>
				<a class="nav-link" href="<%=ctx%>/UserCtl">Add User</a>
				<a class="nav-link" href="<%=ctx%>/UserListCtl">User List</a>
				<a class="nav-link" href="<%=ctx%>/ProductCtl">Add Product</a>
				<a class="nav-link" href="<%=ctx%>/ProductListCtl">Product List</a>
				<%
				}
				%>

				<a class="nav-link" href="<%=ctx%>/CartCtl"> Cart<span
					class="cart-badge"><%=cartCount%></span>
				</a>
				<a class="nav-link" href="<%=ctx%>/MyOrdersCtl">My Orders</a>
				<a class="nav-link" href="<%=ctx%>/LoginCtl?operation=Logout">Logout</a>
				<%
				} else {
				%>
				<a class="nav-link" href="<%=ctx%>/CartCtl">Cart</a>
				<a class="nav-link" href="<%=ctx%>/LoginCtl">Login</a>
				<a class="nav-link" href="<%=ctx%>/UserRegistrationCtl">Register</a>
				<%
				}
				%>
			</div>
		</div>
	</div>
</nav>
<script
	src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>