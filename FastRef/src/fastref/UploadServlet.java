package fastref;

import static com.googlecode.objectify.ObjectifyService.ofy;

import com.googlecode.objectify.ObjectifyService;
import com.google.appengine.api.users.User;
import com.google.appengine.api.users.UserService;
import com.google.appengine.api.users.UserServiceFactory;

import fastref.Document;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.google.appengine.api.blobstore.BlobInfo;
import com.google.appengine.api.blobstore.BlobInfoFactory;
import com.google.appengine.api.blobstore.BlobKey;
import com.google.appengine.api.blobstore.BlobstoreService;
import com.google.appengine.api.blobstore.BlobstoreServiceFactory;

import java.util.Map;

public class UploadServlet extends HttpServlet {

	private BlobstoreService blobstoreService = BlobstoreServiceFactory
			.getBlobstoreService();

	static {
		ObjectifyService.register(Document.class);
	}

	@Override
	public void doPost(HttpServletRequest req, HttpServletResponse res)
			throws ServletException, IOException {
		UserService userService = UserServiceFactory.getUserService();
		User user = userService.getCurrentUser();
		@SuppressWarnings("deprecation")
		Map<String, BlobKey> blobs = blobstoreService.getUploadedBlobs(req);
		BlobKey blobKey = blobs.get("document");
		BlobInfoFactory blobInfoFactory = new BlobInfoFactory();
		BlobInfo blobInfo = blobInfoFactory.loadBlobInfo(blobKey);
		String fileName = blobInfo.getFilename();
		String viewerLink = "/viewer?blob-key=" + blobKey.getKeyString();
		if (fileName.equals("")) {
			res.sendRedirect("/upload.jsp");
			return;
		}
		String fileDisplayName = req.getParameter("newFileName");
		String restriction = req.getParameter("restriction");
		Document document = new Document(user, fileName, fileDisplayName,
				blobKey.getKeyString(), restriction);
		ofy().save().entities(document).now();
		//res.sendRedirect("/upload.jsp");
		try {
		    Thread.sleep(1000);                 //1000 milliseconds is one second.
		} catch(InterruptedException ex) {
		    Thread.currentThread().interrupt();
		}
		res.sendRedirect(viewerLink);
	}

}