package fastref;

import java.io.IOException;

import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
/**
 * Created by leela on 3/28/16.
 */
public class ListFilesServlet extends HttpServlet {

    public void doGet(HttpServletRequest req, HttpServletResponse resp)

            throws IOException {

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
        resp.sendRedirect("/listfiles.jsp");
    }
}
