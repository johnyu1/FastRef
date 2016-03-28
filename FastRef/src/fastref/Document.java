package fastref;

import java.util.Date;

 


import com.google.appengine.api.blobstore.BlobKey;
import com.google.appengine.api.users.User;
import com.googlecode.objectify.annotation.Entity;
import com.googlecode.objectify.annotation.Id;


@Entity

public class Document implements Comparable<Document> {

    @Id Long id;
    User user;
    String documentName;
    String documentKey;
    String docExt;
    String docType;
    Date date;
    
    
    private Document() {}

    public Document(User user, String documentName, String documentKey, String docExt, String docType) {
        this.user = user;
        this.documentName = documentName;
        this.documentKey = documentKey;
        this.docExt = docExt;
        this.docType = docType;
        date = new Date();
    }

    public User getUser() {
        return user;
    }

    public String getDocName() {
        return documentName;
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

    @Override

    public int compareTo(Document other) {

        if (date.after(other.date)) {

            return 1;

        } else if (date.before(other.date)) {

            return -1;

        }

        return 0;

    }

}