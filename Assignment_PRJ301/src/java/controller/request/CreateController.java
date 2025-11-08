/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package controller.request;

import controller.iam.BaseRequiredAuthorizationController;
import dal.RequestForLeaveDBContext;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Objects;
import model.RequestForLeave;
import model.iam.User;
import model.Employee;
import model.Department;
import model.iam.Role;
import java.util.List;
import java.util.stream.Collectors;

@WebServlet(urlPatterns = "/request/create")
public class CreateController extends BaseRequiredAuthorizationController {

    @Override
    protected void processGet(HttpServletRequest req, HttpServletResponse resp, User user) throws ServletException, IOException {
        // Hiển thị form tạo đơn nghỉ phép
        prepareFormData(req, user, null);
        req.getRequestDispatcher("/view/request/create.jsp").forward(req, resp);
    }

    @Override
    protected void processPost(HttpServletRequest req, HttpServletResponse resp, User user) throws ServletException, IOException {
        // Lấy thông tin từ form
        String fromDateStr = req.getParameter("fromDate");
        String toDateStr = req.getParameter("toDate");
        String reason = req.getParameter("reason");
        reason = reason != null ? reason.trim() : null;
        
        req.setAttribute("fromDate", fromDateStr);
        req.setAttribute("toDate", toDateStr);
        req.setAttribute("reason", reason);
        
        prepareFormData(req, user, null);
        
        // Validation
        if (fromDateStr == null || fromDateStr.trim().isEmpty()) {
            req.setAttribute("error", "Vui lòng chọn ngày bắt đầu nghỉ!");
            prepareFormData(req, user, null);
            req.getRequestDispatcher("/view/request/create.jsp").forward(req, resp);
            return;
        }
        
        if (toDateStr == null || toDateStr.trim().isEmpty()) {
            req.setAttribute("error", "Vui lòng chọn ngày kết thúc nghỉ!");
            prepareFormData(req, user, null);
            req.getRequestDispatcher("/view/request/create.jsp").forward(req, resp);
            return;
        }
        
        if (reason == null || reason.trim().isEmpty()) {
            req.setAttribute("error", "Vui lòng nhập lý do nghỉ phép!");
            prepareFormData(req, user, null);
            req.getRequestDispatcher("/view/request/create.jsp").forward(req, resp);
            return;
        }
        