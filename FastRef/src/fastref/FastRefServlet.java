package fastref;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class FastRefServlet extends HttpServlet {

	public void doGet(HttpServletRequest req, HttpServletResponse resp)
			throws ServletException, IOException {

		/*
		 * UserService userService = UserServiceFactory.getUserService(); User
		 * user = userService.getCurrentUser();
		 * 
		 * if (user != null) { resp.setContentType("text/plain");
		 * resp.getWriter().println("Hello, " + user.getNickname());
		 * //resp.sendRedirect
		 * (userService.createLogoutURL(req.getRequestURI())); } else {
		 * resp.sendRedirect(userService.createLoginURL(req.getRequestURI())); }
		 */
		
		req.getRequestDispatcher("/WEB-INF/home.jsp").forward(req, resp);
	}

}