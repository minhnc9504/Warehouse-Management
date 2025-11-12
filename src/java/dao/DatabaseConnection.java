/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;


import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DatabaseConnection {
    // Đọc từ environment variables, fallback về giá trị mặc định nếu không có
    private static final String URL = System.getenv("DATABASE_URL") != null 
            ? System.getenv("DATABASE_URL")
            : (System.getenv("PGHOST") != null 
                ? String.format("jdbc:postgresql://%s:%s/%s",
                    System.getenv("PGHOST"),
                    System.getenv("PGPORT") != null ? System.getenv("PGPORT") : "5432",
                    System.getenv("PGDATABASE") != null ? System.getenv("PGDATABASE") : "postgres")
                : "jdbc:postgresql://aws-1-ap-southeast-1.pooler.supabase.com:5432/postgres");
    
    private static final String USER = System.getenv("PGUSER") != null 
            ? System.getenv("PGUSER")
            : "postgres.bnswukmvtvqwgddxxgll";
    
    private static final String PASSWORD = System.getenv("PGPASSWORD") != null 
            ? System.getenv("PGPASSWORD")
            : "minhnc9504";

    public static Connection getConnection() throws SQLException {
        try {
            Class.forName("org.postgresql.Driver");
            // Nếu DATABASE_URL đã có format đầy đủ, parse nó
            String connectionUrl = URL;
            if (URL.startsWith("postgresql://") || URL.startsWith("postgres://")) {
                // Parse DATABASE_URL format: postgresql://user:password@host:port/database
                connectionUrl = URL.replaceFirst("^postgresql://", "jdbc:postgresql://")
                                  .replaceFirst("^postgres://", "jdbc:postgresql://");
            } else if (!URL.startsWith("jdbc:")) {
                connectionUrl = "jdbc:" + URL;
            }
            return DriverManager.getConnection(connectionUrl, USER, PASSWORD);
        } catch (ClassNotFoundException e) {
            throw new SQLException("PostgreSQL JDBC Driver not found!", e);
        }
    }

    public static void main(String[] args) {
        try (Connection conn = getConnection()) {
            if (conn != null) {
                System.out.println("✅ Connected to Supabase PostgreSQL successfully!");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}
