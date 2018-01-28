/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package it.unitn.webprogramming2017.progetto;

import static it.unitn.webprogramming2017.progetto.DBManager.CON;
import java.io.IOException;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;
import javax.servlet.http.HttpServletRequest;
import org.apache.lucene.analysis.standard.StandardAnalyzer;
import org.apache.lucene.document.Document;
import org.apache.lucene.document.Field;
import org.apache.lucene.document.TextField;
import org.apache.lucene.index.DirectoryReader;
import org.apache.lucene.index.IndexReader;
import org.apache.lucene.index.IndexWriter;
import org.apache.lucene.index.IndexWriterConfig;
import org.apache.lucene.queryparser.classic.ParseException;
import org.apache.lucene.queryparser.classic.QueryParser;
import org.apache.lucene.search.IndexSearcher;
import org.apache.lucene.search.Query;
import org.apache.lucene.search.ScoreDoc;
import org.apache.lucene.search.TopDocs;
import org.apache.lucene.store.Directory;
import org.apache.lucene.store.RAMDirectory;

/**
 *
 * @author don
 */
public class Item {

    public int id_articolo;
    public String nome;
    public String descrizione;
    public String foto;
    public double prezzo;
    public double media_recensioni;
    public int n_recensioni;
    public String negozio;
    public String data_inserimento;
    public String categoria_1;
    public String categoria_2;
    public String categoria_3;

    public static Item getById(int id) throws SQLException {
        String sql = "SELECT * FROM articolo WHERE id_articolo=" + id;
        PreparedStatement stm = DBManager.CON.prepareStatement(sql);

        Item back = null;

        try (ResultSet rs = stm.executeQuery()) {
            if (rs.next()) {
                back = new Item();
                back.id_articolo = rs.getInt("id_articolo");
                back.nome = rs.getString("nome");
                back.descrizione = rs.getString("descrizione");
                back.foto = rs.getString("foto");
                back.prezzo = rs.getDouble("prezzo");
                back.media_recensioni = rs.getDouble("media_recensioni");
                back.n_recensioni = rs.getInt("n_recensioni");
                back.negozio = rs.getString("negozio");
                back.data_inserimento = rs.getString("data_inserimento");
                back.categoria_1 = rs.getString("categoria_1");
                back.categoria_2 = rs.getString("categoria_2");
                back.categoria_3 = rs.getString("categoria_3");
            }
        }
        return back;
    }

    public static List<Item> cerca(String txt, Double min, Double max, String categoria, Integer voto, String venditore, String ordinamento, int npag) throws SQLException, IOException, ParseException {

        List<Item> l = new ArrayList();

        StandardAnalyzer standardAnalyzer = new StandardAnalyzer();
        Directory directory = new RAMDirectory();
        IndexWriterConfig config = new IndexWriterConfig(standardAnalyzer);
        IndexWriter writer = new IndexWriter(directory, config);

        String sql = "SELECT * FROM articolo WHERE prezzo BETWEEN " + min + " AND " + max + " ";
        if (categoria != null && !categoria.equals("tutte")) {
            sql += " and categoria_1 = \"" + categoria + "\"";
        }

        if (voto != null) {
            sql += " and media_recensioni >= " + voto + "";
        }

        if (venditore != null) {
            sql += " and negozio = \"" + venditore + "\"";
        }

        if (ordinamento != null) {
            switch (ordinamento) {
                case "prezzo_cre":
                    sql += " ORDER BY prezzo DESC";
                    break;
                case "prezzo_dec":
                    sql += " ORDER BY prezzo ASC";
                    break;
                case "recensioni":
                    sql += " ORDER BY media_recensioni DESC";
                    break;
            }

        }

        if (npag > 0) {
            sql += " limit " + 20*(npag-1) + "," + 20;
        }



        Statement stmt = DBManager.CON.createStatement();
        ResultSet rs = stmt.executeQuery(sql);

        if (txt != null && txt != "") {

            while (rs.next()) {
                Document doc = new Document();
                doc.add(new TextField("nome", rs.getString("nome"), Field.Store.YES));
                doc.add(new TextField("id_articolo", rs.getString("id_articolo"), Field.Store.YES));
                doc.add(new TextField("descrizione", rs.getString("descrizione"), Field.Store.YES));
                doc.add(new TextField("foto", rs.getString("foto"), Field.Store.YES));
                doc.add(new TextField("prezzo", rs.getString("prezzo"), Field.Store.YES));
                doc.add(new TextField("media_recensioni", rs.getString("media_recensioni"), Field.Store.YES));
                doc.add(new TextField("n_recensioni", rs.getString("n_recensioni"), Field.Store.YES));
                doc.add(new TextField("negozio", rs.getString("negozio"), Field.Store.YES));
                doc.add(new TextField("data_inserimento", rs.getString("data_inserimento"), Field.Store.YES));
                if (categoria != null) {
                    doc.add(new TextField("categoria_1", rs.getString("categoria_1"), Field.Store.YES));
                    doc.add(new TextField("categoria_2", rs.getString("categoria_2"), Field.Store.YES));
                    doc.add(new TextField("categoria_3", rs.getString("categoria_3"), Field.Store.YES));
                }
                writer.addDocument(doc);
            }

            writer.close();

            IndexReader reader = DirectoryReader.open(directory);
            IndexSearcher searcher = new IndexSearcher(reader);
            QueryParser parser = new QueryParser("nome", standardAnalyzer);
            Query query = parser.parse(txt + "~1");
            TopDocs results = searcher.search(query, 10);
            ScoreDoc[] hits = results.scoreDocs;

            Item back;

            for (int i = 0; i < hits.length; ++i) {
                int docId = hits[i].doc;
                Document d = searcher.doc(docId);
                back = new Item();
                back.id_articolo = Integer.parseInt(d.get("id_articolo"));
                back.nome = d.get("nome");
                back.descrizione = d.get("descrizione");
                back.foto = d.get("foto");
                back.prezzo = Double.parseDouble(d.get("prezzo"));
                back.media_recensioni = Double.parseDouble(d.get("media_recensioni"));
                back.n_recensioni = Integer.parseInt(d.get("n_recensioni"));
                back.negozio = d.get("negozio");
                back.data_inserimento = d.get("data_inserimento");
                back.categoria_1 = d.get("categoria_1");
                back.categoria_2 = d.get("categoria_2");
                back.categoria_3 = d.get("categoria_3");
                l.add(back);
            }

        } else {
            Item back;
            while (rs.next()) {
                back = new Item();
                back.id_articolo = Integer.parseInt(rs.getString("id_articolo"));
                back.nome = rs.getString("nome");
                back.descrizione = rs.getString("descrizione");
                back.foto = rs.getString("foto");
                back.prezzo = Double.parseDouble(rs.getString("prezzo"));
                back.media_recensioni = Double.parseDouble(rs.getString("media_recensioni"));
                back.n_recensioni = Integer.parseInt(rs.getString("n_recensioni"));
                back.negozio = rs.getString("negozio");
                back.data_inserimento = rs.getString("data_inserimento");
                back.categoria_1 = rs.getString("categoria_1");
                back.categoria_2 = rs.getString("categoria_2");
                back.categoria_3 = rs.getString("categoria_3");
                l.add(back);
            }
        }
        return l;
    }

    public static Boolean delete_prodotto(String id_prodotto) {

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
}
