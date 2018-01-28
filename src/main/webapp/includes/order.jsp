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
                <h5>I miei ordini</h5>
                <div class="divider"></div>
                <div class="section">
                    <div class="input-field col s12 m6 l3">
                        <select>
                            <option value="" disabled selected>Ordini</option>
                            <option value="1">Ordini</option>
                            <option value="2">Ordini in corso</option>
                            <option value="3">Oridni cancellati</option>
                        </select>
                        <label>Tipologia ordini</label>
                    </div>
                </div>
                <%
                    String sql = "SELECT * FROM ordine WHERE user = '" + usr.getEmail() + "' ORDER BY data DESC";
                    PreparedStatement stm = DBManager.CON.prepareStatement(sql);

                    if (stm == null) {
                        out.print("<h1>Errore</h1>");
                    }

                    try (ResultSet rs = stm.executeQuery()) {
                        if (!rs.next()) {
                            out.print("<h4 class=\"center\">Ancora nessun ordine!</h4>");
                        }
                        rs.previous();
                        int a = 0;
                        while (rs.next()) {

                %>
                <div class="section">
                    <div class="col s12 order-container">
                        <div class="row">
                            <div class="header-order">
                                <div class="col s5 grey-text darken-2-text">
                                    Ordine effettuato il<br>
                                    <span class="black-text darken-4-text"> <%= rs.getString("data")%></span>
                                </div>
                                <div class="col s2 grey-text darken-2-text">
                                    TOTALE: <br>
                                    <span class="black-text darken-4-text"> <%= rs.getString("totale")%></span>
                                </div>
                                <div class="col s5 grey-text darken-2-text right-align">
                                    Ordine #: <br>
                                    <span class="black-text darken-4-text"> <%= rs.getString("id_ordine")%></span>
                                </div>
                            </div>
                        </div>
                        <div class="divider"></div>
                        <div class="section">
                            <div class="col s12">
                                <%
                                    String sql_acquisti = "SELECT * FROM acquisto WHERE id_ordine = " + rs.getString("id_ordine");
                                    PreparedStatement stm_acquisti = DBManager.CON.prepareStatement(sql_acquisti);

                                    if (stm_acquisti == null) {
                                        out.print("<h1>Errore</h1>");
                                    }

                                    try (ResultSet rsa = stm_acquisti.executeQuery()) {
                                        while (rsa.next()) {
                                            Item i = Item.getById(rsa.getInt("id_articolo"));
                                %>
                                <div class="col s12 l6 xl9">
                                    <table>
                                        <tbody>
                                        <div id="modal<%=a%>" class="modal modal-fixed-footer">
                                            <form method="GET" action="Segnalazione">
                                                <div class="modal-content">
                                                    <h4>Descrivi il problema</h4>

                                                    <div class="row">
                                                        <div class="col s3"><img width="100" src="<%=i.foto%>"/></div>
                                                        <div class="col s9"><%=i.nome%><br>
                                                            <strong>Numero ordine: </strong> <%=rs.getString("id_ordine")%><br>
                                                            <strong>Data acquisto: </strong> <%=rsa.getString("data")%>
                                                        </div>
                                                    </div>

                                                    <input type="hidden" name="id_ordine" value="<%=rs.getString("id_ordine")%>" />
                                                    <input type="hidden" name="id_articolo" value="<%=rsa.getString("id_articolo")%>" />
                                                    <input type="hidden" name="data_acquisto" value="<%=rsa.getString("data")%>" />
                                                    <input type="hidden" name="destinatario" value="<%=i.negozio%>" />
                                                    <div class="input-field col s12">
                                                        <input placeholder="Oggetto..." id="oggetto" type="text" name="oggetto" class="validate">
                                                        <label for="oggetto">Oggetto</label>
                                                    </div>
                                                    <div class="input-field col s12">
                                                        <textarea id="textarea1" class="materialize-textarea" name="testo"></textarea>
                                                        <label for="textarea1">Descrivi il problema</label>
                                                    </div>

                                                </div>
                                                <div class="modal-footer">
                                                    <button type="submit" class="modal-action modal-close waves-effect waves-green btn-flat">Invio</button>
                                                    <a href="#!" class="modal-action modal-close waves-effect waves-green btn-flat">Annulla</a>
                                                </div>
                                            </form>
                                        </div>

                                        <tr>
                                            <td><img width="100px" src="<%= i.foto%>"/></td>
                                            <td><span class="grey-text darken-4-text quantity-order"><%= rsa.getInt("quantità")%> X</span> di <a href="prodotto.jsp?idprodotto=<%=i.id_articolo%>"><%= i.nome%></a> <br> 
                                                <span class="red-text darken-2-text">

                                                    <%
                                                        if (rsa.getString("stato").equals("Rimborsato")) {
                                                    %>
                                                    <span class="red-text" style="text-decoration: line-through;"><%=i.prezzo%> €</span>
                                                    <%
                                                    } else {
                                                    %>
                                                    <%=i.prezzo%> €
                                                    <%

                                                        }%>
                                                </span><br>
                                                <strong>Venduto da: </strong><span><%=i.negozio%></span><br>
                                                <strong>Stato ordine: </strong><span><%= rsa.getString("stato")%></span>
                                            </td>
                                        </tr>
                                        </tbody>
                                    </table>
                                </div>
                                <div class="col s12 l6 xl3">
                                    <ul>
                                        <li><a class="waves-effect waves-light btn order-operation modal-trigger" href="#modal<%=a%>"<%a++;%> name="add_to_cart">Segnalazione</a></li>
                                            <%
                                                String sql_review = "SELECT * FROM recensione WHERE utente = '" + usr.getEmail() + "' AND id_articolo = " + rsa.getInt("id_articolo");
                                                PreparedStatement stm_review = DBManager.CON.prepareStatement(sql_review);

                                                try (ResultSet rsrev = stm_review.executeQuery()) {
                                                    if (rsrev.next()) {
                                            %>
                                        <p class="center">Valutazione:</p>
                                        <div class="rating rating-2 center" data-rating="<%=rsrev.getInt("voto")%>">
                                            <i class="star-1">★</i>
                                            <i class="star-2">★</i>
                                            <i class="star-3">★</i>
                                            <i class="star-4">★</i>
                                            <i class="star-5">★</i>
                                        </div>
                                        <%
                                        } else {
                                        %>

                                        <a href="recensione.jsp?prodotto=<%= i.id_articolo%>"><li><button class="waves-effect waves-light btn order-operation" name="add_to_cart">Recensione</button></li></a>

                                        <%

                                                }
                                            }
                                        %>
                                    </ul>
                                </div>

                                <%                }
                                    }
                                %>
                            </div>
                        </div>
                    </div>
                </div>
                <%                }
                    }
                %>
            </div>
        </div>
    </div>
</div>


<script>

    $(document).ready(function () {
        $('select').material_select();
        $('.modal').modal();

    });
</script>