<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page import="it.unitn.webprogramming2017.progetto.User"%>
<div class="section white">
    <div class="container">
        <div class="row">
            <form class="col s12 m10 offset-m1 " method="POST" action="UserOperation">
                <h5>Modifica Dati</h5>
                <div class="divider"></div>
                <br>

                <%
                    User usr = (User) session.getAttribute("usr");
                    Boolean disable = false;
                    if (request.getParameter("edit") != null) {
                        disable = true;
                    }

                %>
                <div class="section">
                    <div class="row">
                        <div class="input-field col s6 l4">
                            <input <%=disable ? "enabled" : "disabled"%> placeholder="Placeholder" id="first_name" name="nome" type="text" class="validate" value="<%= usr.getFirstName()%>">
                            <label for="first_name">Nome</label>
                        </div>
                        <div class="input-field col s6 l4">
                            <input <%=disable ? "enabled" : "disabled"%> id="last_name" type="text" class="validate" name="cognome" value="<%= usr.getLastName()%>">
                            <label for="last_name">Cognome</label>
                        </div>
                    </div>
                    <!--<div class="file-field input-field l4">
                        <div class="btn">
                            <span>File</span>
                            <input type="file">
                        </div>
                        <div class="file-path-wrapper">
                            <input class="file-path validate" type="text">
                        </div> 
                    </div>-->
                    <label>Immagine attuale</label> 
                    <div class="row">

                        <div class="input-field col s12 l6">
                            <img src="<%= usr.getAvatar()%>" style="max-height: 100px;"/><br>
                        </div>
                    </div>
                    <div class="row">
                        <div class="input-field col s12 l6">
                            <input <%=disable ? "enabled" : "disabled"%> id="password" type="password" name="password" class="validate" value="placeholder">
                            <label for="password">Password</label>
                        </div>
                    </div>
                    <c:if test="${param.edit eq true}">
                        <div class="row">
                            <div class="input-field col s12 l6">
                                <input type="password" class="validate" id="confirm_password" value="placeholder">
                                <label for="password">Ripeti password</label>
                            </div>
                        </div>
                    </c:if>
                    <div class="row">
                        <div class="input-field col s12 l6">
                            <input id="email" type="email" class="validate" value="<%= usr.getEmail()%>" disabled>
                            <input type="hidden" name="email" value="<%= usr.getEmail()%>">
                            <label for="email">Email</label>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col s4 l3 xl2">
                            <a class="waves-effect waves-light btn" href="?edit=true">Modifica</a>
                        </div>

                        <c:if test="${param.edit eq true}">
                            <div class="col s4 l3 xl2">
                                <button class="waves-effect waves-light btn" name="save" type="submit">Save</button>
                            </div>
                        </c:if>
                    </div>
                </div>
            </form>
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