package in.co.rays.ctl;

import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.StandardCopyOption;

import in.co.rays.bean.ProductBean;
import in.co.rays.exception.DuplicateRecordException;
import in.co.rays.model.BaseModel;
import in.co.rays.model.ProductModel;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;

@WebServlet("/ProductCtl")
@MultipartConfig(maxFileSize = 2 * 1024 * 1024, maxRequestSize = 3 * 1024 * 1024)
public class ProductCtl extends BaseCtl {

    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher(getView()).forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String op = request.getParameter("operation");

        if ("Reset".equalsIgnoreCase(op)) {
            response.sendRedirect(request.getContextPath() + "/ProductCtl");
            return;
        }

        if ("Save".equalsIgnoreCase(op)) {

            String name = trim(request.getParameter("name"));
            String description = trim(request.getParameter("description"));
            String price = trim(request.getParameter("price"));
            String discount = trim(request.getParameter("discountPercent"));
            String rating = trim(request.getParameter("rating"));
            String quantity = trim(request.getParameter("quantity"));
            String category = trim(request.getParameter("category"));

            String error = validateInput(name, price, discount, rating, quantity);

            if (error != null) {
                request.setAttribute("error", error);
                request.getRequestDispatcher(getView()).forward(request, response);
                return;
            }

            try {
                // image upload
                String imageName = null;
                Part part = request.getPart("image");

                if (part != null && part.getSize() > 0) {
                    String original = part.getSubmittedFileName();
                    String lower = original == null ? "" : original.toLowerCase();

                    if (!(lower.endsWith(".jpg") || lower.endsWith(".jpeg") || lower.endsWith(".png")
                            || lower.endsWith(".gif") || lower.endsWith(".webp"))) {
                        request.setAttribute("error", "Only jpg, jpeg, png, gif, webp images are allowed");
                        request.getRequestDispatcher(getView()).forward(request, response);
                        return;
                    }

                    String ext = lower.substring(lower.lastIndexOf('.'));
                    imageName = System.currentTimeMillis() + ext;

                    File dir = new File(ProductModel.IMAGE_DIR);
                    if (!dir.exists()) {
                        dir.mkdirs();
                    }

                    File target = new File(dir, imageName);
                    try (InputStream in = part.getInputStream()) {
                        Files.copy(in, target.toPath(), StandardCopyOption.REPLACE_EXISTING);
                    }

                    System.out.println("Image saved at: " + target.getAbsolutePath());
                }

                ProductModel model = new ProductModel();

                ProductBean bean = new ProductBean();
                bean.setName(name);
                bean.setDescription(description);
                bean.setPrice(Double.parseDouble(price));
                bean.setDiscountPercent(discount.isEmpty() ? 0 : Double.parseDouble(discount));
                bean.setRating(rating.isEmpty() ? 0 : Double.parseDouble(rating));
                bean.setQuantity(Integer.parseInt(quantity));
                bean.setCategory(category);
                bean.setImage(imageName);

                long pk = model.add(bean);

                request.setAttribute("success", "Product added successfully. Product ID: " + pk);

            } catch (DuplicateRecordException e) {
                request.setAttribute("error", e.getMessage());
            } catch (Exception e) {
                e.printStackTrace();
                request.setAttribute("error", "Something went wrong: " + e.getMessage());
            }

            request.getRequestDispatcher(getView()).forward(request, response);
            return;
        }

        request.getRequestDispatcher(getView()).forward(request, response);
    }

    private String trim(String s) {
        return s == null ? "" : s.trim();
    }

    private String validateInput(String name, String price, String discount, String rating,
            String quantity) {

        if (name.isEmpty()) {
            return "Product name is required";
        }
        if (price.isEmpty()) {
            return "Price is required";
        }
        try {
            if (Double.parseDouble(price) <= 0) {
                return "Price must be greater than 0";
            }
        } catch (NumberFormatException e) {
            return "Price must be a number";
        }
        if (!discount.isEmpty()) {
            try {
                double d = Double.parseDouble(discount);
                if (d < 0 || d > 100) {
                    return "Discount must be between 0 and 100";
                }
            } catch (NumberFormatException e) {
                return "Discount must be a number";
            }
        }
        if (!rating.isEmpty()) {
            try {
                double r = Double.parseDouble(rating);
                if (r < 0 || r > 5) {
                    return "Rating must be between 0 and 5";
                }
            } catch (NumberFormatException e) {
                return "Rating must be a number";
            }
        }
        if (quantity.isEmpty()) {
            return "Quantity is required";
        }
        try {
            if (Integer.parseInt(quantity) < 0) {
                return "Quantity cannot be negative";
            }
        } catch (NumberFormatException e) {
            return "Quantity must be a whole number";
        }
        return null;
    }

    @Override
    public BaseModel getModel() {
        return new ProductModel();
    }

    @Override
    public String getView() {
        return "/jsp/Product.jsp";
    }
}