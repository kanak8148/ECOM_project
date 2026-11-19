
package in.co.rays.model;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

import in.co.rays.bean.UserBean;
import in.co.rays.exception.ApplicationException;
import in.co.rays.exception.DatabaseException;
import in.co.rays.exception.DuplicateRecordException;
import in.co.rays.exception.RecordNotFoundException;
import in.co.rays.util.JDBCDataSource;

public class UserModel extends  BaseModel<UserBean> {

    private static final Logger log = Logger.getLogger(UserModel.class.getName());

    /**
     * Generate Next Primary Key
     */
    public long nextPK() throws DatabaseException {

        String sql = "SELECT MAX(ID) FROM USERS";

        long pk = 0;

        try (Connection conn = JDBCDataSource.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql);
             ResultSet rs = pstmt.executeQuery()) {

            if (rs.next()) {
                pk = rs.getLong(1);
            }

        } catch (Exception e) {
            log.log(Level.SEVERE, "Exception in getting PK", e);
            throw new DatabaseException("Exception in getting PK");
        }

        return pk + 1;
    }

    /**
     * Add User
     */
    public long add(UserBean bean)
            throws ApplicationException, DuplicateRecordException {

        if (findByLogin(bean.getEmail()) != null) {
            throw new DuplicateRecordException("Email already exists");
        }

        String sql = "INSERT INTO USERS"
                + "(id, first_name, last_name, email, password, mobile, role_id, "
                + "created_by, modified_by, created_datetime, modified_datetime) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        Connection conn = null;
        long pk = 0;

        try {
            conn = JDBCDataSource.getConnection();
            conn.setAutoCommit(false);

            pk = nextPK();

            Timestamp now = new Timestamp(System.currentTimeMillis());

            try (PreparedStatement pstmt = conn.prepareStatement(sql)) {

                pstmt.setLong(1, pk);
                pstmt.setString(2, bean.getFirstName());
                pstmt.setString(3, bean.getLastName());
                pstmt.setString(4, bean.getEmail());
                pstmt.setString(5, bean.getPassword());
                pstmt.setString(6, bean.getMobile());
                pstmt.setLong(7, bean.getRoleId());
                pstmt.setString(8, bean.getCreatedBy());
                pstmt.setString(9, bean.getModifiedBy());
                pstmt.setTimestamp(10, now);
                pstmt.setTimestamp(11, now);

                pstmt.executeUpdate();
            }

            conn.commit();

        } catch (Exception e) {

            try {
                if (conn != null) {
                    conn.rollback();
                }
            } catch (SQLException ex) {
                log.log(Level.SEVERE, "Add rollback exception", ex);
            }

            log.log(Level.SEVERE, "Exception in adding User", e);
            throw new ApplicationException("Exception in adding User");

        } finally {
            JDBCDataSource.closeConnection(conn);
        }

        return pk;
    }

    /**
     * Delete User
     */
    public void delete(UserBean bean) throws ApplicationException {

        String sql = "DELETE FROM ST_USER WHERE ID=?";

        try (Connection conn = JDBCDataSource.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setLong(1, bean.getId());
            pstmt.executeUpdate();

        } catch (Exception e) {
            log.log(Level.SEVERE, "Exception in deleting User", e);
            throw new ApplicationException("Exception in deleting User");
        }
    }

    /**
     * Find User By Email / Login
     */
    public UserBean findByLogin(String email) throws ApplicationException {

        String sql = "SELECT * FROM USERS WHERE EMAIL=?";

        UserBean bean = null;

        try (Connection conn = JDBCDataSource.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setString(1, email);

            try (ResultSet rs = pstmt.executeQuery()) {

                if (rs.next()) {
                    bean = new UserBean();
                    bean.setResultSet(rs);
                }
            }

        } catch (Exception e) {
            log.log(Level.SEVERE, "Exception in finding User by Email", e);
            throw new ApplicationException("Exception in finding User");
        }

        return bean;
    }

    /**
     * Find User By Primary Key
     */
    public UserBean findByPK(long pk) throws ApplicationException {

        String sql = "SELECT * FROM ST_USER WHERE ID=?";

        UserBean bean = null;

        try (Connection conn = JDBCDataSource.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setLong(1, pk);

            try (ResultSet rs = pstmt.executeQuery()) {

                if (rs.next()) {
                    bean = new UserBean();
                    bean.setResultSet(rs);
                }
            }

        } catch (Exception e) {
            log.log(Level.SEVERE, "Exception in finding User by PK", e);
            throw new ApplicationException("Exception in finding User by PK");
        }

        return bean;
    }

    /**
     * Update User
     */
    public void update(UserBean bean)
            throws ApplicationException, DuplicateRecordException {

        UserBean existBean = findByLogin(bean.getEmail());

        if (existBean != null && existBean.getId() != bean.getId()) {
            throw new DuplicateRecordException("Email already exists");
        }

        String sql = "UPDATE ST_USER SET "
                + "FIRST_NAME=?, LAST_NAME=?, LOGIN=?, PASSWORD=?, "
                + "MOBILE_NO=?, ROLE_ID=? WHERE ID=?";

        try (Connection conn = JDBCDataSource.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setString(1, bean.getFirstName());
            pstmt.setString(2, bean.getLastName());
            pstmt.setString(3, bean.getEmail());
            pstmt.setString(4, bean.getPassword());
            pstmt.setString(5, bean.getMobile());
            pstmt.setLong(6, bean.getRoleId());
            pstmt.setLong(7, bean.getId());

            pstmt.executeUpdate();

        } catch (Exception e) {
            log.log(Level.SEVERE, "Exception in updating User", e);
            throw new ApplicationException("Exception in updating User");
        }
    }

    /**
     * Search User
     */
    public List<UserBean> search(UserBean bean) throws ApplicationException {
        return search(bean, 0, 0);
    }

    /**
     * Search User With Pagination
     */
    public List<UserBean> search(UserBean bean, int pageNo, int pageSize)
            throws ApplicationException {

        StringBuilder sql = new StringBuilder("SELECT * FROM ST_USER WHERE 1=1");

        List<Object> params = new ArrayList<>();

        if (bean != null) {

            if (bean.getFirstName() != null && !bean.getFirstName().isEmpty()) {
                sql.append(" AND FIRST_NAME LIKE ?");
                params.add(bean.getFirstName() + "%");
            }

            if (bean.getLastName() != null && !bean.getLastName().isEmpty()) {
                sql.append(" AND LAST_NAME LIKE ?");
                params.add(bean.getLastName() + "%");
            }

            if (bean.getEmail() != null && !bean.getEmail().isEmpty()) {
                sql.append(" AND LOGIN LIKE ?");
                params.add(bean.getEmail() + "%");
            }

            if (bean.getMobile() != null && !bean.getMobile().isEmpty()) {
                sql.append(" AND MOBILE_NO LIKE ?");
                params.add(bean.getMobile() + "%");
            }

            if (bean.getRoleId() > 0) {
                sql.append(" AND ROLE_ID=?");
                params.add(bean.getRoleId());
            }

            if (bean.getId() > 0) {
                sql.append(" AND ID=?");
                params.add(bean.getId());
            }
        }

        if (pageSize > 0) {
            int offset = (pageNo - 1) * pageSize;
            sql.append(" LIMIT ?, ?");
            params.add(offset);
            params.add(pageSize);
        }

        List<UserBean> list = new ArrayList<>();

        try (Connection conn = JDBCDataSource.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql.toString())) {

            for (int i = 0; i < params.size(); i++) {
                pstmt.setObject(i + 1, params.get(i));
            }

            try (ResultSet rs = pstmt.executeQuery()) {

                while (rs.next()) {
                    UserBean user = new UserBean();
                    user.setResultSet(rs);
                    list.add(user);
                }
            }

        } catch (Exception e) {
            log.log(Level.SEVERE, "Exception in searching User", e);
            throw new ApplicationException("Exception in searching User");
        }

        return list;
    }

    /**
     * Authenticate User
     */
    public UserBean authenticate(String email, String password)
            throws ApplicationException {

        String sql = "SELECT * FROM USERS WHERE EMAIL=? AND PASSWORD=?";

        UserBean bean = null;

        try (Connection conn = JDBCDataSource.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setString(1, email);
            pstmt.setString(2, password);

            try (ResultSet rs = pstmt.executeQuery()) {

                if (rs.next()) {
                    bean = new UserBean();
                    bean.setResultSet(rs);
                }
            }

        } catch (Exception e) {
            log.log(Level.SEVERE, "Exception in authentication", e);
            throw new ApplicationException("Exception in authentication");
        }

        return bean;
    }

    /**
     * Get All Users
     */
    public List<UserBean> list() throws ApplicationException {
        return list(0, 0);
    }

    /**
     * Get All Users With Pagination
     */
    public List<UserBean> list(int pageNo, int pageSize)
            throws ApplicationException {

        StringBuilder sql = new StringBuilder("SELECT * FROM ST_USER");

        if (pageSize > 0) {
            int offset = (pageNo - 1) * pageSize;
            sql.append(" LIMIT ?, ?");
        }

        List<UserBean> list = new ArrayList<>();

        try (Connection conn = JDBCDataSource.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql.toString())) {

            if (pageSize > 0) {
                int offset = (pageNo - 1) * pageSize;
                pstmt.setInt(1, offset);
                pstmt.setInt(2, pageSize);
            }

            try (ResultSet rs = pstmt.executeQuery()) {

                while (rs.next()) {
                    UserBean bean = new UserBean();
                    bean.setResultSet(rs);
                    list.add(bean);
                }
            }

        } catch (Exception e) {
            log.log(Level.SEVERE, "Exception in getting User list", e);
            throw new ApplicationException("Exception in getting User list");
        }

        return list;
    }

    /**
     * Change Password
     */
    public boolean changePassword(Long id, String oldPassword, String newPassword)
            throws ApplicationException, RecordNotFoundException {

        UserBean bean = findByPK(id);

        if (bean == null || !bean.getPassword().equals(oldPassword)) {
            throw new RecordNotFoundException("User not found or old password is incorrect");
        }

        bean.setPassword(newPassword);

        try {
            update(bean);
        } catch (DuplicateRecordException e) {
            throw new ApplicationException("Email already exists");
        }

        return true;
    }

    /**
     * Register User
     */
    public long registerUser(UserBean bean)
            throws ApplicationException, DuplicateRecordException {

        if (bean.getConfirmPassword() == null
                || !bean.getConfirmPassword().equals(bean.getPassword())) {
            throw new ApplicationException("Password and Confirm Password do not match");
        }

        return add(bean);
    }

	@Override
	public String getWhereClause(UserBean bean) {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public String getTable() {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public UserBean getBean() {
		// TODO Auto-generated method stub
		return null;
	}

}
