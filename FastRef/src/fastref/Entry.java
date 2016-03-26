package fastref;

import java.util.Date;

import com.google.appengine.api.users.User;
import com.googlecode.objectify.annotation.Entity;
import com.googlecode.objectify.annotation.Id;

@Entity
public class Entry implements Comparable<Entry> {
	@Id
	Long id;
	User user;
	String title;
	String content;
	Date date;

	private Entry() {
	}

	public Entry(User user, String title, String content, Date date) {
		this.user = user;
		this.title = title;
		this.content = content;
		this.date = date;
	}

	public User getUser() {
		return user;
	}

	public String getTitle() {
		return title;
	}

	public String getContent() {
		return content;
	}

	public Date getDate() {
		return date;
	}

	@Override
	public int compareTo(Entry other) {
		if (date.after(other.date)) {
			return -1;
		} else if (date.before(other.date)) {
			return 1;
		}
		return 0;
	}
}
