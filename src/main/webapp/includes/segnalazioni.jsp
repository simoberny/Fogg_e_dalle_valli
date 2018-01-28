<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page import="it.unitn.webprogramming2017.progetto.Negozio"%>
<%@page import="it.unitn.webprogramming2017.progetto.User"%>
<%@page import="it.unitn.webprogramming2017.progetto.Item"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="it.unitn.webprogramming2017.progetto.DBManager"%>
<%@page import="java.sql.ResultSet"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%
    User usr = (User) session.getAttribute("usr");
%>

<div class="section white">
    <div class="container">
        <div class="row">
            <div class="col s12 m10 offset-m1">
                <h5>Nuova segnalazione</h5>
                <div class="divider"></div>
                <div class="section">
                    <div class="row">
                        <div class="col s12">
                            <a class="btn-floating btn-large waves-effect waves-light myblue"><i class="material-icons">add</i></a> <strong style="padding-left: 10px;">Nuova segnalazione</strong>
                        </div>
                    </div>
                </div>
                <h5>Le mie segnalazioni</h5>
                <div class="divider"></div>

                <div class="section mobile-scroll">
                    <div class="row">
                        <form method="GET" action="">
                            <input type="hidden" name="page" value="segnalazioni"/>
                            <div class="input-field col s12 m6 l3">
                                <select onchange="this.form.submit()" name="segnalazioni">
                                    <option value="ricevute" <%=(request.getParameter("segnalazioni") != null && request.getParameter("segnalazioni").equals("ricevute")) ? "selected" : " "%>>Ricevute</option>
                                    <option value="fatte" <%=(request.getParameter("segnalazioni") != null && request.getParameter("segnalazioni").equals("fatte")) ? "selected" : " "%>>Fatte</option>
                                </select>
                                <label>Tipologia ordini</label>
                            </div>
                        </form>
                    </div>
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

                                if (request.getParameter("segnalazioni") != null && request.getParameter("segnalazioni").equals("fatte")) {
                                    sql = "SELECT * FROM segnalazione WHERE id_mittente = '" + usr.getEmail() + "'";
                                } else {
                                    sql = "SELECT * FROM segnalazione WHERE id_destinatario = '" + usr.getEmail() + "'";
                                }

                                PreparedStatement stm = DBManager.CON.prepareStatement(sql);
                                try (ResultSet rs = stm.executeQuery()) {
                                    if (!rs.next()) {
                                        out.print("<h5 class=\"center\">Nessuna segnalazione presente!</h5>");
                                    }
                                    rs.previous();
                                    while (rs.next()) {

                            %>

                            <tr>
                                <td><%=rs.getString("id_mittente")%></td>
                                <td><%=rs.getString("id_destinatario")%></td>
                                <td><%=rs.getString("oggetto")%></td>
                                <td><%=rs.getString("stato")%></td>
                                <td><%=rs.getString("data")%></td>
                                <td><a href="user.jsp?page=segnalazioni&segnalazione=<%=rs.getString("id_messaggio")%>">Dettagli</a></td>
                            </tr>

                            <%                                }
                                }
                            %>
                        </tbody>
                    </table>

                    <c:if test="${param.segnalazione != null}">
                        <%
                            sql = "SELECT * FROM segnalazione WHERE id_messaggio = " + request.getParameter("segnalazione");
                            stm = DBManager.CON.prepareStatement(sql);
                            try (ResultSet rs = stm.executeQuery()) {
                                while (rs.next()) {
                                    Item i = Item.getById(Integer.parseInt(rs.getString("id_articolo")));
                        %>
                        <div class="row">
                            <div class="col s12">
                                <div class="card-content">
                                    <ul>
                                        <li><strong>Mittente:</strong> <%=rs.getString("id_mittente")%></li>
                                        <li><strong>Destinatario:</strong> <%=rs.getString("id_destinatario")%></li>
                                        <li><strong>Data messaggio:</strong> <%=rs.getString("data")%></li>
                                        <li><h5 class="grey-text darken-2-text">Riepilogo acquisto</h5></li>
                                        <table class="highlight">
                                            <tr>
                                                <td width="120px"><img src="<%=i.foto%>" width="120px"/></td>
                                                <td><%=i.nome%></td>
                                            </tr>
                                        </table>
                                        <li><strong>Stato: </strong><span class="red-text lighten-2-text"><%=rs.getString("stato")%></span></li>
                                        <li><strong>Oggetto segnalazione:</strong> <%=rs.getString("oggetto")%></li>
                                        <li><strong>Testo messaggio:</strong> <%=rs.getString("testo")%></li>
                                    </ul>
                                </div>
                            </div>
                        </div>
                        <%
                                }
                            }
                        %>
                    </c:if>
                </div>
            </div>
        </div>
    </div>
</div>
<script>

    $(document).ready(function () {
        $('select').material_select();
    });
</script>


