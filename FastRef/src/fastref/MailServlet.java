package fastref;

import java.io.IOException;
import java.util.Collections;
import java.util.List;
import java.util.Properties;
import java.util.logging.Logger;

import javax.mail.Message;
import javax.mail.MessagingException;
import javax.mail.Session;
import javax.mail.Transport;
import javax.mail.internet.AddressException;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.joda.time.DateTime;

import com.googlecode.objectify.ObjectifyService;

@SuppressWarnings("serial")
public class MailServlet extends HttpServlet {
	int mailCount = 0;
	private static final Logger _logger = Logger.getLogger(MailServlet.class
			.getName());

	public void doGet(HttpServletRequest req, HttpServletResponse resp)
			throws IOException {
		Properties props = new Properties();
		Session session = Session.getDefaultInstance(props, null);

		try {
			mailCount = 0;
			List<Subscriber> subscribers = ObjectifyService.ofy().load()
					.type(Subscriber.class).list();
			// UserService userService = UserServiceFactory.getUserService();
			// User user = userService.getCurrentUser();
			Message msg = new MimeMessage(session);
			msg.setFrom(new InternetAddress("admin@j-2blog.appspotmail.com",
					"Admin"));
			msg.setSubject("Daily Digest of J-2 Blog");
			msg.setText(dailyDigest());
			if (mailCount > 0) {
				for (Subscriber subscriber : subscribers) {
					msg.addRecipient(Message.RecipientType.TO,
							new InternetAddress(subscriber.getEmail(),
									subscriber.getNickname()));
				}
				Transport.send(msg);
			}
			resp.sendRedirect("/blog.jsp");
		} catch (AddressException e) {
			resp.sendRedirect("/newEntry.jsp");
			// ...
		} catch (MessagingException e) {
			resp.sendRedirect("/newEntry.jsp");
			// ...
		} catch (Exception ex) {
			// Log any exceptions in your Cron Job
		}
	}

	@Override
	public void doPost(HttpServletRequest req, HttpServletResponse resp)
			throws ServletException, IOException {
		doGet(req, resp);
	}

	@SuppressWarnings("deprecation")
	public String dailyDigest() {
		String msgBody = "You are subscribed to receive daily Auto Digest of blog posts posted in the last 24 hours.\n\n";
		ObjectifyService.register(Entry.class);
		List<Entry> entries = ObjectifyService.ofy().load().type(Entry.class)
				.list();
		Collections.sort(entries);
		DateTime yesterday = DateTime.now().minusDays(1);
		for (Entry entry : entries) {
			DateTime dateTime = new DateTime(entry.getDate());
			if (dateTime.isBefore(yesterday)) {
				break;
			}
			msgBody = msgBody + entry.getTitle() + "\n" + entry.getContent()
					+ "\nPosted by " + entry.getUser().getNickname() + " on "
					+ entry.getDate() + "\n-----\n\n";
			mailCount++;
		}
		msgBody = msgBody + "Thanks,\nJessica Lin & John Yu";
		return msgBody;
	}
}