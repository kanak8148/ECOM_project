package in.co.rays.ctl;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import in.co.rays.bean.CartBean;
import in.co.rays.bean.OrderBean;
import in.co.rays.bean.ProductBean;
import in.co.rays.bean.UserBean;
import in.co.rays.model.BaseModel;
import in.co.rays.model.CartModel;
import in.co.rays.model.OrderModel;
import in.co.rays.model.ProductModel;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/OrderCtl")
public class OrderCtl extends BaseCtl {

    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        UserBean user = (UserBean) request.getSession().getAttribute("user");

        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/LoginCtl");
            return;
        }

        long productId = parseLong(request.getParameter("productId"));
        int qty = 1;

        if (!loadCheckout(request, user, productId, qty)) {
            String back = productId > 0 ? "/ShopCtl" : "/CartCtl";
            response.sendRedirect(request.getContextPath() + back);
            return;
        }

        request.getRequestDispatcher(getView()).forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        UserBean user = (UserBean) request.getSession().getAttribute("user");

        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/LoginCtl");
            return;
        }

        String op = request.getParameter("operation");

        long productId = parseLong(request.getParameter("productId"));
        int qty = (int) parseLong(request.getParameter("quantity"));
        if (qty <= 0) {
            qty = 1;
        }

        if ("Place Order".equalsIgnoreCase(op)) {

            String fullName = trim(request.getParameter("fullName"));
            String mobile = trim(request.getParameter("mobile"));
            String address = trim(request.getParameter("address"));
            String city = trim(request.getParameter("city"));
            String pincode = trim(request.getParameter("pincode"));

            String error = validateInput(fullName, mobile, address, city, pincode);

            if (error != null) {
                request.setAttribute("error", error);
            } else {
                try {
                    OrderBean bean = new OrderBean();
                    bean.setUserId(user.getId());
                    bean.setFullName(fullName);
                    bean.setMobile(mobile);
                    bean.setAddress(address);
                    bean.setCity(city);
                    bean.setPincode(pincode);
                    bean.setPaymentMethod("COD");

                    long orderId = new OrderModel().placeOrder(bean, productId, qty);

                    // cart se order hua to badge 0, buy now me cart wahi rehta hai
                    if (productId == 0) {
                        request.getSession().setAttribute("cartCount", 0);
                    }

                    response.sendRedirect(request.getContextPath() + "/MyOrdersCtl?placed=" + orderId);
                    return;

                } catch (Exception e) {
                    e.printStackTrace();
                    request.setAttribute("error", e.getMessage());
                }
            }
        }

        // error aaya ya "Update Qty": checkout page wapas
        if (!loadCheckout(request, user, productId, qty)) {
            String back = productId > 0 ? "/ShopCtl" : "/CartCtl";
            response.sendRedirect(request.getContextPath() + back);
            return;
        }

        request.getRequestDispatcher(getView()).forward(request, response);
    }

    // checkout ki list aur total yahin banta hai. false = checkout nahi ho sakta
    private boolean loadCheckout(HttpServletRequest request, UserBean user, long productId, int qty) {
        try {
            List<CartBean> list = new ArrayList<CartBean>();

            if (productId > 0) {
                ProductBean p = new ProductModel().findByPK(productId);

                if (p == null || p.getQuantity() <= 0) {
                    return false;
                }

                if (qty > p.getQuantity()) {
                    qty = p.getQuantity();
                }

                CartBean item = new CartBean();
                item.setProductId(p.getId());
                item.setProductName(p.getName());
                item.setImage(p.getImage());
                item.setPrice(p.getPrice());
                item.setDiscountPercent(p.getDiscountPercent());
                item.setStock(p.getQuantity());
                item.setQuantity(qty);
                list.add(item);

                request.setAttribute("buyNow", true);
                request.setAttribute("buyProductId", productId);
            } else {
                list = new CartModel().findByUser(user.getId());
            }

            if (list.isEmpty()) {
                return false;
            }

            double grandTotal = 0;
            for (CartBean c : list) {
                grandTotal += c.getTotal();
            }
            grandTotal = Math.round(grandTotal * 100.0) / 100.0;

            request.setAttribute("list", list);
            request.setAttribute("grandTotal", grandTotal);
            return true;

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Something went wrong: " + e.getMessage());
            return false;
        }
    }

    private long parseLong(String s) {
        try {
            return Long.parseLong(s);
        } catch (Exception e) {
            return 0;
        }
    }

    private String trim(String s) {
        return s == null ? "" : s.trim();
    }

    private String validateInput(String fullName, String mobile, String address, String city,
            String pincode) {

        if (fullName.isEmpty()) {
            return "Full name is required";
        }
        if (!mobile.matches("^[6-9][0-9]{9}$")) {
            return "Mobile must be 10 digits and start with 6-9";
        }
        if (address.isEmpty()) {
            return "Address is required";
        }
        if (city.isEmpty()) {
            return "City is required";
        }
        if (!pincode.matches("^[0-9]{6}$")) {
            return "Pincode must be 6 digits";
        }
        return null;
    }

    @Override
    public BaseModel getModel() {
        return new OrderModel();
    }

    @Override
    public String getView() {
        return "/jsp/Checkout.jsp";
    }
}