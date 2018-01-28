/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package it.unitn.webprogramming2017.progetto;

import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

import org.apache.lucene.analysis.standard.*;
import org.apache.lucene.document.Document;
import org.apache.lucene.document.Field;
import org.apache.lucene.document.StringField;
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

public class Lucene {

    public static void main(String[] args) throws IOException, ParseException, SQLException {
        //New index
        StandardAnalyzer standardAnalyzer = new StandardAnalyzer();
        Directory directory = new RAMDirectory();
        IndexWriterConfig config = new IndexWriterConfig(standardAnalyzer);
        //Create a writer
        IndexWriter writer = new IndexWriter(directory, config);
        try {
            Class.forName("com.mysql.jdbc.Driver");
        } catch (ClassNotFoundException cnfe) {
            throw new RuntimeException(cnfe.getMessage(), cnfe.getCause());
        }

        Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/storedb?zeroDateTimeBehavior=convertToNull", "root", "");

        String sql = "select * from articolo";
        Statement stmt = con.createStatement();
        ResultSet rs = stmt.executeQuery(sql);
        
        while (rs.next()) {
            Document doc = new Document();
            doc.add(new TextField("nome", rs.getString("nome"), Field.Store.YES));
            writer.addDocument(doc);
        }

        writer.close();

        //Now let's try to search for Hello
        IndexReader reader = DirectoryReader.open(directory);
        IndexSearcher searcher = new IndexSearcher(reader);
        QueryParser parser = new QueryParser("nome", standardAnalyzer);
        Query query = parser.parse("and~1");
        TopDocs results = searcher.search(query, 5);
        ScoreDoc[] hits = results.scoreDocs;

        for (int i = 0; i < hits.length; ++i) {
            int docId = hits[i].doc;
            Document d = searcher.doc(docId);
            System.out.println((i + 1) + ". " + d.get("nome"));
        }

        //case insensitive search
        query = parser.parse("and");
        results = searcher.search(query, 5);
        System.out.println("Hits for hello -->" + results.totalHits);
    }
}
