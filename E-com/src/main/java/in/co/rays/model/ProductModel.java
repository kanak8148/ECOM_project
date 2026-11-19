package in.co.rays.model;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

import in.co.rays.bean.ProductBean;
import in.co.rays.exception.ApplicationException;
import in.co.rays.exception.DuplicateRecordException;
import in.co.rays.util.JDBCDataSource;

public class ProductModel extends BaseModel<ProductBean> {

    // images yahan save hongi, apne system ke hisaab se badal lo
    public static final String IMAGE_DIR = "C:/RaysSoftware/uploads/products";

    private static final String COLUMNS = "id, name, description, price, discount_percent, rating, "
            + "quantity, category, image, created_datetime, modified_datetime";

    public long nextPK() throws ApplicationException {

        long pk = 0;
        Connection conn = null;

        try {
            conn = JDBCDataSource.getConnection();

            try (PreparedStatement pstmt = conn.prepareStatement("SELECT MAX(id) FROM products");
                    ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    pk = rs.getLong(1);
                }
            }

        } catch (Exception e) {
            throw new ApplicationException("Exception in getting PK of Product");
        } finally {
            JDBCDataSource.closeConnection(conn);
        }

        return pk + 1;
    }

    @Override
    public long add(ProductBean bean) throws ApplicationException, DuplicateRecordException {

        if (findByName(bean.getName()) != null) {
            throw new DuplicateRecordException("Product already exists");
        }

        String sql = "INSERT INTO products (" + COLUMNS + ") "
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
                pstmt.setString(2, bean.getName());
                pstmt.setString(3, bean.getDescription());
                pstmt.setDouble(4, bean.getPrice());
                pstmt.setDouble(5, bean.getDiscountPercent());
                pstmt.setDouble(6, bean.getRating());
                pstmt.setInt(7, bean.getQuantity());
                pstmt.setString(8, bean.getCategory());
                pstmt.setString(9, bean.getImage());
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
                // rollback fail hua, ignore
            }

            throw new ApplicationException("Exception in adding Product");

        } finally {
            JDBCDataSource.closeConnection(conn);
        }

        return pk;
    }

    @Override
    public void update(ProductBean bean) throws ApplicationException, DuplicateRecordException {

        ProductBean existBean = findByName(bean.getName());

        if (existBean != null && existBean.getId() != bean.getId()) {
            throw new DuplicateRecordException("Product already exists");
        }

        String sql = "UPDATE products SET name = ?, description = ?, price = ?, discount_percent = ?, "
                + "rating = ?, quantity = ?, category = ?, image = ?, modified_datetime = ? "
                + "WHERE id = ?";

        Connection conn = null;

        try {
            conn = JDBCDataSource.getConnection();
            conn.setAutoCommit(false);

            try (PreparedStatement pstmt = conn.prepareStatement(sql)) {

                pstmt.setString(1, bean.getName());
                pstmt.setString(2, bean.getDescription());
                pstmt.setDouble(3, bean.getPrice());
                pstmt.setDouble(4, bean.getDiscountPercent());
                pstmt.setDouble(5, bean.getRating());
                pstmt.setInt(6, bean.getQuantity());
                pstmt.setString(7, bean.getCategory());
                pstmt.setString(8, bean.getImage());
                pstmt.setTimestamp(9, new Timestamp(System.currentTimeMillis()));
                pstmt.setLong(10, bean.getId());

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

            throw new ApplicationException("Exception in updating Product");

        } finally {
            JDBCDataSource.closeConnection(conn);
        }
    }

    public ProductBean findByPK(long id) throws ApplicationException {

        String sql = "SELECT " + COLUMNS + " FROM products WHERE id = ?";

        ProductBean bean = null;
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
            throw new ApplicationException("Exception in finding Product");
        } finally {
            JDBCDataSource.closeConnection(conn);
        }

        return bean;
    }

    // product-specific: naya method
    public ProductBean findByName(String name) throws ApplicationException {

        String sql = "SELECT " + COLUMNS + " FROM products WHERE name = ?";

        ProductBean bean = null;
        Connection conn = null;

        try {
            conn = JDBCDataSource.getConnection();

            try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
                pstmt.setString(1, name);

                try (ResultSet rs = pstmt.executeQuery()) {
                    while (rs.next()) {
                        bean = populate(rs);
                    }
                }
            }

        } catch (Exception e) {
            throw new ApplicationException("Exception in finding Product");
        } finally {
            JDBCDataSource.closeConnection(conn);
        }

        return bean;
    }

    // product-specific: name empty ho to saare products, warna name se search
    public List<ProductBean> search(String name) throws ApplicationException {

        StringBuilder sql = new StringBuilder("SELECT " + COLUMNS + " FROM products WHERE 1=1");

        boolean hasName = name != null && !name.trim().isEmpty();

        if (hasName) {
            sql.append(" AND name LIKE ?");
        }
        sql.append(" ORDER BY id DESC");

        List<ProductBean> list = new ArrayList<ProductBean>();
        Connection conn = null;

        try {
            conn = JDBCDataSource.getConnection();

            try (PreparedStatement pstmt = conn.prepareStatement(sql.toString())) {

                if (hasName) {
                    pstmt.setString(1, name.trim() + "%");
                }

                try (ResultSet rs = pstmt.executeQuery()) {
                    while (rs.next()) {
                        list.add(populate(rs));
                    }
                }
            }

        } catch (Exception e) {
            throw new ApplicationException("Exception in searching Product");
        } finally {
            JDBCDataSource.closeConnection(conn);
        }

        return list;
    }

    @Override
    public String getWhereClause(ProductBean bean) {

        StringBuilder where = new StringBuilder(" WHERE 1=1");

        if (bean != null) {
            if (bean.getName() != null && !bean.getName().trim().isEmpty()) {
                where.append(" AND name LIKE '" + bean.getName().trim().replace("'", "''") + "%'");
            }
            if (bean.getCategory() != null && !bean.getCategory().trim().isEmpty()) {
                where.append(" AND category = '" + bean.getCategory().trim().replace("'", "''") + "'");
            }
        }

        return where.toString();
    }

    @Override
    public String getTable() {
        return "products";
    }

    @Override
    public ProductBean getBean() {
        return new ProductBean();
    }

    private ProductBean populate(ResultSet rs) throws SQLException {
        ProductBean bean = new ProductBean();
        bean.setId(rs.getLong(1));
        bean.setName(rs.getString(2));
        bean.setDescription(rs.getString(3));
        bean.setPrice(rs.getDouble(4));
        bean.setDiscountPercent(rs.getDouble(5));
        bean.setRating(rs.getDouble(6));
        bean.setQuantity(rs.getInt(7));
        bean.setCategory(rs.getString(8));
        bean.setImage(rs.getString(9));
        bean.setCreatedDatetime(rs.getTimestamp(10));
        bean.setModifiedDatetime(rs.getTimestamp(11));
        return bean;
    }
}