<%@page import="java.util.List"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ include file="intestazione.jsp" %>

<div class="section white">
    <div class="container">
        <div class="row">
            <div class="col s12 m12 l10 offset-l1">
                <ol class="progress_cart">
                    <li class="is-complete" data-step="1">
                        Carrello
                    </li>
                    <li class="is-active" data-step="2">
                        Pagamento e spedizione
                    </li>
                    <li data-step="3" class="progress__last">
                        Completato
                    </li>
                </ol>
                <h4 class="blue-grey-text">Pagamento e spedizione</h4>
                <div class="divider"></div>
                <div class="section">
                    <div class="row">
                        <div class="col s12">
                            <div class="spedizione">
                                <h5>Seleziona la spedizione</h5>
                                <form action="CartController" method="POST">
                                    <table>
                                        <thead>
                                            <tr>
                                                <td colspan="3" class="brown-text lighten-2-text">Tipo spedizione</td>
                                                <td colspan="3" class="brown-text lighten-2-text">Tempi</td>
                                                <td class="brown-text lighten-2-text">Costo</td>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <tr>
                                                <td colspan="3">        
                                                    <input class="with-gap" name="group1" type="radio" value="10.0" id="test1" onclick="this.form.submit()" <c:out value='${cart.delivery eq "10.0" ? "checked" : "" }'></c:out>/>
                                                        <label for="test1">Corriere Espresso</label>
                                                    </td>
                                                    <td colspan="3">1-2 giorni</td>
                                                    <td>10 €</td>
                                                </tr>
                                                <tr>
                                                    <td colspan="3">      
                                                        <input class="with-gap" name="group1" type="radio" id="test2" value="6.0" onclick="this.form.submit()" <c:out value='${cart.delivery eq "6.0" ? "checked" : "" }'/>/>
                                                    <label for="test2">Pacco Ordinario</label>
                                                </td>
                                                <td colspan="3">3-4giorni</td>
                                                <td>6 €</td>
                                            </tr>
                                            <tr>
                                                <td colspan="3">    
                                                    <input class="with-gap" name="group1" type="radio" id="test3" value="1.25" onclick="this.form.submit()" <c:out value='${cart.delivery eq "1.25" ? "checked" : "" }'/>/>
                                                    <label for="test3">China AirPost</label>
                                                </td>
                                                <td colspan="3">10-20giorni</td>
                                                <td>1.25 €</td>
                                            </tr>
                                        </tbody>
                                        <tr>
                                            <td></td>
                                            <td colspan="2">        
                                                <input  name="group1" type="checkbox" id="test4" value="3.0" onclick="this.form.submit()" <c:out value='${cart.delivery eq "3.0" ? "checked" : "" }'/>/>
                                                <label for="test4">Assicurazione pacco</label>
                                            </td>
                                            <td colspan="3"></td>
                                            <td>3 €</td>
                                        </tr>
                                        <input type="hidden" name="action" value="Delivery">
                                    </table>
                                </form>

                                <p class="red-text lighten-2-text">I seguenti prodotti sono ritirabili in negozio: </p>
                                <table>
                                    <c:forEach var="cartItem" items="${cart.cartItems}" varStatus="counter">
                                        <c:if test="${cartItem.ritiro}">
                                            <tr>
                                                <td><img width="80px" src="<c:out value="${cartItem.foto}"/>"/></td>
                                                <td><c:out value="${cartItem.nome}"/></td>
                                            </tr>
                                        </c:if>
                                    </c:forEach>   
                                </table>

                            </div>
                        </div>

                        <form method="POST" action="ProcessOrder">
                            <div class="col s12">
                                <div class="payment">
                                    <h5>Pagamento</h5>
                                    <div class="row">
                                        <div class="container-card">

                                            <div class="col1 col s12 m12 l7">
                                                <div class="card-pay">
                                                    <div class="front">
                                                        <div class="type">
                                                            <img class="bankid"/>
                                                        </div>
                                                        <span class="chip-card"></span>
                                                        <span class="card_number">&#x25CF;&#x25CF;&#x25CF;&#x25CF; &#x25CF;&#x25CF;&#x25CF;&#x25CF; &#x25CF;&#x25CF;&#x25CF;&#x25CF; &#x25CF;&#x25CF;&#x25CF;&#x25CF; </span>
                                                        <div class="date"><span class="date_value">MM / YYYY</span></div>
                                                        <span class="fullname">FULL NAME</span>
                                                    </div>
                                                    <div class="back">
                                                        <div class="magnetic"></div>
                                                        <div class="bar"></div>
                                                        <span class="seccode">&#x25CF;&#x25CF;&#x25CF;</span>
                                                        <span class="chip"></span><span class="disclaimer">This card is property of Random Bank of Random corporation. <br> If found please return to Random Bank of Random corporation - 21968 Paris, Verdi Street, 34 </span>
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="col2 col s12 m12 l5">
                                                <label>Card Number</label>
                                                <input class="number" type="text" name="card-code" ng-model="ncard" maxlength="19" onkeypress='return event.charCode >= 48 && event.charCode <= 57'/>
                                                <label>Cardholder name</label>
                                                <input class="inputname" type="text" placeholder=""/>
                                                <label>Expiry date</label>
                                                <input class="expire" type="text" placeholder="MM / YYYY"/>
                                                <label>Security Number</label>
                                                <input class="ccv" type="text" placeholder="CVC" maxlength="3" onkeypress='return event.charCode >= 48 && event.charCode <= 57'/>
                                            </div>
                                        </div>
                                    </div>
                                    <img class="payment_accepted" src="img/creditcards.png"/>
                                </div>
                            </div>
                            <div class="col s12">
                                <div class="spedizione">
                                    <h5>Riepilogo</h5>
                                    <c:if test="${loggedin}">
                                        <ul class="info_user_cart">
                                            <li><span>Nome:</span> <%=usr.getFirstName()%></li>
                                            <li><span>Cognome:</span> <%= usr.getLastName()%></li>
                                            <li><span>Email:</span> <%= usr.getEmail()%></li>
                                        </ul>
                                    </c:if>
                                    <table class="highlight">
                                        <thead>
                                            <tr>
                                                <td colspan="3" class="brown-text lighten-2-text">Carrello</td>
                                                <td colspan="3"></td>
                                                <td class="brown-text lighten-2-text">Prezzo</td>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <tr>
                                                <td colspan="3">Ordine</td>
                                                <td colspan="3"></td>
                                                <td><c:out value="${cart.orderTotal}"/>€</td>
                                            </tr>
                                            <tr>
                                                <td colspan="3">Spedizione</td>
                                                <td colspan="3"></td>
                                                <td><c:out value="${cart.delivery}"/>€</td>
                                            </tr>
                                        </tbody>
                                        <tr class="white">
                                            <td class="total"><strong>Totale ordine: <c:out value="${cart.totalWithDelivery}"/>€</strong></td>
                                        </tr>
                                    </table>
                                    <br><br>
                                    <input type="hidden" name="user" value="<%= usr.getEmail()%>"/>
                                    <c:if test="${loggedin}">
                                        <a href="complete.jsp"><button class="waves-effect waves-light btn add_chart" name="add_to_cart"><i class="material-icons">done_all</i><fmt:message key="paga"/></button></a>
                                    </c:if>
                                    <c:if test="${!loggedin}">
                                        <a href="access.jsp"><button class="waves-effect waves-light btn add_chart" name="add_to_cart"><i class="material-icons">no_encryption</i><fmt:message key="login"/></button></a>
                                    </c:if>
                                    <span class="alternative"> o </span>
                                    <a href="complete.jsp"><button class="waves-effect waves-light btn add_chart white black-text paypal" name="add_to_cart"><fmt:message key="paypal"/></button></a>  
                                </div>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<script>
    // 4: VISA, 51 -> 55: MasterCard, 36-38-39: DinersClub, 34-37: American Express, 65: Discover, 5019: dankort


    $(function () {

        var cards = [{
                nome: "mastercard",
                colore: "#0061A8",
                src: "https://upload.wikimedia.org/wikipedia/commons/0/04/Mastercard-logo.png"
            }, {
                nome: "visa",
                colore: "#E2CB38",
                src: "https://upload.wikimedia.org/wikipedia/commons/thumb/5/5e/Visa_Inc._logo.svg/2000px-Visa_Inc._logo.svg.png"
            }, {
                nome: "dinersclub",
                colore: "#888",
                src: "http://www.worldsultimatetravels.com/wp-content/uploads/2016/07/Diners-Club-Logo-1920x512.png"
            }, {
                nome: "americanExpress",
                colore: "#108168",
                src: "https://upload.wikimedia.org/wikipedia/commons/thumb/3/30/American_Express_logo.svg/600px-American_Express_logo.svg.png"
            }, {
                nome: "discover",
                colore: "#86B8CF",
                src: "https://lendedu.com/wp-content/uploads/2016/03/discover-it-for-students-credit-card.jpg"
            }, {
                nome: "dankort",
                colore: "#0061A8",
                src: "https://upload.wikimedia.org/wikipedia/commons/5/51/Dankort_logo.png"
            }];

        var month = 0;
        var html = document.getElementsByTagName('html')[0];
        var number = "";

        var selected_card = -1;

        $(document).click(function (e) {
            if (!$(e.target).is(".ccv") || !$(e.target).closest(".ccv").length) {
                $(".card-pay").css("transform", "rotatey(0deg)");
                $(".seccode").css("color", "#e1e1e1");
            }
            if (!$(e.target).is(".expire") || !$(e.target).closest(".expire").length) {
                $(".date_value").css("color", "#e1e1e1");
            }
            if (!$(e.target).is(".number") || !$(e.target).closest(".number").length) {
                $(".card_number").css("color", "#e1e1e1");
            }
            if (!$(e.target).is(".inputname") || !$(e.target).closest(".inputname").length) {
                $(".fullname").css("color", "#e1e1e1");
            }
        });


        //Card number input
        $(".number").keyup(function (event) {
            $(".card_number").text($(this).val());
            number = $(this).val();

            if (parseInt(number.substring(0, 2)) > 50 && parseInt(number.substring(0, 2)) < 56) {
                selected_card = 0;
            } else if (parseInt(number.substring(0, 1)) == 4) {
                selected_card = 1;
            } else if (parseInt(number.substring(0, 2)) == 36 || parseInt(number.substring(0, 2)) == 38 || parseInt(number.substring(0, 2)) == 39) {
                selected_card = 2;
            } else if (parseInt(number.substring(0, 2)) == 34 || parseInt(number.substring(0, 2)) == 37) {
                selected_card = 3;
            } else if (parseInt(number.substring(0, 2)) == 65) {
                selected_card = 4;
            } else if (parseInt(number.substring(0, 4)) == 5019) {
                selected_card = 5;
            } else {
                selected_card = -1;
            }

            if (selected_card != -1) {
                $(".front").css("background", cards[selected_card].colore);
                $(".back").css("background", cards[selected_card].colore);
                $(".bankid").attr("src", cards[selected_card].src).show();
            } else {
                $(".front").css("background", "#cacaca");
                $(".back").css("background", "#cacaca");
                $(".bankid").attr("src", "").hide();
            }

            if ($(".card_number").text().length === 0) {
                $(".card_number").html("&#x25CF;&#x25CF;&#x25CF;&#x25CF; &#x25CF;&#x25CF;&#x25CF;&#x25CF; &#x25CF;&#x25CF;&#x25CF;&#x25CF; &#x25CF;&#x25CF;&#x25CF;&#x25CF;");
            }

        }).focus(function () {
            $(".card_number").css("color", "white");
        }).on("keydown input", function () {

            $(".card_number").text($(this).val());

            if (event.key >= 0 && event.key <= 9) {
                if ($(this).val().length === 4 || $(this).val().length === 9 || $(this).val().length === 14) {
                    $(this).val($(this).val() + " ");
                }
            }
        })

        //Name Input
        $(".inputname").keyup(function () {
            $(".fullname").text($(this).val());
            if ($(".inputname").val().length === 0) {
                $(".fullname").text("FULL NAME");
            }
            return event.charCode;
        }).focus(function () {
            $(".fullname").css("color", "white");
        });

        //Security code Input
        $(".ccv").focus(function () {
            $(".card-pay").css("transform", "rotatey(180deg)");
            $(".seccode").css("color", "white");
        }).keyup(function () {
            $(".seccode").text($(this).val());
            if ($(this).val().length === 0) {
                $(".seccode").html("&#x25CF;&#x25CF;&#x25CF;");
            }
        }).focusout(function () {
            $(".card-pay").css("transform", "rotatey(0deg)");
            $(".seccode").css("color", "#e1e1e1");
        });


        //Date expire input
        $(".expire").keypress(function (event) {
            if (event.charCode >= 48 && event.charCode <= 57) {
                if ($(this).val().length === 1) {
                    $(this).val($(this).val() + event.key + " / ");
                } else if ($(this).val().length === 0) {
                    if (event.key == 1 || event.key == 0) {
                        month = event.key;
                        return event.charCode;
                    } else {
                        $(this).val(0 + event.key + " / ");
                    }
                } else if ($(this).val().length > 2 && $(this).val().length < 9) {
                    return event.charCode;
                }
            }
            return false;
        }).keyup(function (event) {
            $(".date_value").html($(this).val());
            if (event.keyCode == 8 && $(".expire").val().length == 4) {
                $(this).val(month);
            }

            if ($(this).val().length === 0) {
                $(".date_value").text("MM / YYYY");
            }
        }).keydown(function () {
            $(".date_value").html($(this).val());
        }).focus(function () {
            $(".date_value").css("color", "white");
        });
    });
</script>

<%@ include file="footer.jsp" %>