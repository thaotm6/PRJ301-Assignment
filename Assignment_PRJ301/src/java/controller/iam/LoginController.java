/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package controller.iam;

import dal.LoginAttemptDBContext;
import dal.UserDBContext;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import model.iam.User;

@WebServlet(urlPatterns = "/login")
public class LoginController extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        // Nếu đã đăng nhập, redirect về home
        HttpSession session = req.getSession(false);
        if (session != null && session.getAttribute("auth") != null) {
            resp.sendRedirect(req.getContextPath() + "/home");
            return;
        }
        req.getRequestDispatcher("view/auth/login.jsp").forward(req, resp);
    }
    
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String username = req.getParameter("username");
        String password = req.getParameter("password");
        
        // Validation và sanitization
        if (username == null || username.trim().isEmpty()) {
            req.setAttribute("error", "Tên đăng nhập không được để trống!");
            req.getRequestDispatcher("view/auth/login.jsp").forward(req, resp);
            return;
        }
        
        if (password == null || password.trim().isEmpty()) {
            req.setAttribute("error", "Mật khẩu không được để trống!");
            req.getRequestDispatcher("view/auth/login.jsp").forward(req, resp);
            return;
        }
        
        // Sanitize input - loại bỏ khoảng trắng thừa
        username = username.trim();
        password = password.trim();
        
        // Kiểm tra độ dài username (bảo mật)
        if (username.length() > 150) {
            req.setAttribute("error", "Tên đăng nhập quá dài!");
            req.getRequestDispatcher("view/auth/login.jsp").forward(req, resp);
            return;
        }
         try {
            // Lấy IP address
            String ipAddress = getClientIpAddress(req);
            
            // Kiểm tra số lần đăng nhập thất bại (bảo mật - chống brute force)
            LoginAttemptDBContext attemptCounter = new LoginAttemptDBContext();
            int failedAttempts = attemptCounter.countFailedAttempts(username, 15); // 15 phút gần nhất
            
            if (failedAttempts >= 5) {
                // Quá nhiều lần thất bại, chặn tạm thời
                req.setAttribute("error", "Tài khoản đã bị khóa tạm thời do quá nhiều lần đăng nhập thất bại. Vui lòng thử lại sau 15 phút!");
                req.setAttribute("username", username);
                logAttempt(username, ipAddress, false, "Account temporarily locked due to too many failed attempts");
                req.getRequestDispatcher("view/auth/login.jsp").forward(req, resp);
                return;
            }
            
            UserDBContext db = new UserDBContext();
            User u = db.get(username, password);
            
            if (u != null) {
                // Login thành công
                HttpSession session = req.getSession();
                session.setAttribute("auth", u);
                session.setMaxInactiveInterval(30 * 60); // Session timeout: 30 phút
                
                // Log thành công
                logAttempt(username, ipAddress, true, null);
                
                // Lấy URL redirect nếu có (từ parameter hoặc referer)
                String redirectUrl = req.getParameter("redirect");
                if (redirectUrl == null || redirectUrl.isEmpty()) {
                    redirectUrl = req.getContextPath() + "/home";
                } else {
                    // Đảm bảo redirect URL có context path
                    if (!redirectUrl.startsWith(req.getContextPath())) {
                        redirectUrl = req.getContextPath() + redirectUrl;
                    }
                }