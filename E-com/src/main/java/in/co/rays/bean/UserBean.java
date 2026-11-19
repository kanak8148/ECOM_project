package in.co.rays.bean;

import java.sql.ResultSet;

public class UserBean extends BaseBean {

	private String firstName;
	private String lastName;
	private String email;
	private String password;
	private String confirmPassword; // sirf registration form ke liye, DB mein nahi jata
	private String mobile;
	private long roleId;

	public String getFirstName() {
		return firstName;
	}

	public void setFirstName(String firstName) {
		this.firstName = firstName;
	}

	public String getLastName() {
		return lastName;
	}

	public void setLastName(String lastName) {
		this.lastName = lastName;
	}

	public String getEmail() {
		return email;
	}

	public void setEmail(String email) {
		this.email = email;
	}

	public String getPassword() {
		return password;
	}

	public void setPassword(String password) {
		this.password = password;
	}

	public String getConfirmPassword() {
		return confirmPassword;
	}

	public void setConfirmPassword(String confirmPassword) {
		this.confirmPassword = confirmPassword;
	}

	public String getMobile() {
		return mobile;
	}

	public void setMobile(String mobile) {
		this.mobile = mobile;
	}

	public long getRoleId() {
		return roleId;
	}

	public void setRoleId(long roleId) {
		this.roleId = roleId;
	}

	@Override
	public String getValue() {
		return firstName + " " + lastName;
	}

	@Override
	public void setResultSet(ResultSet rs) {
		try {
			setFirstName(rs.getString("first_name"));
			setLastName(rs.getString("last_name"));
			setEmail(rs.getString("email"));
			setPassword(rs.getString("password"));
			setMobile(rs.getString("mobile"));
			setRoleId(rs.getLong("role_id"));
		} catch (Exception e) {
			e.printStackTrace();
		}
		super.setResultSet(rs);
	}
}