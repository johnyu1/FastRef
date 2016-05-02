<!DOCTYPE html>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Collections" %>
<%@ page import="java.net.URLEncoder" %>
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
	<title>All Files</title>
	<meta charset="utf-8">
	<meta name="viewport" content="width=device-width, initial-scale=1">
	<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.6/css/bootstrap.min.css" integrity="sha384-1q8mTJOASx8j1Au+a5WDVnPi2lkFfwwEAa8hDDdjZlpLegxhjVME1fgjWPGmkzs7" crossorigin="anonymous">
	<link rel="stylesheet" href="http://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.4.0/css/font-awesome.min.css">
	<script src="http://code.jquery.com/jquery-2.2.2.min.js"></script>
	<script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.6/js/bootstrap.min.js" integrity="sha384-0mSbJDEHialfmuBBQP6A4Qrprq5OVfW37PRR3j5ELqxss1yVqOtnepnHVP9aJ7xS" crossorigin="anonymous"></script>

	<style>
	iframe {
		border: none;
		width: 100%;
		height: 100%;
	}
	
	.iframe-parent {
		display: flex;
		flex-direction: column;
	}
	
	.thumbnail:hover {
		text-decoration: none;
	}
	
	.document {
		padding-bottom: 10px;
	}
	
	.thumb-title {
		margin: 0;
	}
	</style>
	
	<script>
		$(document).ready(function() {
			$(".delete-btn").click(function(event) {
				event.preventDefault();
				window.location.replace($(this).attr("href"));
			});
		});
	</script>
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
					<li class="active"><a href="../listfiles.jsp">All Files</a></li>
					<li><a href="../upload.jsp">Upload</a></li>
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
		<h2>My Files</h2>
        <div class="row">
<%
	ObjectifyService.register(Document.class);
	List<Document> documents = ObjectifyService.ofy().load().type(Document.class).list();   
	Collections.sort(documents); 
	if(documents.isEmpty()){
%>
			<p>None</p>
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
	            pageContext.setAttribute("document_date", document.getDocDate());
	            String downloadLink = "";
                String pdfLink = "";
	            if(!document.getDocKey().equals(null)){
	            	downloadLink="/viewer?blob-key=" + document.getDocKey();
                    pdfLink="/serve?blob-key=" + document.getDocKey();
                    pdfLink = URLEncoder.encode(pdfLink, "UTF-8");
	            }
	            pageContext.setAttribute("document_key", downloadLink);
                pageContext.setAttribute("document_link", pdfLink);
	            String deleteLink ="/delete?blob-key=" + document.getDocKey();
	            pageContext.setAttribute("delete_link", deleteLink);
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
            <div class="col-xs-4 document">
                <a href="${fn:escapeXml(document_key)}" class="thumbnail">
                  <span class="iframe-parent">
                    <iframe src="web/viewer.html?file=${fn:escapeXml(document_link)}"></iframe>
                  </span>
                  
                  <span class="caption" style="padding: 0">
                    <span><h1 class="thumb-title" style="margin-left: 10px; display: inline-block;"><small>${fn:escapeXml(document_name)}</small></h1>
                    <span class="pull-right"><button href="${fn:escapeXml(delete_link)}" class="btn btn-danger delete-btn" style="margin-left: 10px; margin-top: 5px;">Delete</button></span></span><br />
                    <small style="margin-left: 40px; margin-bottom: 50px">${fn:escapeXml(document_date)}</small><br />

                  </span>
                </a>
            </div>
<%
        	}
        }
		if(i == 0){
%>
            <p>None</p>
<%
    	} 
	
	}
	else{
%>
        <p>Sign-in to access your private documents.</p>
<%		
	}
%>
    </div>
    
    <h2>All Files</h2>
    <div class="row">
<%
    
    if (documents.isEmpty()) {
%>
    <p>No previously uploaded documents.</p>
<%
    } else {
        for (Document document : documents) {
        	if(document.getDocRestriction().equals("public") || (document.getUser() != null && 
        			document.getUser().equals(user))){
	            pageContext.setAttribute("document_name", document.getDocName());
	            pageContext.setAttribute("document_ext", document.getDocExt());
	            pageContext.setAttribute("document_date", document.getDocDate());
	            String downloadLink = "";
	            if(!document.getDocKey().equals(null))
	            {
	            	downloadLink="/viewer?blob-key=" + document.getDocKey();
	            }
	            pageContext.setAttribute("document_key", downloadLink);
	            String deleteLink ="/delete?blob-key=" + document.getDocKey();
	            pageContext.setAttribute("delete_link", deleteLink);
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
        <div class="col-xs-4 document">
            <a href="${fn:escapeXml(document_key)}" class="thumbnail">
              <span class="caption" style="padding: 0">
                <span><h1 class="thumb-title" style="margin-left: 10px; display: inline-block;"><small>${fn:escapeXml(document_name)}</small></h1></span><br />
                <small style="margin-left: 40px; margin-bottom: 50px">${fn:escapeXml(document_date)}</small><br />
              </span>
            </a>
        </div>
<%
        	}
        }
    }
%>
        </div>
        </div>
</body>
</html>
