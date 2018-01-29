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
import java.util.Collections;
import java.util.Comparator;
import java.util.List;

/**
 *
 * @author simoberny
 */
public class Notifica {

    private Integer id;
    private Integer id_ordine;
    private Integer id_articolo;
    private String foto;
    private String mittente;
    private String descrizione;
    private String oggetto;
    private String data;

    public Notifica() {

    }

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public Integer getId_ordine() {
        return id_ordine;
    }

    public void setId_ordine(Integer id_ordine) {
        this.id_ordine = id_ordine;
    }

    public Integer getId_articolo() {
        return id_articolo;
    }

    public void setId_articolo(Integer id_articolo) {
        this.id_articolo = id_articolo;
    }

    public String getFoto() {
        return foto;
    }

    public void setFoto(String foto) {
        this.foto = foto;
    }

    public String getMittente() {
        return mittente;
    }

    public void setMittente(String mittente) {
        this.mittente = mittente;
    }

    public String getDescrizione() {
        return descrizione;
    }

    public void setDescrizione(String descrizione) {
        this.descrizione = descrizione;
    }

    public String getOggetto() {
        return oggetto;
    }

    public void setOggetto(String oggetto) {
        this.oggetto = oggetto;
    }

    public String getData() {
        return data;
    }

    public void setData(String data) {
        this.data = data;
    }

    public static Integer getNNotifiche(String venditore) throws SQLException {
        Integer num = 0;
        try (PreparedStatement stm = CON.prepareStatement("SELECT COUNT(*) AS notifiche FROM articolo, acquisto WHERE lettura = 0 AND articolo.negozio = ? AND articolo.id_articolo = acquisto.id_articolo")) {
            stm.setString(1, venditore);
            try (ResultSet rs = stm.executeQuery()) {
                if (rs.next()) {
                    num = rs.getInt("notifiche");
                }
            }
        }

        try (PreparedStatement stm = CON.prepareStatement("SELECT COUNT(*) AS notifiche FROM segnalazione, negozio WHERE negozio.venditore = segnalazione.id_destinatario AND lettura = 0 AND negozio.nome = ?")) {
            stm.setString(1, venditore);
            try (ResultSet rs = stm.executeQuery()) {
                if (rs.next()) {
                    num += rs.getInt("notifiche");
                }
            }
        }

        return num;
    }

    public static List<Notifica> getNotifiche(Integer limit, String venditore, Integer lette) throws SQLException {
        List<Notifica> list = new ArrayList();

        String sql = "SELECT * FROM segnalazione, negozio, utente WHERE negozio.venditore = segnalazione.id_destinatario AND utente.email = segnalazione.id_mittente AND lettura = ? AND negozio.nome = ? ORDER BY data";

        if (limit != 0) {
            sql = " LIMIT " + limit;
        }

        try (PreparedStatement stm = CON.prepareStatement(sql)) {
            stm.setInt(1, lette);
            stm.setString(2, venditore);
            try (ResultSet rs = stm.executeQuery()) {
                Notifica temp = null;
                while (rs.next()) {
                    temp = new Notifica();
                    temp.foto = rs.getString("avatar");
                    temp.mittente = rs.getString("id_mittente");
                    temp.descrizione = "L'utente " + temp.mittente + " ha eseguito un segnalazione";
                    temp.oggetto = "Oggetto: " + rs.getString("oggetto");
                    temp.data = rs.getString("data");
                    temp.id = rs.getInt("id_messaggio");

                    list.add(temp);
                }
            }
        }

        sql = "SELECT acquisto.id_articolo, acquisto.id_ordine, articolo.foto AS articolo_img, ordine.user AS acquirente, quantità, articolo.nome AS articolo, ordine.data AS data_acquisto FROM acquisto, ordine, negozio, articolo WHERE ordine.id_ordine = acquisto.id_ordine AND negozio.nome = articolo.negozio AND acquisto.id_articolo = articolo.id_articolo AND lettura = ? AND negozio.nome = ? ORDER BY data_acquisto";

        if (limit != 0) {
            sql = " LIMIT " + limit;
        }

        try (PreparedStatement stm = CON.prepareStatement(sql)) {
            stm.setInt(1, lette);
            stm.setString(2, venditore);
            try (ResultSet rs = stm.executeQuery()) {
                Notifica temp = null;
                while (rs.next()) {
                    temp = new Notifica();
                    temp.foto = rs.getString("articolo_img");
                    temp.mittente = rs.getString("acquirente");
                    temp.descrizione = "L'utente " + temp.mittente + " ha acquistato " + rs.getString("articolo");
                    temp.oggetto = "Quantità: " + rs.getString("quantità");
                    temp.data = rs.getString("data_acquisto");
                    temp.id_articolo = rs.getInt("id_articolo");
                    temp.id_ordine = rs.getInt("id_ordine");

                    list.add(temp);
                }
            }
        }

        Comparator<Notifica> dataComp = (Notifica o1, Notifica o2) -> o2.data.compareTo(o1.data);
        Collections.sort(list, dataComp);

        return list;
    }

    public static void clearAllNotifiche() {
        String sql = "UPDATE segnalazione SET lettura = 1";
        try (PreparedStatement stm = CON.prepareStatement(sql)) {
            stm.executeUpdate();
            stm.close();
        } catch (SQLException e) {
            System.out.print("Errore");
        }

        sql = "UPDATE acquisto SET lettura = 1";
        try (PreparedStatement stm = CON.prepareStatement(sql)) {
            stm.executeUpdate();
            stm.close();
        } catch (SQLException e) {
            System.out.print("Errore");
        }
    }

    public static void clearNotifica(String id, String id_ordine, String id_articolo) {

        if (!id.equals("null")) {
            String sql = "UPDATE segnalazione SET lettura = 1 WHERE id_messaggio = ?";
            try (PreparedStatement stm = CON.prepareStatement(sql)) {
                stm.setString(1, id);
                stm.executeUpdate();
                stm.close();
            } catch (SQLException e) {
                System.out.print("Errore");
            }
        } else {
            String sql = "UPDATE acquisto SET lettura = 1 WHERE id_ordine = ? AND id_articolo = ?";
            try (PreparedStatement stm = CON.prepareStatement(sql)) {
                stm.setString(1, id_ordine);
                stm.setString(2, id_articolo);
                stm.executeUpdate();
                stm.close();
            } catch (SQLException e) {
                System.out.print("Errore");
            }
        }
    }

    public static List<Notifica> getAdminNotifiche(Integer limit, Integer lette) throws SQLException {
        List<Notifica> list = new ArrayList();

        String sql = "SELECT * FROM segnalazione, negozio, utente WHERE negozio.venditore = segnalazione.id_destinatario AND utente.email = segnalazione.id_mittente AND lettura = ? ORDER BY data";

        if (limit != 0) {
            sql = " LIMIT " + limit;
        }

        try (PreparedStatement stm = CON.prepareStatement(sql)) {
            stm.setInt(1, lette);
            try (ResultSet rs = stm.executeQuery()) {
                Notifica temp = null;
                while (rs.next()) {
                    temp = new Notifica();
                    temp.foto = rs.getString("avatar");
                    temp.mittente = rs.getString("id_mittente");
                    temp.descrizione = "L'utente " + temp.mittente + " ha eseguito un segnalazione";
                    temp.oggetto = "Oggetto: " + rs.getString("oggetto");
                    temp.data = rs.getString("data");
                    temp.id = rs.getInt("id_messaggio");

                    list.add(temp);
                }
            }
        }

        return list;
    }

}
