<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="it.unitn.webprogramming2017.progetto.DBManager"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ include file="intestazione.jsp" %>

<div class="main">
    <div class="row">
        <div class="col s12 l8">
            <h5>Categorie</h5>
            <div class="divider"></div>
            <form action="../AdminOperation" method="POST">
                <table class="bordered highlight">
                    <thead>
                        <tr>
                            <th>Nome</th>
                            <th>Descrizione</th>
                            <th>N° oggetti</th>
                            <th></th>
                            <th></th>
                        </tr>
                    </thead>
                    <tbody>
                        <%
                            String sql = "SELECT * FROM categoria";
                            PreparedStatement stm = DBManager.CON.prepareStatement(sql);

                            try (ResultSet rs = stm.executeQuery()) {
                                rs.previous();
                                while (rs.next()) {
                                    sql = "SELECT COUNT(*) AS count FROM articolo WHERE categoria_1 = '" + rs.getString("nome_categoria") + "'";
                                    PreparedStatement count = DBManager.CON.prepareStatement(sql);
                                    try (ResultSet rs_count = count.executeQuery()) {
                                        rs_count.next();

                        %>
                        <tr>
                            <%                                if (request.getParameter("modify") == null || request.getParameter("modify") != null && (!request.getParameter("modify").equals(rs.getString("nome_categoria")))) {
                            %>
                            <td><%=rs.getString("nome_categoria")%> </td>
                            <td><%=rs.getString("desc_categoria")%></td>
                            <td><%=rs_count.getString("count")%></td>
                            <td>
                                <a class="btn waves-effect waves-light red" href="?modify=<%=rs.getString("nome_categoria")%>">Modifica</a>
                            </td>
                            <%
                            } else if (request.getParameter("modify").equals(rs.getString("nome_categoria"))) {
                            %>
                            <td><input name="nome_cat" value="<%=rs.getString("nome_categoria")%>"/></td>
                            <td><input name="desc_cat" value="<%=rs.getString("desc_categoria")%>"/></td>
                            <td><%=rs_count.getString("count")%></td>
                            <td>
                                <input type="hidden" name="old_key" value="<%=rs.getString("nome_categoria")%>"/>
                                <input type="hidden" name="action" value="update_categoria">
                                <button class="btn waves-effect waves-light red" type="submit">Salva</button>
                            </td>
                            <%}
                            %>
                        </tr>

                        <%                }
                                }
                            }
                        %>
                    </tbody>
                </table>
            </form>
        </div>
    </div>
</div>