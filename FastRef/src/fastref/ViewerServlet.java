package fastref;

import static com.googlecode.objectify.ObjectifyService.ofy;

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
		String json, blobkey;
		blobkey = req.getParameter("blob-key");
		UserService userService = UserServiceFactory.getUserService();
		User user = userService.getCurrentUser();
		List<Document> documents = ObjectifyService.ofy().load().type(Document.class).list();
		
		Document found_document = null;
		if(blobkey != null) {
			for (Document d : documents) {
				if (d.getDocKey().equals(blobkey)) {
					found_document = d;
					break;
				}
			}
		}
		
		json = null;
		if(found_document != null) {
			json = found_document.getBookmarks();	
			
			if(found_document.getDocRestriction().equals("private")) {
				if(user == null || (user != null && !found_document.getUser().equals(user))) {
					resp.sendRedirect("/");
					return;
				}
			}
		}
	
		req.setAttribute("blobkey", blobkey);
		req.setAttribute("json", json);
				
		req.getRequestDispatcher("viewer.jsp").forward(req, resp);
	}
	
	public void doPost(HttpServletRequest req, HttpServletResponse resp)
			throws ServletException, IOException {
		String newjson = req.getParameter("newjson");
		String sameblob = req.getParameter("sameblob");
		
		List<Document> documents = ObjectifyService.ofy().load().type(Document.class).list();
		
		Document found_document = null;
		long saveID = 0;
		if(sameblob != null) {
			for (Document d : documents) {
				if (d.getDocKey().equals(sameblob)) {
					found_document = d;
					saveID = d.id;
					break;
				}
			}
		}
		
		if(found_document != null) {
			found_document.setBookmarks(newjson);
			ofy().save().entities(found_document).now();
			
		}
		
//		req.setAttribute("blobkey", sameblob);
//		req.setAttribute("json", newjson);
//		req.getRequestDispatcher("viewer.jsp").forward(req, resp);
		
	}

}
