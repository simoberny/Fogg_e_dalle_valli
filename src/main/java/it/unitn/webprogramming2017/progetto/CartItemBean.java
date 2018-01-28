/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package it.unitn.webprogramming2017.progetto;

/**
 *
 * @author simoberny
 */
public class CartItemBean {
    private Integer id;
    private String nome;
    private double dblUnitCost;
    private int iQuantity;
    private double dblTotalCost;
    private String foto;
    private Boolean ritiro;
     
    public Integer getId() {
        return id;
    }
    public void setId(String id) {
        this.id = Integer.parseInt(id);
    }
    public String getNome() {
        return nome;
    }
    public void setNome(String nome) {
        this.nome = nome;
    }
    public String getFoto() {
        return foto;
    }
    public void setFoto(String foto) {
        this.foto = foto;
    }
    public double getUnitCost() {
        return dblUnitCost;
    }
    public void setUnitCost(double dblUnitCost) {
        this.dblUnitCost = dblUnitCost;
    }
    public int getQuantity() {
        return iQuantity;
    }
    public void setQuantity(int quantity) {
        iQuantity = quantity;
    }
    public double getTotalCost() {
        return dblTotalCost;
    }
    public void setTotalCost(double dblTotalCost) {
        this.dblTotalCost = dblTotalCost;
    }

    public Boolean getRitiro() {
        return ritiro;
    }

    public void setRitiro(Boolean ritiro) {
        this.ritiro = ritiro;
    }
    
    
}