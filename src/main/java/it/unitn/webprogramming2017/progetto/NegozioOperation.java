/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package it.unitn.webprogramming2017.progetto;

import static it.unitn.webprogramming2017.progetto.DBManager.CON;
import static it.unitn.webprogramming2017.progetto.Utility.getNegozio;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

/**
 *
 * @author anonymous
 */
public class NegozioOperation extends HttpServlet {

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, SQLException {
        response.setContentType("text/html;charset=UTF-8");
        request.setCharacterEncoding("UTF-8"); //Per evitare problemi con le lettere accentate
        HttpSession session = request.getSession();

        String nomenegozio = request.getParameter("nome");
        String descrizione = request.getParameter("desc");
        String orari= request.getParameter("orari");
        String link = request.getParameter("link");
        String lat = request.getParameter("lat");
        String longi = request.getParameter("long");
        String address = request.getParameter("address");

        String sql = "UPDATE negozio, negozio_fisico, coordinate SET descrizione = ?, link = ?, orari = ?, latitudine = ?, longitudine = ?, address = ? WHERE negozio.nome = ?";
        try (PreparedStatement stm = CON.prepareStatement(sql)) {
            stm.setString(1, descrizione);
            stm.setString(2, link);
            stm.setString(3, orari);
            stm.setString(4, lat);
            stm.setString(5, longi);
            stm.setString(6, address);
            stm.setString(7, nomenegozio);
            stm.executeUpdate();
            stm.close();
        } catch (SQLException e) {
            System.out.print("Errore");
            response.sendRedirect("user.jsp?page=negozio&success=unsuccess");
            return;
        }
                
        
        session.setAttribute("negozio", Utility.getNegozio(nomenegozio));
        response.sendRedirect("user.jsp?page=negozio&success=success");
    }

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            processRequest(request, response);
        } catch (SQLException ex) {
            Logger.getLogger(NegozioOperation.class.getName()).log(Level.SEVERE, null, ex);
        }
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            processRequest(request, response);
        } catch (SQLException ex) {
            Logger.getLogger(NegozioOperation.class.getName()).log(Level.SEVERE, null, ex);
        }
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
