package in.co.rays.util;

import java.sql.Connection;
import java.sql.SQLException;
import java.util.ResourceBundle;

import com.mchange.v2.c3p0.ComboPooledDataSource;

public final class JDBCDataSource {
	private static JDBCDataSource jdbc = null;
	private ComboPooledDataSource cpds = null;

	private static ResourceBundle rb = ResourceBundle.getBundle("system");

	private JDBCDataSource() {
		try {
			cpds = new ComboPooledDataSource();
			cpds.setDriverClass(rb.getString("driver"));
			cpds.setJdbcUrl(rb.getString("url"));
			cpds.setUser(rb.getString("username"));
			cpds.setPassword(rb.getString("password"));
			cpds.setInitialPoolSize(10);
			cpds.setMinPoolSize(10);
			cpds.setAcquireIncrement(5);
			cpds.setMaxPoolSize(30);
		} catch (Exception e) {
			e.printStackTrace(); // ORS mein yahan sirf e.getMessage() tha, isse error dikhta nahi tha
		}
	}

	// ek hi pool poore project mein (singleton)
	private static synchronized JDBCDataSource getInstance() {
		if (jdbc == null) {
			jdbc = new JDBCDataSource();
		}
		return jdbc;
	}

	public static Connection getConnection() {
		try {
			return getInstance().cpds.getConnection();
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return null;
	}

	public static void closeConnection(Connection conn) {
		if (conn != null) {
			try {
				conn.close(); // pool mein wapas chala jata hai
			} catch (SQLException e) {
				e.printStackTrace();
			}
		}
	}

	public static void trnRollBack(Connection conn) {
		if (conn != null) {
			try {
				conn.rollback();
			} catch (SQLException e) {
				e.printStackTrace();
			}
		}
	}

}
