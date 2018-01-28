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
import java.sql.SQLException;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 *
 * @author simoberny
 */
public class Review extends HttpServlet {

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
            throws ServletException, IOException {
        String messaggio = request.getParameter("message");
        Integer voto = Integer.parseInt(request.getParameter("voto"));
        String utente = request.getParameter("utente");
        Integer id = Integer.parseInt(request.getParameter("articolo"));

        //Creazione recensione
        try (PreparedStatement stm = CON.prepareStatement("INSERT INTO recensione (utente, id_articolo, testo, voto) VALUES ( ? , ? , ? , ?)")) {
            stm.setString(1, utente);
            stm.setInt(2, id);
            stm.setString(3, messaggio);
            stm.setInt(4, voto);

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
        processRequest(request, response);
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
        processRequest(request, response);
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
