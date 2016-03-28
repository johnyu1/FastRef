<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Collections" %>
<%@ page import="fastref.Document" %>
<%@ page import="com.googlecode.objectify.*" %>
<%@ page import="com.google.appengine.api.users.User" %>
<%@ page import="com.google.appengine.api.users.UserService" %>
<%@ page import="com.google.appengine.api.users.UserServiceFactory" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ page import="com.google.appengine.api.blobstore.BlobstoreServiceFactory" %>
<%@ page import="com.google.appengine.api.blobstore.BlobstoreService" %>
<link rel="stylesheet" href="http://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.4.0/css/font-awesome.min.css">
 
<%
BlobstoreService blobstoreService = BlobstoreServiceFactory.getBlobstoreService();
%>

 

<html>

  <head>
	<link type="text/css" rel="stylesheet" href="/stylesheets/main.css" />
  </head>

 

  <body>


    
<body>
    <form action="<%= blobstoreService.createUploadUrl("/upload") %>" method="post" enctype="multipart/form-data">
        <input type="file" name="document">
        <input type="submit" value="Submit">
        <input type="hidden" name="guestbookName" value="${fn:escapeXml(guestbookName)}"/>
    </form>
</body>


<%
	ObjectifyService.register(Document.class);
	List<Document> documents = ObjectifyService.ofy().load().type(Document.class).list();   
	Collections.sort(documents); 
    if (documents.isEmpty()) {
%>
        <p>There are no documents.</p>
<%
    } else {
%>
        <p>Current uploaded documents</p>
<%
        for (Document document : documents) {
            pageContext.setAttribute("document_name", document.getDocName());
            pageContext.setAttribute("document_ext", document.getDocExt());
            String downloadLink = "";
            if(!document.getDocKey().equals(null))
            {
            	downloadLink="/serve?blob-key=" + document.getDocKey();
            }
            pageContext.setAttribute("document_key", downloadLink);
            String documentType = document.getDocType();
            String docType = "fa fa-file-o";
            if(documentType != null) {
				if(documentType.equals("pdf"))
	            {
	            	docType = "fa fa-file-pdf-o";
	            }
	            else if(documentType.equals("text"))
	            {
	            	docType = "fa fa-file-text-o";
	            }
	            else if(documentType.equals("word"))
	            {
	            	docType = "fa fa-file-word-o";
	            }
	            else if(documentType.equals("image"))
	            {
	            	docType = "fa fa-file-image-o";
	            }
            }
			pageContext.setAttribute("document_type", docType);
           
%>
            <div>
            	<a href=${fn:escapeXml(document_key)}>
            		<i class='${fn:escapeXml(document_type)}' style="font-size:48px"></i>
            		${fn:escapeXml(document_name)}
            	</a>
            	
            </div>

<%
        }
    }

%>

  </body>

</html>