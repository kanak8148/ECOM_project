package in.co.rays.ctl;

import java.io.IOException;

import in.co.rays.bean.UserBean;
import in.co.rays.exception.DuplicateRecordException;
import in.co.rays.model.BaseModel;
import in.co.rays.model.UserModel;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/UserRegistrationCtl")
public class UserRegistrationCtl extends BaseCtl {

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
            response.sendRedirect(request.getContextPath() + "/UserRegistrationCtl");
            return;
        }

        if ("Save".equalsIgnoreCase(op)) {

            String firstName = trim(request.getParameter("firstName"));
            String lastName = trim(request.getParameter("lastName"));
            String email = trim(request.getParameter("email"));
            String mobile = trim(request.getParameter("mobile"));
            String password = request.getParameter("password");
            String confirmPassword = request.getParameter("confirmPassword");

            String error = validateInput(firstName, lastName, email, mobile, password, confirmPassword);

            if (error != null) {
                request.setAttribute("error", error);
                request.getRequestDispatcher(getView()).forward(request, response);
                return;
            }

            try {
                UserModel model = new UserModel();

                UserBean bean = new UserBean();
                bean.setFirstName(firstName);
                bean.setLastName(lastName);
                bean.setEmail(email);
                bean.setMobile(mobile);
                bean.setPassword(password);
                bean.setRoleId(1L); // apne roles table ke hisaab se badlo
                bean.setCreatedBy(email);
                bean.setModifiedBy(email);

                long pk = model.add(bean);

                request.setAttribute("success", "Registration successful. User ID: " + pk);

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

    private String validateInput(String firstName, String lastName, String email, String mobile,
            String password, String confirmPassword) {

        if (firstName.isEmpty()) {
            return "First name is required";
        }
        if (lastName.isEmpty()) {
            return "Last name is required";
        }
        if (email.isEmpty()) {
            return "Email is required";
        }
        if (!email.matches("^[A-Za-z0-9+_.-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$")) {
            return "Enter a valid email";
        }
        if (!mobile.matches("^[6-9][0-9]{9}$")) {
            return "Mobile must be 10 digits and start with 6-9";
        }
        if (password == null || password.length() < 6) {
            return "Password must be at least 6 characters";
        }
        if (!password.equals(confirmPassword)) {
            return "Password and Confirm Password do not match";
        }
        return null;
    }

    @Override
    public BaseModel getModel() {
        return new UserModel();
    }

    @Override
    public String getView() {
        return "/jsp/UserRegistration.jsp";
    }
}