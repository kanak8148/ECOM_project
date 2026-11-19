package in.co.rays.model;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

import in.co.rays.bean.CartBean;
import in.co.rays.exception.ApplicationException;
import in.co.rays.exception.DuplicateRecordException;
import in.co.rays.util.JDBCDataSource;

public class CartModel extends BaseModel<CartBean> {

    private static final String COLUMNS = "id, user_id, product_id, quantity, created_datetime";

    
    public long nextPK() throws ApplicationException {

        long pk = 0;
        Connection conn = null;

        try {
            conn = JDBCDataSource.getConnection();

            try (PreparedStatement pstmt = conn.prepareStatement("SELECT MAX(id) FROM cart");
                    ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    pk = rs.getLong(1);
                }
            }

        } catch (Exception e) {
            throw new ApplicationException("Exception in getting PK of Cart");
        } finally {
            JDBCDataSource.closeConnection(conn);
        }

        return pk + 1;
    }

    @Override
    public long add(CartBean bean) throws ApplicationException, DuplicateRecordException {

        if (findByUserAndProduct(bean.getUserId(), bean.getProductId()) != null) {
            throw new DuplicateRecordException("Product already in cart");
        }

        String sql = "INSERT INTO cart (" + COLUMNS + ") VALUES (?, ?, ?, ?, ?)";

        Connection conn = null;
        long pk = 0;

        try {
            conn = JDBCDataSource.getConnection();
            conn.setAutoCommit(false);

            pk = nextPK();

            try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
                pstmt.setLong(1, pk);
                pstmt.setLong(2, bean.getUserId());
                pstmt.setLong(3, bean.getProductId());
                pstmt.setInt(4, bean.getQuantity());
                pstmt.setTimestamp(5, new Timestamp(System.currentTimeMillis()));

                pstmt.executeUpdate();
            }

            conn.commit();

        } catch (Exception e) {

            try {
                if (conn != null) {
                    conn.rollback();
                }
            } catch (SQLException ex) {
                // rollback fail hua, ignore
            }

            throw new ApplicationException("Exception in adding to Cart");

        } finally {
            JDBCDataSource.closeConnection(conn);
        }

        return pk;
    }

    // sirf quantity update hoti hai
    @Override
    public void update(CartBean bean) throws ApplicationException, DuplicateRecordException {

        String sql = "UPDATE cart SET quantity = ? WHERE id = ?";

        Connection conn = null;

        try {
            conn = JDBCDataSource.getConnection();
            conn.setAutoCommit(false);

            try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
                pstmt.setInt(1, bean.getQuantity());
                pstmt.setLong(2, bean.getId());

                pstmt.executeUpdate();
            }

            conn.commit();

        } catch (Exception e) {

            try {
                if (conn != null) {
                    conn.rollback();
                }
            } catch (SQLException ex) {
                // rollback fail hua, ignore
            }

            throw new ApplicationException("Exception in updating Cart");

        } finally {
            JDBCDataSource.closeConnection(conn);
        }
    }

    
    public CartBean findByPK(long id) throws ApplicationException {

        String sql = "SELECT " + COLUMNS + " FROM cart WHERE id = ?";

        CartBean bean = null;
        Connection conn = null;

        try {
            conn = JDBCDataSource.getConnection();

            try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
                pstmt.setLong(1, id);

                try (ResultSet rs = pstmt.executeQuery()) {
                    while (rs.next()) {
                        bean = populate(rs);
                    }
                }
            }

        } catch (Exception e) {
            throw new ApplicationException("Exception in finding Cart item");
        } finally {
            JDBCDataSource.closeConnection(conn);
        }

        return bean;
    }

    // cart-specific: naya method
    public CartBean findByUserAndProduct(long userId, long productId) throws ApplicationException {

        String sql = "SELECT " + COLUMNS + " FROM cart WHERE user_id = ? AND product_id = ?";

        CartBean bean = null;
        Connection conn = null;

        try {
            conn = JDBCDataSource.getConnection();

            try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
                pstmt.setLong(1, userId);
                pstmt.setLong(2, productId);

                try (ResultSet rs = pstmt.executeQuery()) {
                    while (rs.next()) {
                        bean = populate(rs);
                    }
                }
            }

        } catch (Exception e) {
            throw new ApplicationException("Exception in finding Cart item");
        } finally {
            JDBCDataSource.closeConnection(conn);
        }

        return bean;
    }

    // cart-specific: user ka poora cart, product ki details ke saath
    public List<CartBean> findByUser(long userId) throws ApplicationException {

        String sql = "SELECT c.id, c.user_id, c.product_id, c.quantity, c.created_datetime, "
                + "p.name, p.image, p.price, p.discount_percent, p.quantity "
                + "FROM cart c JOIN products p ON c.product_id = p.id "
                + "WHERE c.user_id = ? ORDER BY c.id DESC";

        List<CartBean> list = new ArrayList<CartBean>();
        Connection conn = null;

        try {
            conn = JDBCDataSource.getConnection();

            try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
                pstmt.setLong(1, userId);

                try (ResultSet rs = pstmt.executeQuery()) {
                    while (rs.next()) {
                        CartBean bean = populate(rs);
                        bean.setProductName(rs.getString(6));
                        bean.setImage(rs.getString(7));
                        bean.setPrice(rs.getDouble(8));
                        bean.setDiscountPercent(rs.getDouble(9));
                        bean.setStock(rs.getInt(10));
                        list.add(bean);
                    }
                }
            }

        } catch (Exception e) {
            throw new ApplicationException("Exception in getting Cart");
        } finally {
            JDBCDataSource.closeConnection(conn);
        }

        return list;
    }

    // cart-specific: item hatana
    public void removeItem(long userId, long productId) throws ApplicationException {

        String sql = "DELETE FROM cart WHERE user_id = ? AND product_id = ?";

        Connection conn = null;

        try {
            conn = JDBCDataSource.getConnection();
            conn.setAutoCommit(false);

            try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
                pstmt.setLong(1, userId);
                pstmt.setLong(2, productId);

                pstmt.executeUpdate();
            }

            conn.commit();

        } catch (Exception e) {

            try {
                if (conn != null) {
                    conn.rollback();
                }
            } catch (SQLException ex) {
                // rollback fail hua, ignore
            }

            throw new ApplicationException("Exception in removing Cart item");

        } finally {
            JDBCDataSource.closeConnection(conn);
        }
    }

    @Override
    public String getWhereClause(CartBean bean) {

        StringBuilder where = new StringBuilder(" WHERE 1=1");

        if (bean != null && bean.getUserId() > 0) {
            where.append(" AND user_id = " + bean.getUserId());
        }

        return where.toString();
    }

    @Override
    public String getTable() {
        return "cart";
    }

    @Override
    public CartBean getBean() {
        return new CartBean();
    }

    private CartBean populate(ResultSet rs) throws SQLException {
        CartBean bean = new CartBean();
        bean.setId(rs.getLong(1));
        bean.setUserId(rs.getLong(2));
        bean.setProductId(rs.getLong(3));
        bean.setQuantity(rs.getInt(4));
        bean.setCreatedDatetime(rs.getTimestamp(5));
        return bean;
    }
}