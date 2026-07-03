<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8"> 
        <title>Intranet Escolar - Registro Académico</title>
        <style>
            body { 
                font-family: 'Segoe UI', Arial, sans-serif; 
                background: linear-gradient(135deg, #1e3c72 0%, #2a5298 100%); 
                display: flex; 
                justify-content: center; 
                align-items: center; 
                height: 100vh; 
                margin: 0; 
            }
            .login-container {
                background: white; 
                padding: 40px; 
                border-radius: 15px; 
                box-shadow: 0 10px 25px rgba(0,0,0,0.2); 
                width: 340px; 
                text-align: center; 
            }
            .logo-placeholder {
                font-size: 50px;
                margin-bottom: 10px;
            }
            h2 { color: #1a365d; margin: 0 0 5px 0; font-size: 24px; }
            .subtitle { color: #718096; font-size: 14px; margin-bottom: 25px; }
            .campo { margin-bottom: 20px; text-align: left; }
            label { display: block; color: #4a5568; margin-bottom: 6px; font-size: 13px; font-weight: bold; }
            input[type="text"], input[type="password"] { width: 100%; padding: 12px; border: 2px solid #e2e8f0; border-radius: 8px; box-sizing: border-box; font-size: 14px; }
            input[type="submit"] { width: 100%; background: #2b6cb0; color: white; border: none; padding: 12px; border-radius: 8px; font-size: 16px; cursor: pointer; font-weight: bold; margin-top: 10px; }
            input[type="submit"]:hover { background: #1a365d; }
            .error { color: #c53030; margin-top: 15px; font-size: 13px; background: #fff5f5; padding: 10px; border-radius: 8px; border-left: 4px solid #f56565; text-align: left; }
        </style>
    </head>
    <body>
        <div class="login-container">
            <div class="logo-placeholder">🎓</div>
            <h2>Registro Académico</h2>
            <div class="subtitle">Sistema Integral de Gestión de Estudiantes</div>
            
            <form action="LoginServlet" method="POST">
                <div class="campo">
                    <label>Usuario / Correo Institucional</label>
                    <input type="text" name="txtUsuario" required placeholder="admin@colegio.edu.pe">
                </div>
                <div class="campo">
                    <label>Contraseña de Acceso</label>
                    <input type="password" name="txtClave" required placeholder="••••••••">
                </div>
                <input type="submit" value="Ingresar al Sistema">
            </form>

            <% if (request.getAttribute("error") != null) { %>
                <div class="error">
                    ⚠️ <b>Error:</b> <%= request.getAttribute("error") %>
                </div>
            <% } %>
        </div>
    </body>
</html>