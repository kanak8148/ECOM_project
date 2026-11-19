<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
    String error = (String) request.getAttribute("error");
    String success = (String) request.getAttribute("success");
    String name = request.getParameter("name") == null ? "" : request.getParameter("name");
    String description = request.getParameter("description") == null ? "" : request.getParameter("description");
    String price = request.getParameter("price") == null ? "" : request.getParameter("price");
    String discountPercent = request.getParameter("discountPercent") == null ? "" : request.getParameter("discountPercent");
    String rating = request.getParameter("rating") == null ? "" : request.getParameter("rating");
    String quantity = request.getParameter("quantity") == null ? "" : request.getParameter("quantity");
    String category = request.getParameter("category") == null ? "" : request.getParameter("category");
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Add Product</title>
</head>
<body>

    <%@ include file="Header.jsp" %>

    <h2>Add Product</h2>

    <% if (error != null) { %>
        <p style="color: red;"><%=error%></p>
    <% } %>
    <% if (success != null) { %>
        <p style="color: green;"><%=success%></p>
    <% } %>

    <form action="<%=request.getContextPath()%>/ProductCtl" method="post" enctype="multipart/form-data">

        <table>
            <tr>
                <td>Product Name</td>
                <td><input type="text" name="name" value="<%=name%>"></td>
            </tr>
            <tr>
                <td>Description</td>
                <td><input type="text" name="description" value="<%=description%>"></td>
            </tr>
            <tr>
                <td>Price</td>
                <td><input type="text" name="price" value="<%=price%>"></td>
            </tr>
            <tr>
                <td>Discount (%)</td>
                <td><input type="text" name="discountPercent" value="<%=discountPercent%>"></td>
            </tr>
            <tr>
                <td>Rating (0 to 5)</td>
                <td><input type="text" name="rating" value="<%=rating%>"></td>
            </tr>
            <tr>
                <td>Quantity</td>
                <td><input type="text" name="quantity" value="<%=quantity%>"></td>
            </tr>
            <tr>
                <td>Category</td>
                <td><input type="text" name="category" value="<%=category%>"></td>
            </tr>
            <tr>
                <td>Image</td>
                <td><input type="file" name="image" accept="image/*"></td>
            </tr>
            <tr>
                <td></td>
                <td>
                    <input type="submit" name="operation" value="Save">
                    <input type="submit" name="operation" value="Reset">
                </td>
            </tr>
        </table>

    </form>

    <p>
        <a href="<%=request.getContextPath()%>/ProductListCtl">View Product List</a>
    </p>

    <%@ include file="Footer.jsp" %>
</body>
</html>