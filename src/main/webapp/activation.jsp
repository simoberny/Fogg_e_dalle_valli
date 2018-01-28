<%@page import="java.util.List"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ include file="intestazione.jsp" %>

<div class="container"> 
    <div class="row">
        <div class="access_console col s12 m6 l4 xl4 offset-m3 offset-l4 offset-xl4 white">
            <div class="col s10 offset-s1">
                <form method="POST" action="ResendActivation">
                    <% if (request.getParameter("error") != null) {
                    %>
                    <h5 class="center red-text">Password non corretta!</h5>
                    <%
                        }
                    %>
                    <h5>Rimanda link di attivazione</h5>
                    <input type="hidden" name="email" value="<%= usr.getEmail()%>">
                    <div class="input-field col s12">
                        <input id="password" type="password" class="validate" name="password" required>
                        <label for="password">Password</label>
                    </div>
                    <button class="btn waves-effect waves-light btn-submit" type="submit" name="action">Send</button>
                </form>
            </div>
        </div>
    </div>
</div>

<%@ include file="footer.jsp" %>