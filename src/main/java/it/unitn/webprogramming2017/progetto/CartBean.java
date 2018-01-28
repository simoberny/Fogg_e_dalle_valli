/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package it.unitn.webprogramming2017.progetto;

import java.util.ArrayList;

/**
 *
 * @author simoberny
 */
public class CartBean {

    private ArrayList alCartItems = new ArrayList();
    private double dblOrderTotal;
    private double delivery = 0;

    public int getLineItemCount() {
        return alCartItems.size();
    }

    public void deleteCartItem(String strItemIndex) {
        int iItemIndex = 0;
        try {
            iItemIndex = Integer.parseInt(strItemIndex);
            alCartItems.remove(iItemIndex - 1);
            calculateOrderTotal();
        } catch (NumberFormatException nfe) {
            System.out.println("Errore nell'eliminare l'elemento: " + nfe.getMessage());
            nfe.printStackTrace();
        }
    }

    public void updateCartItem(String strItemIndex, String strQuantity) {
        double dblTotalCost = 0.0;
        double dblUnitCost = 0.0;
        int iQuantity = 0;
        int iItemIndex = 0;
        CartItemBean cartItem = null;
        try {
            iItemIndex = Integer.parseInt(strItemIndex);
            iQuantity = Integer.parseInt(strQuantity);
            if (iQuantity > 0) {
                cartItem = (CartItemBean) alCartItems.get(iItemIndex - 1);
                dblUnitCost = cartItem.getUnitCost();
                dblTotalCost = dblUnitCost * iQuantity;
                cartItem.setQuantity(iQuantity);
                cartItem.setTotalCost(dblTotalCost);
                calculateOrderTotal();
            }
        } catch (NumberFormatException nfe) {
            System.out.println("Error while updating cart: " + nfe.getMessage());
            nfe.printStackTrace();
        }

    }

    public void addCartItem(String id, String nome, String foto,
            String costo, String quantita, Boolean ritiro) {
        double dblTotalCost = 0.0;
        double dblUnitCost = 0.0;
        int iQuantity = 0;
        CartItemBean cartItem = new CartItemBean();
        try {
            dblUnitCost = Double.parseDouble(costo);
            iQuantity = Integer.parseInt(quantita);
            if (iQuantity > 0) {
                dblTotalCost = dblUnitCost * iQuantity;
                cartItem.setId(id);
                cartItem.setNome(nome);
                cartItem.setFoto(foto);
                cartItem.setUnitCost(dblUnitCost);
                cartItem.setQuantity(iQuantity);
                cartItem.setTotalCost(dblTotalCost);
                cartItem.setRitiro(ritiro);
                alCartItems.add(cartItem);
                calculateOrderTotal();
            }

        } catch (NumberFormatException nfe) {
            System.out.println("Error while parsing from String to primitive types: " + nfe.getMessage());
            nfe.printStackTrace();
        }
    }

    public void addCartItem(CartItemBean cartItem) {
        alCartItems.add(cartItem);
    }

    public CartItemBean getCartItem(int iItemIndex) {
        CartItemBean cartItem = null;
        if (alCartItems.size() > iItemIndex) {
            cartItem = (CartItemBean) alCartItems.get(iItemIndex);
        }
        return cartItem;
    }

    public ArrayList getCartItems() {
        return alCartItems;
    }

    public void setCartItems(ArrayList alCartItems) {
        this.alCartItems = alCartItems;
    }

    public double getOrderTotal() {
        return dblOrderTotal;
    }

    public void setOrderTotal(double dblOrderTotal) {
        this.dblOrderTotal = dblOrderTotal;
    }

    protected void calculateOrderTotal() {
        double dblTotal = 0;
        for (int counter = 0; counter < alCartItems.size(); counter++) {
            CartItemBean cartItem = (CartItemBean) alCartItems.get(counter);
            dblTotal += cartItem.getTotalCost();

        }
        setOrderTotal(dblTotal);
    }
    
    public double getTotalWithDelivery(){
        return dblOrderTotal + this.delivery;
    }
    
    public double getDelivery(){
        return this.delivery;
    }
    
    protected void setDelivery(String delivery){
        this.delivery = Double.parseDouble(delivery);
    }

}
