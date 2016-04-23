package fastref;

import java.util.List;
import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.google.appengine.api.users.User;
import com.google.appengine.api.users.UserService;
import com.google.appengine.api.users.UserServiceFactory;
import com.googlecode.objectify.ObjectifyService;

public class ViewerServlet extends HttpServlet {

	static {
		ObjectifyService.register(Document.class);
	}
	
	public void doGet(HttpServletRequest req, HttpServletResponse resp)
			throws ServletException, IOException {
		String documentKey = req.getParameter("id");
		UserService userService = UserServiceFactory.getUserService();
		User user = userService.getCurrentUser();
		List<Document> documents = ObjectifyService.ofy().load().type(Document.class).list();
		Document serve = new Document();
		for(Document d : documents) {
			if(d.documentKey.equals(documentKey)) {
				serve = d;
			}
		}
		serve.getUser();
		
//		if(!serve.getUser().equals(user)) {
			//resp.sendError(404);
//		}
		
		req.getRequestDispatcher("/WEB-INF/viewer.jsp").forward(req, resp);
	
		//resp.sendRedirect("/upload.jsp");
	}

}
