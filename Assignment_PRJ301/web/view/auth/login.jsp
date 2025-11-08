<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
  <head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đăng nhập - Hệ thống quản lý</title>
    <style>
      /* ===== Blue Sea – Pastel, dịu mắt ===== */
      *{margin:0;padding:0;box-sizing:border-box}
      :root{
        --bg-1:#bfe6ff;        /* xanh nhạt */
        --bg-2:#81d4fa;        /* xanh biển dịu */
        --text:#0c2a3f;        /* chữ chính */
        --muted:#3f6b8a;       /* chữ phụ */
        --surface:#ffffffee;   /* nền thẻ */
        --primary:#2a8df2;     /* xanh chủ đạo */
        --primary-200:#90caf9; /* viền nhạt */
        --primary-600:#1877f2; /* hover */
        --shadow:0 18px 48px rgba(9,30,66,.15);
        --radius:18px;
      }

      body{
        font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        min-height:100vh;
        display:flex; align-items:center; justify-content:center;
        padding:20px;
        color:var(--text);
        background: linear-gradient(135deg, var(--bg-1), var(--bg-2));
        background-attachment: fixed;
      }

      .login-container{
        width:100%; max-width:460px;
        background:var(--surface);
        border-radius:var(--radius);
        padding:44px 38px;
        box-shadow:var(--shadow);
        backdrop-filter: blur(2px);
      }

      .login-header{ text-align:center; margin-bottom:28px }
      .login-header h1{
        font-size:2rem; font-weight:700; color:var(--text); margin-bottom:8px
      }
      .login-header p{ color:var(--muted); font-size:.95rem }

      .form-group{ margin-bottom:18px }
      .form-group label{
        display:block; color:var(--muted); font-weight:600;
        margin-bottom:6px; font-size:.95rem
      }
      .form-group input{
        width:100%; padding:12px 14px; font-size:1rem; outline:0;
        border:1px solid var(--primary-200); border-radius:10px;
        background:#fff; color:var(--text);
        transition:border-color .2s ease, box-shadow .2s ease, background .2s;
      }
      .form-group input::placeholder{ color:#8aa7bf }
      .form-group input:focus{
        border-color:var(--primary);
        box-shadow:0 0 0 3px rgba(42,141,242,.18);
      }

      .login-button{
        width:100%; margin-top:6px; padding:14px;
        border:none; border-radius:10px; color:#fff; font-weight:700; font-size:1.05rem;
        background: linear-gradient(135deg, var(--primary), var(--primary-600));
        cursor:pointer; box-shadow:0 8px 18px rgba(42,141,242,.35);
        transition: filter .2s ease, transform .05s ease, box-shadow .2s ease;
      }
      .login-button:hover{ filter:brightness(1.05) }
      .login-button:active{ transform:translateY(1px) }

      .back-link{ text-align:center; margin-top:16px }
      .back-link a{
        color:var(--primary); text-decoration:none; font-size:.92rem;
      }
      .back-link a:hover{ text-decoration:underline }

      /* Thông báo trạng thái */
      .alert{
        padding:12px; border-radius:10px; margin-bottom:16px; font-size:.95rem
      }
      .alert-error{
        background:#ffefef; color:#b42318; border:1px solid #ffd2d2;
      }
      .alert-ok{
        background:#effaf3; color:#1b7f43; border:1px solid #c7edd8;
      }

      /* Tăng tương phản nút/tab khi người dùng dùng bàn phím */
      :focus-visible{ outline:3px solid rgba(42,141,242,.35); outline-offset:2px }
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
          <div class="alert alert-error">${requestScope.error}</div>
        </c:if>
        <c:if test="${not empty requestScope.message}">
          <div class="alert alert-ok">${requestScope.message}</div>
        </c:if>

        <div class="form-group">
          <label for="txtUsername">Tên đăng nhập</label>
          <input type="text" name="username" id="txtUsername"
                 placeholder="Nhập tên đăng nhập"
                 value="${requestScope.username}" required />
        </div>

        <div class="form-group">
          <label for="txtPassword">Mật khẩu</label>
          <input type="password" name="password" id="txtPassword"
                 placeholder="Nhập mật khẩu" required />
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
