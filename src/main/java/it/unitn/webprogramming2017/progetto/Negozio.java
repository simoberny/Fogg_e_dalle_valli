/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package it.unitn.webprogramming2017.progetto;

import static it.unitn.webprogramming2017.progetto.DBManager.CON;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

/**
 *
 * @author simoberny
 */
public class Negozio {

    private String nome;
    private String venditore;
    private String descrizione;
    private String foto;
    private String link;
    private String citta;
    private String orari;
    private double lati;
    private double longi;

    private String address;

    public Negozio() {

    }

    public String getNome() {
        return nome;
    }

    public void setNome(String nome) {
        this.nome = nome;
    }

    public String getVenditore() {
        return venditore;
    }

    public void setVenditore(String venditore) {
        this.venditore = venditore;
    }

    public String getDescrizione() {
        return descrizione;
    }

    public void setDescrizione(String descrizione) {
        this.descrizione = descrizione;
    }

    public String getFoto() {
        return foto;
    }

    public void setFoto(String foto) {
        this.foto = foto;
    }

    public String getLink() {
        return link;
    }

    public void setLink(String link) {
        this.link = link;
    }

    public String getCitta() {
        return citta;
    }

    public void setCitta(String citta) {
        this.citta = citta;
    }

    public String getOrari() {
        return orari;
    }

    public void setOrari(String orari) {
        this.orari = orari;
    }

    public void setCoordinate(String lat, String longi) {
        this.lati = Double.parseDouble(lat);
        this.longi = Double.parseDouble(longi);
    }

    public Double getLat() {
        return this.lati;
    }

    public Double getLong() {
        return this.longi;
    }

    public void setAddress(String address) {
        this.address = address;
    }

    public String getAddress() {
        return this.address;
    }

    public static Boolean isPhysic(String nome) throws SQLException {
        try (PreparedStatement stm = CON.prepareStatement("SELECT * FROM negozio_fisico WHERE nome = ?")) {
            stm.setString(1, nome);
            try (ResultSet rs = stm.executeQuery()) {
                if(rs.next()){
                    return true;
                }
            }
        }

        return false;
    }

}
