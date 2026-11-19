<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.util.List, in.co.rays.bean.ProductBean"%>
<%
    String error = (String) request.getAttribute("error");
    List<ProductBean> list = (List<ProductBean>) request.getAttribute("list");
    String searchName = request.getParameter("name") == null ? "" : request.getParameter("name");
%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>Shop Products</title>
<style>
    body {
        margin: 0;
        background: #f5f6f8;
        color: #242424;
        font-family: Arial, sans-serif;
    }

    .shop-page {
        width: min(100% - 2rem, 1280px);
        margin: 2rem auto;
    }

    .shop-heading {
        margin-bottom: 1.25rem;
        padding: 1.5rem;
        border-radius: 1rem;
        background: linear-gradient(115deg, #fff4bf, #fff);
        box-shadow: 0 3px 14px rgba(38, 35, 20, 0.06);
    }

    .shop-heading h1 {
        margin: 0 0 0.4rem;
        font-size: clamp(1.5rem, 4vw, 2rem);
        font-weight: 750;
    }

    .shop-heading p {
        margin: 0;
        color: #686868;
    }

    .shop-toolbar {
        display: flex;
        flex-wrap: wrap;
        gap: 0.65rem;
        margin: 1.25rem 0;
    }

    .shop-search {
        display: flex;
        flex: 1 1 280px;
        gap: 0.6rem;
    }

    .shop-search input[type="text"] {
        min-width: 0;
        flex: 1;
        padding: 0.75rem 1rem;
        border: 1px solid #d9dce1;
        border-radius: 0.65rem;
        background: #fff;
    }

    .shop-search input[type="submit"] {
        min-height: 42px;
        padding: 0.65rem 1rem;
        border: 0;
        border-radius: 0.65rem;
        background: #ffd43b;
        color: #302700;
        font-weight: 700;
        cursor: pointer;
    }

    .shop-search input[name="operation"][value="Reset"] {
        background: #eef0f3;
        color: #333;
    }

    .shop-error {
        padding: 0.9rem 1rem;
        border-radius: 0.65rem;
        background: #fff0ef;
        color: #a4261a;
    }

    .shop-count {
        margin: 1.5rem 0 0.8rem;
        color: #666;
        font-size: 0.95rem;
    }

    .shop-grid {
        display: grid;
        grid-template-columns: repeat(auto-fill, minmax(min(100%, 235px), 1fr));
        gap: 1rem;
    }

    .shop-card {
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

    .shop-card:hover {
        transform: translateY(-3px);
        box-shadow: 0 10px 24px rgba(26, 31, 39, 0.11);
    }

    .shop-image-wrap {
        position: relative;
        display: grid;
        box-sizing: border-box;
        height: 220px;
        place-items: center;
        padding: 1rem;
        background: #fafafa;
    }

    .shop-image {
        display: block;
        width: 100%;
        height: 100%;
        object-fit: contain;
    }

    .shop-image-placeholder {
        color: #8a8a8a;
        font-size: 0.9rem;
    }

    .shop-discount {
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

    .shop-info {
        display: flex;
        flex: 1;
        flex-direction: column;
        padding: 1rem;
    }

    .shop-category {
        margin-bottom: 0.45rem;
        color: #777;
        font-size: 0.8rem;
    }

    .shop-name {
        margin: 0 0 0.4rem;
        overflow-wrap: anywhere;
        font-size: 1rem;
        font-weight: 700;
        line-height: 1.35;
    }

    .shop-description {
        margin: 0 0 0.85rem;
        color: #666;
        font-size: 0.88rem;
        line-height: 1.45;
        overflow-wrap: anywhere;
    }

    .shop-rating {
        align-self: flex-start;
        margin-bottom: 0.75rem;
        padding: 0.25rem 0.5rem;
        border-radius: 0.4rem;
        background: #e8f3ff;
        color: #185b9d;
        font-size: 0.82rem;
        font-weight: 700;
    }

    .shop-price {
        display: flex;
        flex-wrap: wrap;
        align-items: baseline;
        gap: 0.45rem;
        margin-top: auto;
        margin-bottom: 0.35rem;
    }

    .shop-price strong {
        font-size: 1.2rem;
    }

    .shop-price s {
        color: #858585;
        font-size: 0.88rem;
    }

    .shop-stock {
        margin-bottom: 0.8rem;
        color: #347545;
        font-size: 0.82rem;
    }

    .shop-stock.out-of-stock {
        color: #b42318;
        font-weight: 700;
    }

    .shop-actions,
    .shop-actions form {
        display: grid;
        grid-template-columns: 1fr 1fr;
        gap: 0.55rem;
        margin-top: auto;
    }

    .shop-actions input {
        width: 100%;
        min-width: 0;
        padding: 0.65rem 0.35rem;
        border: 0;
        border-radius: 0.55rem;
        background: #ffd43b;
        color: #302700;
        font-size: 0.82rem;
        font-weight: 700;
        cursor: pointer;
    }

    .shop-actions input[name="operation"][value="Buy Now"] {
        background: #302700;
        color: #fff;
    }

    .shop-empty {
        grid-column: 1 / -1;
        padding: 3rem 1rem;
        border: 1px dashed #d6d9df;
        border-radius: 0.9rem;
        background: #fff;
        color: #666;
        text-align: center;
    }

    @media (max-width: 480px) {
        .shop-page {
            width: min(100% - 1rem, 1280px);
            margin: 1rem auto;
        }

        .shop-heading {
            padding: 1.1rem;
        }

        .shop-search {
            width: 100%;
            flex-wrap: wrap;
        }

        .shop-search input[type="text"] {
            flex-basis: 100%;
        }

        .shop-search input[type="submit"] {
            flex: 1;
        }

        .shop-grid {
            grid-template-columns: repeat(2, minmax(0, 1fr));
            gap: 0.65rem;
        }

        .shop-image-wrap {
            height: 155px;
            padding: 0.65rem;
        }

        .shop-info {
            padding: 0.75rem;
        }

        .shop-description {
            font-size: 0.82rem;
        }

        .shop-actions,
        .shop-actions form {
            grid-template-columns: 1fr;
        }
    }
</style>
</head>
<body>
    <%@ include file="Header.jsp" %>

    <main class="shop-page">
        <section class="shop-heading">
            <h1>Shop our collection</h1>
            <p>Discover something you'll love, with great deals every day.</p>
        </section>

        <div class="shop-toolbar">
            <form class="shop-search" action="<%=request.getContextPath()%>/ShopCtl" method="post">
                <input type="text" name="name" placeholder="Search products by name" value="<%=searchName%>" aria-label="Search products by name">
                <input type="submit" name="operation" value="Search">
                <input type="submit" name="operation" value="Reset">
            </form>
        </div>

        <% if (error != null) { %>
            <p class="shop-error" role="alert"><%=error%></p>
        <% } %>

        <p class="shop-count">
            <% if (list != null) { %>
                Showing <%=list.size()%> product<%=list.size() == 1 ? "" : "s"%>
            <% } else { %>
                Products
            <% } %>
        </p>

        <section class="shop-grid" aria-label="Products">
            <% if (list != null && !list.isEmpty()) {
                for (ProductBean p : list) { %>
                    <article class="shop-card">
                        <div class="shop-image-wrap">
                            <% if (p.getDiscountPercent() > 0) { %>
                                <span class="shop-discount"><%=p.getDiscountPercent()%>% off</span>
                            <% } %>
                            <% if (p.getImage() != null && !p.getImage().isEmpty()) { %>
                                <img class="shop-image" src="<%=request.getContextPath()%>/ImageCtl?name=<%=p.getImage()%>" alt="<%=p.getName()%>">
                            <% } else { %>
                                <span class="shop-image-placeholder">Image coming soon</span>
                            <% } %>
                        </div>
                        <div class="shop-info">
                            <% if (p.getCategory() != null && !p.getCategory().isEmpty()) { %>
                                <span class="shop-category"><%=p.getCategory()%></span>
                            <% } %>
                            <h2 class="shop-name"><%=p.getName()%></h2>
                            <p class="shop-description"><%=p.getDescription() == null ? "" : p.getDescription()%></p>
                            <span class="shop-rating">★ <%=p.getRating()%> / 5</span>
                            <div class="shop-price">
                                <% if (p.getDiscountPercent() > 0) { %>
                                    <strong>Rs. <%=p.getDiscountPrice()%></strong>
                                    <s>Rs. <%=p.getPrice()%></s>
                                <% } else { %>
                                    <strong>Rs. <%=p.getPrice()%></strong>
                                <% } %>
                            </div>
                            <% if (p.getQuantity() > 0) { %>
                                <span class="shop-stock">In stock · <%=p.getQuantity()%> available</span>
                                <div class="shop-actions">
                                    <form action="<%=request.getContextPath()%>/CartCtl" method="post">
                                        <input type="hidden" name="productId" value="<%=p.getId()%>">
                                        <input type="submit" name="operation" value="Add To Cart">
                                        <input type="submit" name="operation" value="Buy Now">
                                    </form>
                                </div>
                            <% } else { %>
                                <span class="shop-stock out-of-stock">Out of stock</span>
                            <% } %>
                        </div>
                    </article>
                <% }
            } else { %>
                <div class="shop-empty">No products found. Try a different search.</div>
            <% } %>
        </section>
    </main>
    <%@ include file="Footer.jsp" %>
</body>
</html>
