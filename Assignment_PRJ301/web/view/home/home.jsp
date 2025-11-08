<%-- 
    Document   : home
    Created on : Nov 8, 2025, 5:37:12 PM
    Author     : Admin
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Trang chủ - Hệ thống quản lý</title>
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
                padding: 20px;
            }
            .container {
                max-width: 1200px;
                margin: 0 auto;
            }
            .header {
                background: white;
                border-radius: 20px;
                padding: 30px 40px;
                box-shadow: 0 20px 60px rgba(0, 0, 0, 0.3);
                margin-bottom: 30px;
                display: flex;
                justify-content: space-between;
                align-items: center;
            }
            .user-info {
                display: flex;
                align-items: center;
                gap: 15px;
            }
            .user-avatar {
                width: 50px;
                height: 50px;
                border-radius: 50%;
                background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                display: flex;
                align-items: center;
                justify-content: center;
                color: white;
                font-size: 1.5em;
                font-weight: 600;
            }
            .user-details h2 {
                color: #333;
                font-size: 1.3em;
                margin-bottom: 5px;
            }
            .user-details p {
                color: #666;
                font-size: 0.9em;
            }
            .logout-btn {
                background: #f44336;
                color: white;
                padding: 10px 20px;
                border-radius: 10px;
                text-decoration: none;
                font-weight: 600;
                transition: background 0.3s ease;
            }
            .logout-btn:hover {
                background: #d32f2f;
            }
            .content {
                display: grid;
                grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
                gap: 20px;
            }
            .card {
                background: white;
                border-radius: 20px;
                padding: 30px;
                box-shadow: 0 20px 60px rgba(0, 0, 0, 0.3);
                transition: transform 0.3s ease, box-shadow 0.3s ease;
            }
            .card:hover {
                transform: translateY(-5px);
                box-shadow: 0 25px 70px rgba(0, 0, 0, 0.4);
            }
            .card-icon {
                font-size: 3em;
                margin-bottom: 15px;
            }
            .card-title {
                color: #333;
                font-size: 1.3em;
                font-weight: 600;
                margin-bottom: 10px;
            }
            .card-description {
                color: #666;
                font-size: 0.95em;
                margin-bottom: 20px;
                line-height: 1.6;
            }
            .card-link {
                display: inline-block;
                background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                color: white;
                padding: 12px 25px;
                border-radius: 10px;
                text-decoration: none;
                font-weight: 600;
                transition: transform 0.3s ease, box-shadow 0.3s ease;
                box-shadow: 0 4px 15px rgba(102, 126, 234, 0.4);
            }
            .card-link:hover {
                transform: translateY(-2px);
                box-shadow: 0 6px 20px rgba(102, 126, 234, 0.6);
            }
            .welcome-message {
                background: white;
                border-radius: 20px;
                padding: 30px 40px;
                box-shadow: 0 20px 60px rgba(0, 0, 0, 0.3);
                margin-bottom: 30px;
                text-align: center;
            }
            .welcome-message h1 {
                color: #333;
                font-size: 2em;
                margin-bottom: 10px;
            }
            .welcome-message p {
                color: #666;
                font-size: 1.1em;
            }
        </style>
    </head>
    <body>
        <div class="container">
            <div class="header">
                <div class="user-info">
                    <div class="user-avatar">
                        ${user.displayname != null ? user.displayname.charAt(0) : user.username.charAt(0)}
                    </div>
                    <div class="user-details">
                        <h2>${user.displayname != null ? user.displayname : user.username}</h2>
                        <p>${user.employee != null ? user.employee.name : 'Nhân viên'}</p>
                    </div>
                </div>
                <a href="${pageContext.request.contextPath}/logout" class="logout-btn">Đăng xuất</a>
            </div>
            
            <div class="welcome-message">
                <h1>Chào mừng đến với hệ thống quản lý nghỉ phép</h1>
                <p>Xin chào, ${user.displayname != null ? user.displayname : user.username}!</p>
            </div>
            
            <div class="content">
                <div class="card">
                    <div class="card-icon">📝</div>
                    <div class="card-title">Tạo đơn xin nghỉ phép</div>
                    <div class="card-description">
                        Tạo đơn xin nghỉ phép mới với thông tin ngày nghỉ và lý do chi tiết.
                    </div>
                    <a href="${pageContext.request.contextPath}/request/create" class="card-link">Tạo đơn mới</a>
                </div>
                
                <div class="card">
                    <div class="card-icon">📋</div>
                    <div class="card-title">Danh sách đơn nghỉ phép</div>
                    <div class="card-description">
                        Xem danh sách các đơn nghỉ phép đã tạo và trạng thái xử lý của chúng.
                    </div>
                    <a href="${pageContext.request.contextPath}/request/list" class="card-link">Xem danh sách</a>
                </div>
                
                <c:if test="${not empty user.roles}">
                    <c:forEach var="role" items="${user.roles}">
                        <c:forEach var="feature" items="${role.features}">
                            <c:if test="${feature.url == '/request/review'}">
                                <div class="card">
                                    <div class="card-icon">✅</div>
                                    <div class="card-title">Duyệt đơn nghỉ phép</div>
                                    <div class="card-description">
                                        Xem xét và duyệt các đơn nghỉ phép của cấp dưới.
                                    </div>
                                    <a href="${pageContext.request.contextPath}/request/review" class="card-link">Duyệt đơn</a>
                                </div>
                            </c:if>
                            <c:if test="${feature.url == '/division/agenda'}">
                                <div class="card">
                                    <div class="card-icon">📅</div>
                                    <div class="card-title">Lịch trình phòng ban</div>
                                    <div class="card-description">
                                        Xem agenda tình hình lao động của phòng ban.
                                    </div>
                                    <a href="${pageContext.request.contextPath}/division/agenda" class="card-link">Xem lịch trình</a>
                                </div>
                            </c:if>
                        </c:forEach>
                    </c:forEach>
                </c:if>
            </div>
        </div>
    </body>
</html>


