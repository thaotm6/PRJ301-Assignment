

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Danh sách đơn nghỉ phép - Hệ thống quản lý</title>
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
            .header h1 {
                color: #333;
                font-size: 2em;
                font-weight: 600;
            }
            .header-actions {
                display: flex;
                gap: 15px;
            }
            .btn {
                padding: 12px 25px;
                border-radius: 10px;
                text-decoration: none;
                font-weight: 600;
                transition: transform 0.3s ease, box-shadow 0.3s ease;
                border: none;
                cursor: pointer;
                font-size: 1em;
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
            .content {
                background: white;
                border-radius: 20px;
                padding: 30px 40px;
                box-shadow: 0 20px 60px rgba(0, 0, 0, 0.3);
            }
            .table-container {
                overflow-x: auto;
            }
            table {
                width: 100%;
                border-collapse: collapse;
                margin-top: 20px;
            }
            thead {
                background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                color: white;
            }
            th {
                padding: 15px;
                text-align: left;
                font-weight: 600;
                font-size: 0.95em;
            }
            td {
                padding: 15px;
                border-bottom: 1px solid #e0e0e0;
            }
            tbody tr:hover {
                background-color: #f5f5f5;
            }
            .status-badge {
                display: inline-block;
                padding: 5px 15px;
                border-radius: 20px;
                font-size: 0.85em;
                font-weight: 600;
            }
            .status-inprogress {
                background-color: #fff3cd;
                color: #856404;
            }
            .status-approved {
                background-color: #d4edda;
                color: #155724;
            }
            .status-rejected {
                background-color: #f8d7da;
                color: #721c24;
            }
            .empty-message {
                text-align: center;
                padding: 60px 20px;
                color: #666;
            }
            .empty-message-icon {
                font-size: 4em;
                margin-bottom: 20px;
            }
            .empty-message-text {
                font-size: 1.2em;
                margin-bottom: 20px;
            }
            .view-scope {
                font-size: 0.95em;
                color: #555;
            }
            .view-scope strong {
                color: #333;
            }
            .request-title {
                color: #3a4ed5;
                font-weight: 600;
                cursor: default;
            }
            .request-title:hover {
                color: #2a3cc2;
            }
        </style>
    </head>
    <body>
        <div class="container">
            <div class="header">
                <h1>Danh sách đơn nghỉ phép</h1>
                <div class="header-actions">
                    <a href="${pageContext.request.contextPath}/request/create" class="btn btn-primary">Tạo đơn mới</a>
                    <a href="${pageContext.request.contextPath}/home" class="btn btn-secondary">Trang chủ</a>
                </div>
            </div>
            
            <div class="content">
                <div class="view-scope">
                    <strong>Hiển thị:</strong>
                    <c:choose>
                        <c:when test="${canViewSubordinates}">
                            Đơn do bạn và các cấp dưới báo cáo tạo.
                        </c:when>
                        <c:otherwise>
                            Các đơn do chính bạn tạo.
                        </c:otherwise>
                    </c:choose>
                </div>
                
                <c:if test="${not empty requests}">
                    <div class="table-container">
                        <table>
                            <thead>
                                <tr>
                                    <th>Title</th>
                                    <th>From</th>
                                    <th>To</th>
                                    <th>Created By</th>
                                    <th>Status</th>
                                    <th>Processed By</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="request" items="${requests}">
                                    <tr>
                                        <td>
                                            <span class="request-title" title="${fn:escapeXml(request.reason)}">
                                                <c:out value="${request.displayTitle}" />
                                            </span>
                                        </td>
                                        <td>
                                            <fmt:formatDate value="${request.from}" pattern="dd/MM/yyyy"/>
                                        </td>
                                        <td>
                                            <fmt:formatDate value="${request.to}" pattern="dd/MM/yyyy"/>
                                        </td>
                                        <td>${request.createdBy.name}</td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${request.status == 0}">
                                                    <span class="status-badge status-inprogress">Inprogress</span>
                                                </c:when>
                                                <c:when test="${request.status == 1}">
                                                    <span class="status-badge status-approved">Approved</span>
                                                </c:when>
                                                <c:when test="${request.status == 2}">
                                                    <span class="status-badge status-rejected">Rejected</span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="status-badge">-</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${not empty request.processedBy}">
                                                    ${request.processedBy.name}
                                                </c:when>
                                                <c:otherwise>
                                                    <span style="color: #999;">-</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </c:if>
                
                <c:if test="${empty requests}">
                    <div class="empty-message">
                        <div class="empty-message-icon">📋</div>
                        <div class="empty-message-text">Chưa có đơn nghỉ phép nào</div>
                        <a href="${pageContext.request.contextPath}/request/create" class="btn btn-primary">Tạo đơn mới</a>
                    </div>
                </c:if>
            </div>
        </div>
    </body>
</html>

