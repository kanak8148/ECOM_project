package in.co.rays.ctl;

import java.io.IOException;
import java.util.List;

import in.co.rays.bean.ProductBean;
import in.co.rays.model.BaseModel;
import in.co.rays.model.ProductModel;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/ShopCtl")
public class CustomerProductListCtl extends BaseCtl {

    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        loadList(request, "");
        request.getRequestDispatcher(getView()).forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String op = request.getParameter("operation");

        if ("Reset".equalsIgnoreCase(op)) {
            response.sendRedirect(request.getContextPath() + "/ShopCtl");
            return;
        }

        loadList(request, request.getParameter("name"));
        request.getRequestDispatcher(getView()).forward(request, response);
    }

    private void loadList(HttpServletRequest request, String name) {
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
        return "/jsp/CustomerProductList.jsp";
    }
}