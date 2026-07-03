<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="jakarta.servlet.http.HttpSession" %>
<%@page import="java.sql.*" %>
<%@page import="com.sistema.model.Conexion" %>
<%
    // Seguridad: Si no está logueado, al login
    HttpSession sesion = request.getSession(false);
    if(sesion == null || sesion.getAttribute("usuarioLogueado") == null) {
        response.sendRedirect("index.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Reportes Académicos</title>
    <style>
        body { font-family: 'Segoe UI', Arial, sans-serif; background: #f0f4f8; margin: 0; display: flex; }
        .sidebar { width: 250px; background: #1a365d; color: white; height: 100vh; padding: 20px; box-sizing: border-box; position: fixed; }
        .sidebar h2 { font-size: 16px; text-transform: uppercase; border-bottom: 2px solid #2b6cb0; padding-bottom: 10px; margin-bottom: 20px; }
        .sidebar a { display: block; color: #cbd5e0; padding: 12px; text-decoration: none; border-radius: 5px; margin-bottom: 5px; font-size: 14px; }
        .sidebar a:hover { background: #2b6cb0; color: white; }
        .contenido { margin-left: 250px; flex: 1; padding: 30px; }
        .report-container { background: white; padding: 30px; border-radius: 8px; box-shadow: 0 2px 5px rgba(0,0,0,0.05); }
        .report-container h2 { margin-top: 0; color: #1a365d; border-bottom: 2px solid #f0f4f8; padding-bottom: 10px; }
        
        /* Estilos de la Tabla */
        table { width: 100%; border-collapse: collapse; margin-top: 20px; font-size: 14px; }
        th, td { padding: 12px 15px; text-align: left; border-bottom: 1px solid #e2e8f0; }
        th { background-color: #1a365d; color: white; font-weight: bold; }
        tr:hover { background-color: #f7fafc; }
        
        /* Notas en rojo o azul */
        .nota-aprobada { color: #2b6cb0; font-weight: bold; }
        .nota-desaprobada { color: #e53e3e; font-weight: bold; }
        .sin-nota { color: #a0aec0; font-style: italic; }
    </style>
</head>
<body>

    <!-- MENÚ LATERAL IZQUIERDO -->
    <div class="sidebar">
        <h2>Intranet Colegio</h2>
        <a href="principal.jsp">🏠 Inicio / Dashboard</a>
        <a href="matricula.jsp">📝 Control de Matrícula</a>
        <a href="notas.jsp">📚 Registro de Notas</a>
        <a href="reportes.jsp" style="background: #2b6cb0; color: white;">📋 Reportes Académicos</a>
        <a href="index.jsp">🚪 Cerrar Sesión</a>
    </div>

    <!-- CONTENIDO PRINCIPAL -->
    <div class="contenido">
        <div class="report-container">
            <h2>Consolidado General de Alumnos y Calificaciones</h2>
            <p style="color: #4a5568; font-size: 14px;">Lista oficial de estudiantes matriculados en el sistema y sus respectivas notas vigesimales.</p>
            
            <table>
                <thead>
                    <tr>
                        <th>DNI</th>
                        <th>Nombre del Estudiante</th>
                        <th>Grado</th>
                        <th>Sección</th>
                        <th>Curso</th>
                        <th>Calificación</th>
                    </tr>
                </thead>
                <tbody>
                    <%
                        Connection con = null;
                        PreparedStatement ps = null;
                        ResultSet rs = null;
                        
                        try {
                            Class.forName("org.postgresql.Driver");
                            con = Conexion.obtenerConexion();
                            
                            // Esta consulta une la tabla alumnos con la tabla notas de forma inteligente
                            String sql = "SELECT a.dni, a.nombre, a.grado, a.seccion, n.curso, n.nota " +
                                         "FROM alumnos a " +
                                         "LEFT JOIN notas n ON a.dni = n.alumno_dni " +
                                         "ORDER BY a.nombre ASC, n.curso ASC";
                            
                            ps = con.prepareStatement(sql);
                            rs = ps.executeQuery();
                            
                            boolean tieneDatos = false;
                            while(rs.next()) {
                                tieneDatos = true;
                                String dni = rs.getString("dni");
                                String nombre = rs.getString("nombre");
                                String grado = rs.getString("grado");
                                String seccion = rs.getString("seccion");
                                String curso = rs.getString("curso") != null ? rs.getString("curso") : "Sin curso asignado";
                                int notaVal = rs.getInt("nota");
                                boolean esNullNota = rs.wasNull(); // Verifica si de verdad no tiene nota
                    %>
                                <tr>
                                    <td><%= dni %></td>
                                    <td><b><%= nombre %></b></td>
                                    <td><%= grado %></td>
                                    <td>Sección <%= seccion %></td>
                                    <td><%= curso %></td>
                                    <td>
                                        <% if(esNullNota) { %>
                                            <span class="sin-nota">- -</span>
                                        <% } else if(notaVal >= 11) { %>
                                            <span class="nota-aprobada"><%= String.format("%02d", notaVal) %></span>
                                        <% } else { %>
                                            <span class="nota-desaprobada"><%= String.format("%02d", notaVal) %></span>
                                        <% } %>
                                    </td>
                                </tr>
                    <%
                            }
                            if(!tieneDatos) {
                    %>
                                <tr>
                                    <td colspan="6" style="text-align: center; color: #a0aec0; padding: 30px;">
                                        No hay alumnos registrados en el sistema actualmente.
                                    </td>
                                </tr>
                    <%
                            }
                        } catch(Exception e) {
                    %>
                            <tr>
                                <td colspan="6" style="color: #e53e3e; text-align: center;">
                                    Error al cargar reporte: <%= e.getMessage() %>
                                </td>
                            </tr>
                    <%
                        } finally {
                            try { if(rs != null) rs.close(); } catch(Exception e){}
                            try { if(ps != null) ps.close(); } catch(Exception e){}
                            try { if(con != null) con.close(); } catch(Exception e){}
                        }
                    %>
                </tbody>
            </table>
        </div>
    </div>

</body>
</html>