<%-- 
    Document   : intestazione
    Created on : 5-lug-2017, 10.14.29
    Author     : simoberny
--%>

<%@page import="java.util.List"%>
<%@page import="it.unitn.webprogramming2017.progetto.Notifica"%>
<%@page import="it.unitn.webprogramming2017.progetto.Negozio"%>
<%@page import="it.unitn.webprogramming2017.progetto.User"%>
<%@page import="java.sql.Statement"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>


<!-- Per usare fmt:message che setta i messaggi nella lingua del browser -->
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!-- Sistema per salvare la lingua del browser -->
<c:if test="${param.language == 'en'}" >
    <fmt:setLocale  value="en_GB" scope="session"/>
</c:if>
<c:if test="${param.language == 'it'}" >
    <fmt:setLocale  value="it_IT" scope="session"/>
</c:if>

<!-- Setto una variabile JSTL per verificare velocemente se il login è ancora valido -->
<c:set var="loggedin" value="${(sessionScope.loggedIn != null) ? true : false}" scope="page"/>
<c:set var="attivazionetodo" value="${(sessionScope.activation != null) ? true : false}" scope="page"/>
<c:set var="admin" value="${(sessionScope.admin != null) ? true : false}" scope="page"/>

<!-- Avvio Javabeans -->
<jsp:useBean id="db" class="it.unitn.webprogramming2017.progetto.DBManager" scope="application" />
<jsp:useBean id="cart" scope="application" class="it.unitn.webprogramming2017.progetto.CartBean" />

<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>

        <link rel="shortcut icon" type="image/x-icon" href="icon.ico"/>
        <link href="https://fonts.googleapis.com/icon?family=Material+Icons" rel="stylesheet" />

        <!-- Importo vari CSS -->
        <link type="text/css" rel="stylesheet" href="css/materialize.min.css"  media="screen,projection"/>
        <link type="text/css" rel="stylesheet" href="css/style.css"/>

        <!-- Importo vari JS -->
        <script type="text/javascript" src="js/jquery-3.2.1.min.js"></script>
        <script type="text/javascript" src="js/materialize.min.js"></script>

        <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
        <title>Valli Store</title>


        <fmt:setBundle basename="strings" />
    </head>
    <body>      
        <%
            User usr = null;
            Negozio negozio = null;
            Integer nNotifiche = 0;
            List<Notifica> lista = null;

            if (session.getAttribute("usr") != null) {
                usr = (User) session.getAttribute("usr");
            }
            if (session.getAttribute("negozio") != null) {
                negozio = (Negozio) session.getAttribute("negozio");
                nNotifiche = Notifica.getNNotifiche(negozio.getNome());
                lista = Notifica.getNotifiche(0, negozio.getNome(), 0);
            }
        %>

        <!-- Barra rossa che avvisa l'utente che non ha eseguito la conferma dell'account -->
        <c:if test="${attivazionetodo && loggedin}">
            <a href="activation.jsp"><div class="nav-login red white-text"><div class="nav-wrapper center">Profilo in attesa di validazione!</div></div></a>
        </c:if>

        <!-- Barra navigazione alta con cambio lingua -->
        <nav class="nav-login <%=session.getAttribute("admin") != null ? "grey lighten-2" : "blue-grey"%> lighten-5 hide-on-med-and-down">
            <div class="nav-wrapper">
                <ul class="left hide-on-med-and-down">
                    <c:choose>
                        <c:when test="${!loggedin}">
                            <li><a href="access.jsp?type=sign-in" class="blue-grey-text darken-4-text"><fmt:message key="login"/></a></li>
                            <li><a href="" class="blue-grey-text darken-4-text">|</a></li>
                            <li><a href="access.jsp?type=sign-up" class="blue-grey-text darken-4-text"><fmt:message key="register"/></a></li>
                            </c:when>
                            <c:when test="${loggedin && admin}">
                            <li><img class="img-top" src="<%= usr.getAvatar()%>"/></li>
                            <li><a href="admin/index.jsp" class="blue-grey-text darken-4-text"><strong>Admin</strong>, <%= usr.getFirstName()%></a></li>
                            <li><a href="" class="blue-grey-text darken-4-text">|</a></li>
                            <li><a href="logout.jsp" class="blue-grey-text darken-4-text"><fmt:message key="esci"/></a></li>
                            </c:when>
                            <c:otherwise>
                            <li><img class="img-top" src="<%= usr.getAvatar()%>"/></li>
                            <li><a href="user.jsp" class="blue-grey-text darken-4-text">Benvenuto, <%= usr.getFirstName()%></a></li>
                            <li><a href="" class="blue-grey-text darken-4-text">|</a></li>
                            <li><a href="logout.jsp" class="blue-grey-text darken-4-text"><fmt:message key="esci"/></a></li>
                            </c:otherwise>
                        </c:choose>
                </ul>
                <div class="row">
                    <div class="right input-field col xl2 l2 m4 s6 language-s">
                        <form>
                            <select class="icons blue-grey-text darken-4-text" id="language" name="language" onchange="submit()">
                                <option value="" disabled><fmt:message key="lingua"/></option>
                                <option value="it" data-icon="img/it.png" class="circle" ${param.language == 'it' ? 'selected' : ''}>Italian</option>
                                <option value="en" data-icon="img/uk.gif" class="circle" ${param.language == 'en' ? 'selected' : ''}>English</option>
                            </select>
                            <c:forEach var="pageParameter" items="${param}">
                                <input type="hidden" name="${pageParameter.key}" value="${pageParameter.value}">   
                            </c:forEach>
                        </form>
                    </div>
                </div>
            </div>
        </nav>
                            
        <!-- NAV PC -->

        <nav class="white lighten-1 nav-bar" role="navigation">
            <div class="nav-wrapper container hide-on-med-and-down">
                <a id="logo-container" href="index.jsp" class="brand-logo"><img class="icon hide-on-med-and-down" src="img/logo.png"></a>
                <ul class="right hide-on-med-and-down">
                    <li><a href="ricerca.jsp"><i class="material-icons blue-grey-text darken-3-text">search</i></a></li>

                    <li><a href="ricerca.jsp" class="blue-grey-text darken-3-text"><fmt:message key="product"/></a></li>
                    <li><a href="venditori.jsp" class="blue-grey-text darken-3-text"><fmt:message key="sellers"/></a></li>
                    <li><a href="" class="blue-grey-text darken-3-text"><fmt:message key="who"/></a></li>
                    <li><a href="" class="blue-grey-text darken-3-text"><fmt:message key="contact"/></a></li>
                        <c:if test="${loggedin}">
                        <li><a href="user.jsp" class="blue-grey-text darken-3-text"><fmt:message key="account"/></a></li>
                        </c:if>
                    <li><a href="carrello.jsp" class="interact_li"><i class="material-icons blue-grey-text darken-3-text" style="display: inline-block;">local_grocery_store</i><span  class="n_cart"><c:out value="${cart.lineItemCount}"></c:out></span></a></li>
                            <c:if test="${venditore || admin}">
                        <li><a class="dropdown-button blue-grey-text darken-3-tex interact_li" href="notifiche.jsp" data-activates="notifiche"><i class="material-icons blue-grey-text darken-3-text" style="display: inline-block;">notifications</i><span  class="n_cart"><%=nNotifiche%></span></a></li>
                            </c:if>
                </ul>

                <!--/ NAV PC -->
            </div>
            <!-- NAV BAR MOBILE -->            
            <div class="nav-wrapper hide-on-large-only">
                <a id="logo-container" href="index.jsp" class="brand-logo hide-on-large-only">Valli</a>
                <ul class="side-nav" id="nav-mobile">
                    <li class="center-align"><img class="icon " src="img/logo.png"><c:if test="${admin}"><a class="center targhetta_mobile">ADMIN</a></c:if></li>
                        <c:if test="${loggedin}">
                        <li><a href="user.jsp"><%= usr.getFirstName()%></a></li>
                        </c:if>
                        <c:if test="${admin}"><li><a href="admin/index.jsp">Sezione Admin</a></li></c:if>
                        <div class="divider"></div>

                        <li>
                            <div class="search-wrapper">
                                <form action="ricerca.jsp">
                                    <div class="input-field input-mobile-search center-block">
                                        <input id="search" class="mobile-search" type="search" required>
                                        <i class="material-icons search-icon">search</i>
                                    </div>
                                </form>
                            </div>
                        </li>
                        <li><a href="ricerca.jsp"><fmt:message key="product"/></a></li>
                    <li><a href="venditori.jsp"><fmt:message key="sellers"/></a></li>
                    <li><a href=""><fmt:message key="who"/></a></li>
                    <li><a href=""><fmt:message key="contact"/></a></li>

                    <c:choose>
                        <c:when test="${loggedin}">
                            <li><a href="user.jsp" class="blue-grey-text darken-3-text"><fmt:message key="account"/></a></li>
                            </c:when>
                            <c:otherwise>
                            <li><a href="access.jsp?type=sign-in"><fmt:message key="login"/></a></li>
                            <li><a href="access.jsp?type=sign-up"><fmt:message key="register"/></a></li>
                            </c:otherwise>
                        </c:choose>
                    <li class="language-mobile">
                        <div class="row">
                            <div class="input-field col s8 offset-s2 language-s">
                                <form>
                                    <select class="icons blue-grey-text darken-4-text" id="language" name="language" onchange="submit()">
                                        <option value="" disabled><fmt:message key="lingua"/></option>
                                        <option value="it" data-icon="img/it.png" class="circle" ${param.language == 'it' ? 'selected' : ''}>Italian</option>
                                        <option value="en" data-icon="img/uk.gif" class="circle" ${param.language == 'en' ? 'selected' : ''}>English</option>
                                    </select>
                                </form>
                            </div>
                        </div>
                    </li>
                </ul>
                <a href="#" data-activates="nav-mobile" class="button-collapse"><i class="material-icons blue-grey-text darken-3-text">menu</i></a>
                <a href="carrello.jsp" class="hide-on-large-only right"><i class="material-icons blue-grey-text darken-3-text" style="display: inline-block;">local_grocery_store</i><span class="n_cart"><c:out value="${cart.lineItemCount}"></c:out></span></a>
                    <c:if test="${venditore || admin}">
                    <a href="notifiche.jsp" class="hide-on-large-only right"><i class="material-icons blue-grey-text darken-3-text" style="display: inline-block;">notifications</i><span class="n_cart"><%=nNotifiche%></span></a>
                    </c:if>
            </div>
        </nav>


        <ul id='notifiche' class='dropdown-content'>
            <%
                if (lista != null) {
                    if (lista.isEmpty()) {
                        out.print("<h5 class=\"center grey-text\">Nessuna notifica</h5>");
                    } else {
                        for (Notifica not : lista) {
            %>
            <li>
                <a class="notifica">
                    <div class="row">
                        <div class="col s2">
                            <img src="<%=not.getFoto()%>" height="33px"/>
                        </div>
                        <div class="col s10">
                            <span class="testo_notifiche">
                                <%=not.getDescrizione()%><br/>
                                <span class="red-text lighten-2-text"><strong><%=not.getOggetto()%></strong></span>
                            </span>
                        </div>
                    </div>
                </a>
            </li>
            <%
                        }
                    }
                }
            %>
            <li><a href="notifiche.jsp"><button class="waves-effect waves-light btn add_chart" style="display: block; margin: auto;">View more</button></a></li>
        </ul>

        <script>
            //Inizializzazione componenti in JS
            $(".button-collapse").sideNav();
            $('.modal').modal();
            $('select').material_select();
            $(document).ready(function () {
                $('.slider').slider();
            });

            $('.dropdown-button').dropdown({
                inDuration: 300,
                outDuration: 225,
                constrainWidth: true, // Does not change width of dropdown to that of the activator
                hover: false, // Activate on hover
                gutter: 50, // Spacing from edge
                belowOrigin: false, // Displays dropdown below the button
                alignment: 'left', // Displays dropdown with edge aligned to the left of button
                stopPropagation: false // Stops event propagation
            }
            );
        </script>
        <main>
