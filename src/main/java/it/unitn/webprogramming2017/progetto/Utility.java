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
import java.util.ArrayList;
import java.util.List;

/**
 *
 * @author simoberny
 */
public class Utility {

    public static Integer categorie_num() throws SQLException {
        Integer num = 1;
        try (PreparedStatement stm = CON.prepareStatement("SELECT * FROM categoria")) {
            try (ResultSet rs = stm.executeQuery()) {
                while (rs.next()) {
                    num++;
                }
            }
        }

        return num;
    }

    public static Integer prodotti_venditore(String venditore) throws SQLException {
        Integer num = 1;
        try (PreparedStatement stm = CON.prepareStatement("SELECT COUNT(*) FROM articolo WHERE negozio = ?")) {
            stm.setString(1, venditore);
            try (ResultSet rs = stm.executeQuery()) {
                while (rs.next()) {
                    num++;
                }
            }
        }

        return num;
    }

    public static Negozio getNegozio(String nome) throws SQLException {
        Negozio negozio = null;

        try (PreparedStatement stm = CON.prepareStatement("SELECT * FROM negozio, negozio_fisico, coordinate WHERE negozio.nome = negozio_fisico.nome AND negozio_fisico.coordinate = coordinate.id AND negozio.nome = ?")) {
            stm.setString(1, nome); //Setta la stringa "email" sul primo punto di domanda
            try (ResultSet rs = stm.executeQuery()) {
                rs.next();
                negozio = new Negozio();
                negozio.setNome(rs.getString("nome"));
                negozio.setDescrizione(rs.getString("descrizione"));
                negozio.setVenditore(rs.getString("venditore"));
                negozio.setOrari(rs.getString("orari"));
                negozio.setLink(rs.getString("link"));
                negozio.setFoto(rs.getString("foto"));
                negozio.setCitta(rs.getString("citta"));
                negozio.setCoordinate(rs.getString("latitudine"), rs.getString("longitudine"));
                negozio.setAddress(rs.getString("address"));
            } catch (Exception e) {
                System.out.print("Errore");
            }
        }

        return negozio;
    }

}
