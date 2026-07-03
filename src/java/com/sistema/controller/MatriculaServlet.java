package com.sistema.controller;

import com.sistema.model.Conexion;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet(name = "MatriculaServlet", urlPatterns = {"/MatriculaServlet"})
public class MatriculaServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // 1. Capturamos los datos que viajan desde el formulario matricula.jsp
        String dni = request.getParameter("txtDni");
        String nombre = request.getParameter("txtNombre");
        String grado = request.getParameter("txtGrado");
        String seccion = request.getParameter("txtSeccion");
        
        Connection con = null;
        PreparedStatement ps = null;
        
        try {
            // Aseguramos el driver de PostgreSQL activo
            try {
                Class.forName("org.postgresql.Driver");
            } catch (ClassNotFoundException e) {
                System.out.println("Driver ausente en Matrícula: " + e.getMessage());
            }

            // 2. Conectamos usando tu archivo Conexion.java
            con = Conexion.obtenerConexion();
            
            if (con == null) {
                request.setAttribute("error", "Error de conexión con la base de datos.");
                request.getRequestDispatcher("matricula.jsp").forward(request, response);
                return;
            }
            
            // 3. Preparamos la consulta SQL para insertar en la tabla de Neon
            String sql = "INSERT INTO alumnos (dni, nombre, grado, seccion) VALUES (?, ?, ?, ?)";
            ps = con.prepareStatement(sql);
            
            ps.setString(1, dni);
            ps.setString(2, nombre);
            ps.setString(3, grado);
            ps.setString(4, seccion);
            
            // 4. Ejecutamos la inserción
            int filasInsertadas = ps.executeUpdate();
            
            if (filasInsertadas > 0) {
                // Si todo sale bien, mandamos mensaje de éxito
                request.setAttribute("exito", "¡Estudiante matriculado correctamente en el sistema!");
            } else {
                request.setAttribute("error", "No se pudo registrar la matrícula. Inténtalo de nuevo.");
            }
            
        } catch (SQLException e) {
            // Manejo de errores por si meten un DNI duplicado
            if (e.getMessage().contains("duplicate key")) {
                request.setAttribute("error", "Error: Ya existe un alumno registrado con ese número de DNI.");
            } else {
                request.setAttribute("error", "Error en la base de datos: " + e.getMessage());
            }
        } finally {
            // Cerramos los canales de conexión de forma limpia
            try { if (ps != null) ps.close(); } catch (Exception e) {}
            try { if (con != null) con.close(); } catch (Exception e) {}
        }
        
        // Retornamos a la página de matrícula para que muestre el mensaje verde o rojo
        request.getRequestDispatcher("matricula.jsp").forward(request, response);
    }
}