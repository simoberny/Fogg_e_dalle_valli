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
import java.math.BigInteger;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Objects;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 *
 * @author simoberny
 */
@WebServlet(name = "ConfirmUser", urlPatterns = {"/ConfirmUser"})
public class ConfirmUser extends HttpServlet {

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

        String email = request.getParameter("email");
        String hash = request.getParameter("a");
        Integer getHash = Integer.parseInt(hash);

        int count = 0;

        PrintWriter out = response.getWriter();

        DBManager db = new DBManager();
        try (PreparedStatement stm = CON.prepareStatement("SELECT * FROM utente WHERE email = ?")) {
            stm.setString(1, email); //Setta la stringa "email" sul primo punto di domanda
            try (ResultSet rs = stm.executeQuery()) {
                rs.next();
                String temp = email + rs.getString("password");
                Integer hashed = temp.hashCode();
                out.print(hashed);
                out.print(getHash);
                if (hashed.equals(getHash)) {
                    String sql = "UPDATE utente SET data_conferma_registrazione=NOW() WHERE email=?";
                    try (PreparedStatement statement = CON.prepareStatement(sql)) {
                        statement.setString(1, email);
                        count = statement.executeUpdate();
                    } catch (SQLException e) {
                        out.println(e.getMessage());
                    }
                }
            }
        }

        if (count > 0) {
            RequestDispatcher requestDispatcher = request
                    .getRequestDispatcher("message.jsp?message=utente_confermato&origin=index.jsp");
            requestDispatcher.forward(request, response);
        } else {
            RequestDispatcher requestDispatcher = request
                    .getRequestDispatcher("message.jsp?message=errore&origin=index.jsp");
            requestDispatcher.forward(request, response);
        }
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
            Logger.getLogger(ConfirmUser.class.getName()).log(Level.SEVERE, null, ex);
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
            Logger.getLogger(ConfirmUser.class.getName()).log(Level.SEVERE, null, ex);
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
