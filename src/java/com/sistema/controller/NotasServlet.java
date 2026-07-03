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

@WebServlet(name = "NotasServlet", urlPatterns = {"/NotasServlet"})
public class NotasServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // 1. Capturamos los datos enviados desde notas.jsp
        String dni = request.getParameter("txtDni");
        String curso = request.getParameter("txtCurso");
        int nota = Integer.parseInt(request.getParameter("txtNota"));
        
        Connection con = null;
        PreparedStatement ps = null;
        
        try {
            // Aseguramos el driver de PostgreSQL activo
            try {
                Class.forName("org.postgresql.Driver");
            } catch (ClassNotFoundException e) {
                System.out.println("Driver ausente en Notas: " + e.getMessage());
            }

            // 2. Conectamos usando tu archivo Conexion.java
            con = Conexion.obtenerConexion();
            
            if (con == null) {
                request.setAttribute("error", "Error de conexión con la base de datos.");
                request.getRequestDispatcher("notas.jsp").forward(request, response);
                return;
            }
            
            // 3. Preparamos la consulta SQL para insertar en la tabla 'notas'
            String sql = "INSERT INTO notas (alumno_dni, curso, nota) VALUES (?, ?, ?)";
            ps = con.prepareStatement(sql);
            
            ps.setString(1, dni);
            ps.setString(2, curso);
            ps.setInt(3, nota);
            
            // 4. Ejecutamos la inserción
            int filasInsertadas = ps.executeUpdate();
            
            if (filasInsertadas > 0) {
                request.setAttribute("exito", "¡Calificación registrada con éxito!");
            } else {
                request.setAttribute("error", "No se pudo registrar la nota. Inténtalo de nuevo.");
            }
            
        } catch (SQLException e) {
            // Si el DNI no existe, saltará el error de la llave foránea (foreign key)
            if (e.getMessage().contains("violates foreign key constraint")) {
                request.setAttribute("error", "Error: El DNI ingresado no corresponde a ningún alumno matriculado.");
            } else {
                request.setAttribute("error", "Error en la base de datos: " + e.getMessage());
            }
        } finally {
            // Cerramos los canales limpios
            try { if (ps != null) ps.close(); } catch (Exception e) {}
            try { if (con != null) con.close(); } catch (Exception e) {}
        }
        
        // Redirigimos de vuelta a notas.jsp con la respuesta
        request.getRequestDispatcher("notas.jsp").forward(request, response);
    }
}