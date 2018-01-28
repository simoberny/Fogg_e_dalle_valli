<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ include file="intestazione.jsp" %>

<div class="container"> 
    <div class="row">
        <div class="access_console col s12 m6 l4 xl4 offset-m3 offset-l4 offset-xl4 white">
            <div class="select_access">
                <a href="" class="sin activesin"> Modifica Negozio</a>
            </div>
            <div class="container"> 
                <c:choose>
                    <c:when test="${true}">

                        <div class="row">
                            <h5 class="center">Dati negozio</h5>
                            <form class="col s12" method="POST" action="NegozioOperation" id="registration_form">
                                <div class="row login-pad">
                                    <input type="hidden" id="nome" type="text" class="validate" name="nome" value="<%=negozio.getNome()%>" >
                                    <div class="input-field col s12">
                                        <textarea id="textarea1" class="materialize-textarea" name="desc" ><%=negozio.getDescrizione()%></textarea>
                                        <label for="textarea1">Descrizione</label>
                                    </div>
                                    <div class="input-field col s12">
                                        <input id="link" type="text" class="validate" name="link" value="<%=negozio.getLink()%>">
                                        <label for="link">Link</label>
                                    </div>
                                    <div class="input-field col s12">
                                        <textarea id="orari" class="materialize-textarea" name="orari" ><%=negozio.getOrari()%></textarea>
                                        <label for="orari">Orari</label>
                                    </div>

                                    <iframe src="https://www.google.com/maps/embed?pb=!1m18!1m12!1m3!1d2768.576810390775!2d<%=negozio.getLat()%>!3d<%=negozio.getLong()%>!2m3!1f0!2f0!3f0!3m2!1i1024!2i768!4f13.1!3m3!1m2!1s0x0%3A0x0!2zNDbCsDAzJzM0LjMiTiAxMcKwMTQnMDEuOCJF!5e0!3m2!1sit!2sit!4v1508677642868" width="100%" height="250" frameborder="0" style="border:0" allowfullscreen></iframe>

                                    <div class="row">
                                        <h6 class="center">Nuove coordinate</h6>
                                        <div class="input-field col s6">
                                            <input id="lat" type="text" class="validate" name="lat" value="<%=negozio.getLat()%>" required>
                                            <label for="lat">Latitudine</label>
                                        </div>
                                        <div class="input-field col s6">
                                            <input id="long" type="text" class="validate" name="long" value="<%=negozio.getLong()%>" required>
                                            <label for="long">Longitudine</label>
                                        </div>
                                    </div>

                                    <div class="input-field col s12">
                                        <input id="address" type="text" class="validate" name="address" value="<%=negozio.getAddress()%>">
                                        <label for="address">Link</label>
                                    </div>
                                </div>
                                <button class="btn waves-effect waves-light btn-submit" type="submit" name="action">Salva</button>
                            </form>
                        </div>
                    </c:when>
                    <c:otherwise>

                    </c:otherwise>
                </c:choose>    
            </div>
        </div>
    </div>

</div>

<script>
    $('#textarea1').trigger('autoresize');
</script>
