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
	boolean showSubscribe = true;
	if (user != null) {
		pageContext.setAttribute("user", user);
		ObjectifyService.register(Subscriber.class);
		List<Subscriber> subscribers = ObjectifyService.ofy().load().type(Subscriber.class).list(); 
		for(Subscriber subscriber : subscribers) {
			if(user.getEmail().equals(subscriber.getEmail())) {
				showSubscribe = false;
			}
		}
	}
%>

<html>

   <head>
      <meta charset="utf-8">
      <title>All Entries</title>
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
                  <li class="active"><a href="../allEntries.jsp">All Entries <span class="sr-only">(current)</span></a></li>
<%
	if (user != null) {
%>       
                  <li><a href="../newEntry.jsp">New Entry</a></li>
<%          
		if(showSubscribe) {
%>
                  <li><a href="../subscribe">Subscribe</a></li>
<%
		} else {
%>
                  <li><a href="/unsubscribe">Unsubscribe</a></li>
<%
		}
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
               <a href="../newEntry.jsp" class="btn btn-default btn-lg btn-block">Make a new entry</a>
            </p>
         </div>
      </div>
<%
 	}
%>
      <div class="container">
         <div class="bs-component">
            <p>
               <button type="reset" onclick="Print()" class="btn btn-default">Print</button>
               <a href="javascript:emailCurrentPage()" class="btn btn-default">Email</a>
            </p>
         </div>
      </div>
      
      <script>
         function Print() {
            window.print();
         }
         function emailCurrentPage() {
            window.location.href="mailto:?subject="+document.title+"&body="+escape(window.location.href);
         }
      </script>
<%
	ObjectifyService.register(Entry.class);
	List<Entry> entries = ObjectifyService.ofy().load().type(Entry.class).list();   
	Collections.sort(entries); 
	if (entries.isEmpty()) {
%>

      <div class="container">
         <div class="alert alert-danger">
            <p><center>There are currently no blog posts to display.</center></p>
            <p><center><img src="pictures/saddog.jpg" alt="Sad dog" style="width:80%;"></center></p>
         </div>
      </div>

<%
    } else {
%>

      <div class="container">
         <h2>All blog posts:</h2>
      </div>

<%
		for (Entry entry : entries) {
			if(entry.getTitle() == "") {
				pageContext.setAttribute("entry_title", "(Untitled)");
			} else {
				pageContext.setAttribute("entry_title", entry.getTitle());
			}
			pageContext.setAttribute("entry_content", entry.getContent());
			pageContext.setAttribute("entry_user", entry.getUser());
			pageContext.setAttribute("entry_date", entry.getDate());
%>
      <div class="container">
         <div class="panel panel-primary">
            <div class="panel-heading">
               <h1 class="panel-title"><font size = "5">${fn:escapeXml(entry_title)}</font></h1>
            </div>
            <div class="panel-body">
               <p>${fn:escapeXml(entry_content)}</p>
               <p>Posted by <b>${fn:escapeXml(entry_user.nickname)}</b> on ${fn:escapeXml(entry_date)}</p>
            </div>
         </div>
      </div>
<%
		}
	}
%>

   </body>
</html>