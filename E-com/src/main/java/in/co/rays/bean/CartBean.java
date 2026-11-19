package in.co.rays.bean;

public class CartBean extends BaseBean {

	private long userId;
	private long productId;
	private int quantity;

	// join se aane wali product ki details (cart table me store nahi hoti)
	private String productName;
	private String image;
	private double price;
	private double discountPercent;
	private int stock;

	public double getDiscountPrice() {
		double dp = price - (price * discountPercent / 100);
		return Math.round(dp * 100.0) / 100.0;
	}

	public double getTotal() {
		return Math.round(getDiscountPrice() * quantity * 100.0) / 100.0;
	}

	public long getUserId() {
		return userId;
	}

	public void setUserId(long userId) {
		this.userId = userId;
	}

	public long getProductId() {
		return productId;
	}

	public void setProductId(long productId) {
		this.productId = productId;
	}

	public int getQuantity() {
		return quantity;
	}

	public void setQuantity(int quantity) {
		this.quantity = quantity;
	}

	public String getProductName() {
		return productName;
	}

	public void setProductName(String productName) {
		this.productName = productName;
	}

	public String getImage() {
		return image;
	}

	public void setImage(String image) {
		this.image = image;
	}

	public double getPrice() {
		return price;
	}

	public void setPrice(double price) {
		this.price = price;
	}

	public double getDiscountPercent() {
		return discountPercent;
	}

	public void setDiscountPercent(double discountPercent) {
		this.discountPercent = discountPercent;
	}

	public int getStock() {
		return stock;
	}

	public void setStock(int stock) {
		this.stock = stock;
	}

	@Override
	public String getValue() {
		// TODO Auto-generated method stub
		return null;
	}
}