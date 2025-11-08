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