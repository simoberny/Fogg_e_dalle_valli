/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package it.unitn.webprogramming2017.progetto;

import static it.unitn.webprogramming2017.progetto.DBManager.CON;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
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
 * @author simoberny
 */
public class Segnalazione extends HttpServlet {

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

        HttpSession session = request.getSession();
        String id_articolo = request.getParameter("id_articolo");
        String data_acquisto = request.getParameter("data_acquisto");
        String id_mittente = String.valueOf(session.getAttribute("id"));
        String id_destinatario = getIdNegozio(request.getParameter("destinatario"));
        String id_ordine = request.getParameter("id_ordine");
        String oggetto = request.getParameter("oggetto");
        String testo = request.getParameter("testo");
        System.out.println(id_mittente);


        try (PreparedStatement stm = CON.prepareStatement("INSERT INTO segnalazione (id_mittente, id_destinatario, id_ordine, id_articolo, data_acquisto, oggetto, testo, data) VALUES ( ? , ? , ?, ? , ? , ? , ? , NOW())")) {
            stm.setString(1, id_mittente);
            stm.setString(2, id_destinatario);
            stm.setString(3, id_ordine);
            stm.setString(4, id_articolo);
            stm.setString(5, data_acquisto);
            stm.setString(6, oggetto);
            stm.setString(7, testo);

            stm.executeUpdate();
        } catch (SQLException e) {
            System.out.println(e.getMessage());
            response.sendRedirect("user.jsp?page=ordini&success=unsuccess");
            return;
        }
        
        response.sendRedirect("user.jsp?page=ordini&success=success");
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
            Logger.getLogger(Segnalazione.class.getName()).log(Level.SEVERE, null, ex);
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
            Logger.getLogger(Segnalazione.class.getName()).log(Level.SEVERE, null, ex);
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

    private String getIdNegozio(String nome) throws SQLException {
        String idNegozio = " ";
        try (PreparedStatement stm = CON.prepareStatement("SELECT venditore FROM negozio WHERE nome = ?")) {
            stm.setString(1, nome);
            try (ResultSet rs = stm.executeQuery()) {
                rs.next();

                idNegozio = rs.getString("venditore");
            }
        }

        return idNegozio;
    }
}
