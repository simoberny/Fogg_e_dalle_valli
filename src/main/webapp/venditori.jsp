<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="it.unitn.webprogramming2017.progetto.DBManager"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ include file="intestazione.jsp" %>


<div class="section white">        
        <div class="row">
            <div class="container">
                <div class="divider"></div>
                <div class="col s3">
                    <div class="icon-block">
                        <h2 class="center light-blue-text"><i class="material-icons">group</i></h2>
                        <h5 class="center">Negozi</h5>
                        <p class="light">Il nostro store è trasparente e affidabile. Ecco la lista dei nostri negozi in ordine decrescente per affidabilità</p>
                    </div>
                </div>
                <div class="col s7 offset-s1 ">
                    <br><br>
                        <table class="bordered highlight">
                            <thead>
                                <tr>
                                    <th>Nome negozio</th>
                                    <th>N° oggetti venduti</th>
                                    <th>Affidabilità</th>   
                                </tr>
                            </thead>
                            <tbody>
                                <%  
                                    String sql = "SELECT N.nome, ifnull(SUM(media_recensioni*n_recensioni)/SUM(n_recensioni), 0) as star, ifnull(SUM(quantity), 0) as quantity FROM negozio N left join articolo A ON N.nome = A.negozio left join (select id_articolo, sum(quantità) as quantity from acquisto group by id_articolo) as B ON A.id_articolo = B.id_articolo GROUP BY N.nome ORDER BY star desc, quantity desc";

                                    PreparedStatement stm = DBManager.CON.prepareStatement(sql);
                                    try (ResultSet rs = stm.executeQuery()) {
                                        System.out.println(rs);
                                        while (rs.next()) {

                                %>

                                <tr>                                 
                                    <td><a href="negozio.jsp?view=<%=rs.getString("nome")%>"><span class="venditore myblue_text"><%=rs.getString("nome")%></span></a></td>
                                    <td><%=rs.getString("quantity")%></td>
                                    <td><span class="valutazione">                            
                                        <div class="rating" data-rating="<%=Math.round(rs.getDouble("star"))%>">
                                            <i class="star-1">★</i>
                                            <i class="star-2">★</i>
                                            <i class="star-3">★</i>
                                            <i class="star-4">★</i>
                                            <i class="star-5">★</i>
                                        </div>
                                    </span>  <%=Math.round(rs.getDouble("star") / 5 * 100)%>  % </td>                           
                                </tr> 
                                <%
                                    }
                                }
                                %>
                        </tbody>
                    </table>            
                </div>
            </div>
        </div>
    </div>
</div>

<%@ include file="footer.jsp" %>



                                
