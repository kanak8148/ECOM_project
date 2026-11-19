package in.co.rays.ctl;

import java.io.IOException;
import java.util.List;

import in.co.rays.bean.CartBean;
import in.co.rays.bean.ProductBean;
import in.co.rays.bean.UserBean;
import in.co.rays.model.BaseModel;
import in.co.rays.model.CartModel;
import in.co.rays.model.ProductModel;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/CartCtl")
public class CartCtl extends BaseCtl {

    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        UserBean user = (UserBean) request.getSession().getAttribute("user");

        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/LoginCtl");
            return;
        }

        loadCart(request, user);
        request.getRequestDispatcher(getView()).forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        UserBean user = (UserBean) request.getSession().getAttribute("user");

        // login nahi hai to login page pe bhejo
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/LoginCtl");
            return;
        }

        String op = request.getParameter("operation");

        long productId = 0;
        try {
            productId = Long.parseLong(request.getParameter("productId"));
        } catch (Exception e) {
            // productId nahi aayi, neeche "not found" error milega
        }

        try {
            CartModel model = new CartModel();

            if ("Add To Cart".equalsIgnoreCase(op) || "Buy Now".equalsIgnoreCase(op)) {

                ProductBean product = new ProductModel().findByPK(productId);

                if (product == null) {
                    request.setAttribute("error", "Product not found");
                } else if (product.getQuantity() <= 0) {
                    request.setAttribute("error", "Product is out of stock");
                } else {
                    CartBean existing = model.findByUserAndProduct(user.getId(), productId);

                    boolean changed = true;

                    if (existing == null) {
                        CartBean bean = new CartBean();
                        bean.setUserId(user.getId());
                        bean.setProductId(productId);
                        bean.setQuantity(1);
                        model.add(bean);
                    } else if (existing.getQuantity() < product.getQuantity()) {
                        existing.setQuantity(existing.getQuantity() + 1);
                        model.update(existing);
                    } else {
                        changed = false;
                        request.setAttribute("error",
                                "Only " + product.getQuantity() + " items in stock, already in your cart");
                    }

                    if (changed) {
                        // redirect se pehle header badge ka count refresh
                        loadCart(request, user);

                        if ("Buy Now".equalsIgnoreCase(op)) {
                            response.sendRedirect(request.getContextPath() + "/CartCtl");
                        } else {
                            response.sendRedirect(request.getContextPath() + "/ShopCtl?added=1");
                        }
                        return;
                    }
                }

            } else if ("Update".equalsIgnoreCase(op)) {

                int qty = 0;
                try {
                    qty = Integer.parseInt(request.getParameter("quantity"));
                } catch (Exception e) {
                    // galat quantity, neeche error milega
                }

                CartBean existing = model.findByUserAndProduct(user.getId(), productId);
                ProductBean product = new ProductModel().findByPK(productId);

                if (existing == null || product == null) {
                    request.setAttribute("error", "Item not found in cart");
                } else if (qty <= 0) {
                    request.setAttribute("error", "Quantity must be at least 1");
                } else if (qty > product.getQuantity()) {
                    request.setAttribute("error", "Only " + product.getQuantity() + " items in stock");
                
                } else {
                    existing.setQuantity(qty);
                    model.update(existing);
                    request.setAttribute("success", "Cart updated");
                }

            } else if ("Remove".equalsIgnoreCase(op)) {

                model.removeItem(user.getId(), productId);
                request.setAttribute("success", "Item removed from cart");
            }

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Something went wrong: " + e.getMessage());
        }

        loadCart(request, user);
        request.getRequestDispatcher(getView()).forward(request, response);
    }

    // cart load karke total quantity aur grand total yahin calculate hota hai
    private void loadCart(HttpServletRequest request, UserBean user) {
        try {
            List<CartBean> list = new CartModel().findByUser(user.getId());

            int totalQty = 0;
            double grandTotal = 0;

            for (CartBean c : list) {
                totalQty += c.getQuantity();
                grandTotal += c.getTotal();
            }

            grandTotal = Math.round(grandTotal * 100.0) / 100.0;

            request.setAttribute("list", list);
            request.setAttribute("totalQty", totalQty);
            request.setAttribute("grandTotal", grandTotal);

            // header badge ke liye session me
            request.getSession().setAttribute("cartCount", totalQty);

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Something went wrong: " + e.getMessage());
        }
    }

    @Override
    public BaseModel getModel() {
        return new CartModel();
    }

    @Override
    public String getView() {
        return "/jsp/Cart.jsp";
    }
}