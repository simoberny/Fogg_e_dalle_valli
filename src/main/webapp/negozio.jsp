
<%@ include file="intestazione.jsp" %>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page import="it.unitn.webprogramming2017.progetto.Utility"%>
<%@page import="it.unitn.webprogramming2017.progetto.Negozio"%>
<%@page import="it.unitn.webprogramming2017.progetto.User"%>
<%@page import="it.unitn.webprogramming2017.progetto.Item"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="it.unitn.webprogramming2017.progetto.DBManager"%>
<%@page import="java.sql.ResultSet"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%    if (request.getParameter("view") != null) {
        negozio = Utility.getNegozio(request.getParameter("view"));
    }

%>

<div class="section white">
    <div class="container">
        <div class="row">
            <div class="col s12 m10 offset-m1">
                <h5>Negozio <%=negozio.getNome()%></h5>
                <div class="divider"></div>
                <div class="section">
                    <div class="row">
                        <div class="col s4 l3">
                            <img class="img-responsive" width="100%" src="<%=negozio.getFoto()%>"/>
                        </div>
                        <div class="col s8 l4">
                            <h5><strong>Nome negozio: </strong><%=negozio.getNome()%></h5>
                            <p><%=negozio.getDescrizione()%></p>
                            <a href="<%=negozio.getLink()%>"><i class="material-icons">public</i> Sito <%=negozio.getNome()%></a>
                            <pre><%=(negozio.getOrari() != null) ? negozio.getOrari() : " "%></pre>

                            <br>
                            <%
                                PreparedStatement fisico = DBManager.CON.prepareStatement("SELECT * FROM negozio_fisico, coordinate WHERE negozio_fisico.nome = ? AND negozio_fisico.coordinate = coordinate.id");
                                fisico.setString(1, negozio.getNome());
                                try (ResultSet rs = fisico.executeQuery()) {
                                    if (rs.next()) {
                            %>   
                            <p><%=rs.getString("address")%>, <strong><%=rs.getString("citta")%></strong></p>
                        </div>

                        <div class="col s12 l5">
                            <h5 class="grey-text">Posizione negozio</h5>
                            <a><p><%=rs.getString("latitudine")%>, <%=rs.getString("longitudine")%></p></a>
                            <iframe src="https://www.google.com/maps/embed?pb=!1m18!1m12!1m3!1d2768.576810390775!2d<%=rs.getString("latitudine")%>!3d<%=rs.getString("longitudine")%>!2m3!1f0!2f0!3f0!3m2!1i1024!2i768!4f13.1!3m3!1m2!1s0x0%3A0x0!2zNDbCsDAzJzM0LjMiTiAxMcKwMTQnMDEuOCJF!5e0!3m2!1sit!2sit!4v1508677642868" width="100%" height="250" frameborder="0" style="border:0" allowfullscreen></iframe>

                            <%
                                    }
                                }
                            %>
                        </div>
                    </div>
                </div>
                <h5>I miei prodotti  <span class="red-text lighten-2-text"><%=Utility.prodotti_venditore(negozio.getNome())%></span> </h5>
                <div class="divider"></div>
                <table>
                    <tbody>
                        <%
                            String sql = "SELECT * FROM articolo WHERE negozio = '" + negozio.getNome() + "'";
                            PreparedStatement stm = DBManager.CON.prepareStatement(sql);

                            if (stm == null) {
                                out.print("<h1>Errore</h1>");
                            }

                            try (ResultSet rs = stm.executeQuery()) {
                                if (!rs.next()) {
                                    out.print("<h4 class=\"center\">Ancora nessun prodotto inserito!</h4>");
                                }
                                rs.previous();
                                while (rs.next()) {

                        %>

                        <tr>
                            <td><img width="100px" src="<%=rs.getString("foto")%>"/></td>
                            <td><a href="prodotto.jsp?idprodotto=<%=rs.getString("id_articolo")%>"><%=rs.getString("nome")%></a> <br> <span class="red-text darken-2-text"><%=rs.getString("prezzo")%> €</span></td>
                            <td>
                                <ul>
                                    <li><a href="prodotto.jsp?idprodotto=<%=rs.getString("id_articolo")%>"><button class="waves-effect waves-light btn order-operation" name="add_to_cart">Mostra</button></a></li>
                                </ul>
                            </td>
                        </tr>

                        <%                }
                            }
                        %>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</div>

<%@ include file="footer.jsp" %>
