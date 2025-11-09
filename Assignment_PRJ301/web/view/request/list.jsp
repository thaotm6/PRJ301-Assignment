

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
      /* ========= Blue Sea Pastel – thay tím bằng xanh dịu ========= */
      *{margin:0;padding:0;box-sizing:border-box}

      :root{
        --bg-1:#cfefff;          /* nền xanh rất nhạt */
        --bg-2:#9ed8ff;          /* xanh biển dịu */
        --surface:#ffffff;
        --text:#0c2a3f;
        --muted:#3f6b8a;
        --primary:#2a8df2;
        --primary-600:#1e7ce0;
        --primary-200:#bfe0ff;
        --shadow:0 12px 36px rgba(9,30,66,.14);
        --radius:20px;
      }

      body{
        font-family:'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        background:linear-gradient(135deg,var(--bg-1),var(--bg-2));
        background-attachment:fixed;
        min-height:100vh;
        padding:20px;
        color:var(--text);
      }

      .container{max-width:1200px;margin:0 auto}

      .header{
        background:var(--surface);
        border-radius:var(--radius);
        padding:30px 40px;
        box-shadow:var(--shadow);
        margin-bottom:30px;
        display:flex;justify-content:space-between;align-items:center;
      }
      .header h1{color:var(--text);font-size:2em;font-weight:700}

      .header-actions{display:flex;gap:15px}

      .btn{
        padding:12px 25px;border-radius:10px;text-decoration:none;
        font-weight:700;border:none;cursor:pointer;font-size:1em;
        transition:filter .2s ease, transform .05s ease, box-shadow .2s ease;
      }
      .btn-primary{
        background:linear-gradient(135deg,var(--primary),var(--primary-600));
        color:#fff;box-shadow:0 8px 18px rgba(42,141,242,.28);
      }
      .btn-primary:hover{filter:brightness(1.07)}
      .btn-primary:active{transform:translateY(1px)}

      .btn-secondary{
        background:#f4f7fb;color:var(--text);border:1px solid var(--primary-200);
      }
      .btn-secondary:hover{background:#e9f2ff}

      .content{
        background:var(--surface);
        border-radius:var(--radius);
        padding:30px 40px;
        box-shadow:var(--shadow);
      }

      .table-container{overflow-x:auto}

      table{width:100%;border-collapse:collapse;margin-top:20px}

      thead{
        background:linear-gradient(135deg,var(--primary),var(--primary-600));
        color:#fff;
      }
      th{padding:15px;text-align:left;font-weight:700;font-size:.95em}
      td{padding:15px;border-bottom:1px solid #e6eef7}

      tbody tr:hover{background-color:#eef6ff}

      .status-badge{
        display:inline-block;padding:5px 15px;border-radius:20px;
        font-size:.85em;font-weight:700;
      }
      .status-inprogress{background-color:#eaf3ff;color:#1a4e9f;border:1px solid #cfe0ff}
      .status-approved{background-color:#d4edda;color:#155724}
      .status-rejected{background-color:#f8d7da;color:#721c24}

      .empty-message{text-align:center;padding:60px 20px;color:#667d92}
      .empty-message-icon{font-size:4em;margin-bottom:20px}
      .empty-message-text{font-size:1.2em;margin-bottom:20px}

      .view-scope{font-size:.95em;color:#4a6a83}
      .view-scope strong{color:var(--text)}

      .request-title{
        color:#2a8df2;font-weight:700;cursor:default;
      }
      .request-title:hover{color:#1e7ce0}
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

