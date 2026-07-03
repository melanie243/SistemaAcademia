<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="jakarta.servlet.http.HttpSession" %>
<%
    // Seguridad
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
    <title>Registro de Notas</title>
    <style>
        body { font-family: 'Segoe UI', Arial, sans-serif; background: #f0f4f8; margin: 0; display: flex; }
        .sidebar { width: 250px; background: #1a365d; color: white; height: 100vh; padding: 20px; box-sizing: border-box; }
        .sidebar h2 { font-size: 16px; text-transform: uppercase; border-bottom: 2px solid #2b6cb0; padding-bottom: 10px; margin-bottom: 20px; }
        .sidebar a { display: block; color: #cbd5e0; padding: 12px; text-decoration: none; border-radius: 5px; margin-bottom: 5px; font-size: 14px; }
        .sidebar a:hover { background: #2b6cb0; color: white; }
        .contenido { flex: 1; padding: 30px; }
        .form-container { background: white; padding: 30px; border-radius: 8px; box-shadow: 0 2px 5px rgba(0,0,0,0.05); max-width: 500px; }
        .form-container h2 { margin-top: 0; color: #1a365d; border-bottom: 2px solid #f0f4f8; padding-bottom: 10px; }
        .campo { margin-bottom: 15px; }
        .campo label { display: block; margin-bottom: 5px; color: #4a5568; font-weight: bold; font-size: 14px; }
        .campo input[type="text"], .campo input[type="number"], .campo select { width: 100%; padding: 10px; border: 1px solid #cbd5e0; border-radius: 4px; box-sizing: border-box; }
        .btn-registrar { background: #2b6cb0; color: white; border: none; padding: 12px 20px; border-radius: 4px; font-weight: bold; cursor: pointer; width: 100%; font-size: 14px; }
        .btn-registrar:hover { background: #1a365d; }
        .msg-exito { background: #c6f6d5; color: #22543d; padding: 10px; border-radius: 4px; margin-bottom: 15px; font-size: 14px; }
        .msg-error { background: #fed7d7; color: #742a2a; padding: 10px; border-radius: 4px; margin-bottom: 15px; font-size: 14px; }
    </style>
</head>
<body>

    <!-- MENÚ LATERAL IZQUIERDO -->
    <div class="sidebar">
        <h2>Intranet Colegio</h2>
        <a href="principal.jsp">🏠 Inicio / Dashboard</a>
        <a href="matricula.jsp">📝 Control de Matrícula</a>
        <a href="notas.jsp" style="background: #2b6cb0; color: white;">📚 Registro de Notas</a>
        <a href="reportes.jsp">📋 Reportes Académicos</a>
        <a href="index.jsp">🚪 Cerrar Sesión</a>
    </div>

    <!-- CONTENIDO PRINCIPAL -->
    <div class="contenido">
        <div class="form-container">
            <h2>Registro Vigesimal de Calificaciones</h2>
            
            <% if(request.getAttribute("exito") != null) { %>
                <div class="msg-exito"><%= request.getAttribute("exito") %></div>
            <% } %>
            <% if(request.getAttribute("error") != null) { %>
                <div class="msg-error"><%= request.getAttribute("error") %></div>
            <% } %>

            <form action="NotasServlet" method="POST">
                <div class="campo">
                    <label>DNI del Estudiante:</label>
                    <input type="text" name="txtDni" maxlength="8" required placeholder="DNI del alumno ya matriculado">
                </div>
                <div class="campo">
                    <label>Asignatura / Curso:</label>
                    <select name="txtCurso">
                        <option value="Matemáticas">Matemáticas</option>
                        <option value="Comunicación">Comunicación</option>
                        <option value="Ciencia y Tecnología">Ciencia y Tecnología</option>
                        <option value="Historia">Historia</option>
                    </select>
                </div>
                <div class="campo">
                    <label>Nota (Escala Vigesimal: 00 - 20):</label>
                    <input type="number" name="txtNota" min="0" max="20" required placeholder="Ej. 18">
                </div>
                <button type="submit" class="btn-registrar">Registrar Calificación</button>
            </form>
        </div>
    </div>

</body>
</html>