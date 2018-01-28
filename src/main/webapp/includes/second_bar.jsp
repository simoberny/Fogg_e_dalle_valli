<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<nav class="blue-grey lighten-5 nav-bar hide-on-med-and-down" role="navigation">
    <div class="nav-wrapper container">
        <ul class="right hide-on-med-and-down">
            <li><a href="user.jsp?page=dati" class="blue-grey-text darken-3-text"><fmt:message key="modifica"/></a></li>
            <li><a href="user.jsp?page=ordini" class="blue-grey-text darken-3-text"><fmt:message key="ordini"/></a></li>
            <li><a href="user.jsp?page=segnalazioni" class="blue-grey-text darken-3-text"><fmt:message key="segnalazioni"/></a></li>
                <c:if test="${venditore}">
                <li><a href="user.jsp?page=negozio" class="blue-grey-text darken-3-text"><fmt:message key="negozio"/></a></li>
                </c:if>
        </ul>
    </div>
</nav>

<!--MOBILE-->
<div class="row hide-on-large-only">
    <div class="col s12 no-padding">
        <ul class="tabs tabs-fixed-width">
            <li class="tab col s4"><a href="user.jsp?page=dati" class="blue-grey-text darken-4-text <c:if test="${param.page eq 'modifica'}">active</c:if>"><fmt:message key="modifica"/></a></li>
            <li class="tab col s4"><a href="user.jsp?page=ordini" class="blue-grey-text darken-4-text <c:if test="${param.page eq 'ordini'}">active</c:if>"><fmt:message key="ordini"/></a></li>
            <li class="tab col s4"><a href="user.jsp?page=segnalazioni" class="blue-grey-text darken-4-text <c:if test="${param.page eq 'segnalazioni'}">active</c:if>"><fmt:message key="segnalazioni"/></a></li>
                <c:if test="${venditore}">
                <li class="tab col s4"><a href="user.jsp?page=negozio" class="blue-grey-text darken-4-text <c:if test="${param.page eq 'recensioni'}">active</c:if>"><fmt:message key="negozio"/></a></li>
                </c:if>
        </ul>
    </div>
</div>
