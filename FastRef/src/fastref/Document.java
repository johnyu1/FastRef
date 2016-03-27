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
    Date date;
    String documentKey;
    
    private Document() {}

    public Document(User user, String documentName, String documentKey) {
        this.user = user;
        this.documentName = documentName;
        this.documentKey = documentKey;
        date = new Date();
    }

    public User getUser() {
        return user;
    }

    public String getDocName() {
        return documentName;
    }
    
    public String getDocKey() {
        return documentKey;
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