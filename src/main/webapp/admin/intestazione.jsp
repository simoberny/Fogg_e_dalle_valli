<%@page import="it.unitn.webprogramming2017.progetto.Notifica"%>
<%@page import="java.util.List"%>
<%@page import="it.unitn.webprogramming2017.progetto.User"%>
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

<!-- Carico i pacchetti per l'internaziolizazione -->
<fmt:setBundle basename="pages" var="pagesBundle"/>
<fmt:setBundle basename="labels" scope="session"/>
<fmt:setBundle basename="com.example.i18n.text" />

<jsp:useBean id="db" class="it.unitn.webprogramming2017.progetto.DBManager" scope="application" />

<!-- Setto una variabile JSTL per verificare velocemente se il login è ancora valido -->
<c:set var="loggedin" value="${(sessionScope.loggedIn != null) ? true : false}" scope="application"/>
<c:set var="admin" value="${(sessionScope.admin != null) ? true : false}" scope="application"/>

<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>

        <link rel="shortcut icon" type="image/x-icon" href="../icon.ico"/>
        <link href="https://fonts.googleapis.com/icon?family=Material+Icons" rel="stylesheet" />

        <!-- Importo vari CSS -->
        <link type="text/css" rel="stylesheet" href="../css/materialize.min.css"  media="screen,projection"/>
        <link type="text/css" rel="stylesheet" href="style.css"/>

        <!-- Importo vari JS -->
        <script type="text/javascript" src="../js/jquery-3.2.1.min.js"></script>
        <script type="text/javascript" src="../js/materialize.min.js"></script>



        <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
        <title>Valli Store</title>


        <fmt:setBundle basename="resource/strings" />
    </head>
    <body>   
        <%
            User usr = null;
            if (session.getAttribute("usr") != null) {
                usr = (User) session.getAttribute("usr");
            }

            List<Notifica> lista = Notifica.getAdminNotifiche(0, 0);
        %>

        <ul id="slide-out" class="side-nav fixed">
            <li><div class="user-view">
                    <div class="background blue-grey"></div>
                    <a href="index.jsp"><img class="circle" src="../img/admin.png"></a>
                    <a href="index.jsp"><span class="white-text name"><%=usr.getFirstName()%></span></a>
                    <a href="#!email"><span class="white-text email"><%=usr.getEmail()%></span></a>
                </div></li>
            <li><a href="../user.jsp"><i class="material-icons">cloud</i>Modifica profilo</a></li>
            <li><a href="../logout.jsp">Esci</a></li>
            <li><div class="divider"></div></li>
            <li><a class="subheader">Gestione</a></li>
            <li>  

                <ul class="collapsible" data-collapsible="accordion">
                    <li>
                        <div class="collapsible-header"><i class="material-icons">shopping_cart</i>Articoli</div>
                        <div class="collapsible-body">
                            <ul>
                                <li><a href="articoli.jsp">Tutti gli articoli</a></li>
                                <li><a href="articoli.jsp?tipo=delete">Articoli eliminati</a></li>
                            </ul>
                        </div>
                    </li>
                    <li>
                        <div class="collapsible-header"><a href="categorie.jsp" class="black-text"><i class="material-icons">toc</i>Categorie</a></div>
                    </li>
                    <li>
                        <div class="collapsible-header"><i class="material-icons">supervisor_account</i>Utenti</div>
                        <div class="collapsible-body">
                            <ul>
                                <li><a href="utenti.jsp?tipo=all">Visualizza utenti</a></li>
                                <li><a href="utenti.jsp?tipo=not">Utenti da confermare</a></li>
                            </ul>
                        </div>
                    </li>
                    <li>
                        <div class="collapsible-header"><i class="material-icons">warning</i>Segnalazioni</div>
                        <div class="collapsible-body">
                            <ul>
                                <li><a href="segnalazioni.jsp?tipo=chiuse">Risolte</a></li>
                                <li><a href="segnalazioni.jsp?tipo=aperte">Aperte</a></li>
                            </ul>
                        </div>
                    </li>
                </ul>
            </li>
        </ul>


        <nav>
            <a href="#" data-activates="slide-out" class="button-collapse"><i class="material-icons">menu</i></a>
            <div class="nav-wrapper blue-grey">
                <ul id="nav-mobile" class="left hide-on-med-and-up">
                    <li><a href="index.jsp">Admin</a></li>
                </ul>
                <ul id="nav-mobile" class="right hide-on-med-and-down">
                    <li><a href="../index.jsp">Sito Principale</a></li>
                </ul>
                <ul class="right">
                    <li><a href="#" class="dropdown-button" data-activates="notifiche">Notifiche <span class="new badge red"><%=lista.size()%></span></a></li>
                    <li><a>Logout</a></li>
                </ul>
            </div>
        </nav>
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
                            <img src="../<%=not.getFoto()%>" height="33px"/>
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
            <li><a href="index.jsp"><button class="waves-effect waves-light btn add_chart" style="display: block; margin: auto;">View more</button></a></li>
        </ul>

        <script>
            $(".button-collapse").sideNav();
            $('.collapsible').collapsible();

            $('.dropdown-button').dropdown({
                inDuration: 300,
                outDuration: 225,
                constrainWidth: false, // Does not change width of dropdown to that of the activator
                hover: false, // Activate on hover
                gutter: 0, // Spacing from edge
                belowOrigin: true, // Displays dropdown below the button
                alignment: 'right', // Displays dropdown with edge aligned to the left of button
                stopPropagation: false // Stops event propagation
            }
            );
        </script>