package in.co.rays.model;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

import in.co.rays.bean.OrderBean;
import in.co.rays.bean.OrderItemBean;
import in.co.rays.exception.ApplicationException;
import in.co.rays.exception.DuplicateRecordException;
import in.co.rays.util.EmailBuilder;
import in.co.rays.util.EmailUtility;
import in.co.rays.util.JDBCDataSource;

public class OrderModel extends BaseModel<OrderBean> {

    private static final String COLUMNS = "id, user_id, full_name, mobile, address, city, pincode, "
            + "payment_method, total_amount, status, created_datetime";

    
    public long nextPK() throws ApplicationException {

        long pk = 0;
        Connection conn = null;

        try {
            conn = JDBCDataSource.getConnection();
            pk = nextId(conn, "orders");
        } catch (Exception e) {
            throw new ApplicationException("Exception in getting PK of Order");
        } finally {
            JDBCDataSource.closeConnection(conn);
        }

        return pk;
    }

    // cart ke saare items ka order
    public long placeOrder(OrderBean order) throws ApplicationException {
        return placeOrder(order, 0, 0);
    }

    // productId > 0: Buy Now (sirf ek product, cart ko haath nahi lagta)
    // productId = 0: poora cart
    public long placeOrder(OrderBean order, long productId, int qty) throws ApplicationException {

        Connection conn = null;
        long orderId = 0;
        String userEmail = null;
        List<OrderItemBean> items = new ArrayList<OrderItemBean>();
        double grandTotal = 0;

        try {
            conn = JDBCDataSource.getConnection();
            conn.setAutoCommit(false);

            if (productId > 0) {
                // Buy Now: ek product
                if (qty <= 0) {
                    throw new ApplicationException("Quantity must be at least 1");
                }

                String sql = "SELECT id, name, price, discount_percent FROM products WHERE id = ?";

                try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
                    pstmt.setLong(1, productId);

                    try (ResultSet rs = pstmt.executeQuery()) {
                        if (rs.next()) {
                            items.add(buildItem(rs.getLong(1), rs.getString(2), rs.getDouble(3),
                                    rs.getDouble(4), qty));
                        }
                    }
                }

                if (items.isEmpty()) {
                    throw new ApplicationException("Product not found");
                }

            } else {
                // poora cart
                String cartSql = "SELECT c.product_id, c.quantity, p.name, p.price, p.discount_percent "
                        + "FROM cart c JOIN products p ON c.product_id = p.id WHERE c.user_id = ?";

                try (PreparedStatement pstmt = conn.prepareStatement(cartSql)) {
                    pstmt.setLong(1, order.getUserId());

                    try (ResultSet rs = pstmt.executeQuery()) {
                        while (rs.next()) {
                            items.add(buildItem(rs.getLong(1), rs.getString(3), rs.getDouble(4),
                                    rs.getDouble(5), rs.getInt(2)));
                        }
                    }
                }

                if (items.isEmpty()) {
                    throw new ApplicationException("Your cart is empty");
                }
            }

            for (OrderItemBean item : items) {
                grandTotal += item.getTotal();
            }
            grandTotal = Math.round(grandTotal * 100.0) / 100.0;

            // user ka email nikalo (mail bhejne ke liye)
            // NOTE: table/column name apne DB ke hisaab se badalna (users / email)
            try (PreparedStatement pstmt = conn.prepareStatement("SELECT email FROM users WHERE id = ?")) {
                pstmt.setLong(1, order.getUserId());
                try (ResultSet rs = pstmt.executeQuery()) {
                    if (rs.next()) {
                        userEmail = rs.getString(1);
                    }
                }
            }

            // order insert
            orderId = nextId(conn, "orders");

            String orderSql = "INSERT INTO orders (" + COLUMNS + ") VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

            try (PreparedStatement pstmt = conn.prepareStatement(orderSql)) {
                pstmt.setLong(1, orderId);
                pstmt.setLong(2, order.getUserId());
                pstmt.setString(3, order.getFullName());
                pstmt.setString(4, order.getMobile());
                pstmt.setString(5, order.getAddress());
                pstmt.setString(6, order.getCity());
                pstmt.setString(7, order.getPincode());
                pstmt.setString(8, order.getPaymentMethod());
                pstmt.setDouble(9, grandTotal);
                pstmt.setString(10, "PLACED");
                pstmt.setTimestamp(11, new Timestamp(System.currentTimeMillis()));
                pstmt.executeUpdate();
            }

            // har item: stock kam karo + order_items me daalo
            long itemId = nextId(conn, "order_items");

            String stockSql = "UPDATE products SET quantity = quantity - ? WHERE id = ? AND quantity >= ?";
            String itemSql = "INSERT INTO order_items (id, order_id, product_id, product_name, price, quantity, total) "
                    + "VALUES (?, ?, ?, ?, ?, ?, ?)";

            for (OrderItemBean item : items) {

                try (PreparedStatement pstmt = conn.prepareStatement(stockSql)) {
                    pstmt.setInt(1, item.getQuantity());
                    pstmt.setLong(2, item.getProductId());
                    pstmt.setInt(3, item.getQuantity());

                    if (pstmt.executeUpdate() == 0) {
                        throw new ApplicationException("Not enough stock for " + item.getProductName());
                    }
                }

                try (PreparedStatement pstmt = conn.prepareStatement(itemSql)) {
                    pstmt.setLong(1, itemId++);
                    pstmt.setLong(2, orderId);
                    pstmt.setLong(3, item.getProductId());
                    pstmt.setString(4, item.getProductName());
                    pstmt.setDouble(5, item.getPrice());
                    pstmt.setInt(6, item.getQuantity());
                    pstmt.setDouble(7, item.getTotal());
                    pstmt.executeUpdate();
                }
            }

            // cart sirf tab khali hota hai jab cart se order hua ho
            if (productId == 0) {
                try (PreparedStatement pstmt = conn.prepareStatement("DELETE FROM cart WHERE user_id = ?")) {
                    pstmt.setLong(1, order.getUserId());
                    pstmt.executeUpdate();
                }
            }

            conn.commit();

        } catch (ApplicationException e) {
            rollback(conn);
            throw e;
        } catch (Exception e) {
            rollback(conn);
            throw new ApplicationException("Exception in placing Order");
        } finally {
            JDBCDataSource.closeConnection(conn);
        }

        // ---- commit ho chuka hai, ab confirmation mail bhejo ----
        // Mail fail ho to bhi order safe rahe, isliye alag thread aur alag try/catch
        if (userEmail != null && !userEmail.trim().isEmpty()) {
            final String to = userEmail;
            final String subject = "Order Confirmation - Order #" + orderId;
            final String body = EmailBuilder.orderConfirmation(order, orderId, items, grandTotal);

            new Thread(() -> {
                try {
                    EmailUtility.sendMail(to, subject, body);
                } catch (Exception e) {
                    e.printStackTrace(); // yahan logger use kar sakte ho
                }
            }).start();
        }

        return orderId;
    }
    // order-specific: user ke saare orders, items ke saath
    public List<OrderBean> findByUser(long userId) throws ApplicationException {

        List<OrderBean> list = new ArrayList<OrderBean>();
        Connection conn = null;

        try {
            conn = JDBCDataSource.getConnection();

            try (PreparedStatement pstmt = conn.prepareStatement(
                    "SELECT " + COLUMNS + " FROM orders WHERE user_id = ? ORDER BY id DESC")) {
                pstmt.setLong(1, userId);

                try (ResultSet rs = pstmt.executeQuery()) {
                    while (rs.next()) {
                        list.add(populate(rs));
                    }
                }
            }

            for (OrderBean order : list) {
                loadItems(conn, order);
            }

        } catch (Exception e) {
            throw new ApplicationException("Exception in getting Orders");
        } finally {
            JDBCDataSource.closeConnection(conn);
        }

        return list;
    }

    
    public OrderBean findByPK(long id) throws ApplicationException {

        OrderBean bean = null;
        Connection conn = null;

        try {
            conn = JDBCDataSource.getConnection();

            try (PreparedStatement pstmt = conn.prepareStatement(
                    "SELECT " + COLUMNS + " FROM orders WHERE id = ?")) {
                pstmt.setLong(1, id);

                try (ResultSet rs = pstmt.executeQuery()) {
                    while (rs.next()) {
                        bean = populate(rs);
                    }
                }
            }

            if (bean != null) {
                loadItems(conn, bean);
            }

        } catch (Exception e) {
            throw new ApplicationException("Exception in finding Order");
        } finally {
            JDBCDataSource.closeConnection(conn);
        }

        return bean;
    }

    // order sirf placeOrder() se banta hai
    @Override
    public long add(OrderBean bean) throws ApplicationException, DuplicateRecordException {
        return placeOrder(bean);
    }

    // abhi sirf status update hota hai
    @Override
    public void update(OrderBean bean) throws ApplicationException, DuplicateRecordException {

        Connection conn = null;

        try {
            conn = JDBCDataSource.getConnection();
            conn.setAutoCommit(false);

            try (PreparedStatement pstmt = conn.prepareStatement("UPDATE orders SET status = ? WHERE id = ?")) {
                pstmt.setString(1, bean.getStatus());
                pstmt.setLong(2, bean.getId());
                pstmt.executeUpdate();
            }

            conn.commit();

        } catch (Exception e) {
            rollback(conn);
            throw new ApplicationException("Exception in updating Order");
        } finally {
            JDBCDataSource.closeConnection(conn);
        }
    }

    @Override
    public String getWhereClause(OrderBean bean) {

        StringBuilder where = new StringBuilder(" WHERE 1=1");

        if (bean != null && bean.getUserId() > 0) {
            where.append(" AND user_id = " + bean.getUserId());
        }

        return where.toString();
    }

    @Override
    public String getTable() {
        return "orders";
    }

    @Override
    public OrderBean getBean() {
        return new OrderBean();
    }

    private OrderItemBean buildItem(long productId, String name, double price, double discount, int qty) {
        double finalPrice = Math.round((price - (price * discount / 100)) * 100.0) / 100.0;

        OrderItemBean item = new OrderItemBean();
        item.setProductId(productId);
        item.setProductName(name);
        item.setPrice(finalPrice);
        item.setQuantity(qty);
        item.setTotal(Math.round(finalPrice * qty * 100.0) / 100.0);
        return item;
    }

    private long nextId(Connection conn, String table) throws SQLException {
        long pk = 0;
        try (PreparedStatement pstmt = conn.prepareStatement("SELECT MAX(id) FROM " + table);
                ResultSet rs = pstmt.executeQuery()) {
            if (rs.next()) {
                pk = rs.getLong(1);
            }
        }
        return pk + 1;
    }

    private void loadItems(Connection conn, OrderBean order) throws SQLException {

        String sql = "SELECT id, order_id, product_id, product_name, price, quantity, total "
                + "FROM order_items WHERE order_id = ?";

        try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setLong(1, order.getId());

            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    OrderItemBean item = new OrderItemBean();
                    item.setId(rs.getLong(1));
                    item.setOrderId(rs.getLong(2));
                    item.setProductId(rs.getLong(3));
                    item.setProductName(rs.getString(4));
                    item.setPrice(rs.getDouble(5));
                    item.setQuantity(rs.getInt(6));
                    item.setTotal(rs.getDouble(7));
                    order.getItems().add(item);
                }
            }
        }
    }

    private void rollback(Connection conn) {
        try {
            if (conn != null) {
                conn.rollback();
            }
        } catch (SQLException ex) {
            // rollback fail hua, ignore
        }
    }

    private OrderBean populate(ResultSet rs) throws SQLException {
        OrderBean bean = new OrderBean();
        bean.setId(rs.getLong(1));
        bean.setUserId(rs.getLong(2));
        bean.setFullName(rs.getString(3));
        bean.setMobile(rs.getString(4));
        bean.setAddress(rs.getString(5));
        bean.setCity(rs.getString(6));
        bean.setPincode(rs.getString(7));
        bean.setPaymentMethod(rs.getString(8));
        bean.setTotalAmount(rs.getDouble(9));
        bean.setStatus(rs.getString(10));
        bean.setCreatedDatetime(rs.getTimestamp(11));
        return bean;
    }
}