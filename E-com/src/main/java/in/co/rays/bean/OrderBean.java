package in.co.rays.bean;

import java.util.ArrayList;
import java.util.List;

public class OrderBean extends BaseBean {

    private long userId;
    private String fullName;
    private String mobile;
    private String address;
    private String city;
    private String pincode;
    private String paymentMethod;
    private double totalAmount;
    private String status;

    // order ke items (orders table me store nahi hote)
    private List<OrderItemBean> items = new ArrayList<OrderItemBean>();

    public long getUserId() { return userId; }
    public void setUserId(long userId) { this.userId = userId; }

    public String getFullName() { return fullName; }
    public void setFullName(String fullName) { this.fullName = fullName; }

    public String getMobile() { return mobile; }
    public void setMobile(String mobile) { this.mobile = mobile; }

    public String getAddress() { return address; }
    public void setAddress(String address) { this.address = address; }

    public String getCity() { return city; }
    public void setCity(String city) { this.city = city; }

    public String getPincode() { return pincode; }
    public void setPincode(String pincode) { this.pincode = pincode; }

    public String getPaymentMethod() { return paymentMethod; }
    public void setPaymentMethod(String paymentMethod) { this.paymentMethod = paymentMethod; }

    public double getTotalAmount() { return totalAmount; }
    public void setTotalAmount(double totalAmount) { this.totalAmount = totalAmount; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public List<OrderItemBean> getItems() { return items; }
    public void setItems(List<OrderItemBean> items) { this.items = items; }
	@Override
	public String getValue() {
		// TODO Auto-generated method stub
		return null;
	}
}