package in.co.rays.ctl;

import java.io.IOException;

import in.co.rays.bean.BaseBean;
import in.co.rays.bean.UserBean;
import in.co.rays.exception.ApplicationException;
import in.co.rays.exception.DuplicateRecordException;
import in.co.rays.model.BaseModel;
import in.co.rays.util.ServletUtility;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

public abstract  class BaseCtl <B extends BaseBean, M extends BaseModel<B>> extends HttpServlet  {
	public static final String OP_SAVE = "Save";
	public static final String OP_CANCEL = "Cancel";
	public static final String OP_DELETE = "Delete";
	public static final String OP_LIST = "List";
	public static final String OP_SEARCH = "Search";
	public static final String OP_NEW = "New";
	public static final String OP_BACK = "Back";
	public static final String OP_NEXT = "Next";
	public static final String OP_PREVIOUS = "Previous";
	public static final String OP_LOG_OUT = "Logout";

	public static final String HAS_ERROR = "haserror";
	public static final String MESSAGE = "message";
	public static final String MSG_SUCCESS = "success";
	public static final String MSG_ERROR = "error";

	/** Form ki validation. false return karo to page wapas dikhta hai. Child override karta hai. */
	protected boolean validate(HttpServletRequest request) {
		return true;
	}

	/** Page dikhane se pehle dropdown wagairah ka data. Child override karta hai. */
	protected void preload(HttpServletRequest request) {
	}

	/** Request ke parameters se bean banata hai. Child override karta hai. */
	protected B populateBean(HttpServletRequest request) {
		return null;
	}

	/** createdBy / modifiedBy bharta hai (login user ka email, login nahi to "guest") */
	protected void populateDTO(BaseBean bean, HttpServletRequest request) {
		UserBean loggedIn = (UserBean) request.getSession().getAttribute("user");
		String who = loggedIn == null ? "guest" : loggedIn.getEmail();
		bean.setCreatedBy(who);
		bean.setModifiedBy(who);
	}

	// id aayi to record load karke form mein dikhata hai (edit ke liye)
	@Override
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		long id = DataUtility.getLong(request.getParameter("id"));
		M model = getModel();
		if (id > 0) {
			ServletUtility.setBean(model.findByPk(id), request);
		}
		ServletUtility.forward(getView(), request, response);
	}

	// Save: id hai to update, nahi to add
	@Override
	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		B bean = populateBean(request);
		M model = getModel();
		try {
			if (bean.getId() > 0) {
				model.update(bean);
				ServletUtility.setSuccessMessage("Record updated successfully", request);
			} else {
				model.add(bean);
				ServletUtility.setSuccessMessage("Record saved successfully", request);
			}
		} catch (DuplicateRecordException e) {
			ServletUtility.setErrorMessage(e.getMessage(), request);
		} catch (ApplicationException e) {
			e.printStackTrace();
			ServletUtility.setErrorMessage("Something went wrong, please try again", request);
		}
		ServletUtility.setBean(bean, request);
		ServletUtility.forward(getView(), request, response);
	}

	// har request pehle yahan se guzarti hai: preload, phir POST par validate
	@Override
	protected void service(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		preload(request);
		if (request.getMethod().equals("POST") && !validate(request)) {
			ServletUtility.forward(getView(), request, response);
			return;
		}
		super.service(request, response);
	}

	public abstract M getModel();

	public abstract String getView();
}

