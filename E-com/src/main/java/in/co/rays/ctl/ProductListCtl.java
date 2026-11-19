package in.co.rays.ctl;

import java.io.IOException;
import java.net.URLEncoder;
import java.util.List;

import in.co.rays.bean.ProductBean;
import in.co.rays.bean.UserBean;
import in.co.rays.model.BaseModel;
import in.co.rays.model.ProductModel;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/ProductListCtl")
public class ProductListCtl extends BaseCtl {

	 private static final long serialVersionUID = 1L;

	    // roleId 1 = admin maana hai, apne role table ke hisaab se badalna
	    private static final long ADMIN_ROLE_ID = 1;

	    private boolean isAdmin(HttpServletRequest request) {
	        HttpSession session = request.getSession(false);
	        if (session == null) {
	            return false;
	        }
	        UserBean user = (UserBean) session.getAttribute("user");
	        return user != null && user.getRoleId() == ADMIN_ROLE_ID;
	    }

	    @Override
	    protected void doGet(HttpServletRequest request, HttpServletResponse response)
	            throws ServletException, IOException {

	        String op = request.getParameter("operation");

	        // edit ke baad redirect hokar aaye to message dikhao
	        String msg = request.getParameter("msg");
	        if (msg != null && !msg.trim().isEmpty()) {
	            request.setAttribute("success", msg);
	        }

	        // Edit: product load karke form dikhao (sirf admin)
	        if ("Edit".equalsIgnoreCase(op)) {
	            if (!isAdmin(request)) {
	                request.setAttribute("error", "Only admin can edit products");
	            } else {
	                try {
	                    long id = Long.parseLong(request.getParameter("id"));
	                    ProductBean bean = new ProductModel().findByPk(id);
	                    if (bean == null) {
	                        request.setAttribute("error", "Product not found");
	                    } else {
	                        request.setAttribute("bean", bean);
	                    }
	                } catch (NumberFormatException e) {
	                    request.setAttribute("error", "Invalid product id");
	                } catch (Exception e) {
	                    e.printStackTrace();
	                    request.setAttribute("error", "Something went wrong: " + e.getMessage());
	                }
	            }
	        }

	        loadList(request, "");
	        request.getRequestDispatcher(getView()).forward(request, response);
	    }

	    @Override
	    protected void doPost(HttpServletRequest request, HttpServletResponse response)
	            throws ServletException, IOException {

	        String op = request.getParameter("operation");

	        if ("Reset".equalsIgnoreCase(op) || "Cancel".equalsIgnoreCase(op)) {
	            response.sendRedirect(request.getContextPath() + "/ProductListCtl");
	            return;
	        }

	        // Update: validate karke save karo (sirf admin)
	        if ("Update".equalsIgnoreCase(op)) {

	            if (!isAdmin(request)) {
	                request.setAttribute("error", "Only admin can edit products");
	                loadList(request, "");
	                request.getRequestDispatcher(getView()).forward(request, response);
	                return;
	            }

	            ProductBean bean = new ProductBean();
	            String error = null;
	            double price = 0;
	            double discount = 0;
	            int quantity = 0;

	            try {
	                bean.setId(Long.parseLong(request.getParameter("id")));
	                bean.setName(request.getParameter("name") == null ? "" : request.getParameter("name").trim());
	                bean.setImage(request.getParameter("image") == null ? "" : request.getParameter("image").trim());

	                price = Double.parseDouble(request.getParameter("price"));
	                discount = Double.parseDouble(request.getParameter("discountPercent"));
	                quantity = Integer.parseInt(request.getParameter("quantity"));
	            } catch (NumberFormatException e) {
	                error = "Price, discount and quantity must be valid numbers";
	            }

	            if (error == null) {
	                if (bean.getName().isEmpty()) {
	                    error = "Name is required";
	                } else if (price <= 0) {
	                    error = "Price must be greater than 0";
	                } else if (discount < 0 || discount > 100) {
	                    error = "Discount must be between 0 and 100";
	                } else if (quantity < 0) {
	                    error = "Quantity cannot be negative";
	                }
	            }

	            bean.setPrice(price);
	            bean.setDiscountPercent(discount);
	            bean.setQuantity(quantity);

	            if (error == null) {
	                try {
	                    new ProductModel().update(bean);
	                    response.sendRedirect(request.getContextPath() + "/ProductListCtl?msg="
	                            + URLEncoder.encode("Product updated successfully", "UTF-8"));
	                    return;
	                } catch (Exception e) {
	                    e.printStackTrace();
	                    error = e.getMessage();
	                }
	            }

	            // error aaya to form wapas dikhao, bhari hui values ke saath
	            request.setAttribute("error", error);
	            request.setAttribute("bean", bean);
	            loadList(request, "");
	            request.getRequestDispatcher(getView()).forward(request, response);
	            return;
	        }

	        // normal search
	        String name = request.getParameter("name");
	        loadList(request, name);
	        request.getRequestDispatcher(getView()).forward(request, response);
	    }

	    private void loadList(HttpServletRequest request, String name) {
	        // JSP is flag se Edit column dikhayegi
	        request.setAttribute("isAdmin", isAdmin(request));

	        try {
	            ProductModel model = new ProductModel();
	            List<ProductBean> list = model.search(name);
	            request.setAttribute("list", list);
	        } catch (Exception e) {
	            e.printStackTrace();
	            request.setAttribute("error", "Something went wrong: " + e.getMessage());
	        }
	    }

	    @Override
	    public BaseModel getModel() {
	        return new ProductModel();
	    }

	    @Override
	    public String getView() {
	        return "/jsp/ProductList.jsp";
	    }
	}
