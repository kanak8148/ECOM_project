package in.co.rays.bean;

public class OrderItemBean {

    private long id;
    private long orderId;
    private long productId;
    private String productName;
    private double price;
    private int quantity;
    private double total;

    public long getId() { return id; }
    public void setId(long id) { this.id = id; }

    public long getOrderId() { return orderId; }
    public void setOrderId(long orderId) { this.orderId = orderId; }

    public long getProductId() { return productId; }
    public void setProductId(long productId) { this.productId = productId; }

    public String getProductName() { return productName; }
    public void setProductName(String productName) { this.productName = productName; }

    public double getPrice() { return price; }
    public void setPrice(double price) { this.price = price; }

    public int getQuantity() { return quantity; }
    public void setQuantity(int quantity) { this.quantity = quantity; }

    public double getTotal() { return total; }
    public void setTotal(double total) { this.total = total; }
}