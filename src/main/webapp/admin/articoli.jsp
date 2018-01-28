<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="it.unitn.webprogramming2017.progetto.DBManager"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ include file="intestazione.jsp" %>

<div class="main">
    <div class="row">
        <div class="col s12 l8">
            <h5>Articoli</h5>
            <div class="divider"></div>
            <table class="bordered highlight">
                <thead>
                    <tr>
                        <th>Nome</th>
                        <th>Categoria</th>
                        <th>Foto</th>
                        <th>Negozio</th>
                        <th>Valutazione</th>
                        <th>Elimina</th>
                    </tr>
                </thead>
                <tbody>
                    <%                        String sql = "SELECT * FROM articolo";
                        PreparedStatement stm = DBManager.CON.prepareStatement(sql);
                        try (ResultSet rs = stm.executeQuery()) {
                            if (!rs.next()) {
                                out.print("<h4 class=\"center\">Ancora nessun prodotto!</h4>");
                            }
                            rs.previous();
                            while (rs.next()) {

                    %>

                    <tr>
                        <td><%=rs.getString("nome")%></td>
                        <td><%=rs.getString("categoria_1")%></td>
                        <td><img src="../<%=rs.getString("foto")%>" width="100px"/></td>
                        <td><%=rs.getString("negozio")%></td>
                        <td>                                                
                            <div class="rating center" data-rating="<%=rs.getString("media_recensioni")%>">
                                <i class="star-1">★</i>
                                <i class="star-2">★</i>
                                <i class="star-3">★</i>
                                <i class="star-4">★</i>
                                <i class="star-5">★</i>
                            </div>
                        </td>
                        <td>
                            <form method="POST" action="../AdminOperation">
                                <input type="hidden" name="action" value="cancella_prodotto"/>
                                <input type="hidden" name="id_prodotto" value="<%=rs.getString("id_articolo")%>"/>
                                <a class="btn-floating waves-effect waves-light red"><i class="material-icons">close</i></a>
                            </form>
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