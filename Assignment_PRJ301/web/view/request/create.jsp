

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Tạo đơn xin nghỉ phép - Hệ thống quản lý</title>
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
                max-width: 800px;
                margin: 0 auto;
                background: white;
                border-radius: 20px;
                padding: 40px;
                box-shadow: 0 20px 60px rgba(0, 0, 0, 0.3);
            }
            .header {
                text-align: center;
                margin-bottom: 40px;
            }
            .header h1 {
                color: #333;
                font-size: 2em;
                margin-bottom: 10px;
                font-weight: 600;
            }
            .header p {
                color: #666;
                font-size: 0.95em;
            }
            .alert {
                padding: 15px;
                border-radius: 10px;
                margin-bottom: 20px;
                font-size: 0.95em;
            }
            .alert-error {
                background-color: #fee;
                color: #c33;
                border: 1px solid #fcc;
            }
            .alert-success {
                background-color: #efe;
                color: #3c3;
                border: 1px solid #cfc;
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
            .form-group input[type="date"],
            .form-group textarea {
                width: 100%;
                padding: 12px 15px;
                border: 2px solid #e0e0e0;
                border-radius: 10px;
                font-size: 1em;
                transition: border-color 0.3s ease, box-shadow 0.3s ease;
                outline: none;
                font-family: inherit;
            }
            .form-group input[type="date"]:focus,
            .form-group textarea:focus {
                border-color: #667eea;
                box-shadow: 0 0 0 3px rgba(102, 126, 234, 0.1);
            }
            .form-group textarea {
                min-height: 120px;
                resize: vertical;
            }
            .form-group small {
                display: block;
                color: #666;
                font-size: 0.85em;
                margin-top: 5px;
            }
            .form-actions {
                display: flex;
                gap: 15px;
                margin-top: 30px;
            }
            .btn {
                flex: 1;
                padding: 15px;
                border-radius: 10px;
                font-size: 1.1em;
                font-weight: 600;
                cursor: pointer;
                transition: transform 0.3s ease, box-shadow 0.3s ease;
                text-decoration: none;
                text-align: center;
                border: none;
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
            .profile-card {
                background: #fef6ed;
                border: 1px solid #f4dbc1;
                border-radius: 15px;
                padding: 20px 25px;
                margin-bottom: 30px;
            }
            .profile-title {
                font-size: 1.1em;
                font-weight: 600;
                color: #5a3e85;
                margin-bottom: 12px;
                display: flex;
                align-items: center;
                gap: 10px;
            }
            .profile-row {
                display: flex;
                gap: 10px;
                margin-bottom: 8px;
                font-size: 0.95em;
                flex-wrap: wrap;
            }
            .profile-label {
                font-weight: 600;
                color: #4b4b4b;
                min-width: 90px;
            }
            .profile-value {
                color: #333;
                flex: 1;
            }
            .state-flow {
                margin-top: 18px;
                padding-top: 16px;
                border-top: 1px dashed rgba(118, 75, 162, 0.3);
            }
            .state-flow-title {
                font-weight: 600;
                color: #5a3e85;
                margin-bottom: 10px;
                font-size: 0.92em;
            }
            .state-list {
                display: flex;
                flex-wrap: wrap;
                gap: 12px;
                font-size: 0.88em;
                color: #555;
            }
            .state-item {
                padding: 6px 12px;
                border-radius: 999px;
                background: rgba(118, 75, 162, 0.08);
                border: 1px solid rgba(118, 75, 162, 0.2);
                display: flex;
                align-items: center;
                gap: 6px;
                line-height: 1.3;
            }
            .state-item span {
                font-weight: 600;
                color: #4a3b8f;
            }
        </style>
    </head>
    <body>
        <div class="container">
            <div class="header">
                <h1>Tạo đơn xin nghỉ phép</h1>
                <p>Vui lòng điền đầy đủ thông tin để tạo đơn nghỉ phép</p>
            </div>
            
            <c:if test="${not empty requestScope.error}">
                <div class="alert alert-error">
                    ${requestScope.error}
                </div>
            </c:if>
            
            <c:if test="${not empty requestScope.message}">
                <div class="alert alert-success">
                    ${requestScope.message}
                </div>
            </c:if>
            
            <div class="profile-card">
                <div class="profile-title">Thông tin người tạo đơn</div>
                <div class="profile-row">
                    <span class="profile-label">Nhân viên:</span>
                    <span class="profile-value">${requestScope.employeeName}</span>
                </div>
                <div class="profile-row">
                    <span class="profile-label">Vai trò:</span>
                    <span class="profile-value">
                        <c:choose>
                            <c:when test="${not empty requestScope.roleSummary}">
                                ${requestScope.roleSummary}
                            </c:when>
                            <c:otherwise>
                                Chưa được phân quyền
                            </c:otherwise>
                        </c:choose>
                    </span>
                </div>
                <div class="profile-row">
                    <span class="profile-label">Phòng ban:</span>
                    <span class="profile-value">${requestScope.employeeDeptName}</span>
                </div>
                <div class="state-flow">
                    <div class="state-flow-title">Đơn nghỉ phép sẽ đi qua các trạng thái:</div>
                    <div class="state-list">
                        <div class="state-item"><span>S1</span>Inprogress (đang chờ duyệt)</div>
                        <div class="state-item"><span>S2</span>Approved (đã phê duyệt)</div>
                        <div class="state-item"><span>S3</span>Rejected (từ chối)</div>
                    </div>
                    <div style="margin-top: 8px; font-size: 0.83em; color: #777;">
                        Đơn mới tạo sẽ luôn ở trạng thái <strong>Inprogress</strong> để chờ người quản lý xử lý.
                    </div>
                </div>
            </div>
            
            <form action="${pageContext.request.contextPath}/request/create" method="POST">
                <div class="form-group">
                    <label for="fromDate">Ngày bắt đầu nghỉ <span style="color: red;">*</span></label>
                    <input type="date" name="fromDate" id="fromDate" 
                           value="${requestScope.fromDate}" 
                           min="${requestScope.today}" 
                           required/>
                    <small>Chọn ngày bắt đầu nghỉ phép</small>
                </div>
                
                <div class="form-group">
                    <label for="toDate">Ngày kết thúc nghỉ <span style="color: red;">*</span></label>
                    <input type="date" name="toDate" id="toDate" 
                           value="${requestScope.toDate}" 
                           min="${not empty requestScope.fromDate ? requestScope.fromDate : requestScope.today}" 
                           required/>
                    <small>Chọn ngày kết thúc nghỉ phép (phải sau hoặc bằng ngày bắt đầu)</small>
                </div>
                
                <div class="form-group">
                    <label for="reason">Lý do nghỉ phép <span style="color: red;">*</span></label>
                    <textarea name="reason" id="reason" 
                              placeholder="Nhập lý do nghỉ phép..." 
                              required>${requestScope.reason}</textarea>
                    <small>Mô tả chi tiết lý do bạn cần nghỉ phép</small>
                </div>
                
                <div class="form-actions">
                    <button type="submit" class="btn btn-primary">Tạo đơn nghỉ phép</button>
                    <a href="${pageContext.request.contextPath}/request/list" class="btn btn-secondary">Hủy</a>
                </div>
            </form>
            
            <div class="back-link">
                <a href="${pageContext.request.contextPath}/request/list">← Quay lại danh sách đơn</a>
            </div>
        </div>
        <script>
            (function() {
                var fromDateInput = document.getElementById('fromDate');
                var toDateInput = document.getElementById('toDate');
                if (!fromDateInput || !toDateInput) {
                    return;
                }
                var today = "${requestScope.today}";
                if (!today || today === "null") {
                    today = new Date().toISOString().split('T')[0];
                }
                fromDateInput.min = today;
                if (!fromDateInput.value) {
                    fromDateInput.value = today;
                }
                if (!toDateInput.min) {
                    toDateInput.min = fromDateInput.value || today;
                }
                fromDateInput.addEventListener('change', function() {
                    var value = this.value;
                    toDateInput.min = value || today;
                    if (toDateInput.value && value && toDateInput.value < value) {
                        toDateInput.value = value;
                    }
                });
            })();
        </script>
        
    </body>
</html>

