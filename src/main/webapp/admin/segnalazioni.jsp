<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="it.unitn.webprogramming2017.progetto.DBManager"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ include file="intestazione.jsp" %>

<div class="main mobile-scroll">
    <div class="row">
        <div class="col s12 l8">
            <h5>Segnalazioni<c:if test="${param.tipo == 'chiuse'}"><c:out value=" Risolte"></c:out></c:if><c:if test="${param.tipo == 'aperte'}"><c:out value=" Aperte"></c:out></c:if></h5>
                    <div class="divider"></div>
                    <table class="bordered highlight">
                        <thead>
                            <tr>
                                <th>Mittente</th>
                                <th>Destazione</th>
                                <th>Oggetto</th>
                                <th>Stato</th>
                                <th>Data</th>
                            </tr>
                        </thead>
                        <tbody>
                    <%
                        String sql = " ";

                        if (request.getParameter("tipo") != null && request.getParameter("tipo").equals("chiuse")) {
                            sql = "SELECT * FROM segnalazione WHERE stato = 'chiusa'";
                        } else {
                            sql = "SELECT * FROM segnalazione WHERE stato = 'aperta'";
                        }

                        PreparedStatement stm = DBManager.CON.prepareStatement(sql);
                        try (ResultSet rs = stm.executeQuery()) {
                            while (rs.next()) {

                    %>

                    <tr>
                        <td><%=rs.getString("id_mittente")%></td>
                        <td><%=rs.getString("id_destinatario")%></td>
                        <td><%=rs.getString("oggetto")%></td>
                        <td><%=rs.getString("stato")%></td>
                        <td><%=rs.getString("data")%></td>
                        <td><a href="segnalazione.jsp?id=<%=rs.getString("id_messaggio")%>">Dettagli</a></td>
                    </tr>
                    <%
                            }
                        }
                    %>
                </tbody>
            </table>
        </div>
    </div>
</div>