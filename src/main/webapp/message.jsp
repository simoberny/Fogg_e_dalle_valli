<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ include file="intestazione.jsp" %>
<%
    String message = request.getParameter("message");
%>

<div class="section">
    <div class="container">
        <div class="row">
            <div class="col s12 m6 offset-m3 white">
                <h5 class="center"><fmt:message key="message"/></h5>
                <h4 class="myblue_text center"><fmt:message key="<%=message%>"/></h4>
            </div>
        </div>
    </div>
</div>
<%
    if (request.getParameter("origin") != null) {
        response.setHeader("Refresh", "2; URL=" + request.getParameter("origin"));
    }

    response.setHeader("Refresh", "2; URL=index.jsp");
%>
</body>
</html>
