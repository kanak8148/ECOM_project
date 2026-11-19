package in.co.rays.util;

import java.io.InputStream;
import java.util.Properties;

import javax.mail.Authenticator;
import javax.mail.Message;
import javax.mail.MessagingException;
import javax.mail.PasswordAuthentication;
import javax.mail.Session;
import javax.mail.Transport;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;

public class EmailUtility {
	 // Gmail SMTP settings
	  // Agar system.properties kisi package folder me hai (jaise in/co/rays/bundle/),
    // to yahan poora path likho: "in/co/rays/bundle/system.properties"
    private static final String PROPS_FILE = "system.properties";

    private static final Properties PROPS = new Properties();

    static {
        try (InputStream in = EmailUtility.class.getClassLoader().getResourceAsStream(PROPS_FILE)) {
            if (in == null) {
                throw new RuntimeException(PROPS_FILE + " not found in classpath");
            }
            PROPS.load(in);
        } catch (Exception e) {
            throw new ExceptionInInitializerError(e);
        }
    }

    private static Session getSession() {
        final String username = PROPS.getProperty("mail.username");
        final String password = PROPS.getProperty("mail.password");

        return Session.getInstance(PROPS, new Authenticator() {
            @Override
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(username, password);
            }
        });
    }

    public static void sendMail(String to, String subject, String htmlBody) throws MessagingException {
        Message message = new MimeMessage(getSession());
        message.setFrom(new InternetAddress(PROPS.getProperty("mail.username")));
        message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(to));
        message.setSubject(subject);
        message.setContent(htmlBody, "text/html; charset=utf-8");
        Transport.send(message);
    }
}