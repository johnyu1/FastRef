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
	UserService userService = UserServiceFactory.getUserService();
	User user = userService.getCurrentUser();
	if (user != null) {
		pageContext.setAttribute("user", user);
	}
%>
<html>
<head>
	<title>Upload</title>
	<meta charset="utf-8">
	<meta name="viewport" content="width=device-width, initial-scale=1">
	<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.6/css/bootstrap.min.css" integrity="sha384-1q8mTJOASx8j1Au+a5WDVnPi2lkFfwwEAa8hDDdjZlpLegxhjVME1fgjWPGmkzs7" crossorigin="anonymous">
	<link type="text/css" rel="stylesheet" href="/stylesheets/fileinput.min.css" />
	<link rel="stylesheet" href="http://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.4.0/css/font-awesome.min.css">
	<script src="http://code.jquery.com/jquery-2.2.2.min.js"></script>
	<script src=js/fileinput.min.js type="text/javascript"></script>
	<script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.6/js/bootstrap.min.js" integrity="sha384-0mSbJDEHialfmuBBQP6A4Qrprq5OVfW37PRR3j5ELqxss1yVqOtnepnHVP9aJ7xS" crossorigin="anonymous"></script>

</head>
    
<body>
	<nav class="navbar navbar-default">
		<div class="container">
			<div class="navbar-header">
				<button type="button" class="navbar-toggle collapsed" data-toggle="collapse" data-target="#mynavbar">
					<span class="sr-only">Toggle navigation</span>
					<span class="icon-bar"></span>
					<span class="icon-bar"></span>
					<span class="icon-bar"></span>
				</button>
				<a class="navbar-brand" href="../">FastRef</a>
			</div>
			<div class="collapse navbar-collapse" id="mynavbar">
				<ul class="nav navbar-nav">
					<li><a href="../listfiles.jsp">All Files</a></li>
					<li class="active"><a href="../upload.jsp">Upload</a></li>
				</ul>
				<ul class="nav navbar-nav navbar-right">
					<%
						if (user != null) {
					%>
                  <li><a>Welcome ${fn:escapeXml(user.nickname)}</a></li>
                  <li><a href="<%= userService.createLogoutURL(request.getRequestURI()) %>">Sign Out</a></li>
					<%
						} else {
					%>
                  <li><a href="<%= userService.createLoginURL(request.getRequestURI()) %>">Sign In</a></li>
					<%
					}
					%>
				</ul>
			</div>
		</div>
	</nav>

	<div class="container">
		<img class="center-block" src="pictures/upload-cloud.svg" alt="Upload-cloud" style="width:50%;"></p>
	</div>

	<div class="container">
	    <form role="form" action="<%= blobstoreService.createUploadUrl("/upload") %>" method="post" enctype="multipart/form-data">
			<div class="form-group">
				 <label for="textArea">Rename File (leave blank for original file name): </label>
                 <div>
                     <textarea name="newFileName" class="form-control" rows="1" id="textArea"></textarea>
                  </div>
                <input type="radio" name="restriction" value="private" checked> Private<br>
				<input type="radio" name="restriction" value="public"> Public<br>
				<label class="sr-only" for="file">Choose a file</label>
				<input type="file" class="file" name="document"/>
			</div>

			
			<!-- <button type="submit" class="btn btn-primary btn-lg center-block" value="Submit">Submit</button>
			 -->
		</form>
	</div>

	<div class="container">
		<p>Private Documents: </p>
	</div>
<%
	ObjectifyService.register(Document.class);
	List<Document> documents = ObjectifyService.ofy().load().type(Document.class).list();   
	Collections.sort(documents); 
	if(documents.isEmpty()){
%>
		<div class="container">
			<p>None</p>
		</div>
<%
	}
	else if(user != null){
		int i = 0;
        for (Document document : documents) {
        	if(document.getDocRestriction().equals("private") && document.getUser() != null && 
        			document.getUser().equals(user)){
        		i++;
	            pageContext.setAttribute("document_name", document.getDocName());
	            pageContext.setAttribute("document_ext", document.getDocExt());
	            pageContext.setAttribute("document_restrictions", document.getDocRestriction());
	            String downloadLink = "";
	            if(!document.getDocKey().equals(null)){
	            	downloadLink="/serve?blob-key=" + document.getDocKey();
	            }
	            pageContext.setAttribute("document_key", downloadLink);
	            String documentType = document.getDocType();
	            String docType = "fa fa-file-o";
	            if(documentType != null) {
					if(documentType.equals("pdf")){
		            	docType = "fa fa-file-pdf-o";
		            }
		            else if(documentType.equals("text")){
		            	docType = "fa fa-file-text-o";
		            }
		            else if(documentType.equals("word")){
		            	docType = "fa fa-file-word-o";
		            }
		            else if(documentType.equals("image")){
		            	docType = "fa fa-file-image-o";
		            }
					
	            }
				pageContext.setAttribute("document_type", docType);	           
%>
			<div class="container">
				<a href=${fn:escapeXml(document_key)}>
					<i class='${fn:escapeXml(document_type)}' style="font-size:48px"></i>
						${fn:escapeXml(document_name)}
				</a>     	
			</div>
<%
        	}
        }
		if(i == 0){
%>
			<div class="container">
				<p>None</p>
			</div>
<%
    	} 
	
	}
	else{
%>
		<div class="container">
			<p>Sign-in to access your private documents.</p>
		</div>
<%		
	}
    if (documents.isEmpty()) {
%>
<!--<div class="container">
		<p>No previously uploaded documents.</p>
	</div>  -->
<%
    } else {
%>
	<div class="container">
		<p>All uploaded documents:</p>
	</div>
<%
		
        for (Document document : documents) {
        	if(document.getDocRestriction().equals("public") || (document.getUser() != null && 
        			document.getUser().equals(user))){
	            pageContext.setAttribute("document_name", document.getDocName());
	            pageContext.setAttribute("document_ext", document.getDocExt());
	            pageContext.setAttribute("document_restrictions", document.getDocRestriction());
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
		<div class="container">
			<a href=${fn:escapeXml(document_key)}>
				<i class='${fn:escapeXml(document_type)}' style="font-size:48px"></i>
					${fn:escapeXml(document_name)}
			</a>     
		</div>
<%
        	}
        }
    }
%>
</body>
</html>
