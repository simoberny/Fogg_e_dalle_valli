<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ include file="intestazione.jsp" %>

<div class="container"> 
    <div class="row">
        <div class="access_console col s12 m6 l4 xl4 offset-m3 offset-l4 offset-xl4 white">
            <div class="container"> 
                <div class="section"> 
                    <c:choose>
                        <c:when test="${param.type eq 'recover'}">
                            <div class="row">
                                <h5 class="center">forgot password?</h5>
                                <form class="col s12" method="POST" action="RecoverPassword" id="login_form">
                                    <div class="row login-pad">
                                        <div class="input-field col s12">
                                            <input id="email" type="email" name="email" class="validate">
                                            <label for="email">Enter the email to recover the password</label>
                                        </div>
                                        <!--<div class="input-field col s12">
                                            <p>
                                                <input type="checkbox" id="test5" name="longlogin"/>
                                                <label for="test5"><fmt:message key="auto_access"/></label>
                                            </p>
                                        </div>-->
                                        <input type="hidden" name="from" value="${pageContext.request.requestURI}">
                                    </div>
                                    <input type="hidden" name="action" value="request">
                                    <button class="btn waves-effect waves-light btn-submit" type="submit" name="invio">Send</button>
                                </form>
                            </div>
                        </c:when>
                        <c:when test="${param.type eq 'new'}">
                            <div class="row">
                                <h5 class="center">New Password</h5>
                                <form class="col s12" method="POST" action="RecoverPassword" id="login_form">
                                    <div class="row login-pad">
                                        <div class="input-field col s12">
                                            <input id="password" type="password" class="validate" name="password" required>
                                            <label for="password">Password</label>
                                        </div>
                                        <div class="input-field col s12">
                                            <input id="confirm_password" type="password" class="validate" name="password2" required>
                                            <label for="confirm_password">Confirm Password</label>
                                        </div>
                                        <!--<div class="input-field col s12">
                                            <p>
                                                <input type="checkbox" id="test5" name="longlogin"/>
                                                <label for="test5"><fmt:message key="auto_access"/></label>
                                            </p>
                                        </div>-->
                                        <input type="hidden" name="from" value="${pageContext.request.requestURI}">
                                    </div>
                                    <input type="hidden" name="email" value="<c:out value="${param.email}"/>">
                                    <input type="hidden" name="action" value="change">
                                    <button class="btn waves-effect waves-light btn-submit" type="submit" name="invio">Save</button>
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

</div>

<script>


    var password = document.getElementById("password")
            , confirm_password = document.getElementById("confirm_password");

    function validatePassword() {
        if (password.value != confirm_password.value) {
            confirm_password.setCustomValidity("Passwords Don't Match");
        } else {
            confirm_password.setCustomValidity('');
        }
    }

    password.onchange = validatePassword;
    confirm_password.onkeyup = validatePassword;
</script>