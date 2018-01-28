<%@page import="java.util.List"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ include file="intestazione.jsp" %>

<div class="section white">
    <div class="container">
        <div class="row">
            <div class="col s12 m10 offset-m1">
                <h4 class="center">Notifiche <strong class="red-text lighten-2-text"><%=nNotifiche%></strong></h4>
                <div class="divider"></div>
                <%

                    if (request.getParameter("delete_not") != null) {
                        Notifica.clearNotifica(request.getParameter("id"), request.getParameter("id_ordine"), request.getParameter("id_articolo"));
                    }

                    if (request.getParameter("delete_all") != null) {
                        Notifica.clearAllNotifiche();
                    }

                    if (request.getParameter("notifiche") != null && request.getParameter("notifiche").equals("lette")) {
                        lista = Notifica.getNotifiche(0, negozio.getNome(), 1);
                    } else {
                        lista = Notifica.getNotifiche(0, negozio.getNome(), 0);
                    }
                %>
                <div class="section">
                    <div class="row">
                        <div class="col s12">
                            <div class="row">
                                <form method="GET" action="">
                                    <div class="input-field col s12 m6 l3">
                                        <select onchange="this.form.submit()" name="notifiche">
                                            <option value="new" <%=(request.getParameter("notifiche") != null && request.getParameter("notifiche").equals("new")) ? "selected" : " "%>>Nuove</option>
                                            <option value="lette" <%=(request.getParameter("notifiche") != null && request.getParameter("notifiche").equals("lette")) ? "selected" : " "%>>Notifiche lette</option>                                    </select>
                                        <label>Notifiche</label>
                                    </div>
                                </form>
                                <form method=POST" action=""> 
                                    <button class="waves-effect waves-light btn right" type="submit" name="delete_all" value="submit"> Segna tutte come lette</button>
                                </form>
                            </div>
                            <%
                                if (lista.isEmpty()) {
                                    out.print("<h4 class=\"center\">Nessuna notifica!</h4>");
                            } else {
                            %>
                            <table class="bordered highlight">
                                <tbody>
                                    <%
                                        for (Notifica not : lista) {
                                    %>
                                    <tr>
                                        <td><img src="<%=not.getFoto()%>" height="80px"/></td>
                                        <td><%=not.getDescrizione()%><br><span class="red-text lighten-2-text"><strong><%=not.getOggetto()%></strong></span></td>

                                        <%
                                            if (!(request.getParameter("notifiche") != null && request.getParameter("notifiche").equals("lette"))) {
                                        %>
                                        <td>
                                            <form method="POST" action=""> 
                                                <input type="hidden" name="id" value="<%=not.getId()%>">
                                                <input type="hidden" name="id_ordine" value="<%=not.getId_ordine()%>">
                                                <input type="hidden" name="id_articolo" value="<%=not.getId_articolo()%>">
                                                <button class="waves-effect waves-light btn right" name="delete_not" value="submit" type="submit"><i class="material-icons">done</i></button>
                                            </form>
                                        </td>
                                        <%
                                            }
                                        %>
                                    </tr>
                                    <%
                                        }
                                    %>
                                </tbody>
                            </table>
                            <%
                                }
                            %>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<script>
    $(document).ready(function () {
        $('select').material_select();
    });
</script>

<%@ include file="footer.jsp" %>