package in.co.rays.bean;

import java.sql.ResultSet;

public class RoleBean extends BaseBean {

	// role table ki ids (pehle ADMIN, phir USER insert karna)
	public static final int ADMIN = 1;
	public static final int USER = 2;

	private String name;

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	@Override
	public String getValue() {
		return name;
	}

	@Override
	public void setResultSet(ResultSet rs) {
		try {
			setName(rs.getString("name"));

		} catch (Exception e) {
			e.printStackTrace();
		}
		super.setResultSet(rs);
	}
}
