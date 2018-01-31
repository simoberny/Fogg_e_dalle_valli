<%@page import="java.text.DecimalFormat"%>
<%@page import="it.unitn.webprogramming2017.progetto.Item"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="it.unitn.webprogramming2017.progetto.DBManager"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ include file="intestazione.jsp" %>

<%    String id = request.getParameter("idprodotto");

    Item i = Item.getById(Integer.parseInt(id));
    DecimalFormat df = new DecimalFormat("#.00");
%>

<div class="container">
    <div class="mycumbs">
        <a href="index.jsp">Home</a>
        <a href="ricerca.jsp">Prodotti</a>
        <a href="#"><%=i.nome%></a>
    </div>
</div>

<div class="section white">
    <div class="container">
        <% if (request.getParameter("add_to_cart") != null) {
        %>

        <div class="row">
            <div class="col s12 m8 offset-m2 newcart">
                <div class="col s2 m2"><i class="myblue_text material-icons add_cart_icon">add_shopping_cart</i></div>
                <div class="col s10 m10">
                    <div class="container">
                        <h5>Oggetto <span class="blue-grey-text lighten-2-text"><%=i.nome%></span> aggiunto al carrello!</h5>
                        <p>Quantità: <%=request.getParameter("quantity") != null ? request.getParameter("quantity") : 0%></p>
                    </div>
                </div>
            </div>
        </div>
        <%
            }
        %>
        <div class="row">            
            <div class="col s12">
                <div class="row">
                    <div class="col s12 m6">
                        <img class="pro_img" src="<%=i.foto%>">
                    </div>
                    <div class="col s12 m5 descrizione">
                        <h5 class="blue-grey-text darken-4-text pro_title">
                            <%=i.nome%>
                        </h5>
                        <a href="negozio.jsp?view=<%=i.negozio%>"><span class="venditore myblue_text"><%=i.negozio%></span></a>
                        <br>    

                        <span class="valutazione">                            
                            <div class="rating" data-rating="<%=Math.round(i.media_recensioni)%>">
                                <i class="star-1">★</i>
                                <i class="star-2">★</i>
                                <i class="star-3">★</i>
                                <i class="star-4">★</i>
                                <i class="star-5">★</i>
                            </div>
                        </span>
                        <span><%=i.n_recensioni%> Reviews</span>
                        <p class="info"><%=i.descrizione.substring(0, Math.min(100, i.descrizione.length() - 1))%>...</p>
                        <table class="price">     
                            <tbody>
                                <tr>
                                    <th class="left_price"><fmt:message key="price"/></th>
                                    <td class="right_price" style="text-decoration: line-through;"><%=df.format(i.prezzo * (100 + 22) / 100)%>€</td>
                                </tr>
                                <tr>
                                    <th class="left_price"><fmt:message key="low_price"/></th>
                                    <td class="right_price"><%=i.prezzo%>€</td>
                                </tr>
                                <tr>
                                    <th class="left_price">IVA 22% inc</th>
                                </tr>
                            </tbody>
                        </table>
                        <form method="POST" action="CartController">
                            <div class="row">
                                <div class="col s6 offset-s3 m5 l5 xl4">
                                    <span><fmt:message key="quantity"/></span><br>
                                    <span class="pro_add" id="minus_quantity">-</span><input style="text-align: center;" name="quantity" type="text" class="pro_quantity" value="1"><span class="pro_add" id="add_quantity">+</span>
                                </div>
                            </div>
                            <input type="hidden" name="idoggetto" value="<%=i.id_articolo%>"/>
                            <input type="hidden" name="nome" value="<%=i.nome%>"/>
                            <input type="hidden" name="foto" value="<%=i.foto%>"/>
                            <input type="hidden" name="prezzo" value="<%=i.prezzo%>"/>
                            <input type="hidden" name="venditore" value="<%=i.negozio%>"/>
                            <input type="hidden" name="action" value="add">
                            <button class="waves-effect waves-light btn add_chart" name="add_to_cart"><i class="material-icons">add_shopping_cart</i><fmt:message key="chart"/></button>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
<div class="section grey lighten-3">
    <div class="container">
        <div class="row">    
            <div class="col s10 offset-s1" style="">
                <h5 class="blue-grey-text darken-4-text">
                    <fmt:message key="desc"/>
                </h5>
                <%=i.descrizione%>
            </div>
        </div>
    </div>
</div>
<div class="section  grey lighten-5">
    <div class="container">
        <div class="row">    
            <div class="col s10 offset-s1">
                <h5 class="blue-grey-text darken-2-text">
                    Reviews
                </h5>
                <%
                    String sql = "SELECT * FROM recensione WHERE id_articolo = " + i.id_articolo + " ORDER BY voto";
                    PreparedStatement stm = DBManager.CON.prepareStatement(sql);

                    if (stm == null) {
                        out.print("<h1>Error</h1>");
                    }

                    try (ResultSet rs = stm.executeQuery()) {
                        if (!rs.next()) {
                            out.print("<h5 class=\"center blue-grey-text\">No reviews avaiable!</h5>");
                        }
                        rs.previous();
                        while (rs.next()) {
                            String email = rs.getString("utente");
                            User utente = db.getUser(email);
                %>
                <div class="section">
                    <div class="col s12">
                        <div class="row">
                            <div class="chip">
                                <img src="<%=utente.getAvatar()%>" alt="Contact Person">
                                <%=utente.getFirstName() + " " + utente.getLastName()%>
                            </div>
                            <div class="bar-recensione">
                                <span>Valutazione: </span>
                                <form action="" method="post" class="ratized ratized-v2">
                                    <input id="radio1" type="radio" name="estrellas" value="1" <%=(rs.getInt("voto") == 1) ? "checked" : ""%>>
                                    <label>&#9733;</label>

                                    <input id="radio2" type="radio" name="estrellas" value="2" <%=(rs.getInt("voto") == 2) ? "checked" : ""%>>
                                    <label>&#9733;</label>

                                    <input id="radio3" type="radio" name="estrellas" value="3" <%=(rs.getInt("voto") == 3) ? "checked" : ""%>>
                                    <label>&#9733;</label>

                                    <input id="radio4" type="radio" name="estrellas" value="4" <%=(rs.getInt("voto") == 4) ? "checked" : ""%>>
                                    <label>&#9733;</label>

                                    <input id="radio5" type="radio" name="estrellas" value="5" <%=(rs.getInt("voto") == 5) ? "checked" : ""%>>
                                    <label>&#9733;</label>

                                </form>
                                <p><%= rs.getString("testo")%></p>
                            </div>
                        </div>
                    </div>
                </div>
                <%

                        }
                    }
                %>
            </div>
        </div>
    </div>
</div>

<script>
    $(document).ready(function () {
        $("#add_quantity").mousedown(function () {
            var temp = parseInt($('.pro_quantity').val()) + 1;
            if (temp < 10) {
                $(".pro_quantity").val("" + temp);
            }
        });

        $("#minus_quantity").mousedown(function () {
            var temp = parseInt($('.pro_quantity').val()) - 1;
            if (temp >= 0) {
                $(".pro_quantity").val("" + temp);
            }
        });
    });
</script>

<%@include file="footer.jsp" %>