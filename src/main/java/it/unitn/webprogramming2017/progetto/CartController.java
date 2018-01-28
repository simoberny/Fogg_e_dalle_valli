/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package it.unitn.webprogramming2017.progetto;

import static it.unitn.webprogramming2017.progetto.Negozio.isPhysic;
import java.io.IOException;
import java.io.PrintWriter;
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
public class CartController extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String strAction = request.getParameter("action");

        if (strAction != null && !strAction.equals("")) {
            if (strAction.equals("add")) {
                try {
                    addToCart(request);
                } catch (SQLException ex) {
                    Logger.getLogger(CartController.class.getName()).log(Level.SEVERE, null, ex);
                }
            } else if (strAction.equals("Update")) {
                updateCart(request);
            } else if (strAction.equals("Delete")) {
                deleteCart(request);
            } else if (strAction.equals("Delivery")) {
                setDelivery(request);
            }
        }
        
        if(!strAction.equals("Delivery")){
            response.sendRedirect("carrello.jsp");
        }else{
            response.sendRedirect("checkout.jsp");
        }
        
    }

    protected void setDelivery(HttpServletRequest request) {
        HttpSession session = request.getSession();
        String delivery = request.getParameter("group1");
        CartBean cartBean = null;

        Object objCartBean = session.getAttribute("cart");
        if (objCartBean != null) {
            cartBean = (CartBean) objCartBean;
        } else {
            cartBean = new CartBean();
        }
        cartBean.setDelivery(delivery);
    }

    protected void deleteCart(HttpServletRequest request) {
        HttpSession session = request.getSession();
        String idoggetto = request.getParameter("indice");
        CartBean cartBean = null;

        Object objCartBean = session.getAttribute("cart");
        if (objCartBean != null) {
            cartBean = (CartBean) objCartBean;
        } else {
            cartBean = new CartBean();
        }
        cartBean.deleteCartItem(idoggetto);
    }

    protected void updateCart(HttpServletRequest request) {
        HttpSession session = request.getSession();
        String quantita = request.getParameter("quantity");
        String idoggetto = request.getParameter("indice");

        CartBean cartBean = null;

        Object objCartBean = session.getAttribute("cart");
        if (objCartBean != null) {
            cartBean = (CartBean) objCartBean;
        } else {
            cartBean = new CartBean();
        }
        cartBean.updateCartItem(idoggetto, quantita);
    }

    protected void addToCart(HttpServletRequest request) throws SQLException {
        HttpSession session = request.getSession();
        String id = request.getParameter("idoggetto");
        String nome = request.getParameter("nome");
        String foto = request.getParameter("foto");
        String prezzo = request.getParameter("prezzo");
        String quantita = request.getParameter("quantity");
        String negozio = request.getParameter("venditore");

        CartBean cartBean = null;

        Object objCartBean = session.getAttribute("cart");

        if (objCartBean != null) {
            cartBean = (CartBean) objCartBean;
        } else {
            cartBean = new CartBean();
            session.setAttribute("cart", cartBean);
        }  
        
        Boolean fisico = isPhysic(negozio);
        
        cartBean.addCartItem(id, nome, foto, prezzo, quantita, fisico);
    }

}
