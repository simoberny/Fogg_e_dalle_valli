<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="it.unitn.webprogramming2017.progetto.DBManager"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ include file="intestazione.jsp" %>

<div class="main">
    <div class="row">
        <div class="col s12 l8">
            <h5><c:if test="${param.tipo == 'all'}"><c:out value="Tutti gli "></c:out></c:if>Utenti<c:if test="${param.tipo != 'all'}"><c:out value=" da confermare"></c:out></c:if></h5>
                    <div class="divider"></div>
                    <table class="bordered highlight">
                        <thead>
                            <tr>
                                <th>Nome/Cognome</th>
                                <th>Email</th>
                                <th>Foto</th>
                                <th>Data registrazione</th>
                                <th>Venditore</th>
                            <c:if test="${param.tipo != 'all'}">
                            <th>Conferma</th>
                            </c:if>
                    </tr>
                </thead>
                <tbody>
                    <%
                        String sql = "SELECT * FROM utente";

                        if (request.getParameter("tipo") != null && !request.getParameter("tipo").equals("all")) {
                            sql = "SELECT * FROM utente WHERE data_conferma_registrazione IS NULL";
                        }
                        PreparedStatement stm = DBManager.CON.prepareStatement(sql);
                        try (ResultSet rs = stm.executeQuery()) {
                            while (rs.next()) {

                    %>

                    <tr>
                        <td><%=rs.getString("nome")%> <%=rs.getString("cognome")%></td>
                        <td><%=rs.getString("email")%></td>
                        <td><img src="../<%=rs.getString("avatar")%>" width="50px"/></td>
                        <td><%=rs.getString("data_registrazione")%></td>
                        <td>
                            <%
                                if (rs.getString("tipo_utente").equals("2")) {
                            %>
                            <img src="../img/tick.png" width="20"/>
                            <%
                                }
                            %>
                        </td>
                        <td>
                            <%
                                if (rs.getString("data_conferma_registrazione") == null) {
                            %>
                            <form method="POST" action="../AdminOperation">
                                <input type="hidden" name="utente" value="<%=rs.getString("email")%>">
                                <input type="hidden" name="action" value="conferma_utente">
                                <button class="btn waves-effect waves-light red" type="submit">Conferma</button>
                            </form>
                            <%
                                }
                            %>
                        </td>
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