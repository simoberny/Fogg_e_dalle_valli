/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package it.unitn.webprogramming2017.progetto;

import java.io.IOException;
import java.io.PrintWriter;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import com.lambdaworks.codec.Base64;
import com.lambdaworks.crypto.SCryptUtil;
import java.io.File;
import java.math.BigInteger;
import java.net.InetAddress;
import java.sql.Date;
import java.util.Properties;
import javax.servlet.RequestDispatcher;
import javax.mail.*;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;
import java.security.MessageDigest;

/**
 *
 * @author simoberny
 */
public class Register extends HttpServlet {

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     *
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, SQLException {
        response.setContentType("text/html;charset=UTF-8");
        
        request.setCharacterEncoding("UTF-8"); //Per evitare problemi con le lettere accentate
        
        String nome = request.getParameter("nome");
        String cognome = request.getParameter("cognome");
        String email = request.getParameter("email");
        String plain_password = request.getParameter("password");
        String avatar = "avatar/default.png";  //DAFAULT IMAGE PLACEHOLDER
        Integer tipo = 1; //DEFAULT Utente normale

        final String username = "vallistoreproject@gmail.com";
        final String password = "vallistore";
        String from = "vallistore@noreply.it";
        String to = email;

        Properties props = new Properties();
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true");
        props.put("mail.smtp.host", "smtp.gmail.com");
        props.put("mail.smtp.port", "587");

        Session session = Session.getInstance(props,
                new javax.mail.Authenticator() {
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(username, password);
            }
        });

        /* Generazione cartella di salvataggio */
        /*String appPath = request.getServletContext().getRealPath("/");
        String savePath = appPath.substring(0, appPath.indexOf("build")) + "web" + File.separator + "avatar";*/
        /* */

        String generatedSecuredPasswordHash = SCryptUtil.scrypt(plain_password, 16, 16, 16);
        
        User us = new User();
        us.setFirstName(nome);
        us.setLastName(cognome);
        us.setEmail(email);
        us.setPassword(generatedSecuredPasswordHash);
        us.setTipo(tipo);
        us.setAvatar(avatar);

        DBManager db = new DBManager();

        if (db.registerUser(us)) {
            
            String string_to_hash = email + generatedSecuredPasswordHash;
            Integer hashed = string_to_hash.hashCode();
            String confirm_link = "http://" + InetAddress.getLocalHost().getHostAddress() + ":8084/Fogg_E_Dalle_Valli_Maven/ConfirmUser?email=" + email + "&a=" + hashed;

            try {
                MimeMessage message = new MimeMessage(session);
                message.setFrom(new InternetAddress(from));
                message.addRecipient(Message.RecipientType.TO, new InternetAddress(to));
                message.setSubject("Attivazione account ValliStore!");
                message.setContent("<h2>Vallistore</h2> <br> Attiva il tuo account cliccando sul link seguente: <br><br> <a href=\""+ confirm_link +"\">Conferma l'account su valli store!</a>","text/html");
                Transport.send(message);
                System.out.println("Sent message successfully....");
            } catch (MessagingException mex) {
                mex.printStackTrace();
            }

            RequestDispatcher requestDispatcher = request
                    .getRequestDispatcher("message.jsp?message=success_registration&origin=access.jsp");
            requestDispatcher.forward(request, response);
        } else {
            PrintWriter out = response.getWriter();
            out.println("Errore!");
        }

        response.setHeader("Refresh", "1; URL=access.jsp");
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
            Logger.getLogger(Register.class.getName()).log(Level.SEVERE, null, ex);
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
            Logger.getLogger(Register.class.getName()).log(Level.SEVERE, null, ex);
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
