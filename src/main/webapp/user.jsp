<%@ include file="intestazione.jsp" %>
<%@include file="includes/second_bar.jsp" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<c:if test="${param.success eq 'success'}">
    <div class="row green lighten-2 white-text">
        <div class="col s12">
            <h5 class="center">Operazione eseguita con successo!</h5>
        </div>
    </div>
</c:if>

<c:if test="${param.success eq 'unsuccess'}">
    <div class="row red lighten-2 white-text">
        <div class="col s12">
            <h5 class="center">Operazione non riuscita!</h5>
        </div>
    </div>
</c:if>

<c:choose>
    <c:when test="${param.page eq 'ordini'}"><jsp:include page="includes/order.jsp"/></c:when>
    <c:when test="${param.page eq 'segnalazioni'}"><jsp:include page="includes/segnalazioni.jsp"/></c:when>
    <c:when test="${param.page eq 'negozio'}"><jsp:include page="includes/negozio.jsp"/></c:when>
    <c:otherwise><jsp:include page="includes/userdata.jsp"/></c:otherwise>
</c:choose>

<%@ include file="footer.jsp" %>