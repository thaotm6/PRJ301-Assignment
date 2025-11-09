<%-- 
    Document   : home
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
        <title>Trang chủ - Hệ thống quản lý</title>
        <style>
      /* ========= Blue Sea Pastel – dịu mắt, hiện đại ========= */
      *{margin:0;padding:0;box-sizing:border-box}

      :root{
        --bg-1:#bfe6ff;        /* nền gradient nhạt */
        --bg-2:#81d4fa;        /* xanh biển dịu */
        --surface:#ffffff;     /* nền thẻ/card */
        --text:#0c2a3f;        /* chữ chính */
        --muted:#3f6b8a;       /* chữ phụ */
        --primary:#2a8df2;     /* xanh chủ đạo */
        --primary-600:#1877f2; /* hover/đậm hơn */
        --primary-200:#90caf9; /* viền nhạt */
        --shadow:0 12px 36px rgba(9,30,66,.14);
        --shadow-strong:0 18px 48px rgba(9,30,66,.18);
        --radius:20px;
      }

      body{
        font-family:'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        min-height:100vh;
        padding:20px;
        color:var(--text);
        background:linear-gradient(135deg,var(--bg-1),var(--bg-2));
        background-attachment:fixed;
      }

      .container{max-width:1200px;margin:0 auto}

      /* ===== Header / User bar ===== */
      .header{
        background:var(--surface);
        border-radius:var(--radius);
        padding:24px 32px;
        box-shadow:var(--shadow);
        margin-bottom:24px;
        display:flex;justify-content:space-between;align-items:center;
      }
      .user-info{display:flex;align-items:center;gap:14px}

      .user-avatar{
        width:52px;height:52px;border-radius:50%;
        display:flex;align-items:center;justify-content:center;
        color:#fff;font-size:1.3rem;font-weight:700;
        background:linear-gradient(135deg,#64b5f6,#1e88e5);
        box-shadow:0 6px 16px rgba(30,136,229,.35);
      }

      .user-details h2{
        color:var(--text);font-size:1.2rem;font-weight:700;margin-bottom:4px
      }
      .user-details p{color:var(--muted);font-size:.95rem}

      .logout-btn{
        background:linear-gradient(135deg,#ef5350,#e53935);
        color:#fff;text-decoration:none;font-weight:700;border-radius:12px;
        padding:10px 18px;transition:filter .2s ease, transform .05s ease;
        box-shadow:0 8px 18px rgba(229,57,53,.25);
      }
      .logout-btn:hover{filter:brightness(1.07)}
      .logout-btn:active{transform:translateY(1px)}

      /* ===== Welcome banner ===== */
      .welcome-message{
        background:var(--surface);
        border-radius:var(--radius);
        padding:26px 32px;
        box-shadow:var(--shadow);
        margin-bottom:26px;
        text-align:center;
      }
      .welcome-message h1{color:var(--text);font-size:1.8rem;margin-bottom:8px}
      .welcome-message p{color:var(--muted);font-size:1rem}

      /* ===== Cards grid ===== */
      .content{
        display:grid;
        grid-template-columns:repeat(auto-fit,minmax(280px,1fr));
        gap:22px;
      }

      .card{
        background:var(--surface);
        border-radius:var(--radius);
        padding:26px 22px;
        box-shadow:var(--shadow);
        transition:transform .25s ease, box-shadow .25s ease;
      }
      .card:hover{
        transform:translateY(-4px);
        box-shadow:var(--shadow-strong);
      }

      .card-icon{font-size:2.6rem;margin-bottom:12px}
      .card-title{color:var(--text);font-size:1.15rem;font-weight:700;margin-bottom:8px}
      .card-description{color:var(--muted);font-size:.95rem;margin-bottom:18px;line-height:1.55}

      .card-link{
        display:inline-block;border:none;color:#fff;font-weight:700;
        padding:10px 18px;border-radius:12px;text-decoration:none;
        background:linear-gradient(135deg,var(--primary),var(--primary-600));
        box-shadow:0 8px 18px rgba(42,141,242,.28);
        transition:filter .2s ease, transform .05s ease;
      }
      .card-link:hover{filter:brightness(1.07)}
      .card-link:active{transform:translateY(1px)}

      /* Trợ năng: khi focus bằng bàn phím */
      :focus-visible{outline:3px solid rgba(42,141,242,.35);outline-offset:2px}
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

