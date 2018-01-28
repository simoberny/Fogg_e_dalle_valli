/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package it.unitn.webprogramming2017.progetto;

import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Logger;
import com.lambdaworks.crypto.*;

/**
 *
 * @author simoberny
 */
public class DBManager {

    public static transient Connection CON;
    private final static String dbpath = "jdbc:mysql://localhost:3306/storedb?characterEncoding=utf8";

    public DBManager() throws SQLException {
        try {
            Class.forName("com.mysql.jdbc.Driver", true, getClass().getClassLoader());
        } catch (ClassNotFoundException cnfe) {
            throw new RuntimeException(cnfe.getMessage(), cnfe.getCause());
        }

        CON = null;

        try {
            CON = DriverManager.getConnection(dbpath, "root", "");
            System.out.println("Connesso!");
        } catch (Exception e) {
            System.out.println("Non è possibile connettersi al database!");
        }
    }

    public static void shutdown() {
        try {
            DriverManager.getConnection(dbpath + ";shutdown=true");
        } catch (SQLException sqle) {
            Logger.getLogger(DBManager.class.getName()).info(sqle.getMessage());
        }
    }

    public PreparedStatement query(String sql) throws SQLException {
        try (PreparedStatement stm = CON.prepareStatement(sql)) {
            return stm;
        } catch (Exception e) {
            return null;
        }
    }

    public Boolean registerUser(User user) throws SQLException {
        try (PreparedStatement stm = CON.prepareStatement("INSERT INTO utente (nome, cognome, email, password, avatar, data_registrazione, tipo_utente) VALUES ( ? , ? , ? , ? , ?, NOW(), ?)")) {
            stm.setString(1, user.getFirstName());
            stm.setString(2, user.getLastName());
            stm.setString(3, user.getEmail());
            stm.setString(4, user.getPassword());
            stm.setString(5, user.getAvatar());
            stm.setInt(6, user.getTipo());

            stm.executeUpdate();
        } catch (SQLException e) {
            System.out.println(e.getMessage());
            return false;
        }

        return true;
    }

    public User loginUser(String email, String plain_password) throws SQLException {
        try (PreparedStatement stm = CON.prepareStatement("SELECT * FROM utente WHERE email = ?")) {
            stm.setString(1, email); //Setta la stringa "email" sul primo punto di domanda
            try (ResultSet rs = stm.executeQuery()) {
                User user = null;
                rs.next();

                if (SCryptUtil.check(plain_password, rs.getString("password"))) {
                    user = new User();
                    user.setFirstName(rs.getString("nome"));
                    user.setLastName(rs.getString("cognome"));
                    user.setEmail(rs.getString("email"));
                    user.setPassword(rs.getString("password"));
                    user.setAvatar(rs.getString("avatar"));
                    user.setTipo(rs.getInt("tipo_utente"));
                    user.setData(rs.getDate("data_registrazione"));
                    if (rs.getDate("data_conferma_registrazione") != null) {
                        user.setAttivazione(true);
                    } else {
                        user.setAttivazione(false);
                    }
                } else {
                    System.out.println("Password errata per utente " + rs.getString("email"));
                }

                return user;
            } catch (Exception e) {
                return null;
            }
        }
    }

    public List<User> getUsers() throws SQLException {
        List<User> users = new ArrayList<>();

        try (PreparedStatement stm = CON.prepareStatement("SELECT * FROM utente")) {
            try (ResultSet rs = stm.executeQuery()) {

                while (rs.next()) {
                    User user = new User();
                    user.setEmail(rs.getString("email"));
                    user.setPassword(rs.getString("password"));
                    user.setFirstName(rs.getString("nome"));
                    user.setLastName(rs.getString("cognome"));
                    user.setTipo(rs.getInt("tipo_utente"));
                    user.setData(rs.getDate("data_registrazione"));

                    users.add(user);
                }
            }
        }

        return users;
    }

    public User getUser(String idUser) throws SQLException {
        if (idUser == null) {
            throw new SQLException("idUser is null");
        }
        try (PreparedStatement stm = CON.prepareStatement("SELECT * FROM utente WHERE email = ?")) {
            stm.setString(1, idUser);
            try (ResultSet rs = stm.executeQuery()) {

                rs.next();
                User user = new User();
                user.setEmail(rs.getString("email"));
                user.setPassword(rs.getString("password"));
                user.setFirstName(rs.getString("nome"));
                user.setLastName(rs.getString("cognome"));
                user.setAvatar(rs.getString("avatar"));
                user.setTipo(rs.getInt("tipo_utente"));
                user.setData(rs.getDate("data_registrazione"));

                return user;
            }
        }
    }

}
