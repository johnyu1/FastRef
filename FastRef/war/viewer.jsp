<!DOCTYPE html>
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
	<title>Viewer</title>
	<meta charset="utf-8">
	<meta name="viewport" content="width=device-width, initial-scale=1">
	<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.6/css/bootstrap.min.css" integrity="sha384-1q8mTJOASx8j1Au+a5WDVnPi2lkFfwwEAa8hDDdjZlpLegxhjVME1fgjWPGmkzs7" crossorigin="anonymous">
	<link rel="stylesheet" href="http://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.4.0/css/font-awesome.min.css">
	<script src="http://code.jquery.com/jquery-2.2.2.min.js"></script>
	<script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.6/js/bootstrap.min.js" integrity="sha384-0mSbJDEHialfmuBBQP6A4Qrprq5OVfW37PRR3j5ELqxss1yVqOtnepnHVP9aJ7xS" crossorigin="anonymous"></script>
	<script src="js/pdf/pdf.js"></script>
	<script src="js/fastref2.js"></script>

<%	String blobkey = (String)request.getAttribute("blobkey"); %>
<%	String json = (String)request.getAttribute("json"); 
	if(json.equals("")) {
		json = "{}";
	}
	String downloadLink="/serve?blob-key=" + blobkey;
	String viewerLink="../viewer?blob-key=" + blobkey;
	pageContext.setAttribute("downloadLink", downloadLink);
%>
	
	<script>
		var blobid = '<%= blobkey%>';
		var pdf_url = '/serve?blob-key=<%= blobkey%>';
		keywords = <%= json%>;

        loadPDF(function() {
            renderPage(1);
        });
    </script>
    
    <style>
    .keyword-panel {
        margin-top: 10px;
        margin-bottom: 0px;
        cursor: pointer;
    }

    .click-remove {
        cursor: pointer;
    }

    .kw {
        margin-left: 10px;
    }
    </style>
	

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
					<li><a href="../upload.jsp">Upload</a></li>
				</ul>
				<ul class="nav navbar-nav navbar-right">
					<%
						if (user != null) {
					%>
                  <li><a>Welcome ${fn:escapeXml(user.nickname)}</a></li>
                  <li><a href="<%= userService.createLogoutURL(viewerLink) %>">Sign Out</a></li>
					<%
						} else {
					%>
                  <li><a href="<%= userService.createLoginURL(viewerLink) %>">Sign In</a></li>
					<%
					}
					%>
				</ul>
			</div>
		</div>
	</nav>
	
	<div class="container">
 		<div class="row">
			<div class="col-md-4"> 
				<div class="btn-group btn-group-justified">
					<a href="${fn:escapeXml(downloadLink)}" class="btn btn-info">Download</a>
					<a onclick="postJSON(keywords, blobid)" class="btn btn-success">Save</a>
                </div>
                <p id="saved"></p>
				<form role="form" id="keyword-form" class="form-inline" style="margin-top: 10px">
					<div class="form-group"> 
						<input class="form-control" type="text" id="keyword" placeholder="Search keyword"/>
                    </div>
                    <div class="form-group"> 
	                    <div class="btn-group" role="group" style="display:flex">
	                    <button type="button" class="btn btn-default" id="page-less"><span class="glyphicon glyphicon-chevron-left"></span></button>
	                    <button type="button" class="btn btn-default disabled" style="cursor: default" id="page-num">1</button>
	                    <button type="button" class="btn btn-default" id="page-more"><span class="glyphicon glyphicon-chevron-right"></span></button>
	                    </div>
                    </div>
                    
				</form>
				
                <form role="form" id="keyword-add-form" class="form-inline" style="margin-top: 20px">
					<div class="form-group"> 
						<input class="form-control" type="text" id="add-keyword" placeholder="New Keyword" />
					</div>
					<div class="form-group"> 
						<input class="form-control" style="width: 60px" type="text" id="add-page" placeholder="Page"/>
                   	</div>
                   	<div class="form-group"> 
                    	<button class="btn btn-default" type="submit">Add</button> 
                    </div>
				</form>
           
                <div id="panel-holder" style="margin-bottom: 20px; padding: 0px; max-height: 500px">
                </div>
 			</div>
			<div class="col-md-8"> 
				   
				<canvas id="the-canvas" style="border:1px  solid black"></canvas>
		  	</div>
		</div>
	</div>
	

</body>
</html>
