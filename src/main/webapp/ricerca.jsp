<%-- 
    Document   : ricerca
    Created on : 11-lug-2017, 15.32.20
    Author     : simoberny
--%>

<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="it.unitn.webprogramming2017.progetto.DBManager"%>
<%@page import="it.unitn.webprogramming2017.progetto.DBManager"%>
<%@page import="java.util.List"%>
<%@page import="it.unitn.webprogramming2017.progetto.Item"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ include file="intestazione.jsp" %>

<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Ricerca</title>
        <link type="text/css" rel="stylesheet" href="css/nouislider.min.css"/>
        <script type="text/javascript" src="js/nouislider.min.js"></script>
    </head>
    <body>
        <div class="container">
            <div class="section">
                <form action="" method="GET" id="search_form">
                    <div class="row">
                        <div class="col s12 m12">
                            <div class="input-field">
                                <input id="search" type="search" name="txt" class="white main_search" value="<%= (request.getParameter("txt") != null) ? request.getParameter("txt") : ""%>">
                                <label class="label-icon" for="search"><i class="material-icons blue-grey-text darken-3-text">search</i></label>
                                <input class="search_button" type="submit" class="right" value="Cerca"/>
                            </div>
                        </div>
                        <div class="col s12 m6 l4 xl3">
                            <ul class="collapsible" data-collapsible="expandable">
                                <li>
                                    <div class="collapsible-header active"><i class="material-icons">euro_symbol</i><fmt:message key="price"/></div>
                                    <div class="collapsible-body white"> 
                                        <br>
                                        <p class="range-field">
                                        <div class="slider-price" id="slider-price" ></div>
                                        <input type="hidden" class="unibox-price-min" name="min" value="<%= (request.getParameter("min") != null) ? request.getParameter("min") : 0%>" />
                                        <input type="hidden" class="unibox-price-max" name="max" value="<%= (request.getParameter("max") != null) ? request.getParameter("max") : 8000%>" />
                                    </div>
                                </li>
                                <li>
                                    <div class="collapsible-header active"><i class="material-icons">blur_on</i>Categoria</div>
                                    <div class="collapsible-body white">
                                        <p>
                                            <input type="radio" class="filled-in" name="category" value="tutte" id="Tutte" onchange="this.form.submit()" <%=(request.getParameter("category") != null && request.getParameter("category").equals("tutte")) ? "checked" : ""%>/>
                                            <label for="Tutte">Tutte</label>
                                        </p>
                                        <%
                                            String sql = "SELECT * FROM categoria ORDER BY nome_categoria";
                                            PreparedStatement stm = DBManager.CON.prepareStatement(sql);
                                            try (ResultSet rs = stm.executeQuery()) {
                                                while (rs.next()) {
                                                    String categoria = rs.getString("nome_categoria");
                                        %>
                                        <p>
                                            <input type="radio" class="filled-in" name="category" value="<%=categoria%>" id="<%=categoria%>" onchange="this.form.submit()" <%=(request.getParameter("category") != null && request.getParameter("category").equals(categoria)) ? "checked" : ""%>/>
                                            <label for="<%=categoria%>"><%=categoria%></label>
                                        </p>
                                        <%                                            }
                                            }
                                        %>
                                    </div>
                                </li>
                                <li>
                                    <div class="collapsible-header active"><i class="material-icons">whatshot</i>Media recensioni</div>
                                    <div class="collapsible-body white">
                                        <c:forEach begin="1" end="4" varStatus="loop">
                                            <button name="voto" value="${loop.index}" style="margin: 5px 0; background: rgba(0,0,0,0); border: none;">
                                                <div class="rating" data-rating="${loop.index}">
                                                    <i class="star-1">★</i>
                                                    <i class="star-2">★</i>
                                                    <i class="star-3">★</i>
                                                    <i class="star-4">★</i>
                                                    <i class="star-5">★</i>
                                                    o più
                                                </div>
                                            </button>

                                        </c:forEach>
                                        <c:if test="${param.voto != null}">
                                            <input type="hidden" name="voto" value="<%=(request.getParameter("voto") != null) ? request.getParameter("voto") : "0"%>"/>
                                        </c:if>
                                    </div>
                                </li>
                            </ul>
                        </div>
                        <input type="hidden" name="page" value="segnalazioni"/>
                        <div class="input-field col s12 m6 l3">
                            <select onchange="this.form.submit()" name="ordinamento">
                                <option value="prezzo_cre" <%=(request.getParameter("ordinamento") != null && request.getParameter("ordinamento").equals("prezzo_cre")) ? "selected" : " "%>>Ordina per prezzo decrescente</option>
                                <option value="prezzo_dec" <%=(request.getParameter("ordinamento") != null && request.getParameter("ordinamento").equals("prezzo_dec")) ? "selected" : " "%>>Ordina per prezzo crescente</option>
                                <option value="recensioni" <%=(request.getParameter("ordinamento") != null && request.getParameter("ordinamento").equals("recensioni")) ? "selected" : " "%>>Ordina per recensioni crescenti</option>
                            </select>
                            <label>Ordina</label>
                        </div>
                            <ul class="pagination center">                               
                               
                                <input id ="pagenum" type="hidden" name="npag" value="1"/>
                                <% if ( ((request.getParameter("npag") != null ? Integer.parseInt(request.getParameter("npag")) : 1)) > 1) { %>
                                <li class="waves-effect" onclick="decrementa()"><i id="prevPag" class="material-icons">chevron_left</i></li> 
                                <% } %>
                                <li class="waves-effect" ><%= (request.getParameter("npag") != null ? request.getParameter("npag") : 1) %></li>
                                <li class="waves-effect" onclick="incrementa()"><i id="succPag" class="material-icons">chevron_right</i></li>                                                                
                            </ul>
                        <div class="col s12 m6 l8 xl9">

                            <%
                                String txt = request.getParameter("txt");
                                String categoria = request.getParameter("category");
                                Integer voto = 0;
                                if (request.getParameter("voto") != null) {
                                    voto = Integer.parseInt(request.getParameter("voto"));
                                }

                                Double min = 0.0;
                                Double max = 8000.0;


                                if (request.getParameter("min") != null && request.getParameter("max") != null) {
                                    min = Double.parseDouble(request.getParameter("min"));
                                    max = Double.parseDouble(request.getParameter("max"));
                                }

                                String venditore = request.getParameter("venditore");
                                String ordinamento = request.getParameter("ordinamento");

                                List<Item> list = Item.cerca(txt, min, max, categoria, voto, venditore, ordinamento, (request.getParameter("npag") != null ? Integer.parseInt(request.getParameter("npag")) : 1));
                                int ii = 0;
                                for (Item item : list) {
                                    //System.out.println("i"+ (ii++) + " nome: " + item.nome); //ok
                            %>
                            <div class="col s12 m12 l5 xl4">
                                <a href="prodotto.jsp?idprodotto=<%=item.id_articolo%>">
                                    <div class="card medium produkt">
                                        <div class="card-image">
                                            <img src="<%=item.foto%>">
                                        </div>
                                        <div class="card-content">
                                            <span class="card-title"><%=item.nome%></span>
                                        </div>
                                        <div class="card-action row">
                                            <div class="col s8">
                                                <div class="rating" data-rating="<%=Math.round(item.media_recensioni * 2) / 2.0%>">
                                                    <i class="star-1">★</i>
                                                    <i class="star-2">★</i>
                                                    <i class="star-3">★</i>
                                                    <i class="star-4">★</i>
                                                    <i class="star-5">★</i>
                                                </div>
                                            </div>
                                            <div class="col s4">
                                                <span href="#" class="price-card right"><%=item.prezzo%>€</span>
                                            </div>
                                        </div>
                                    </div>
                                </a>
                            </div>
                            <%
                                }
                            %>                            

                        </div>
                    </div>
                </form>
            </div>
        </div>

        <script>

            var pagina= <%= (request.getParameter("npag") != null) ? Integer.parseInt(request.getParameter("npag")) : 1 %>;
            

            $(document).ready(function () {
                $('.collapsible').collapsible();
                var slider = document.getElementById('slider-price');
                noUiSlider.create(slider, {
                    start: [$("input.unibox-price-min").val(), $("input.unibox-price-max").val()],
                    connect: true,
                    step: 1,
                    range: {
                        'min': 0,
                        'max': 8000

                    },
                    tooltips: true
                });
                slider.noUiSlider.on('change', function (values, handle, unencoded, tap, positions) {
                    $("input.unibox-price-min").val(values[0]);
                    $("input.unibox-price-max").val(values[1]);
                    $("#search_form").submit();
                });
            });

            $(document).ready(function () {
                $('select').material_select();
            });

            
            function incrementa(){
                pagina++;
                $("#pagenum").val(pagina);               
                $("form").submit();                
            }
            
            function decrementa(){
                if (pagina > 1){
                    pagina--;
                }                
                $("#pagenum").val(pagina);
                $("form").submit();                
            }

        </script>

        <%@ include file="footer.jsp" %>
