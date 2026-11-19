package in.co.rays.bean;

public interface EComView {
	// Tomcat mein project ka context path (Servers → Modules mein "Path" dekh), pom ke finalName jaisa
		public String APP_CONTEXT = "/E-com";
		public String PAGE_FOLDER = "/jsp";

		public String LOGIN_VIEW = PAGE_FOLDER + "/Login.jsp";
		public String USER_REGISTRATION_VIEW = PAGE_FOLDER + "/UserRegistrationView.jsp";
		public String WELCOME_VIEW = PAGE_FOLDER + "/Welcome.jsp";

		public String LOGIN_CTL = APP_CONTEXT + "/LoginCtl";
		public String USER_REGISTRATION_CTL = APP_CONTEXT + "/UserRegistrationCtl";
		public String WELCOME_CTL = APP_CONTEXT + "/WelcomeCtl";
	}

