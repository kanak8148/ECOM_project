package in.co.rays.ctl;

import java.io.IOException;

import in.co.rays.bean.UserBean;
import in.co.rays.model.UserModel;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/LoginCtl")
public class LoginCtl extends HttpServlet {

	private static final long serialVersionUID = 1L;

	private UserModel model = new UserModel();

	protected String getView() {
		return "/jsp/Login.jsp";
	}

	@Override
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		System.out.println("LoginCtl doGet called");
		request.getRequestDispatcher(getView()).forward(request, response);
	}

	@Override
	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		String email = request.getParameter("email");
		String password = request.getParameter("password");

		try {
			UserBean bean = model.authenticate(email, password);

			if (bean != null) {
				HttpSession session = request.getSession();
				session.setAttribute("user", bean);
				response.sendRedirect(request.getContextPath() + "/jsp/Welcome.jsp");
			} else {
				request.setAttribute("error", "Invalid Email or Password");
				request.getRequestDispatcher(getView()).forward(request, response);
			}

		} catch (Exception e) {
			e.printStackTrace();
			request.setAttribute("error", "Something went wrong");
			request.getRequestDispatcher(getView()).forward(request, response);
		}
	}
}