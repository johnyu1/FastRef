package fastref;

import java.util.Date;

import java.util.regex.Pattern;

import com.google.appengine.api.users.User;
import com.googlecode.objectify.annotation.Entity;
import com.googlecode.objectify.annotation.Id;

@Entity
public class Document implements Comparable<Document> {

	@Id
	Long id;
	User user;
	String documentName;
	String documentDisplayName;
	String documentKey;
	String docExt;
	String docType;
	String docRestriction;
	String documentBookmarks;
	Date date;
	
	/**
	 * Default Constructor
	 * 
	 */
	public Document() {
	}
	
	/**
	 * Document constructor - populates the fields
	 * 
	 * @param user a User object
	 * @param documentName the original name of the document
	 * @param documentInputtedName the new inputed name to rename the document
	 * @param documentKey the document blobKey.toString()
	 * @param restriction the restriction setting (either "public" or "private")
	 */
	public Document(User user, String documentName,
			String documentInputtedName, String documentKey, String restriction) {
		this.user = user;
		this.documentName = documentName;
		this.documentKey = documentKey;
		this.docRestriction = restriction;
		this.docExt = parseFileExtension(documentName);
		this.docType = determineFileType(this.docExt);
		this.documentDisplayName = createDisplayName(documentInputtedName
				.trim());
		this.documentBookmarks = "";
		date = new Date();
	}
	
	/**
	 * Returns a correctly formatted display name based on 
	 * inputed rename String of document
	 * 
	 * @param documentInputtedName the inputed new document name
	 * @return String display name with correctly appended extension
	 */
	public String createDisplayName(String documentInputtedName) {
		String displayName = documentInputtedName;
		if (displayName.equals("")) {
			return documentName;
		}
		String ext = parseFileExtension(displayName);
		if (ext.equals(docExt)) {
			return displayName;
		}
		return displayName + "." + docExt;

	}
	
	/**
	 * Parses the document name to get the 
	 * file extension
	 * 
	 * @param fileName the document name
	 * @return the file extension
	 */
	public String parseFileExtension(String fileName) {
		String[] splitName = fileName.split(Pattern.quote("."));
		String extension = splitName[splitName.length - 1].toLowerCase();
		return extension;
	}
	
	/**
	 * Determines the file type based on the 
	 * file extension. Used for grouping extensions.
	 * 
	 * @param extension the extension of the file (pdf, doc, txt, etc.)
	 * @return the file type (pdf, text, iamge, etc.)
	 */
	public String determineFileType(String extension) {
		String fileType = "file";
		if (extension.equals("pdf")) {
			fileType = "pdf";
		} else if (extension.equals("txt")) {
			fileType = "text";
		} else if (extension.equals("jpg") || extension.equals("png")
				|| extension.equals("tiff")) {
			fileType = "image";
		} else if (extension.equals("doc") || extension.equals("docx")) {
			fileType = "word";
		}
		return fileType;
	}
	
	/**
	 * Returns the user/creator of the document
	 * 
	 * @return the User/Creator Object of the corresponding document
	 */
	public User getUser() {
		return user;
	}
	
	/**
	 * Returns the document display name
	 * 
	 * @return the document display name
	 */
	public String getDocName() {
		return documentDisplayName;
	}
	
	/**
	 * Returns the documents extension
	 * 
	 * @return the documents extension (pdf, txt, png, etc.)
	 */
	public String getDocExt() {
		return docExt;
	}
	
	/**
	 * Returns the documents corresponding blobKey as a
	 * String. blobKey.toString()
	 * 
	 * @return the document key (blobKey.toString())
	 */
	public String getDocKey() {
		return documentKey;
	}
	
	/**
	 * Returns the document type.
	 * 
	 * @return the document type (pdf, text, image)
	 */
	public String getDocType() {
		return docType;
	}
	
	/**
	 * Returns the document restriction (either "public" or "private")
	 * 
	 * @return the document restriction ("public" or "private")
	 */
	public String getDocRestriction() {
		return docRestriction;
	}
	
	/**
	 * Updates the document bookmarks
	 * 
	 * @param jsoninput JSON string with all the bookmarks
	 */
	public void setBookmarks(String jsoninput) {
		documentBookmarks = jsoninput;
	}
	
	/**
	 * Returns the document bookmarks
	 * 
	 * @return the document bookmarks
	 */
	public String getBookmarks() {
		return documentBookmarks;
	}
	
	/**
	 * Returns the date/time the document was uploaded
	 * 
	 * @return the document Date
	 */
    public Date getDocDate(){
    	return date;
    }
    
    /**
     * Overriding compareTo function that compare the documents alphabetically.
     * If the file names are the same, the date/time the document was uploaded
     * is compared.
     */
    @Override
    public int compareTo(Document other) {
    	int compare = documentName.compareTo(other.documentName);
    	if(compare == 0)
    	{
	        if (date.after(other.date)) {
	
	            return 1;
	
	        } else if (date.before(other.date)) {
	
	            return -1;
	
	        }
    	}
        return compare;
    }

}