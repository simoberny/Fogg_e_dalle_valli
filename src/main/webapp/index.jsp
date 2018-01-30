<%@page import="it.unitn.webprogramming2017.progetto.DBManager"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ include file="intestazione.jsp" %>

<c:if test="${loggedin}">
    <ul class="collection hide-on-large-only logged-mobile">
        <li class="collection-item avatar">
            <img src="<%= usr.getAvatar()%>" alt="" class="circle">
            <span class="title"><fmt:message key="benvenuto"/>, <%= usr.getFirstName()%></span>
            <p><%= usr.getEmail()%><br>
                <a href="user.jsp"><fmt:message key="profile"/></a>
            </p>
            <a href="logout.jsp" class="secondary-content"><fmt:message key="esci"/></a>
        </li>
    </ul>
</c:if>

<div class="container no-pad-bot" id="index-banner">
    <div class="row no-margin">
        <div class="col s12 xl10 offset-xl1">
            <form method="GET" action="ricerca.jsp">
                <div class="input-field">
                    <input id="search" type="search" name="txt" class="white main_search autocomplete"  autocomplete="off" required placeholder="Search ...">
                    <label class="label-icon" for="search"><i class="material-icons blue-grey-text darken-3-text">search</i></label>
                    <input class="search_button" type="submit" class="right" value="Search"/>
                </div>
                <br>
            </form>
        </div>
        <div class="col s12 no-padding">
            <div class="slider white">
                <span class="previous-slide button-slide hide-on-med-and-down"><i class="material-icons">keyboard_arrow_left</i></span>
                <span class="next-slide button-slide hide-on-med-and-down"><i class="material-icons">keyboard_arrow_right</i></span>
                <ul class="slides">
                    <li>
                        <img src="img/1.jpg"> <!-- random image -->
                        <div class="caption center-align">
                            <h3>MSI GTX 1080</h3>
                            <h5 class="light grey-text text-lighten-3">New Twin Frozr V system</h5>
                        </div>
                    </li>
                    <li>
                        <img src="img/2.jpg"> <!-- random image -->
                        <div class="caption left-align">
                            <h3>MSI Z270</h3>
                            <h5 class="light grey-text text-lighten-3">New motherboards MSI</h5>
                        </div>
                    </li>
                    <li>
                        <img src="img/3.png"> <!-- random image -->
                    </li>
                    <li>
                        <img src="img/4.jpg"> <!-- random image -->
                        <div class="caption center-align">
                            <h3>Sapphire RX 580</h3>
                            <h5 class="light grey-text text-lighten-3">Simply amazing!</h5>
                        </div>
                    </li>
                </ul>
            </div>
        </div>
    </div>
    <div class="row no-margin padding-bottom white presentation-2">
        <div class="section">
            <div class="col s12 m4">
                <div class="icon-block">
                    <h2 class="center light-blue-text"><i class="material-icons">flash_on</i></h2>
                    <h5 class="center"><fmt:message key="sped_home"/></h5>

                    <p class="light">Thanks to our automated logistics, the order is waiting for less than 48 hours. Speed ​​is our strength.</p>
                </div>
            </div>

            <div class="col s12 m4">
                <div class="icon-block">
                    <h2 class="center light-blue-text"><i class="material-icons">group</i></h2>
                    <h5 class="center"><fmt:message key="affidabilita"/></h5>

                    <p class="light">Reliability means trust, we do not tolerate mistakes towards our customers. You can trust us.</p>
                </div>
            </div>

            <div class="col s12 m4">
                <div class="icon-block">
                    <h2 class="center light-blue-text"><i class="material-icons">attach_money</i></h2>
                    <h5 class="center"><fmt:message key="superprezzi"/></h5>

                    <p class="light"> We offer the lowest prices on the Web !, the products from us are all original. We have Superprice thanks to the purchase in stock and to the efficiency of the company.</p>
                </div>
            </div>
        </div>
    </div>
</div>

<div class="container">
    <div class="row">
        <br>
        <h5 class="header blue-grey-text"><fmt:message key="evidenza"/></h5>

        <div class="divider"></div>
        <br>

        <%
            String sql = "SELECT * FROM articolo ORDER BY data_inserimento LIMIT 4";
            PreparedStatement stm = DBManager.CON.prepareStatement(sql);

            if (stm == null) {
                out.print("<h1>Errore</h1>");
            }

            try (ResultSet rs = stm.executeQuery()) {
                while (rs.next()) {

        %>

        <div class="col s12 m6 l4 xl3">
            <a href="prodotto.jsp?idprodotto=<%=rs.getString("id_articolo")%>" style="color: #444;">
                <div class="card medium produkt">
                    <div class="card-image">
                        <img src="<%=rs.getString("foto")%>" />
                        <form method="POST" action="CartController">
                            <input name="quantity" type="hidden" class="pro_quantity" value="1"/>
                            <input type="hidden" name="idoggetto" value="<%=rs.getInt("id_articolo")%>"/>
                            <input type="hidden" name="nome" value="<%=rs.getString("nome")%>"/>
                            <input type="hidden" name="foto" value="<%=rs.getString("foto")%>"/>
                            <input type="hidden" name="prezzo" value="<%=rs.getString("prezzo")%>"/>
                            <input type="hidden" name="action" value="add">
                        </form>
                    </div>
                    <div class="card-content">
                        <span class="card-title"><%=rs.getString("nome")%></span>
                        <h5 href="#" class="price-card blue-grey-text "><%=rs.getString("prezzo")%>€</h5>
                    </div>
                    <div class="card-action row">
                        <div class="col s12">
                            <div class="rating" data-rating="<%=Math.round(Double.parseDouble(rs.getString("media_recensioni")) * 2) / 2.0%>">
                                <i class="star-1">★</i>
                                <i class="star-2">★</i>
                                <i class="star-3">★</i>
                                <i class="star-4">★</i>
                                <i class="star-5">★</i>
                            </div>
                            <span class="grey-text"> (<%=rs.getString("n_recensioni")%>)</span>
                        </div>
                    </div>
                </div>
            </a>
        </div>

        <%                }
            }
        %>
    </div>
    <div class="row">
        <br>
        <h5 class="header blue-grey-text"><fmt:message key="arrivo"/></h5>

        <div class="divider"></div>
        <br>
        <%
            if (stm == null) {
                out.print("<h1>Errore</h1>");
            }

            sql = "SELECT * FROM articolo ORDER BY nome LIMIT 4";
            stm = DBManager.CON.prepareStatement(sql);
            try (ResultSet rs = stm.executeQuery()) {
                while (rs.next()) {

        %>

        <div class="col s12 m6 l4 xl3">
            <a href="prodotto.jsp?idprodotto=<%=rs.getString("id_articolo")%>" style="color: #444;">
                <div class="card medium produkt">
                    <div class="card-image">
                        <img src="<%=rs.getString("foto")%>" />
                        <form method="POST" action="CartController">
                            <input name="quantity" type="hidden" class="pro_quantity" value="1"/>
                            <input type="hidden" name="idoggetto" value="<%=rs.getInt("id_articolo")%>"/>
                            <input type="hidden" name="nome" value="<%=rs.getString("nome")%>"/>
                            <input type="hidden" name="foto" value="<%=rs.getString("foto")%>"/>
                            <input type="hidden" name="prezzo" value="<%=rs.getString("prezzo")%>"/>
                            <input type="hidden" name="action" value="add">
                        </form>
                    </div>
                    <div class="card-content">
                        <span class="card-title"><%=rs.getString("nome")%></span>
                        <h5 href="#" class="price-card blue-grey-text "><%=rs.getString("prezzo")%>€</h5>
                    </div>
                    <div class="card-action row">
                        <div class="col s12">
                            <div class="rating" data-rating="<%=Math.round(Double.parseDouble(rs.getString("media_recensioni")) * 2) / 2.0%>">
                                <i class="star-1">★</i>
                                <i class="star-2">★</i>
                                <i class="star-3">★</i>
                                <i class="star-4">★</i>
                                <i class="star-5">★</i>
                            </div>
                            <span class="grey-text"> (<%=rs.getString("n_recensioni")%>)</span>
                        </div>
                    </div>
                </div>
            </a>
        </div>

        <%                }
            }
        %>
    </div>

    <script>
        $(document).ready(function () {
            $(".previous-slide").click(function () {
                $('.slider').slider('prev');
            });
            $(".next-slide").click(function () {
                $('.slider').slider('next');
            });
            $(".slider").hover(function () {
                $(this).slider('pause');
            });
            $(".slider").mouseout(function () {
                $(this).slider('start');
            });
        });

        $(document).ready(function () {
            //Autocomplete
            $(function () {
                $(".autocomplete").keyup(function () {
                    var value = $(this).val();
                    $.ajax({
                        type: 'GET',
                        url: 'Autocomplete',
                        data: {
                            term: value
                        },
                        success: function (response) {
                            console.log(response);
                            var array = response;
                            var complete_array = {};
                            for (var i = 0; i < array.length; i++) {
                                complete_array[array[i].nome] = array[i].foto;
                            }
                            $('input.autocomplete').autocomplete({
                                data: complete_array,
                                limit: 5, // The max amount of results that can be shown at once. Default: Infinity.
                                minLength: 1,
                            });
                        }
                    });
                });
            });
        });
    </script>
    <%@ include file="footer.jsp" %>
