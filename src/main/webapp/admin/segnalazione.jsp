<%@page import="it.unitn.webprogramming2017.progetto.Item"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="it.unitn.webprogramming2017.progetto.DBManager"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ include file="intestazione.jsp" %>

<div class="main">
    <div class="row">
        <div class="col s12 l8">
            <h5>Segnalazione n° <c:out value="${param.id}"></c:out></h5>
                <div class="divider"></div>

            <%                String sql = "SELECT * FROM segnalazione WHERE id_messaggio = " + request.getParameter("id");
                PreparedStatement stm = DBManager.CON.prepareStatement(sql);
                try (ResultSet rs = stm.executeQuery()) {
                    while (rs.next()) {
                        Item i = Item.getById(Integer.parseInt(rs.getString("id_articolo")));
            %>
            <div class="card">
                <div class="card-content">
                    <ul>
                        <li><strong>Mittente:</strong> <%=rs.getString("id_mittente")%></li>
                        <li><strong>Destinatario:</strong> <%=rs.getString("id_destinatario")%></li>
                        <li><strong>Data messaggio:</strong> <%=rs.getString("data")%></li>
                        <li><h5 class="grey-text darken-2-text">Riepilogo acquisto</h5></li>
                        <table class="highlight">
                            <tr>
                                <td width="120px"><img src="../<%=i.foto%>" width="120px"/></td>
                                <td><%=i.nome%></td>
                            </tr>
                        </table>
                        <li><strong>Stato: </strong><span class="red-text lighten-2-text"><%=rs.getString("stato")%></span></li>
                        <li><strong>Oggetto segnalazione:</strong> <%=rs.getString("oggetto")%></li>
                        <li><strong>Testo messaggio:</strong> <%=rs.getString("testo")%></li>
                    </ul>
                </div>
                <div class="card-action">
                    <form action="../AdminOperation" method="POST">
                        <input type="hidden" name="action" value="action_segnalazione"/>
                        <input type="hidden" name="id" value="<%=rs.getString("id_messaggio")%>"/>
                        <input type="hidden" name="ordine" value="<%=rs.getString("id_ordine")%>"/>
                        <input type="hidden" name="articolo" value="<%=i.id_articolo%>"/>

                        <button type="submit" class="waves-effect waves-light btn myblue btn_segnalazione" name="sub_action" value="rimborso">Rimborso</button>
                        <button type="submit" class="waves-effect waves-light btn myblue btn_segnalazione disabled" name="sub_action" value="segnalazione">Segnalazione venditore</button>
                        <button type="submit" class="waves-effect waves-light btn myblue btn_segnalazione" name="sub_action" value="ignora">Ignora</button>
                        <button type="submit" class="waves-effect waves-light btn myblue btn_segnalazione" name="sub_action" value="elimina">Elimina</button>
                    </form>
                </div>
            </div>
            <%
                    }
                }
            %>

        </div>
    </div>
</div>