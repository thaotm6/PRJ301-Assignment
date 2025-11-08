
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Thông báo - Hệ thống quản lý</title>
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
            .message-container {
                background: white;
                border-radius: 20px;
                padding: 50px 40px;
                box-shadow: 0 20px 60px rgba(0, 0, 0, 0.3);
                max-width: 500px;
                width: 100%;
                text-align: center;
            }
            .message-icon {
                font-size: 4em;
                margin-bottom: 20px;
            }
            .message-success {
                color: #4caf50;
            }
            .message-error {
                color: #f44336;
            }
            .message-info {
                color: #2196f3;
            }
            .message-text {
                font-size: 1.2em;
                color: #333;
                margin-bottom: 30px;
                line-height: 1.6;
            }
            .message-actions {
                margin-top: 30px;
            }
            .btn {
                display: inline-block;
                padding: 12px 30px;
                border-radius: 10px;
                text-decoration: none;
                font-weight: 600;
                transition: transform 0.3s ease, box-shadow 0.3s ease;
                margin: 0 10px;
            }
            .btn-primary {
                background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                color: white;
                box-shadow: 0 4px 15px rgba(102, 126, 234, 0.4);
            }
            .btn-primary:hover {
                transform: translateY(-2px);
                box-shadow: 0 6px 20px rgba(102, 126, 234, 0.6);
            }
            .btn-secondary {
                background: #f5f5f5;
                color: #333;
            }
            .btn-secondary:hover {
                background: #e0e0e0;
            }
        </style>
    </head>
    <body>
        <div class="message-container">
            <c:choose>
                <c:when test="${not empty requestScope.message}">
                    <div class="message-icon message-success">✓</div>
                    <div class="message-text">${requestScope.message}</div>
                </c:when>
                <c:when test="${not empty requestScope.error}">
                    <div class="message-icon message-error">✗</div>
                    <div class="message-text">${requestScope.error}</div>
                </c:when>
                <c:otherwise>
                    <div class="message-icon message-info">ℹ</div>
                    <div class="message-text">Không có thông báo</div>
                </c:otherwise>
            </c:choose>
            <div class="message-actions">
                <a href="${pageContext.request.contextPath}/login" class="btn btn-primary">Đăng nhập</a>
                <a href="${pageContext.request.contextPath}/home" class="btn btn-secondary">Trang chủ</a>
            </div>
        </div>
    </body>
</html>
