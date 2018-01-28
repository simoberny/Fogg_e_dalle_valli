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
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 *
 * @author simoberny
 */
public class AdminOperation extends HttpServlet {

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

        String action = request.getParameter("action");
        String referer = request.getHeader("Referer");
        Boolean res = false;

        switch (action) {
            case "update_categoria":
                referer.substring(0, referer.lastIndexOf("?") + 1);
                res = update_Categoria(request);
                break;
            case "conferma_utente":
                res = conferma_utente(request);
                break;
            case "cancella_prodotto":
                res = delete_prodotto(request);
                break;
            case "action_segnalazione":
                res = gestione_segnalazione(request);
                break;
            default:
                break;
        }

        referer += ("&success=" + (res ? "success" : "unsuccess"));
        response.sendRedirect(referer);
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
            Logger.getLogger(AdminOperation.class.getName()).log(Level.SEVERE, null, ex);
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
            Logger.getLogger(AdminOperation.class.getName()).log(Level.SEVERE, null, ex);
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

    private Boolean update_Categoria(HttpServletRequest request) throws SQLException {
        String nome = request.getParameter("nome_cat");
        String descrizione = request.getParameter("desc_cat");
        String old = request.getParameter("old_key");

        String sql = "UPDATE categoria SET nome_categoria = ?, desc_categoria = ? WHERE nome_categoria = ?";
        try (PreparedStatement stm = CON.prepareStatement(sql)) {
            stm.setString(1, nome);
            stm.setString(2, descrizione);
            stm.setString(3, old);
            stm.executeUpdate();
            stm.close();
        } catch (SQLException e) {
            return false;
        }

        return true;
    }

    private Boolean conferma_utente(HttpServletRequest request) {
        String email = request.getParameter("utente");

        String sql = "UPDATE utente SET data_conferma_registrazione = NOW() WHERE email = ?";
        try (PreparedStatement stm = CON.prepareStatement(sql)) {
            stm.setString(1, email);
            stm.executeUpdate();
            stm.close();
        } catch (SQLException e) {
            return false;
        }

        return true;
    }

    private Boolean delete_prodotto(HttpServletRequest request) {
        String id_prodotto = request.getParameter("id_prodotto");

        String sql = "DELETE FROM articolo WHERE id_articolo = ?";
        try (PreparedStatement stm = CON.prepareStatement(sql)) {
            stm.setString(1, id_prodotto);
            stm.executeUpdate();
            stm.close();
        } catch (SQLException e) {
            return false;
        }

        return true;
    }

    private Boolean gestione_segnalazione(HttpServletRequest request) {
        String azione = request.getParameter("sub_action");
        Boolean rs = false;
        switch (azione) {
            case "ignora":
                rs = ignora_segnalazione(request);
                break;

            case "elimina":
                rs = elimina_segnalazione(request);
                break;
            case "segnalazione":
                System.out.println("Implementazione da gruppi 5+");
                break;
            case "rimborso":
                rs = rimborso_segnalazione(request);
                break;
        }

        return rs;
    }

    private Boolean ignora_segnalazione(HttpServletRequest request) {
        String id = request.getParameter("id");

        String sql = "UPDATE segnalazione SET stato = 'chiusa' WHERE id_messaggio = ?";
        try (PreparedStatement stm = CON.prepareStatement(sql)) {
            stm.setString(1, id);
            stm.executeUpdate();
            stm.close();
        } catch (SQLException e) {
            return false;
        }

        return true;
    }

    private Boolean elimina_segnalazione(HttpServletRequest request) {
        String id = request.getParameter("id");

        String sql = "DELETE FROM segnalazione WHERE id_messaggio = ?";
        try (PreparedStatement stm = CON.prepareStatement(sql)) {
            stm.setString(1, id);
            stm.executeUpdate();
            stm.close();
        } catch (SQLException e) {
            return false;
        }

        return true;
    }

    private Boolean rimborso_segnalazione(HttpServletRequest request) {
        String id = request.getParameter("id");
        String ordine = request.getParameter("ordine");
        String articolo = request.getParameter("articolo");

        String sql = "UPDATE segnalazione SET stato = 'chiusa' WHERE id_messaggio = ?";
        try (PreparedStatement stm = CON.prepareStatement(sql)) {
            stm.setString(1, id);
            stm.executeUpdate();
            stm.close();
        } catch (SQLException e) {
            return false;
        }

        sql = "UPDATE acquisto SET stato = 'Rimborsato' WHERE id_ordine = ? AND id_articolo = ?";
        try (PreparedStatement stm = CON.prepareStatement(sql)) {
            stm.setString(1, ordine);
            stm.setString(2, articolo);
            stm.executeUpdate();
            stm.close();
        } catch (SQLException e) {
            return false;
        }

        return true;
    }
}
