package in.co.rays.util;


import java.util.List;

import in.co.rays.bean.OrderBean;
import in.co.rays.bean.OrderItemBean;

public class EmailBuilder {

    private static final String BRAND_NAME = "Klick by Kanak"; // apna app ka naam
    private static final String BRAND_COLOR = "#c62828";

    // user ki value HTML me safe daalne ke liye
    private static String esc(String s) {
        if (s == null) {
            return "";
        }
        return s.replace("&", "&amp;")
                .replace("<", "&lt;")
                .replace(">", "&gt;")
                .replace("\"", "&quot;")
                .replace("'", "&#39;");
    }

    private static String money(double amount) {
        return "&#8377; " + String.format("%.2f", amount);
    }

    // common layout: header + content + footer
    private static String wrap(String title, String content) {
        StringBuilder sb = new StringBuilder();
        sb.append("<div style='background:#f4f4f4;padding:20px;font-family:Arial,Helvetica,sans-serif;'>");
        sb.append("<div style='max-width:600px;margin:0 auto;background:#ffffff;border-radius:8px;overflow:hidden;'>");

        // header
        sb.append("<div style='background:").append(BRAND_COLOR).append(";color:#ffffff;padding:20px;text-align:center;'>");
        sb.append("<h1 style='margin:0;font-size:22px;'>").append(esc(BRAND_NAME)).append("</h1>");
        sb.append("<p style='margin:5px 0 0 0;font-size:14px;'>").append(esc(title)).append("</p>");
        sb.append("</div>");

        // content
        sb.append("<div style='padding:20px;color:#333333;font-size:14px;line-height:1.5;'>");
        sb.append(content);
        sb.append("</div>");

        // footer
        sb.append("<div style='background:#fafafa;padding:15px;text-align:center;font-size:12px;color:#888888;'>");
        sb.append("Ye ek automatic mail hai, please iska reply na karein.<br>");
        sb.append("&copy; ").append(esc(BRAND_NAME));
        sb.append("</div>");

        sb.append("</div></div>");
        return sb.toString();
    }

    public static String orderConfirmation(OrderBean order, long orderId, List<OrderItemBean> items,
            double grandTotal) {

        StringBuilder c = new StringBuilder();

        c.append("<p>Hi <b>").append(esc(order.getFullName())).append("</b>,</p>");
        c.append("<p>Thank you for your order! It has been placed successfully, and we’re getting it ready to ship. You’ll find all the details below.</p>");
        c.append("<p><b>Order ID:</b> #").append(orderId).append("</p>");

        // items table
        c.append("<table width='100%' cellpadding='8' cellspacing='0' ")
         .append("style='border-collapse:collapse;margin:15px 0;'>");
        c.append("<tr style='background:#eeeeee;text-align:left;'>")
         .append("<th>Product</th>")
         .append("<th style='text-align:right;'>Price</th>")
         .append("<th style='text-align:center;'>Qty</th>")
         .append("<th style='text-align:right;'>Total</th>")
         .append("</tr>");

        for (OrderItemBean item : items) {
            c.append("<tr style='border-bottom:1px solid #dddddd;'>")
             .append("<td>").append(esc(item.getProductName())).append("</td>")
             .append("<td style='text-align:right;'>").append(money(item.getPrice())).append("</td>")
             .append("<td style='text-align:center;'>").append(item.getQuantity()).append("</td>")
             .append("<td style='text-align:right;'>").append(money(item.getTotal())).append("</td>")
             .append("</tr>");
        }

        c.append("<tr>")
         .append("<td colspan='3' style='text-align:right;padding-top:12px;'><b>Grand Total</b></td>")
         .append("<td style='text-align:right;padding-top:12px;'><b>").append(money(grandTotal)).append("</b></td>")
         .append("</tr>");
        c.append("</table>");

        // payment + address
        c.append("<p><b>Payment Method:</b> ").append(esc(order.getPaymentMethod())).append("</p>");
        c.append("<p><b>Delivery Address:</b><br>")
         .append(esc(order.getFullName())).append("<br>")
         .append(esc(order.getAddress())).append("<br>")
         .append(esc(order.getCity())).append(" - ").append(esc(order.getPincode())).append("<br>")
         .append("Mobile: ").append(esc(order.getMobile()))
         .append("</p>");

        c.append("<p>Thank you for shopping with Klick by Kanak!</p>");

        return wrap("Order Confirmation", c.toString());
    }
}