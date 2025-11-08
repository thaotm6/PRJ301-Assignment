        

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Duyệt đơn nghỉ phép</title>
        <style>
            * {
                margin: 0;
                padding: 0;
                box-sizing: border-box;
            }
            body {
                font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
                background: linear-gradient(135deg, #74ebd5 0%, #9face6 100%);
                min-height: 100vh;
                display: flex;
                align-items: center;
                justify-content: center;
                padding: 30px 15px;
            }
            .container {
                width: 100%;
                max-width: 520px;
            }
            .card {
                background-color: rgba(255, 255, 255, 0.95);
                border-radius: 18px;
                box-shadow: 0 25px 60px rgba(79, 134, 247, 0.35);
                padding: 35px 40px;
                color: #1f2a44;
            }
            .card h1 {
                font-size: 1.6em;
                margin-bottom: 20px;
                font-weight: 600;
                color: #0f1a3a;
            }
            .meta-row {
                margin-bottom: 12px;
                font-size: 0.95em;
                line-height: 1.45;
            }
            .meta-label {
                font-weight: 600;
                color: #1a237e;
            }
            .reason-box {
                border: 2px dashed rgba(26, 35, 126, 0.25);
                border-radius: 14px;
                padding: 18px;
                margin-top: 6px;
                margin-bottom: 24px;
                font-size: 1.05em;
                background: rgba(248, 249, 255, 0.85);
                min-height: 80px;
                display: flex;
                align-items: center;
                justify-content: center;
                text-align: center;
                color: #283593;
            }
            .status-chip {
                display: inline-block;
                padding: 6px 14px;
                border-radius: 20px;
                font-size: 0.85em;
                font-weight: 600;
                margin-top: 4px;
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
            .alert {
                padding: 14px 18px;
                border-radius: 12px;
                font-size: 0.95em;
                margin-bottom: 18px;
                border-left: 4px solid;
            }
            .alert-success {
                background-color: rgba(212, 237, 218, 0.9);
                color: #155724;
                border-color: #28a745;
            }
            .alert-error {
                background-color: rgba(248, 215, 218, 0.9);
                color: #721c24;
                border-color: #dc3545;
            }
            .note-group {
                margin-bottom: 22px;
            }
            .note-group label {
                display: block;
                font-weight: 600;
                margin-bottom: 8px;
                color: #1a237e;
            }
            .note-group textarea {
                width: 100%;
                min-height: 110px;
                padding: 12px 14px;
                border-radius: 12px;
                border: 1px solid rgba(26, 35, 126, 0.2);
                font-family: inherit;
                font-size: 0.95em;
                resize: vertical;
                background-color: rgba(255, 255, 255, 0.95);
                color: #1f2a44;
            }
            .note-group textarea:disabled {
                background-color: rgba(229, 232, 240, 0.6);
                cursor: not-allowed;
            }
            .action-row {
                display: flex;
                gap: 16px;
                justify-content: center;
            }
            .btn {
                flex: 1;
                padding: 14px 20px;
                border-radius: 12px;
                font-size: 1em;
                font-weight: 600;
                border: none;
                cursor: pointer;
                transition: transform 0.2s ease, box-shadow 0.2s ease;
            }
            .btn:disabled {
                cursor: not-allowed;
                opacity: 0.7;
                box-shadow: none;
            }
            .btn-reject {
                background: linear-gradient(135deg, #ff758c 0%, #ff7eb3 100%);
                color: #fff;
                box-shadow: 0 12px 25px rgba(255, 117, 140, 0.35);
            }
            .btn-approve {
                background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                color: #fff;
                box-shadow: 0 12px 25px rgba(118, 75, 162, 0.35);
            }
            .btn:hover:not(:disabled) {
                transform: translateY(-2px);
                box-shadow: 0 16px 30px rgba(102, 126, 234, 0.4);
            }
            .footer-links {
                margin-top: 20px;
                text-align: center;
            }
            .footer-links a {
                color: #1a237e;
                text-decoration: none;
                font-weight: 600;
                transition: color 0.2s ease;
            }
            .footer-links a:hover {
                color: #0d47a1;
            }
            .empty-message {
                text-align: center;
                font-size: 1em;
                color: #283593;
            }
        </style>
    </head>
    <body>
        <div class="container">
            <div class="card">
                <h1>Duyệt đơn xin nghỉ phép</h1>

                <c:if test="${not empty success}">
                    <div class="alert alert-success">
                        ${success}
                    </div>
                </c:if>
                <c:if test="${not empty error}">
                    <div class="alert alert-error">
                        ${error}
                    </div>
                </c:if>

                <c:choose>
                    <c:when test="${not empty targetRequest}">
                        <div class="meta-row">
                            <span class="meta-label">Duyệt bởi:</span>
                            <c:choose>
                                <c:when test="${not empty currentUser.employee}">
                                    <c:out value="${currentUser.employee.name}" />
                                </c:when>
                                <c:otherwise>
                                    <c:out value="${currentUser.displayname}" />
                                </c:otherwise>
                            </c:choose>
                            <c:if test="${not empty currentUser.roles}">
                                , Role:
                                <c:forEach var="role" items="${currentUser.roles}" varStatus="loop">
                                    <c:out value="${role.name}" />
                                    <c:if test="${!loop.last}">
                                        ,
                                    </c:if>
                                </c:forEach>
                            </c:if>
                        </div>
                        <div class="meta-row">
                            <span class="meta-label">Tạo bởi:</span>
                            <c:choose>
                                <c:when test="${not empty targetRequest.createdBy}">
                                    <c:out value="${targetRequest.createdBy.name}" />
                                </c:when>
                                <c:otherwise>
                                    <em>Không xác định</em>
                                </c:otherwise>
                            </c:choose>
                        </div>
                        <div class="meta-row">
                            <span class="meta-label">Từ ngày:</span>
                            <fmt:formatDate value="${targetRequest.from}" pattern="dd/MM/yyyy"/>
                        </div>
                        <div class="meta-row">
                            <span class="meta-label">Tới ngày:</span>
                            <fmt:formatDate value="${targetRequest.to}" pattern="dd/MM/yyyy"/>
                        </div>
                        <div class="meta-row">
                            <span class="meta-label">Trạng thái:</span>
                            <c:set var="status" value="${targetRequest.status}" />
                            <c:choose>
                                <c:when test="${status == 0}">
                                    <span class="status-chip status-inprogress">Inprogress</span>
                                </c:when>
                                <c:when test="${status == 1}">
                                    <span class="status-chip status-approved">Approved</span>
                                </c:when>
                                <c:when test="${status == 2}">
                                    <span class="status-chip status-rejected">Rejected</span>
                                </c:when>
                                <c:otherwise>
                                    <span class="status-chip">Unknown</span>
                                </c:otherwise>
                            </c:choose>
                        </div>
                        <div class="reason-box">
                            <c:out value="${targetRequest.reason}" />
                        </div>

                        <c:if test="${not empty targetRequest.processedBy}">
                            <div class="meta-row">
                                <span class="meta-label">Đã xử lý bởi:</span>
                                <c:out value="${targetRequest.processedBy.name}" />
                            </div>
                        </c:if>
                        <c:if test="${not empty targetRequest.processedTime}">
                            <div class="meta-row">
                                <span class="meta-label">Thời gian xử lý:</span>
                                <fmt:formatDate value="${targetRequest.processedTime}" pattern="dd/MM/yyyy HH:mm"/>
                            </div>
                        </c:if>

                        <form method="post" action="${pageContext.request.contextPath}/request/review">
                            <input type="hidden" name="rid" value="${targetRequest.id}" />

                            <div class="note-group">
                                <label for="note">Ghi chú xử lý</label>
                                <textarea id="note" name="note" maxlength="255" <c:if test="${!canAct}">disabled</c:if>><c:out value="${noteInput}" default=""/></textarea>
                                <c:if test="${canAct}">
                                    <small style="display:block;margin-top:6px;color:#5c6bc0;">* Bắt buộc khi chọn Reject</small>
                                </c:if>
                            </div>

                            <div class="action-row">
                                <button type="submit" class="btn btn-reject" name="decision" value="reject" <c:if test="${!canAct}">disabled</c:if>>Reject</button>
                                <button type="submit" class="btn btn-approve" name="decision" value="approve" <c:if test="${!canAct}">disabled</c:if>>Approve</button>
                            </div>
                        </form>
                    </c:when>
                    <c:otherwise>
                        <div class="empty-message">
                            Không tìm thấy thông tin đơn nghỉ phép phù hợp.
                        </div>
                    </c:otherwise>
                </c:choose>

                <div class="footer-links">
                    <a href="${pageContext.request.contextPath}/request/list">Quay về danh sách đơn</a>
                </div>
            </div>
        </div>
    </body>
</html>

