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
      <title>J-2 Blog</title>
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

      <div class="container">
         <div class="jumbotron">
            <h1>J-2 Blog</h1>
            <p>Welcome to John and Jessica's blog for EE 461L. We hope you enjoy your stay!</p>
            <img src="/pictures/redpanda.jpg" alt="Red Panda" style="width:100%;">
         </div>
      </div>

<%
	ObjectifyService.register(Entry.class);
	List<Entry> entries = ObjectifyService.ofy().load().type(Entry.class).list();   
	Collections.sort(entries); 
    if (entries.isEmpty()) {
%>
        
      <div class="container">
         <div class="alert alert-danger">
            <p>There are currently no blog posts to display.</p>
         </div>
      </div>

<%
	} else {
%>

      <div class="container">
         <h2>Most recent blog posts: </h2>
      </div>

<%
		int nbrRecentEntries = 3;
		if(entries.size() < 3) {
			nbrRecentEntries = entries.size();
		}
		for (int i = 0; i < nbrRecentEntries; i+=1) {
			if(entries.get(i).getTitle() == ""){
				pageContext.setAttribute("entry_title", "(Untitled)");
			} else {
				pageContext.setAttribute("entry_title", entries.get(i).getTitle());
			} 
			pageContext.setAttribute("entry_content", entries.get(i).getContent());
			pageContext.setAttribute("entry_user", entries.get(i).getUser());
			pageContext.setAttribute("entry_date", entries.get(i).getDate());
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