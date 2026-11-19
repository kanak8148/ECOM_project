package in.co.rays.ctl;

import java.io.IOException;
import java.util.List;

import in.co.rays.bean.OrderBean;
import in.co.rays.bean.UserBean;
import in.co.rays.model.BaseModel;
import in.co.rays.model.OrderModel;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/MyOrdersCtl")
public class MyOrdersCtl extends BaseCtl {

    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        UserBean user = (UserBean) request.getSession().getAttribute("user");

        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/LoginCtl");
            return;
        }

        try {
            List<OrderBean> list = new OrderModel().findByUser(user.getId());
            request.setAttribute("list", list);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Something went wrong: " + e.getMessage());
        }

        request.getRequestDispatcher(getView()).forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }

    @Override
    public BaseModel getModel() {
        return new OrderModel();
    }

    @Override
    public String getView() {
        return "/jsp/MyOrders.jsp";
    }
}