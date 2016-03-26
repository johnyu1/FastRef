<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Collections" %>
<%@ page import="fastref.Entry" %>
<%@ page import="com.googlecode.objectify.*" %>
<%@ page import="com.google.appengine.api.users.User" %>
<%@ page import="com.google.appengine.api.users.UserService" %>
<%@ page import="com.google.appengine.api.users.UserServiceFactory" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>


<html>

   <head>
      <meta charset="utf-8">
      <title>New Entry</title>
      <meta name="viewport" content="width=device-width, initial-scale=1">
      <link rel="stylesheet" href="/stylesheets/bootstrap.css">
      <script src="js/jquery.min.js" type="text/javascript"></script>
      <script src="js/bootstrap.min.js" type="text/javascript"></script>
   </head>

   <body>
      <nav class="navbar navbar-default">
          <div class="container">
            <div class="navbar-header">
               <button type="button" class="navbar-toggle collapsed" data-toggle="collapse" data-target="#bs-example-navbar-collapse-1">
                  <span class="sr-only">Toggle navigation</span>
                  <span class="icon-bar"></span>
                  <span class="icon-bar"></span>
                  <span class="icon-bar"></span>
               </button>
               <a class="navbar-brand" href="../">J-2 Blog</a>
            </div>

            <div class="collapse navbar-collapse" id="bs-example-navbar-collapse-1">
               <ul class="nav navbar-nav">
                  <li><a href="../allEntries.jsp">All Entries </a></li>
                  <li class="active"><a href="../newEntry.jsp">New Entry <span class="sr-only">(current)</span></a></li>
               </ul>
               <ul class="nav navbar-nav navbar-right">
<%
	UserService userService = UserServiceFactory.getUserService();
	User user = userService.getCurrentUser();
	if (user != null) {
		pageContext.setAttribute("user", user);
%>
                  <li><a>${fn:escapeXml(user.nickname)}</a></li>
                  <li><a href="<%= userService.createLogoutURL("/blog.jsp") %>">Sign Out</a></li>
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
         <form class="form-horizontal" action="/sign" method="post">
            <fieldset>
               <legend><h1>Create a new blog entry</h1></legend>
               <div class="form-group">
                  <label for="textArea" class="col-lg-2 control-label">Title</label>
                  <div class="col-lg-10">
                     <textarea name="title" class="form-control" rows="1" id="textArea"></textarea>
                  </div>
               </div>
               <div class="form-group">
                  <label for="textArea" class="col-lg-2 control-label">Text</label>
                  <div class="col-lg-10">
                     <textarea name="content" class="form-control" rows="8" id="textArea"></textarea>
                  </div>
               </div>
               <div class="form-group">
                  <div class="col-lg-10 col-lg-offset-2">
                     <button type="reset" onclick="document.location.href='../blog.jsp'" class="btn btn-default">Cancel</button>
                     <button type="submit" value="post" class="btn btn-primary">Submit</button>
                  </div>
               </div>
            </fieldset>
         </form>
      </div>
      
   </body>
   
</html>