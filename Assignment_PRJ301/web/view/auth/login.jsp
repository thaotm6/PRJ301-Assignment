
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Đăng nhập - Hệ thống quản lý</title>
        <style>
            * {
                margin: 0;
                padding: 0;
                box-sizing: border-box;
            }
            body {
                font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
                background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                min-height: 100vh;
                display: flex;
                justify-content: center;
                align-items: center;
                padding: 20px;
            }
            .login-container {
                background: white;
                border-radius: 20px;
                padding: 50px 40px;
                box-shadow: 0 20px 60px rgba(0, 0, 0, 0.3);
                max-width: 450px;
                width: 100%;
            }
            .login-header {
                text-align: center;
                margin-bottom: 40px;
            }
            .login-header h1 {
                color: #333;
                font-size: 2em;
                margin-bottom: 10px;
                font-weight: 600;
            }
            .login-header p {
                color: #666;
                font-size: 0.95em;
            }
            .form-group {
                margin-bottom: 25px;
            }
            .form-group label {
                display: block;
                color: #333;
                font-weight: 500;
                margin-bottom: 8px;
                font-size: 0.95em;
            }
            .form-group input {
                width: 100%;
                padding: 12px 15px;
                border: 2px solid #e0e0e0;
                border-radius: 10px;
                font-size: 1em;
                transition: border-color 0.3s ease, box-shadow 0.3s ease;
                outline: none;
            }
            .form-group input:focus {
                border-color: #667eea;
                box-shadow: 0 0 0 3px rgba(102, 126, 234, 0.1);
            }
            .form-group input::placeholder {
                color: #999;
            }
            .login-button {
                width: 100%;
                background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                color: white;
                border: none;
                padding: 15px;
                border-radius: 10px;
                font-size: 1.1em;
                font-weight: 600;
                cursor: pointer;
                transition: transform 0.3s ease, box-shadow 0.3s ease;
                box-shadow: 0 4px 15px rgba(102, 126, 234, 0.4);
                margin-top: 10px;
            }
            .login-button:hover {
                transform: translateY(-2px);
                box-shadow: 0 6px 20px rgba(102, 126, 234, 0.6);
            }
            .login-button:active {
                transform: translateY(0);
            }
            .back-link {
                text-align: center;
                margin-top: 20px;
            }
            .back-link a {
                color: #667eea;
                text-decoration: none;
                font-size: 0.9em;
                transition: color 0.3s ease;
            }
            .back-link a:hover {
                color: #764ba2;
                text-decoration: underline;
            }
        </style>
    </head>
    <body>
        <div class="login-container">
            <div class="login-header">
                <h1>Đăng nhập</h1>
                <p>Vui lòng đăng nhập để tiếp tục</p>
            </div>
            <form action="${pageContext.request.contextPath}/login" method="POST">
                <c:if test="${not empty requestScope.error}">
                    <div style="background-color: #fee; color: #c33; padding: 12px; border-radius: 8px; margin-bottom: 20px; border: 1px solid #fcc;">
                        ${requestScope.error}
                    </div>
                </c:if>
                <c:if test="${not empty requestScope.message}">
                    <div style="background-color: #efe; color: #3c3; padding: 12px; border-radius: 8px; margin-bottom: 20px; border: 1px solid #cfc;">
                        ${requestScope.message}
                    </div>
                </c:if>
                <div class="form-group">
                    <label for="txtUsername">Tên đăng nhập</label>
                    <input type="text" name="username" id="txtUsername" placeholder="Nhập tên đăng nhập" value="${requestScope.username}" required/>
                </div>
                <div class="form-group">
                    <label for="txtPassword">Mật khẩu</label>
                    <input type="password" name="password" id="txtPassword" placeholder="Nhập mật khẩu" required/>
                </div>
                <c:if test="${not empty param.redirect}">
                    <input type="hidden" name="redirect" value="${param.redirect}"/>
                </c:if>
                <input type="submit" id="btnLogin" class="login-button" value="Đăng nhập"/>
            </form>
            <div class="back-link">
                <a href="${pageContext.request.contextPath}/">← Quay lại trang chủ</a>
            </div>
        </div>
    </body>
</html>
