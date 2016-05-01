package fastref;

import java.io.IOException;
import java.util.List;

import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.google.appengine.api.blobstore.BlobKey;
import com.google.appengine.api.blobstore.BlobstoreService;
import com.google.appengine.api.blobstore.BlobstoreServiceFactory;
import com.google.appengine.api.users.User;
import com.google.appengine.api.users.UserService;
import com.google.appengine.api.users.UserServiceFactory;
import com.googlecode.objectify.ObjectifyService;

public class ServeServlet extends HttpServlet {
	private BlobstoreService blobstoreService = BlobstoreServiceFactory
			.getBlobstoreService();

	@Override
	public void doGet(HttpServletRequest req, HttpServletResponse res)
			throws IOException {
		UserService userService = UserServiceFactory.getUserService();
		User user = userService.getCurrentUser();
		List<Document> documents = ObjectifyService.ofy().load().type(Document.class).list();
		String blobkey = req.getParameter("blob-key");
		Document found_document = null;
		if(blobkey != null) {
			for (Document d : documents) {
				if (d.getDocKey().equals(blobkey)) {
					found_document = d;
					break;
				}
			}
		}
		if(found_document.getDocRestriction().equals("private")) {
			if(user == null || (user != null && !found_document.getUser().equals(user))) {
				res.sendRedirect("/");
			}
		}
		BlobKey blobKey = new BlobKey(req.getParameter("blob-key"));
		blobstoreService.serve(blobKey, res);
	}
}