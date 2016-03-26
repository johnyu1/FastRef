package fastref;

import static com.googlecode.objectify.ObjectifyService.ofy;

import java.io.IOException;
import java.util.Date;

import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.google.appengine.api.users.User;
import com.google.appengine.api.users.UserService;
import com.google.appengine.api.users.UserServiceFactory;
import com.googlecode.objectify.ObjectifyService;

public class SignBlogServlet extends HttpServlet {
	static {
		ObjectifyService.register(Entry.class);
	}

	public void doPost(HttpServletRequest req, HttpServletResponse resp)
			throws IOException {
		UserService userService = UserServiceFactory.getUserService();
		User user = userService.getCurrentUser();
		String blogName = req.getParameter("blogName");
		String title = req.getParameter("title");
		String content = req.getParameter("content");
		Date date = new Date();
		Entry entry = new Entry(user, title, content, date);
		// ofy().save().entities(entry).now();
		ofy().save().entities(entry);
		resp.sendRedirect("/blog.jsp?blogName=" + blogName);

	}

}