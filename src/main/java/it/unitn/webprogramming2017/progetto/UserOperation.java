/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package it.unitn.webprogramming2017.progetto;

import com.lambdaworks.crypto.SCryptUtil;
import static it.unitn.webprogramming2017.progetto.DBManager.CON;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

/**
 *
 * @author anonymous
 */
@WebServlet(name = "UserOperation", urlPatterns = {"/UserOperation"})
public class UserOperation extends HttpServlet {

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
        request.setCharacterEncoding("UTF-8"); //Per evitare problemi con le lettere accentate
        HttpSession session = request.getSession();
        DBManager db = new DBManager();

        
        String nome = request.getParameter("nome");
        String cognome = request.getParameter("cognome");
        String email = request.getParameter("email");
        String password = request.getParameter("password");

        if (!password.equals("placeholder")) {
            String generatedSecuredPasswordHash = SCryptUtil.scrypt(password, 16, 16, 16);

            String sql = "UPDATE utente SET nome = ?, cognome = ?, password = ? WHERE email = ?";
            try (PreparedStatement stm = CON.prepareStatement(sql)) {
                stm.setString(1, nome);
                stm.setString(2, cognome);
                stm.setString(3, generatedSecuredPasswordHash);
                stm.setString(4, email);
                stm.executeUpdate();
                stm.close();
            } catch (SQLException e) {
                System.out.println(e.getMessage());
                response.sendRedirect("user.jsp?success=unsuccess");
                return;
            }

        } else {
            String sql = "UPDATE utente SET nome = ?, cognome = ? WHERE email = ?";
            try (PreparedStatement stm = CON.prepareStatement(sql)) {
                stm.setString(1, nome);
                stm.setString(2, cognome);
                stm.setString(3, email);
                stm.executeUpdate();
                stm.close();
            } catch (SQLException e) {
                System.out.println(e.getMessage());
                response.sendRedirect("user.jsp?success=unsuccess");
                return;
            }
        }

        session.setAttribute("usr", db.getUser(email));
        response.sendRedirect("user.jsp?success=success");
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
            Logger.getLogger(UserOperation.class.getName()).log(Level.SEVERE, null, ex);
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
            Logger.getLogger(UserOperation.class.getName()).log(Level.SEVERE, null, ex);
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
