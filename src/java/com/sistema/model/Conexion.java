package com.sistema.model;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class Conexion {
    
private static final String URL = "jdbc:postgresql://ep-wispy-dust-atu63gyi.c-9.us-east-1.aws.neon.tech/neondb?sslmode=require";
private static final String USUARIO = "neondb_owner";
private static final String CLAVE = "npg_zb8ZCsKOj1rR";

    public static Connection obtenerConexion() {
        Connection con = null;
        try {
            Class.forName("org.postgresql.Driver");
            con = DriverManager.getConnection(URL, USUARIO, CLAVE);
            System.out.println("¡Conexión exitosa a la base de datos de Neon!");
        } catch (ClassNotFoundException e) {
            System.out.println("Error: No se encontró el driver de PostgreSQL: " + e.getMessage());
        } catch (SQLException e) {
            System.out.println("Error al conectar a la base de datos: " + e.getMessage());
        }
        return con;
    }
}