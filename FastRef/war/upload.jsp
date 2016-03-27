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
        <input type="file" name="myFile">
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
            String redirectURL="/serve?blob-key=" + document.getDocKey();
            pageContext.setAttribute("document_key", redirectURL);
           
%>
            <div>
            	<a href= ${fn:escapeXml(redirectURL)}>${fn:escapeXml(document_name)}</a>
            </div>
<%
        }
    }

%>

  </body>

</html>