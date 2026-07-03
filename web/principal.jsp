<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="jakarta.servlet.http.HttpSession" %>
<%
    // CONTROL DE SEGURIDAD: Si alguien intenta entrar escribiendo la URL sin loguearse, lo botamos al login
    HttpSession sesion = request.getSession(false);
    if(sesion == null || sesion.getAttribute("usuarioLogueado") == null) {
        response.sendRedirect("index.jsp");
        return;
    }
    String usuario = (String) sesion.getAttribute("usuarioLogueado");
    
    // CORRECCIÓN: Jalamos "rolUsuario" que es como lo guardamos en el LoginServlet
    String rol = (String) sesion.getAttribute("rolUsuario");
    if (rol == null) {
        rol = "Admin"; // Si por alguna razón llega vacío, le ponemos un valor por defecto
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Panel de Gestión Académica</title>
    <style>
        body { font-family: 'Segoe UI', Arial, sans-serif; background: #f0f4f8; margin: 0; display: flex; }
        .sidebar { width: 250px; background: #1a365d; color: white; height: 100vh; padding: 20px; box-sizing: border-box; }
        .sidebar h2 { font-size: 16px; text-transform: uppercase; border-bottom: 2px solid #2b6cb0; padding-bottom: 10px; margin-bottom: 20px; }
        .sidebar a { display: block; color: #cbd5e0; padding: 12px; text-decoration: none; border-radius: 5px; margin-bottom: 5px; font-size: 14px; }
        .sidebar a:hover { background: #2b6cb0; color: white; }
        .contenido { flex: 1; padding: 30px; }
        .barra-superior { background: white; padding: 20px; border-radius: 8px; box-shadow: 0 2px 5px rgba(0,0,0,0.05); display: flex; justify-content: space-between; align-items: center; margin-bottom: 25px; }
        .barra-superior h1 { margin: 0; font-size: 20px; color: #2d3748; }
        .btn-cerrar { background: #e53e3e; color: white; padding: 8px 15px; border-radius: 5px; text-decoration: none; font-size: 13px; font-weight: bold; }
        .grid-modulos { display: grid; grid-template-columns: repeat(auto-fit, minmax(250px, 1fr)); gap: 20px; }
        .tarjeta { background: white; padding: 20px; border-radius: 8px; box-shadow: 0 2px 5px rgba(0,0,0,0.05); border-top: 4px solid #2b6cb0; }
        .tarjeta h3 { margin-top: 0; color: #2b6cb0; font-size: 16px; }
        .tarjeta p { color: #4a5568; font-size: 13px; line-height: 1.5; }
        .btn-accion { display: inline-block; background: #2b6cb0; color: white; padding: 8px 12px; border-radius: 4px; text-decoration: none; font-size: 12px; font-weight: bold; margin-top: 10px; }
    </style>
</head>
<body>

    <!-- MENÚ LATERAL IZQUIERDO -->
    <div class="sidebar">
        <h2>Intranet Colegio</h2>
        <a href="principal.jsp">🏠 Inicio / Dashboard</a>
        <a href="#">📝 Control de Matrícula</a>
        <a href="#">📚 Registro de Notas</a>
        <a href="reportes.jsp">📋 Reportes Académicos</a>
        <a href="#">⚙️ Configuración</a>
    </div>

    <!-- CONTENIDO PRINCIPAL -->
    <div class="contenido">
        <div class="barra-superior">
            <h1>Sistema Integral de Gestión Académica</h1>
            <div>
                <!-- Muestra el Nombre Real y el Rol de forma dinámica y limpia -->
                <span style="margin-right: 15px; font-size: 14px; color: #4a5568;">👤 <b><%= usuario %></b> (<%= rol %>)</span>
                <a href="index.jsp" class="btn-cerrar">Cerrar Sesión</a>
            </div>
        </div>

        <!-- SECCIÓN DE MÓDULOS DEL COLEGIO -->
        <div class="grid-modulos">
            <div class="tarjeta">
                <h3>Control de Matrícula</h3>
                <p>Módulo para la automatización de procesos de inscripción escolar y asignación de aulas a estudiantes.</p>
                <a href="matricula.jsp" class="btn-accion">Abrir Matrícula</a>
            </div>
            <div class="tarjeta">
                <h3>Registro Vigesimal de Notas</h3>
                <p>Ingreso de calificaciones por competencias académicas con mitigatorio de errores humanos en actas finales.</p>
                <a href="notas.jsp" class="btn-accion">Subir Calificaciones</a>
            </div>
            <div class="tarjeta">
                <h3>Eficiencia Operativa</h3>
                <p>Monitoreo del estado administrativo y reportes automáticos para reducir la carga de tiempo en secretaría.</p>
                <a href="reportes.jsp" class="btn-accion">Ver Reportes</a>
            </div>
        </div>
    </div>

</body>
</html>