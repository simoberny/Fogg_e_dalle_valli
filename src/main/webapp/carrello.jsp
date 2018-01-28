<%@page import="java.util.List"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ include file="intestazione.jsp" %>

<div class="section white">
    <div class="container">
        <div class="row">
            <div class="col s12 m10 offset-m1">
                <ol class="progress_cart">
                    <li class="is-active" data-step="1">
                        Carrello
                    </li>
                    <li data-step="2">
                        Pagamento e spedizione
                    </li>
                    <li data-step="3" class="progress__last">
                        Completato
                    </li>
                </ol>
                <h4 class="blue-grey-text">Carrello</h4>
                <div class="divider"></div>
                <div class="carrello">
                    <c:if test="${cart.lineItemCount==0}">
                        <h4 class="center">Il carrello è vuoto</h4><br/>
                    </c:if>
                    <c:if test="${cart.lineItemCount!=0}">
                        <table class="striped">
                            <thead>
                                <tr>
                                    <td></td>
                                    <td>Nome Prodotto</td>
                                    <td>Quantità</td>
                                    <td>Prezzo Unitario</td>
                                    <td>Totale</td>
                                </tr>
                            </thead>
                            <tbody>

                                <c:forEach var="cartItem" items="${cart.cartItems}" varStatus="counter">
                                    <tr>
                                        <td><img width="100px" src="<c:out value="${cartItem.foto}"/>"/></td>
                                        <td>
                                            <form method="POST" action="CartController">
                                                <c:out value="${cartItem.nome}"/><br>
                                                <input type='hidden' name='indice' value='<c:out value="${counter.count}"/>' />
                                                <input class="deleteItem" type="submit" name="action" value="Delete"/>
                                            </form>
                                        </td>
                                        <td>
                                            <form method="POST" action="CartController">
                                                <input type='hidden' name='indice' value='<c:out value="${counter.count}"/>' />
                                                <input style="text-align: center;" name="quantity" type="text" class="cart_quantity" value='<c:out value="${cartItem.quantity}"/>'/>
                                                <input class="modify_cart" type="submit" name="action" value="Update" />
                                            </form>
                                        </td>

                                        <td><c:out value="${cartItem.unitCost}"/>€</td>
                                        <td><c:out value="${cartItem.totalCost}"/>€</td>
                                    </tr>
                                </c:forEach>

                            </tbody>
                            <tr class="white">
                                <td colspan="4"></td>
                                <td class="total"><strong>Totale: <c:out value="${cart.orderTotal}"/>€</strong></td>
                            </tr>
                            <c:if test="${cart.lineItemCount!=0}">
                                <tr class="white">
                                    <td colspan="3">
                                        <a href="checkout.jsp"><button class="waves-effect waves-light btn add_chart" name="add_to_cart"><i class="material-icons">done_all</i><fmt:message key="finish"/></button></a>
                                        <button class="waves-effect waves-light btn add_chart white black-text" name="add_to_cart"><i class="material-icons">delete_forever</i><fmt:message key="deletecart"/></button></td>
                                    <td></td>
                                    <td></td>
                                </tr>
                            </c:if>
                        </table>
                    </c:if>

                </div>
            </div>
        </div>
    </div>
</div>

<%@ include file="footer.jsp" %>