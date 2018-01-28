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
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

/**
 *
 * @author simoberny
 */
public class Login extends HttpServlet {

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

        DBManager db = new DBManager();

        //TODO LOGIN
        String email = request.getParameter("email");
        String plain_password = request.getParameter("password");
        String comingPage = request.getParameter("from");

        User loggeduser = db.loginUser(email, plain_password);

        HttpSession session = request.getSession();

        PrintWriter out = response.getWriter();
        if (loggeduser != null) {
            session.setAttribute("loggedIn", true);
            session.setAttribute("usr", loggeduser);
            if (!loggeduser.getAttivazione()) {
                session.setAttribute("activation", true);
            }
            if (loggeduser.getTipo() == 0) {
                session.setAttribute("admin", true);
            } else if (loggeduser.getTipo() == 2) {
                session.setAttribute("venditore", true);
                Negozio negozio = null;
                
                try (PreparedStatement stm = CON.prepareStatement("SELECT * FROM negozio, negozio_fisico, coordinate WHERE negozio.nome = negozio_fisico.nome AND negozio_fisico.coordinate = coordinate.id AND venditore = ?")) {
                    stm.setString(1, email); //Setta la stringa "email" sul primo punto di domanda
                    try (ResultSet rs = stm.executeQuery()) {
                        rs.next();
                        negozio = new Negozio();
                        negozio.setNome(rs.getString("nome"));
                        negozio.setDescrizione(rs.getString("descrizione"));
                        negozio.setVenditore(rs.getString("venditore"));
                        negozio.setLink(rs.getString("link"));
                        negozio.setFoto(rs.getString("foto"));
                        negozio.setCitta(rs.getString("citta"));
                        negozio.setOrari(rs.getString("orari"));
                        negozio.setCoordinate(rs.getString("latitudine"), rs.getString("longitudine"));
                        negozio.setAddress(rs.getString("address"));
                    } catch (Exception e) {
                        System.out.print("Errore");
                    }
                }
                session.setAttribute("negozio", negozio);
            }
        } else {
            RequestDispatcher requestDispatcher = request.getRequestDispatcher("access.jsp?type=sign-in");
            request.setAttribute("error", "Utente non trovato");
            requestDispatcher.forward(request, response);
        }

        response.setHeader("Refresh", "0; URL=index.jsp");
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
            Logger.getLogger(Login.class.getName()).log(Level.SEVERE, null, ex);
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
            Logger.getLogger(Login.class.getName()).log(Level.SEVERE, null, ex);
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
