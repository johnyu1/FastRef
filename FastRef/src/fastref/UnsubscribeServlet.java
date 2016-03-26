package fastref;

import static com.googlecode.objectify.ObjectifyService.ofy;

import java.io.IOException;
import java.util.List;

import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.google.appengine.api.users.User;
import com.google.appengine.api.users.UserService;
import com.google.appengine.api.users.UserServiceFactory;
import com.googlecode.objectify.ObjectifyService;

public class UnsubscribeServlet extends HttpServlet {
	static {
		ObjectifyService.register(Subscriber.class);
	}

	public void doGet(HttpServletRequest req, HttpServletResponse resp)
			throws IOException {
		String message = "";
		boolean subscriberExists = false;
		String blogName = req.getParameter("blogName");
		UserService userService = UserServiceFactory.getUserService();
		User user = userService.getCurrentUser();
		List<Subscriber> subscribers = ObjectifyService.ofy().load()
				.type(Subscriber.class).list();
		for (Subscriber currentSubscriber : subscribers) {
			String email = currentSubscriber.getUser().getEmail();
			String userEmail = user.getEmail();
			if (email.equals(userEmail)) {
				subscriberExists = true;
				ofy().delete().entities(currentSubscriber).now();
			}
		}
		resp.sendRedirect("/unsubscribe.jsp?blogName=" + blogName);
	}

}