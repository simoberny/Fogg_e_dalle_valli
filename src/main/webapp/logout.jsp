<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%
    session.invalidate();

    Cookie[] killCookie = request.getCookies();
    if (killCookie != null) //if(readCookie.length<=1)
    {
        for (int i = 0; i < killCookie.length; i++) {
            killCookie[i].getValue();
            killCookie[i].setValue("");
            killCookie[i].setMaxAge(0);
            response.addCookie(killCookie[i]);
        }
    }

    response.setHeader("Refresh", "1; URL=access.jsp");

%>