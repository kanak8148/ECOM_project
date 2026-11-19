package in.co.rays.bean;

import java.sql.Timestamp;

public class ProductBean extends BaseBean {
	
	

	    private long id;
	    private String name;
	    private String description;
	    private double price;
	    private double discountPercent;
	    private double rating;
	    private int quantity;
	    private String category;
	    private String image;
	    private Timestamp createdDatetime;
	    private Timestamp modifiedDatetime;

	    // discount ke baad ka price, DB me store nahi hota
	    public double getDiscountPrice() {
	        double dp = price - (price * discountPercent / 100);
	        return Math.round(dp * 100.0) / 100.0;
	    }

	    public long getId() { return id; }
	    public void setId(long id) { this.id = id; }

	    public String getName() { return name; }
	    public void setName(String name) { this.name = name; }

	    public String getDescription() { return description; }
	    public void setDescription(String description) { this.description = description; }

	    public double getPrice() { return price; }
	    public void setPrice(double price) { this.price = price; }

	    public double getDiscountPercent() { return discountPercent; }
	    public void setDiscountPercent(double discountPercent) { this.discountPercent = discountPercent; }

	    public double getRating() { return rating; }
	    public void setRating(double rating) { this.rating = rating; }

	    public int getQuantity() { return quantity; }
	    public void setQuantity(int quantity) { this.quantity = quantity; }

	    public String getCategory() { return category; }
	    public void setCategory(String category) { this.category = category; }

	    public String getImage() { return image; }
	    public void setImage(String image) { this.image = image; }

	    public Timestamp getCreatedDatetime() { return createdDatetime; }
	    public void setCreatedDatetime(Timestamp createdDatetime) { this.createdDatetime = createdDatetime; }

	    public Timestamp getModifiedDatetime() { return modifiedDatetime; }
	    public void setModifiedDatetime(Timestamp modifiedDatetime) { this.modifiedDatetime = modifiedDatetime; }
	


	@Override
	public String getValue() {
		// TODO Auto-generated method stub
		return null;
	}

}
