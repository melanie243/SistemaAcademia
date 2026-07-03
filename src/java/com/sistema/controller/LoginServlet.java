package com.sistema.controller;

import com.sistema.model.Conexion;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet(name = "LoginServlet", urlPatterns = {"/LoginServlet"})
public class LoginServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String correo = request.getParameter("txtUsuario");
        String clave = request.getParameter("txtClave");
        
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        
        try {
            try {
                Class.forName("org.postgresql.Driver");
            } catch (ClassNotFoundException e) {
                System.out.println("Driver ausente: " + e.getMessage());
            }

            con = Conexion.obtenerConexion();
            
            if (con == null) {
                request.setAttribute("error", "La conexión con Neon falló (con es null). Revisa tu archivo Conexion.java.");
                request.getRequestDispatcher("index.jsp").forward(request, response);
                return;
            }
            
            String sql = "SELECT * FROM usuarios WHERE usuario = ? AND clave = ?";
            ps = con.prepareStatement(sql);
            ps.setString(1, correo);
            ps.setString(2, clave);
            
            rs = ps.executeQuery();
            
            if (rs.next()) {
                HttpSession session = request.getSession();
                session.setAttribute("usuarioLogueado", rs.getString("nombre"));
                session.setAttribute("rolUsuario", rs.getString("rol"));
                response.sendRedirect("principal.jsp");
            } else {
                request.setAttribute("error", "El correo o la contraseña son incorrectos.");
                request.getRequestDispatcher("index.jsp").forward(request, response);
            }
            
        } catch (SQLException e) {
            request.setAttribute("error", "Error de base de datos: " + e.getMessage());
            request.getRequestDispatcher("index.jsp").forward(request, response);
        } finally {
            try { if (rs != null) rs.close(); } catch (Exception e) {}
            try { if (ps != null) ps.close(); } catch (Exception e) {}
            try { if (con != null) con.close(); } catch (Exception e) {}
        }
    }
}