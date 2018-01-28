<%@page import="java.util.List"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ include file="intestazione.jsp" %>

<%    List prodotti = null;
    if (session.getAttribute("carrello") != null) {
        prodotti = (List) session.getAttribute("carrello");
    }
%>

<div class="section white" style="height: 100%;">
    <div class="container">
        <div class="row">
            <div class="col s12 m10 offset-m1">
                <ol class="progress_cart">
                    <li class="is-complete" data-step="1">
                        Carrello
                    </li>
                    <li class="is-complete" data-step="2">
                        Pagamento e spedizione
                    </li>
                    <li data-step="3" class="progress__last is-active">
                        Completato
                    </li>
                </ol>
                <c:if test='${param.stato eq "success"}'>
                    <h4 class="blue-grey-text center">Ordine Completato!</h4>
                    <div class="divider"></div>
                    
                    <h4 class="center"><i class="material-icons tick_order">check_circle</i></h4>
                    <h4 class="center blue-grey-text">Ordine n° <c:out value="${param.id}"></c:out> completato con successo!</h4>
                </c:if>

                <c:if test='${param.stato eq "unsuccess"}'>
                    <h4 class="blue-grey-text center">Ordine non completato!</h4>
                    <div class="divider"></div>
                    <h4 class="center blue-grey-text"></h4>
                </c:if>
            </div>
        </div>
    </div>
</div>