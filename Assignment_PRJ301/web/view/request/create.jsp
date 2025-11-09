<%-- 
    Document   : create
    Created on : Nov 8, 2025
    Author     : sonnt
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Tạo đơn xin nghỉ phép - Hệ thống quản lý</title>
      <style>
      /* ========= Blue Sea Pastel – dịu mắt, bỏ hoàn toàn tím ========= */
      *{margin:0;padding:0;box-sizing:border-box}

      :root{
        --bg-1:#cfefff;          /* nền xanh rất nhạt */
        --bg-2:#9ed8ff;          /* xanh biển dịu */
        --surface:#ffffff;       /* nền thẻ */
        --surface-alt:#f5fbff;   /* thẻ phụ/section */
        --text:#0c2a3f;          /* chữ chính */
        --muted:#3f6b8a;         /* chữ phụ */
        --placeholder:#8aa7bf;
        --primary:#2a8df2;       /* xanh chủ đạo */
        --primary-600:#1e7ce0;   /* đậm hơn cho hover */
        --primary-200:#bfe0ff;   /* viền input nhạt */
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

      .container{
        max-width:800px;
        margin:0 auto;
        background:var(--surface);
        border-radius:var(--radius);
        padding:40px;
        box-shadow:var(--shadow);
      }

      .header{text-align:center;margin-bottom:40px}
      .header h1{
        color:var(--text);
        font-size:2em;
        margin-bottom:10px;
        font-weight:700;
      }
      .header p{color:var(--muted);font-size:.95em}

      /* Alerts */
      .alert{padding:15px;border-radius:10px;margin-bottom:20px;font-size:.95em}
      .alert-error{background:#ffeff0;color:#c62828;border:1px solid #ffd5d8}
      .alert-success{background:#effaf3;color:#1b7f43;border:1px solid #cdebd6}

      /* Profile/Info card */
      .profile-card{
        background:var(--surface-alt);
        border:1px solid var(--primary-200);
        border-radius:15px;
        padding:20px 25px;
        margin-bottom:30px;
        box-shadow:0 4px 14px rgba(42,141,242,.08);
      }
      .profile-title{
        font-size:1.1em;font-weight:700;
        color:#1e5aa7;           /* xanh đậm dịu */
        margin-bottom:12px;display:flex;align-items:center;gap:10px;
      }
      .profile-row{display:flex;gap:10px;margin-bottom:8px;font-size:.95em;flex-wrap:wrap}
      .profile-label{font-weight:700;color:var(--text);min-width:90px}
      .profile-value{color:var(--text);flex:1}

      .state-flow{margin-top:18px;padding-top:16px;border-top:1px dashed rgba(42,141,242,.35)}
      .state-flow-title{font-weight:700;color:#1e5aa7;margin-bottom:10px;font-size:.92em}
      .state-list{display:flex;flex-wrap:wrap;gap:12px;font-size:.88em;color:#4c6e87}
      .state-item{
        padding:6px 12px;border-radius:999px;
        background:rgba(42,141,242,.08);
        border:1px solid rgba(42,141,242,.20);
        display:flex;align-items:center;gap:6px;line-height:1.3
      }
      .state-item span{font-weight:700;color:#1565c0}

      /* Form fields */
      .form-group{margin-bottom:25px}
      .form-group label{
        display:block;color:var(--text);font-weight:700;margin-bottom:8px;font-size:.95em
      }
      .form-group input[type="date"],
      .form-group textarea{
        width:100%;padding:12px 15px;
        border:1px solid var(--primary-200);
        border-radius:10px;font-size:1em;outline:none;font-family:inherit;
        transition:border-color .2s ease, box-shadow .2s ease, background .2s;
        background:#fff;color:var(--text);
      }
      .form-group input::placeholder,
      .form-group textarea::placeholder{color:var(--placeholder)}
      .form-group input[type="date"]:focus,
      .form-group textarea:focus{
        border-color:var(--primary);
        box-shadow:0 0 0 3px rgba(42,141,242,.18);
      }
      .form-group textarea{min-height:120px;resize:vertical}
      .form-group small{display:block;color:var(--muted);font-size:.85em;margin-top:5px}

      /* Actions */
      .form-actions{display:flex;gap:15px;margin-top:30px}
      .btn{
        flex:1;padding:15px;border-radius:10px;font-size:1.1em;font-weight:700;
        cursor:pointer;transition:filter .2s ease, transform .05s ease, box-shadow .2s ease;
        text-decoration:none;text-align:center;border:none;
      }
      .btn-primary{
        background:linear-gradient(135deg,var(--primary),var(--primary-600));
        color:#fff;box-shadow:0 8px 18px rgba(42,141,242,.28);
      }
      .btn-primary:hover{filter:brightness(1.07)}
      .btn-primary:active{transform:translateY(1px)}
      .btn-secondary{background:#f4f7fb;color:var(--text);border:1px solid var(--primary-200)}
      .btn-secondary:hover{background:#e9f2ff}

      .back-link{text-align:center;margin-top:20px}
      .back-link a{
        color:var(--primary);text-decoration:none;font-size:.9em;transition:color .2s
      }
      .back-link a:hover{color:var(--primary-600);text-decoration:underline}

      /* Responsive */
      @media (max-width:600px){
        .container{padding:28px 22px}
        .form-actions{flex-direction:column}
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