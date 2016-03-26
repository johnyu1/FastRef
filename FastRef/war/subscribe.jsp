<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Collections" %>
<%@ page import="fastref.Entry" %>
<%@ page import="fastref.Subscriber" %>
<%@ page import="com.googlecode.objectify.*" %>
<%@ page import="com.google.appengine.api.users.User" %>
<%@ page import="com.google.appengine.api.users.UserService" %>
<%@ page import="com.google.appengine.api.users.UserServiceFactory" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<%
    UserService userService = UserServiceFactory.getUserService();
    User user = userService.getCurrentUser();
    if (user != null) {
		pageContext.setAttribute("user", user);
    }
%>

<html>

   <head>
      <meta charset="utf-8">
      <title>Subscribed!</title>
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
<%
    if (user != null) {
%>       
                  <li><a href="../newEntry.jsp">New Entry</a></li>
                  <li><a href="/unsubscribe">Unsubscribe</a></li>
<%
	}
%>
               </ul>
               <ul class="nav navbar-nav navbar-right">
<%
    if (user != null) {
%>
                  <li><a>${fn:escapeXml(user.nickname)}</a></li>
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

<%
	if(user != null) {
%>

      <div class="container">
         <div class="bs-component">
            <p>
               <a href="../blog.jsp" class="btn btn-default btn-lg btn-block">Return to Homepage</a>
            </p>
         </div>
      </div>
<%
 	}
%>

      <div class="container">
         <div class="alert alert-danger">
            <p><center>Thank you for subscribing to J-2 Blog! You will receive daily digest emails of recent posts. </center></p>
            <p><center><img src="pictures/happydog.jpg" alt="Happy dog" style="width:80%;"></center></p>
         </div>
      </div>

   </body>

</html>