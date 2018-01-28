<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ include file="intestazione.jsp" %>

<div class="container"> 
    <div class="row">
        <div class="access_console col s12 m6 l4 xl4 offset-m3 offset-l4 offset-xl4 white">
            <div class="select_access">
                <a href="?type=sign-in" class="sin <c:if test="${param.type eq 'sign-in'}">activesin</c:if><c:if test="${param.type == null}">activesin</c:if>"><fmt:message key="signin_button"/></a>
                <a href="?type=sign-up" class="sin <c:if test="${param.type eq 'sign-up'}">activesun</c:if>"><fmt:message key="signup_button"/></a>
                </div>
                <div class="container"> 
                <c:choose>
                    <c:when test="${param.type eq 'sign-up'}">

                        <div class="row">
                            <h5 class="center"><fmt:message key="signup"/></h5>
                            <form class="col s12" method="POST" action="Register" id="registration_form">
                                <div class="row login-pad">
                                    <div class="input-field col s12">
                                        <input id="nome" type="text" class="validate" name="nome" required>
                                        <label for="nome"><fmt:message key="name"/></label>
                                    </div>
                                    <div class="input-field col s12">
                                        <input id="cognome" type="text" class="validate" name="cognome" required>
                                        <label for="cognome"><fmt:message key="last"/></label>
                                    </div>
                                    <!--<div class="input-field col s12">
                                        <input id="username" type="text" class="validate" name="username" required>
                                        <label for="username">Username</label>
                                    </div>-->
                                    <div class="input-field col s12">
                                        <input id="password" type="password" class="validate" name="password" required>
                                        <label for="password">Password</label>
                                    </div>
                                    <div class="input-field col s12">
                                        <input id="email" type="email" class="validate" name="email" required>
                                        <label for="email" data-error="wrong" data-success="right">Email</label>
                                    </div>
                                    <div class="input-field col s12">
                                        <div class="file-field input-field">
                                            <div class="btn">
                                                <span>Avatar</span>
                                                <input type="file" name="file" id="file">
                                            </div>
                                            <div class="file-path-wrapper">
                                                <input class="file-path validate" type="text">
                                            </div>
                                        </div>
                                    </div>
                                    <p>
                                        <input type="checkbox" id="termini" name="termini"/>
                                        <label for="termini"><a href="#condizioni"><fmt:message key="termini"/></a></label>
                                    </p>
                                </div>
                                <button class="btn waves-effect waves-light btn-submit" type="submit" name="action"><fmt:message key="signup_button"/></button>
                            </form>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <%                            String error = (String) request.getAttribute("error");
                        %>
                        <div class="row">
                            <h5 class="center"><fmt:message key="signin"/></h5>
                            <form class="col s12" method="POST" action="Login" id="login_form">
                                <div class="row login-pad">
                                    <div class="input-field col s12">
                                        <input id="username" type="email" name="email" class="validate" value="${param.username}">
                                        <label for="username">Email</label>
                                    </div>
                                    <div class="input-field col s12">
                                        <input id="password" type="password" name="password" class="validate">
                                        <label for="password">Password</label>
                                    </div>
                                    <!--<div class="input-field col s12">
                                        <p>
                                            <input type="checkbox" id="test5" name="longlogin"/>
                                            <label for="test5"><fmt:message key="auto_access"/></label>
                                        </p>
                                    </div>-->
                                    <input type="hidden" name="from" value="${pageContext.request.requestURI}">
                                </div>
                                <strong><p class="center red-text lighten-2-text"><%=(error != null) ? error : ' '%></p></strong>
                                <button class="btn waves-effect waves-light btn-submit" type="submit" name="action"><fmt:message key="signin_button"/></button>
                                <div class="center">
                                    <a href="forgotpassword.jsp?type=recover"><fmt:message key="miss_pass"/></a>
                                </div>
                            </form>
                        </div>
                    </c:otherwise>
                </c:choose>    
            </div>
        </div>
    </div>

</div>

<div id="condizioni" class="modal modal-fixed-footer">
    <div class="modal-content">
        <h4><fmt:message key="termini2"/></h4>
        <p><fmt:message key="termini"/></p>

        <p><fmt:message key="termini_text"/></p>
    </div>
    <div class="modal-footer">
        <a href="#!" class="modal-action modal-close waves-effect waves-green btn-flat">Agree</a>
    </div>
</div>

<script>
    $('.modal').modal();
</script>