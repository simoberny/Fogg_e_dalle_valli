<%@page import="it.unitn.webprogramming2017.progetto.Item"%>
<%@ include file="intestazione.jsp" %>
<%@include file="includes/second_bar.jsp" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%
    String id = request.getParameter("prodotto");
    Item i = Item.getById(Integer.parseInt(id));    
%>

<div class="section white">
    <div class="container">
        <div class="row">
            <div class="col s12 m10 offset-m1">
                <h5>Recensione prodotto <span class="blue-grey-text lighten-2-text"><%= i.nome%></span></h5>
                <div class="divider"></div>
                <div class="section">
                    <div class="row">
                        <div class="col s12 m3 l3">
                            <img class="img-recensione" src="<%= i.foto%>">
                        </div>
                        <div class="col s12 m9 l9">
                            <p>Valutazione: </p>
                            <form action="Review" method="post">
                                <div class="ratized">
                                    <input id="radio1" type="radio" name="voto" value="1" checked><label for="radio1">&#9733;</label>

                                    <input id="radio2" type="radio" name="voto" value="2">
                                    <label for="radio2">&#9733;</label>

                                    <input id="radio3" type="radio" name="voto" value="3">
                                    <label for="radio3">&#9733;</label>

                                    <input id="radio4" type="radio" name="voto" value="4">
                                    <label for="radio4">&#9733;</label>

                                    <input id="radio5" type="radio" name="voto" value="5">
                                    <label for="radio5">&#9733;</label>
                                </div>

                                <div class="input-field col s12">
                                    <textarea id="textarea1" class="materialize-textarea" name="message"></textarea>
                                    <label for="textarea1">Recensione</label>
                                </div>

                                <input type="hidden" name="articolo" value="<%=i.id_articolo%>"/>
                                <input type="hidden" name="utente" value="<%=usr.getEmail()%>"/>

                                <input type="hidden" name="from" value="${pageContext.request.requestURI}">

                                <button class="waves-effect waves-light btn" type="submit">Salva</button>
                            </form>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<script>
    $('#textarea1').trigger('autoresize');
</script>

<%@ include file="footer.jsp" %>