package fastref;

import java.util.Comparator;

public class DocumentComparator implements Comparator<Document> {

	public DocumentComparator() {
	}

	@Override
	public int compare(Document o1, Document o2) {
		// int compare = documentName.compareTo(other.documentName);
		return o1.date.compareTo(o2.date);

	}

}
