<%@page import="java.util.List"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ include file="intestazione.jsp" %>

<div class="section white">
    <div class="container">
        <div class="row">
            <div class="col s12 m10 offset-m1">
                <ol class="progress_cart">
                    <li class="is-active" data-step="1">
                        Cart
                    </li>
                    <li data-step="2">
                        payment and shipping
                    </li>
                    <li data-step="3" class="progress__last">
                        Completed
                    </li>
                </ol>
                <h4 class="blue-grey-text">Cart</h4>
                <div class="divider"></div>
                <div class="carrello">
                    <c:if test="${cart.lineItemCount==0}">
                        <h4 class="center">The cart is empty</h4><br/>
                    </c:if>
                    <c:if test="${cart.lineItemCount!=0}">
                        <table class="striped">
                            <thead>
                                <tr>
                                    <td></td>
                                    <td>Product name</td>
                                    <td>Quantity</td>
                                    <td>Price</td>
                                    <td>Tot</td>
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