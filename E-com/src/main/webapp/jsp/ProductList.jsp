<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.util.List, in.co.rays.bean.ProductBean, in.co.rays.bean.UserBean"%>
<%!
    // user ki value HTML me safe daalne ke liye
    String esc(String s) {
        if (s == null) return "";
        return s.replace("&", "&amp;").replace("<", "&lt;").replace(">", "&gt;")
                .replace("\"", "&quot;").replace("'", "&#39;");
    }
%>
<%
    String error = (String) request.getAttribute("error");
    List<ProductBean> list = (List<ProductBean>) request.getAttribute("list");
    String searchName = request.getParameter("name") == null ? "" : request.getParameter("name");

    // sirf user id 1 ko Edit / Update dikhega
    UserBean loginUser = (UserBean) session.getAttribute("user");
    boolean admin = loginUser != null && loginUser.getId() == 1;

    String success = (String) request.getAttribute("success");
    ProductBean editBean = (ProductBean) request.getAttribute("bean");
%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>Product List</title>
<style>
    body {
        margin: 0;
        background: #f5f6f8;
        color: #242424;
        font-family: Arial, sans-serif;
    }

    .catalog-page {
        width: min(100% - 2rem, 1280px);
        margin: 2rem auto;
    }

    .catalog-heading {
        margin-bottom: 1.25rem;
        padding: 1.5rem;
        border-radius: 1rem;
        background: linear-gradient(115deg, #fff4bf, #fff);
        box-shadow: 0 3px 14px rgba(38, 35, 20, 0.06);
    }

    .catalog-heading h1 {
        margin: 0 0 0.4rem;
        font-size: clamp(1.5rem, 4vw, 2rem);
        font-weight: 750;
    }

    .catalog-heading p {
        margin: 0;
        color: #686868;
    }

    .catalog-toolbar {
        display: flex;
        flex-wrap: wrap;
        gap: 0.75rem;
        margin: 1.25rem 0;
    }

    .catalog-search {
        display: flex;
        flex: 1 1 280px;
        gap: 0.6rem;
    }

    .catalog-search input[type="text"] {
        min-width: 0;
        flex: 1;
        padding: 0.75rem 1rem;
        border: 1px solid #d9dce1;
        border-radius: 0.65rem;
        background: #fff;
    }

    .catalog-search input[type="submit"],
    .catalog-action {
        display: inline-flex;
        align-items: center;
        justify-content: center;
        min-height: 42px;
        padding: 0.65rem 1rem;
        border: 0;
        border-radius: 0.65rem;
        font-weight: 700;
        text-decoration: none;
        cursor: pointer;
    }

    .catalog-search input[name="operation"][value="Search"],
    .catalog-action-primary {
        background: #ffd43b;
        color: #302700;
    }

    .catalog-search input[name="operation"][value="Reset"],
    .catalog-action-secondary {
        background: #eef0f3;
        color: #333;
    }

    .catalog-message {
        margin: 1rem 0;
        padding: 0.9rem 1rem;
        border-radius: 0.65rem;
    }

    .catalog-error {
        background: #fff0ef;
        color: #a4261a;
    }

    .catalog-results {
        margin: 1.5rem 0 0.8rem;
        color: #666;
        font-size: 0.95rem;
    }

    .product-grid {
        display: grid;
        grid-template-columns: repeat(auto-fill, minmax(min(100%, 270px), 1fr));
        gap: 1rem;
    }

    .product-card {
        display: flex;
        min-width: 0;
        flex-direction: column;
        overflow: hidden;
        border: 1px solid #eceef1;
        border-radius: 0.9rem;
        background: #fff;
        box-shadow: 0 3px 12px rgba(26, 31, 39, 0.05);
        transition: transform 0.18s ease, box-shadow 0.18s ease;
    }

    .product-card:hover {
        transform: translateY(-3px);
        box-shadow: 0 10px 24px rgba(26, 31, 39, 0.11);
    }

    .product-image-wrap {
        position: relative;
        display: grid;
        box-sizing: border-box;
        aspect-ratio: 1 / 1;
        place-items: center;
        padding: 0.75rem;
        background: #fafafa;
    }

    .product-image {
        display: block;
        width: 100%;
        height: 100%;
        object-fit: contain;
    }

    .product-image-placeholder {
        color: #8a8a8a;
        font-size: 0.9rem;
    }

    .discount-badge {
        position: absolute;
        top: 0.8rem;
        left: 0.8rem;
        padding: 0.35rem 0.55rem;
        border-radius: 999px;
        background: #e8f7ed;
        color: #16783a;
        font-size: 0.78rem;
        font-weight: 700;
    }

    .product-info {
        display: flex;
        flex: 1;
        flex-direction: column;
        padding: 1rem;
    }

    .product-category {
        margin-bottom: 0.45rem;
        color: #777;
        font-size: 0.8rem;
    }

    .product-name {
        margin: 0 0 0.4rem;
        overflow-wrap: anywhere;
        font-size: 1rem;
        font-weight: 700;
        line-height: 1.35;
    }

    .product-description {
        margin: 0 0 0.85rem;
        color: #666;
        font-size: 0.88rem;
        line-height: 1.45;
        overflow-wrap: anywhere;
    }

    .product-rating {
        align-self: flex-start;
        margin-bottom: 0.75rem;
        padding: 0.25rem 0.5rem;
        border-radius: 0.4rem;
        background: #e8f3ff;
        color: #185b9d;
        font-size: 0.82rem;
        font-weight: 700;
    }

    .product-price {
        display: flex;
        flex-wrap: wrap;
        align-items: baseline;
        gap: 0.45rem;
        margin-top: auto;
        margin-bottom: 0.35rem;
    }

    .product-price strong {
        font-size: 1.2rem;
    }

    .product-price s {
        color: #858585;
        font-size: 0.88rem;
    }

    .product-stock {
        margin-bottom: 0.8rem;
        color: #347545;
        font-size: 0.82rem;
    }

    .product-stock.out-of-stock {
        color: #b42318;
        font-weight: 700;
    }

    .product-actions {
        display: grid;
        grid-template-columns: 1fr 1fr;
        gap: 0.55rem;
        margin-top: auto;
    }

    .product-actions form {
        display: contents;
    }

    .product-actions input {
        width: 100%;
        min-width: 0;
        padding: 0.65rem 0.35rem;
        border: 0;
        border-radius: 0.55rem;
        font-size: 0.82rem;
        font-weight: 700;
        cursor: pointer;
    }

    .product-actions input[name="operation"][value="Add To Cart"] {
        background: #ffd43b;
        color: #302700;
    }

    .product-actions input[name="operation"][value="Buy Now"] {
        background: #302700;
        color: #fff;
    }

    .empty-products {
        grid-column: 1 / -1;
        padding: 3rem 1rem;
        border: 1px dashed #d6d9df;
        border-radius: 0.9rem;
        background: #fff;
        color: #666;
        text-align: center;
    }

    .catalog-success {
        background: #e8f7ed;
        color: #16783a;
    }

    .edit-form {
        max-width: 460px;
        margin: 1rem 0 1.5rem;
        padding: 1.25rem;
        border: 1px solid #eceef1;
        border-radius: 0.9rem;
        background: #fff;
        box-shadow: 0 3px 12px rgba(26, 31, 39, 0.05);
    }

    .edit-form h2 {
        margin: 0 0 0.8rem;
        font-size: 1.15rem;
    }

    .edit-form label {
        display: block;
        margin: 0.7rem 0 0.25rem;
        font-size: 0.85rem;
        font-weight: 700;
    }

    .edit-form input[type="text"],
    .edit-form input[type="number"] {
        width: 100%;
        box-sizing: border-box;
        padding: 0.65rem 0.8rem;
        border: 1px solid #d9dce1;
        border-radius: 0.55rem;
    }

    .edit-form-actions {
        display: flex;
        gap: 0.6rem;
        margin-top: 1rem;
    }

    .edit-form-actions button {
        padding: 0.65rem 1.2rem;
        border: 0;
        border-radius: 0.55rem;
        font-weight: 700;
        cursor: pointer;
    }

    .edit-form-actions button[value="Update"] {
        background: #ffd43b;
        color: #302700;
    }

    .edit-form-actions button[value="Cancel"] {
        background: #eef0f3;
        color: #333;
    }

    .product-edit-link {
        display: block;
        margin-top: 0.55rem;
        padding: 0.6rem 0.35rem;
        border-radius: 0.55rem;
        background: #eef0f3;
        color: #333;
        font-size: 0.82rem;
        font-weight: 700;
        text-align: center;
        text-decoration: none;
    }

    @media (max-width: 480px) {
        .catalog-page {
            width: min(100% - 1rem, 1280px);
            margin: 1rem auto;
        }

        .catalog-heading {
            padding: 1.1rem;
        }

        .catalog-toolbar,
        .catalog-search {
            width: 100%;
        }

        .catalog-search {
            flex-wrap: wrap;
        }

        .catalog-search input[type="text"] {
            flex-basis: 100%;
        }

        .catalog-search input[type="submit"] {
            flex: 1;
        }

        .product-grid {
            grid-template-columns: minmax(0, 1fr);
            gap: 0.85rem;
        }

        .product-info {
            padding: 0.75rem;
        }

        .product-description {
            font-size: 0.82rem;
        }

        .product-actions {
            grid-template-columns: 1fr;
        }
    }
</style>
</head>
<body>
    <%@ include file="Header.jsp" %>

    <main class="catalog-page">
        <section class="catalog-heading">
            <h1>Find your next favourite</h1>
            <p>Browse the collection and discover great deals.</p>
        </section>

        <div class="catalog-toolbar">
            <form class="catalog-search" action="<%=request.getContextPath()%>/ProductListCtl" method="post">
                <input type="text" name="name" placeholder="Search products by name" value="<%=searchName%>" aria-label="Search products by name">
                <input type="submit" name="operation" value="Search">
                <input type="submit" name="operation" value="Reset">
            </form>
        </div>

        <% if (success != null) { %>
            <p class="catalog-message catalog-success" role="status"><%=esc(success)%></p>
        <% } %>

        <% if (error != null) { %>
            <p class="catalog-message catalog-error" role="alert"><%=error%></p>
        <% } %>

        <% if (admin && editBean != null) { %>
            <form class="edit-form" action="<%=request.getContextPath()%>/ProductListCtl" method="post">
                <h2>Edit product</h2>
                <input type="hidden" name="id" value="<%=editBean.getId()%>">

                <label for="edit-name">Name</label>
                <input type="text" id="edit-name" name="name" value="<%=esc(editBean.getName())%>" required>

                <label for="edit-price">Price (Rs.)</label>
                <input type="number" id="edit-price" name="price" step="0.01" min="0" value="<%=editBean.getPrice()%>" required>

                <label for="edit-discount">Discount (%)</label>
                <input type="number" id="edit-discount" name="discountPercent" step="0.01" min="0" max="100" value="<%=editBean.getDiscountPercent()%>" required>

                <label for="edit-qty">Quantity (stock)</label>
                <input type="number" id="edit-qty" name="quantity" step="1" min="0" value="<%=editBean.getQuantity()%>" required>

                <label for="edit-image">Image name</label>
                <input type="text" id="edit-image" name="image" value="<%=esc(editBean.getImage())%>">

                <div class="edit-form-actions">
                    <button type="submit" name="operation" value="Update">Update</button>
                    <button type="submit" name="operation" value="Cancel" formnovalidate>Cancel</button>
                </div>
            </form>
        <% } %>

        <p class="catalog-results">
            <% if (list != null) { %>
                Showing <%=list.size()%> product<%=list.size() == 1 ? "" : "s"%>
            <% } else { %>
                Products
            <% } %>
        </p>

        <section class="product-grid" aria-label="Products">
            <% if (list != null && !list.isEmpty()) {
                for (ProductBean p : list) { %>
                    <article class="product-card">
                        <div class="product-image-wrap">
                            <% if (p.getDiscountPercent() > 0) { %>
                                <span class="discount-badge"><%=p.getDiscountPercent()%>% off</span>
                            <% } %>
                            <% if (p.getImage() != null && !p.getImage().isEmpty()) { %>
                                <img class="product-image" src="<%=request.getContextPath()%>/ImageCtl?name=<%=p.getImage()%>" alt="<%=p.getName()%>">
                            <% } else { %>
                                <span class="product-image-placeholder">Image coming soon</span>
                            <% } %>
                        </div>
                        <div class="product-info">
                            <% if (p.getCategory() != null && !p.getCategory().isEmpty()) { %>
                                <span class="product-category"><%=p.getCategory()%></span>
                            <% } %>
                            <h2 class="product-name"><%=p.getName()%></h2>
                            <p class="product-description"><%=p.getDescription() == null ? "" : p.getDescription()%></p>
                            <span class="product-rating">★ <%=p.getRating()%> / 5</span>
                            <div class="product-price">
                                <strong>Rs. <%=p.getDiscountPrice()%></strong>
                                <% if (p.getDiscountPercent() > 0) { %>
                                    <s>Rs. <%=p.getPrice()%></s>
                                <% } %>
                            </div>
                            <% if (p.getQuantity() > 0) { %>
                                <span class="product-stock">In stock · <%=p.getQuantity()%> available</span>
                                <div class="product-actions">
                                    <form action="<%=request.getContextPath()%>/CartCtl" method="post">
                                        <input type="hidden" name="productId" value="<%=p.getId()%>">
                                        <input type="submit" name="operation" value="Add To Cart">
                                        <input type="submit" name="operation" value="Buy Now">
                                    </form>
                                </div>
                            <% } else { %>
                                <span class="product-stock out-of-stock">Out of stock</span>
                            <% } %>
                            <% if (admin) { %>
                                <a class="product-edit-link" href="<%=request.getContextPath()%>/ProductListCtl?operation=Edit&id=<%=p.getId()%>">Edit</a>
                            <% } %>
                        </div>
                    </article>
                <% }
            } else { %>
                <div class="empty-products">No products found. Try a different search.</div>
            <% } %>
        </section>
    </main>
    <%@ include file="Footer.jsp" %>
</body>
</html>