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
import java.sql.Statement;
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
public class ProcessOrder extends HttpServlet {

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
        response.setContentType("text/html;charset=UTF-8");

        HttpSession session = request.getSession();

        String cardcode = request.getParameter("card-code");
        String email = request.getParameter("user");
        CartBean cartBean = null;
        Object objCartBean = session.getAttribute("cart");

        if (objCartBean != null) {
            cartBean = (CartBean) objCartBean;
        } else {
            RequestDispatcher requestDispatcher = request.getRequestDispatcher("message.jsp?message=cart_expired");
            requestDispatcher.forward(request, response);
        }

        
        //Creazione ordine complessivo
        try (PreparedStatement stm = CON.prepareStatement("INSERT INTO ordine (user, totale, data, pagamento, modalità) VALUES ( ? , ? , NOW() , ? , ?)")) {
            stm.setString(1, email);
            stm.setDouble(2, cartBean.getTotalWithDelivery());
            stm.setString(3, cardcode);
            stm.setString(4, " " + cartBean.getDelivery());

            stm.executeUpdate();
        } catch (SQLException e) {
            System.out.println(e.getMessage());
            response.sendRedirect("complete.jsp?stato=unsuccess");
        }

        Integer id_ordine = 0;

        //Ottengo il numero incrementale dell'ordine
        try (PreparedStatement stm = CON.prepareStatement("select last_insert_id() as last_id from ordine")) {
            try (ResultSet rs = stm.executeQuery()) {
                rs.next();
                id_ordine = rs.getInt("last_id");
            } catch (Exception e) {

            }
        } catch (SQLException ex) {
            Logger.getLogger(ProcessOrder.class.getName()).log(Level.SEVERE, null, ex);
        }

        //Creazione singoli acquisti degli articoli
        for (int i = 0; i < cartBean.getLineItemCount(); i++) {
            CartItemBean temp = cartBean.getCartItem(i);
            try (PreparedStatement stm = CON.prepareStatement("INSERT INTO acquisto (id_ordine, id_articolo, stato, prezzo, data, quantità) VALUES ( ? , ? , ?, ?, NOW() , ?)")) {
                stm.setInt(1, id_ordine);
                stm.setInt(2, temp.getId());
                stm.setString(3, "Pagato");
                stm.setDouble(4, temp.getTotalCost());
                stm.setInt(5, temp.getQuantity());

                stm.executeUpdate();
            } catch (SQLException e) {
                System.out.println(e.getMessage());
            }
        }
        
        session.setAttribute("cart", null);
        
        RequestDispatcher requestDispatcher = request.getRequestDispatcher("complete.jsp?stato=success&id=" + id_ordine);
        requestDispatcher.forward(request, response);
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
