package fastref;

import static org.junit.Assert.*;

import org.junit.After;
import org.junit.Before;
import org.junit.Test;

import com.google.appengine.api.users.User;

import fastref.Document;

public class DocumentTest {
	Document document;
	User user;

	@Before
	public void setUp() throws Exception {
		user = new User("test@example.com", "example.com");
		document = new Document(user, "Name.pdf", "NewName", "docKey", "private");
	}

	@After
	public void tearDown() throws Exception {
	}
	
	/**
	 * Tests that the default constructor creates a Document object
	 */
	@Test
	public void testDocumentConstructor() {
		assertNotNull(new Document());
	}
	
	/**
	 * Tests that the constructed object is not null.
	 */
	@Test
	public void testDocumentWithParameterConstructor() {
		assertNotNull(document);
	}
	
	/**
	 * Creates display name with a file name that has a single extension
	 * and verifies correct display name created
	 */
	@Test
	public void testCreateDisplayNameWithExt() {
		String displayName = document.createDisplayName("OrigName.pdf", "NewName.pdf");
		assertEquals("NewName.pdf", displayName);
	}

	/**
	 * Creates display name with a file name that has a no extension
	 * and verifies correct display name created
	 */
	@Test
	public void testCreateDisplayNameWithNoExt() {
		String displayName = document.createDisplayName("OrigName.pdf", "NewName");
		assertEquals("NewName.pdf", displayName);
	}
	
	/**
	 * Creates display name with a file name that has a multiple extensions
	 * and verifies correct display name created
	 */
	@Test
	public void testCreateDisplayNameWithMultipleExt() {
		String displayName = document.createDisplayName("OrigName.pdf", "NewName.doc.pdf");
		assertEquals("NewName.doc.pdf", displayName);
	}
	
	/**
	 * Creates display name with a file name that has a wrong extension
	 * and verifies correct display name created
	 */
	@Test
	public void testCreateDisplayNameWithWrongExt() {
		String displayName = document.createDisplayName("OrigName.pdf", "NewName.pdf.doc");
		assertEquals("NewName.pdf.doc.pdf", displayName);
	}
	
	/**
	 * Parses a file name that has a extension and verifies
	 * correct extension is parsed.
	 */
	@Test
	public void testParseFileExtension() {
		String extension = document.parseFileExtension("fileName.pdf");
		assertEquals("pdf", extension);
	}
	
	/**
	 * Parses a file name that has a extension and verifies
	 * correct extension is parsed.
	 */
	@Test
	public void testParseFileExtensionNoExtension() {
		String extension = document.parseFileExtension("fileName");
		assertEquals("", extension);
	}
	
	/**
	 * Parses a file name that has a extension and verifies
	 * correct extension is parsed.
	 */
	@Test
	public void testParseFileExtensionMultipleExtensions() {
		String extension = document.parseFileExtension("fileName.pdf.docx");
		assertEquals("docx", extension);
	}
	
	/**
	 * Determines a file type from a given valid extension and verifies
	 * correct type is returned.
	 */
	@Test
	public void testDetermineFileTypeValidExt() {
		String type = document.determineFileType("pdf");
		assertEquals("pdf", type);
	}
	
	/**
	 * Determines a file type from a given unknown extension and verifies
	 * "file" type is returned.
	 */
	@Test
	public void testDetermineFileTypeUnknownExt() {
		String type = document.determineFileType("RANDOM");
		assertEquals("file", type);
	}
	
	/**
	 * Get the User object and verify it is the correct object.
	 */
	@Test
	public void testGetUser() {
		assertEquals(user, document.getUser());
	}
	
	/**
	 * Get the document name and verify it is the correct value.
	 */
	@Test
	public void testGetDocName() {
		assertEquals("NewName.pdf", document.getDocName());
	}

	/**
	 * Get the document extension and verify it is the correct value.
	 */
	@Test
	public void testGetDocExt() {
		assertEquals("pdf", document.getDocExt());
	}

	/**
	 * Get the document key and verify it is the correct value.
	 */
	@Test
	public void testGetDocKey() {
		assertEquals("docKey", document.getDocKey());
	}

	/**
	 * Get the document type and verify it is the correct value.
	 */
	@Test
	public void testGetDocType() {
		assertEquals("pdf", document.getDocType());
	}

	/**
	 * Get the document restriction and verify it is the correct value.
	 */
	@Test
	public void testGetDocRestriction() {
		assertEquals("private", document.getDocRestriction());
	}

	/**
	 * Set and get the document name and verify it is the correct value.
	 */
	@Test
	public void testSetGetBookmarks() {
		document.setBookmarks("JSONINPUT");
		assertEquals("JSONINPUT", document.getBookmarks());
	}

	/**
	 * Get the document date and verify it is the correct value.
	 */
	@Test
	public void testGetDocDate() {
		assertNotNull(document.getDocDate());
	}
	
	/**
	 * Creates a new document and compare it to the original document.
	 * Verify that new document is "less than" the original document as it 
	 * is alphabetized higher.
	 */
	@Test
	public void testCompareToDiffName() {
		Document newDoc = new Document(user, "A.pdf", "A", "docKey", "private");
		assertEquals(-1, determineSignOfNumber(newDoc.compareTo(document)));
	}
	
	/**
	 * Creates a new document and compare it to the original document.
	 * Verify that new document is "greater than" the original document as it 
	 * was created later.
	 */
	@Test
	public void testCompareToSameName() {
		try {
		    Thread.sleep(1000);                 //1000 milliseconds is one second.
		    Document newDoc = new Document(user, "Name.pdf", "NewName", "docKey", "private");
			assertEquals(1, determineSignOfNumber(newDoc.compareTo(document)));
		} catch(InterruptedException ex) {
		    Thread.currentThread().interrupt();
		}
		
	}
	
	/**
	 * Determine if integer is negative, zero, or positive.
	 * 
	 * @param nbr the number to be evaluated
	 * @return -1 if negative, 0 if zero, and 1 if positive
	 */
	public int determineSignOfNumber(int nbr)
	{
		int negOfNbr = nbr * -1;
		if(negOfNbr > nbr){
			return -1;
		}
		else if(negOfNbr < nbr){
			return 1;
		}
		return 0;
	}

}
