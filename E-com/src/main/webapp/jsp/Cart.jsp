<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="java.util.List, in.co.rays.bean.CartBean"%>
<%
String error = (String) request.getAttribute("error");
String success = (String) request.getAttribute("success");
List<CartBean> list = (List<CartBean>) request.getAttribute("list");
double grandTotal = 0;
if (list != null) {
	for (CartBean item : list) {
		grandTotal += item.getTotal();
	}
}
grandTotal = Math.round(grandTotal * 100.0) / 100.0;
%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>My Cart</title>
<style>
body {
	margin: 0;
	background: #f5f6f8;
	color: #242424;
	font-family: Arial, sans-serif;
}

.cart-page {
	max-width: 1180px;
}

.cart-heading {
	border: 0;
	border-radius: 1rem;
	background: linear-gradient(115deg, #fff1ad, #fff);
	box-shadow: 0 3px 14px rgba(38, 35, 20, 0.06);
}

.cart-heading h1 {
	color: #302700;
	font-weight: 800;
}

.cart-item {
	border: 1px solid #eceef1;
	border-radius: 0.9rem;
	background: #fff;
	box-shadow: 0 3px 12px rgba(26, 31, 39, 0.05);
}

.cart-product-image {
	display: block;
	width: 112px;
	height: 112px;
	border-radius: 0.7rem;
	background: #fafafa;
	object-fit: contain;
}

.cart-image-placeholder {
	display: grid;
	width: 112px;
	height: 112px;
	place-items: center;
	border-radius: 0.7rem;
	background: #fafafa;
	color: #888;
	font-size: 0.8rem;
	text-align: center;
}

.cart-product-name {
	color: #302700;
	font-size: 1.05rem;
	font-weight: 700;
	overflow-wrap: anywhere;
}

.cart-price {
	color: #302700;
	font-weight: 700;
}

.cart-unit-price {
	color: #6d6d6d;
	font-size: 0.9rem;
}

.cart-quantity {
	width: 86px;
}

.cart-update-form {
	display: flex;
	flex-wrap: wrap;
	align-items: center;
	gap: 0.5rem;
}

.cart-summary {
	position: sticky;
	top: 1rem;
	border: 1px solid #eceef1;
	border-radius: 0.9rem;
	box-shadow: 0 3px 12px rgba(26, 31, 39, 0.05);
}

.cart-summary-title {
	color: #302700;
	font-weight: 750;
}

.cart-total {
	color: #302700;
	font-size: 1.35rem;
	font-weight: 800;
}

.cart-empty {
	border: 1px dashed #d6d9df;
	border-radius: 1rem;
	background: #fff;
}

@media ( max-width : 991.98px) {
	.cart-summary {
		position: static;
	}
}

@media ( max-width : 575.98px) {
	.cart-page {
		padding-right: 0.75rem;
		padding-left: 0.75rem;
	}
	.cart-heading .card-body {
		padding: 1.25rem !important;
	}
	.cart-item {
		padding: 0.85rem !important;
	}
	.cart-product-image, .cart-image-placeholder {
		width: 76px;
		height: 76px;
	}
	.cart-product-name {
		font-size: 0.98rem;
	}
	.cart-item-total {
		text-align: right;
	}
	.cart-item-controls {
		align-items: stretch !important;
	}
	.cart-update-form, .cart-remove-form {
		width: 100%;
	}
	.cart-update-form label {
		margin-right: auto;
	}
	.cart-update-form .cart-quantity {
		width: 72px;
	}
	.cart-update-form button, .cart-remove-form button {
		min-height: 38px;
	}
	.cart-remove-form button {
		width: 100%;
	}
}
</style>
</head>
<body>
	<%@ include file="Header.jsp"%>

	<main class="container cart-page py-4 py-md-5">
		<section class="cart-heading card mb-4">
			<div class="card-body p-4 p-md-5">
				<p class="text-uppercase small fw-bold text-secondary mb-2">Your
					shopping bag</p>
				<h1 class="h2 mb-2">My Cart</h1>
				<p class="text-secondary mb-0">Review your items and update
					quantities before you continue.</p>
			</div>
		</section>

		<%
		if (error != null) {
		%>
		<div class="alert alert-danger" role="alert"><%=error%></div>
		<%
		}
		%>
		<%
		if (success != null) {
		%>
		<div class="alert alert-success" role="status"><%=success%></div>
		<%
		}
		%>

		<%
		if (list != null && !list.isEmpty()) {
		%>
		<div class="row g-4 align-items-start">
			<section class="col-12 col-lg-8" aria-label="Cart items">
				<div class="d-flex justify-content-between align-items-center mb-3">
					<h2 class="h5 mb-0">Items in your cart</h2>
					<span class="text-secondary small"><%=list.size()%> item<%=list.size() == 1 ? "" : "s"%></span>
				</div>

				<div class="d-grid gap-3">
					<%
					for (CartBean c : list) {
					%>
					<article class="cart-item p-3 p-md-4">
						<div class="row g-3 align-items-center">
							<div class="col-auto">
								<%
								if (c.getImage() != null && !c.getImage().isEmpty()) {
								%>
								<img class="cart-product-image"
									src="<%=request.getContextPath()%>/ImageCtl?name=<%=c.getImage()%>"
									alt="<%=c.getProductName()%>">
								<%
								} else {
								%>
								<div class="cart-image-placeholder">
									Image<br>coming soon
								</div>
								<%
								}
								%>
							</div>

							<div class="col">
								<h3 class="cart-product-name mb-2"><%=c.getProductName()%></h3>
								<div class="cart-unit-price">
									Rs.
									<%=c.getDiscountPrice()%>
									each
									<%
								if (c.getDiscountPercent() > 0) {
								%>
									<s class="ms-1">Rs. <%=c.getPrice()%></s> <span
										class="text-success ms-1"><%=c.getDiscountPercent()%>%
										off</span>
									<%
									}
									%>
								</div>
							</div>

							<div class="col-12 col-md-auto text-md-end cart-item-total">
								<div class="small text-secondary">Item total</div>
								<div class="cart-price">
									Rs.
									<%=c.getTotal()%></div>
							</div>

							<div class="col-12">
								<div
									class="d-flex flex-wrap justify-content-between align-items-center gap-3 pt-2 border-top cart-item-controls">
									<form class="cart-update-form"
										action="<%=request.getContextPath()%>/CartCtl" method="post">
										<input type="hidden" name="productId"
											value="<%=c.getProductId()%>"> <label
											class="small fw-semibold"
											for="quantity-<%=c.getProductId()%>">Qty</label> <input
											class="form-control form-control-sm cart-quantity"
											id="quantity-<%=c.getProductId()%>" type="number"
											name="quantity" value="<%=c.getQuantity()%>" min="1"
											max="<%=c.getStock()%>"
											aria-label="Quantity for <%=c.getProductName()%>">
										<button class="btn btn-sm btn-warning fw-semibold"
											type="submit" name="operation" value="Update">Update</button>
									</form>

									<form class="cart-remove-form"
										action="<%=request.getContextPath()%>/CartCtl" method="post">
										<input type="hidden" name="productId"
											value="<%=c.getProductId()%>">
										<button class="btn btn-sm btn-outline-danger" type="submit"
											name="operation" value="Remove">Remove</button>
									</form>
								</div>
							</div>
						</div>
					</article>
					<%
					}
					%>
				</div>
			</section>

			<aside class="col-12 col-lg-4" aria-label="Order summary">
				<div class="cart-summary card">
					<div class="card-body p-4">
						<h2 class="cart-summary-title h5 mb-4">Order summary</h2>
						<div
							class="d-flex justify-content-between align-items-center border-top pt-3">
							<span class="fw-semibold">Grand total</span> <span
								class="cart-total">Rs. <%=grandTotal%></span>
						</div>
						<p class="small text-secondary mt-3 mb-4">Total reflects
							current item quantities and discounts.</p>
						<a class="btn btn-warning w-100 fw-bold py-2"
							href="<%=request.getContextPath()%>/ShopCtl">Continue
							Shopping</a>
						<%
						if (list != null && !list.isEmpty()) {
						%>
						<a href="<%=request.getContextPath()%>/OrderCtl"
							class="btn btn-dark w-100 mb-2">Palce Order</a>
						<%
						}
						%>
					</div>
				</div>
			</aside>
		</div>
		<%
		} else {
		%>
		<section class="cart-empty text-center p-4 p-md-5">
			<div class="display-5 mb-3" aria-hidden="true">🛍️</div>
			<h2 class="h4">Your cart is empty</h2>
			<p class="text-secondary mb-4">Looks like you haven't added
				anything to your cart yet.</p>
			<a class="btn btn-warning fw-bold px-4 py-2"
				href="<%=request.getContextPath()%>/ShopCtl">Explore Products</a>
		</section>
		<%
		}
		%>
	</main>
	<%@ include file="Footer.jsp"%>
</body>
</html>
