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
import com.google.appengine.api.images.Image;
import com.google.appengine.api.images.ImagesService;
import com.google.appengine.api.images.ImagesServiceFactory;
import com.google.appengine.api.images.Transform;



import java.util.Map;
import java.util.regex.Pattern;




public class UploadServlet extends HttpServlet {

	private BlobstoreService blobstoreService = BlobstoreServiceFactory.getBlobstoreService();
	
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
		 	String extension = fileName.split(Pattern.quote("."))[1].toLowerCase();		 	
		 	String fileType = "file";
		 	if(extension.equals("pdf"))
		 	{
		 		fileType = "pdf";
		 	}
		 	else if(extension.equals("txt"))
		 	{
		 		fileType = "text";
		 	}
		 	else if(extension.equals("jpg") || fileType.equals("png") || fileType.equals("tiff"))
		 	{
		 		fileType = "image";
		 	}
		 	else if(extension.equals("doc") || fileType.equals("docx"))
		 	{
		 		fileType = "word";
		 	}
	        Document document = new Document(user, fileName, blobKey.getKeyString(), extension, fileType);
		 	ofy().save().entities(document).now();		 	
		 	
		 	res.sendRedirect("/upload.jsp");
		 	
		 	//Download the document using "/serve?blob-key=" + blobKey.getKeyString()"
	       /* if (blobKey == null) {
	            res.sendRedirect("/");
	        } else {
	            res.sendRedirect("/serve?blob-key=" + blobKey.getKeyString());
	        }*/
	 }

}