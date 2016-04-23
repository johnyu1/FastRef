package fastref;

import java.util.Date;

import java.util.regex.Pattern;

import com.google.appengine.api.blobstore.BlobKey;
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

	public Document() {
	}

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

	public String parseFileExtension(String fileName) {
		String[] splitName = fileName.split(Pattern.quote("."));
		String extension = splitName[splitName.length - 1].toLowerCase();
		return extension;
	}

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

	public User getUser() {
		return user;
	}

	public String getDocName() {
		return documentDisplayName;
	}

	public String getDocExt() {
		return docExt;
	}

	public String getDocKey() {
		return documentKey;
	}

	public String getDocType() {
		return docType;
	}

	public String getDocRestriction() {
		return docRestriction;
	}

	public void setBookmarks(String jsoninput) {
		documentBookmarks = jsoninput;
	}

	public String getBookmarks() {
		return documentBookmarks;
	}

	@Override
	public int compareTo(Document other) {
		int compare = documentName.compareTo(other.documentName);
		if (compare == 0) {
			if (date.after(other.date)) {

				return 1;

			} else if (date.before(other.date)) {

				return -1;

			}
		}
		return compare;

	}

}