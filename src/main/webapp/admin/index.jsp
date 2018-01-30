<%@page import="java.util.LinkedHashMap"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.Map"%>
<%@page import="java.util.HashMap"%>
<%@page import="it.unitn.webprogramming2017.progetto.DBManager"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="it.unitn.webprogramming2017.progetto.Utility"%>
<%@page import="it.unitn.webprogramming2017.progetto.Item"%>
<%@page import="com.google.gson.*" %>
<%@ include file="intestazione.jsp" %>
<script type="text/javascript" src="js/fusioncharts.js"></script>
<script type="text/javascript" src="js/themes/fusioncharts.theme.zune.js"></script>

<div class="main">
    <div class="section">
        <div class="row">
            <div class="col s12">
                <h5>Statistiche</h5>
                <div class="divider"></div>
                <div class="col s12 m6 l3">
                    <div class="card red lighten-2 white-text">
                        <div class="row">
                            <div class="col s2">
                                <i class="material-icons icon_admin">supervisor_account</i>
                            </div>
                            <div class="col s10">
                                <div class="card-content white-text">
                                    <span class="card-title card_admin_title"><%=db.getUsers().size()%></span>
                                    <h5>Utenti</h5>
                                </div>
                            </div>
                        </div>
                        <div class="card-action white">
                            <a href="utenti.jsp" class="grey-text">Visualizza</a>
                        </div>

                    </div>
                </div>
                <div class="col s12 m6 l3">
                    <div class="card green lighten-2 white-text">
                        <div class="row">
                            <div class="col s2">
                                <i class="material-icons icon_admin">shopping_cart</i>                            
                            </div>
                            <div class="col s10">
                                <div class="card-content white-text">
                                    <span class="card-title card_admin_title"><%=Utility.articoli_num()%></span>
                                    <h5>Prodotti</h5>
                                </div>
                            </div>
                        </div>
                        <div class="card-action white">
                            <a href="articoli.jsp" class="grey-text">Visualizza</a>
                        </div>
                    </div>
                </div>
                <div class="col s12 m6 l3">
                    <div class="card blue lighten-2 white-text">
                        <div class="row">
                            <div class="col s2">
                                <i class="material-icons icon_admin">toc</i> 
                            </div>
                            <div class="col s10">
                                <div class="card-content white-text">
                                    <span class="card-title card_admin_title"><%=Utility.categorie_num()%></span>
                                    <h5>Categorie</h5>
                                </div>
                            </div>
                        </div>
                        <div class="card-action white">
                            <a href="categorie.jsp" class="grey-text">Visualizza</a>
                        </div>
                    </div>
                </div>
                <div class="col s12">
                    <div id="chart" class="mobile-scroll"></div>
                </div>
            </div>
        </div>
        <div class="row">       
            <div class="col s12">
                <h5>Notifiche</h5>
                <div class="divider"></div>
                <%

                    if (request.getParameter("notifiche") != null && request.getParameter("notifiche").equals("lette")) {
                        lista = Notifica.getAdminNotifiche(0, 1);
                    } else {
                        lista = Notifica.getAdminNotifiche(0, 0);
                    }
                %>

                <div class="section">
                    <div class="row">
                        <div class="col s12 m12 l8">
                            <div class="row">
                                <form method="GET" action="">
                                    <div class="input-field col s12 m6 l2">
                                        <select onchange="this.form.submit()" name="notifiche">
                                            <option value="new" <%=(request.getParameter("notifiche") != null && request.getParameter("notifiche").equals("new")) ? "selected" : " "%>>Nuove</option>
                                            <option value="lette" <%=(request.getParameter("notifiche") != null && request.getParameter("notifiche").equals("lette")) ? "selected" : " "%>>Notifiche lette</option>                                    
                                        </select>
                                        <label>Notifiche</label>
                                    </div>
                                </form>
                                <form method=POST" action=""> 
                                    <button class="waves-effect waves-light btn right" type="submit" name="delete_all" value="submit">Segna tutte come lette</button>
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
                                        <td><img src="../<%=not.getFoto()%>" height="80px"/></td>
                                        <td><%=not.getDescrizione()%><br><span class="red-text lighten-2-text"><strong><%=not.getOggetto()%></strong></span></td>
                                                    <%
                                                        if (!(request.getParameter("notifiche") != null && request.getParameter("notifiche").equals("lette"))) {
                                                    %>
                                        <td>
                                            <form method="POST" action=""> 
                                                <input type="hidden" name="id" value="<%=not.getId()%>">
                                                <input type="hidden" name="id_ordine" value="<%=not.getId_ordine()%>">
                                                <input type="hidden" name="id_articolo" value="<%=not.getId_articolo()%>"> 
                                                <a href="segnalazione.jsp?id=<%=not.getId()%>" class="waves-effect waves-light btn myblue right" name="delete_not" value="submit" type="submit">Gestisci</a>  
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

<%@page import="fusioncharts.FusionCharts" %>

<%
    Gson gson = new Gson();

    // Form the SQL query that returns the top 10 most populous countries
    String sql = "SELECT data_registrazione AS Data, COUNT(*) AS Numero_registrazioni FROM utente GROUP BY data_registrazione LIMIT 10";
    String avg = "SELECT AVG(a.count) AS Media FROM (SELECT COUNT(*) as count FROM utente GROUP BY data_registrazione) as a LIMIT 10";

    PreparedStatement pt = DBManager.CON.prepareStatement(sql);
    ResultSet rs = pt.executeQuery();

    Map<String, String> chartobj = new HashMap<String, String>();
    chartobj.put("caption", "Registrazioni utenti ultimi 10 giorni");
    chartobj.put("showValues", "0");
    chartobj.put("theme", "zune");

    ArrayList arrData = new ArrayList();
    while (rs.next()) {
        Map<String, String> lv = new HashMap<String, String>();
        lv.put("label", rs.getString("Data"));
        lv.put("value", rs.getString("Numero_registrazioni"));
        arrData.add(lv);
    }

    rs.close();

    pt = DBManager.CON.prepareStatement(avg);
    rs = pt.executeQuery();

    String media = " ";

    if (rs.next()) {
        media = rs.getString("Media");
    }

    ArrayList array_globale = new ArrayList();
    ArrayList array_map_line = new ArrayList();
    Map<String, String> map_line = new HashMap<String, String>();
    Map<String, String> glob_trends = new HashMap<String, String>();

    map_line.put("startvalue", media);
    map_line.put("color", "#1aaf5d");
    map_line.put("displayvalue", "Media{br}settimanale");
    map_line.put("valueOnRight", "1");
    map_line.put("thickness", "2");

    array_map_line.add(map_line);

    glob_trends.put("line", gson.toJson(array_map_line));
    array_globale.add(glob_trends);

    Map<String, String> dataMap = new LinkedHashMap<String, String>();
    dataMap.put("chart", gson.toJson(chartobj));
    dataMap.put("data", gson.toJson(arrData));
    dataMap.put("trendlines", gson.toJson(array_globale));

    FusionCharts columnChart = new FusionCharts(
            "column2d",// chartType
            "chart1",// chartId
            "600", "400",// chartWidth, chartHeight
            "chart",// chartContainer
            "json",// dataFormat
            gson.toJson(dataMap)
    );

%>
<!--    Step 5: Render the chart    -->            
<%=columnChart.render()%>

<script>
    $(document).ready(function () {
        $('select').material_select();
    });
</script>

</body>
</html>