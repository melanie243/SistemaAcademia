<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="jakarta.servlet.http.HttpSession" %>
<%
    // Seguridad: Si no ha iniciado sesión, al login
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
    <title>Control de Matrícula</title>
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
        .campo input[type="text"], .campo select { width: 100%; padding: 10px; border: 1px solid #cbd5e0; border-radius: 4px; box-sizing: border-box; }
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
        <a href="matricula.jsp" style="background: #2b6cb0; color: white;">📝 Control de Matrícula</a>
        <a href="#">📚 Registro de Notas</a>
        <a href="reportes.jsp">📋 Reportes Académicos</a>
        <a href="index.jsp">🚪 Cerrar Sesión</a>
    </div>

    <!-- CONTENIDO PRINCIPAL -->
    <div class="contenido">
        <div class="form-container">
            <h2>Ficha de Matrícula Escolar</h2>
            
            <!-- Mensajes de respuesta de Java -->
            <% if(request.getAttribute("exito") != null) { %>
                <div class="msg-exito"><%= request.getAttribute("exito") %></div>
            <% } %>
            <% if(request.getAttribute("error") != null) { %>
                <div class="msg-error"><%= request.getAttribute("error") %></div>
            <% } %>

            <form action="MatriculaServlet" method="POST">
                <div class="campo">
                    <label>DNI del Estudiante:</label>
                    <input type="text" name="txtDni" maxlength="8" required placeholder="Ingrese 8 dígitos">
                </div>
                <div class="campo">
                    <label>Nombre Completo del Alumno:</label>
                    <input type="text" name="txtNombre" required placeholder="Ej. Juan Carlos Flores">
                </div>
                <div class="campo">
                    <label>Grado Académico:</label>
                    <select name="txtGrado">
                        <option value="1ro de Secundaria">1ro de Secundaria</option>
                        <option value="2do de Secundaria">2do de Secundaria</option>
                        <option value="3ro de Secundaria">3ro de Secundaria</option>
                        <option value="4to de Secundaria">4to de Secundaria</option>
                        <option value="5to de Secundaria">5to de Secundaria</option>
                    </select>
                </div>
                <div class="campo">
                    <label>Sección:</label>
                    <select name="txtSeccion">
                        <option value="A">Sección A</option>
                        <option value="B">Sección B</option>
                        <option value="C">Sección C</option>
                    </select>
                </div>
                <button type="submit" class="btn-registrar">Confirmar e Inscribir Alumno</button>
            </form>
        </div>
    </div>

</body>
</html>