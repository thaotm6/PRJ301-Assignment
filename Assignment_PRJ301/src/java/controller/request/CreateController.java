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
        
        // Parse dates
        SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
        Date fromDate = null;
        Date toDate = null;
        
        try {
            fromDate = dateFormat.parse(fromDateStr);
            toDate = dateFormat.parse(toDateStr);
        } catch (ParseException ex) {
            req.setAttribute("error", "Ngày tháng không hợp lệ!");
            prepareFormData(req, user, null);
            req.getRequestDispatcher("/view/request/create.jsp").forward(req, resp);
            return;
        }
        
        // Kiểm tra ngày bắt đầu phải trước hoặc bằng ngày kết thúc
        if (fromDate.after(toDate)) {
            req.setAttribute("error", "Ngày bắt đầu phải trước hoặc bằng ngày kết thúc!");
            prepareFormData(req, user, null);
            req.getRequestDispatcher("/view/request/create.jsp").forward(req, resp);
            return;
        }
        
        // Kiểm tra ngày bắt đầu không được là quá khứ (tùy chọn - có thể cho phép nghỉ trong quá khứ)
        java.util.Calendar cal = java.util.Calendar.getInstance();
        cal.set(java.util.Calendar.HOUR_OF_DAY, 0);
        cal.set(java.util.Calendar.MINUTE, 0);
        cal.set(java.util.Calendar.SECOND, 0);
        cal.set(java.util.Calendar.MILLISECOND, 0);
        Date today = cal.getTime();
        if (fromDate.before(today)) {
            req.setAttribute("error", "Ngày bắt đầu không được là quá khứ!");
            prepareFormData(req, user, null);
            req.getRequestDispatcher("/view/request/create.jsp").forward(req, resp);
            return;
        }
        
        try {
            // Tạo đơn nghỉ phép
            RequestForLeave request = new RequestForLeave();
            request.setCreatedBy(user.getEmployee());
            request.setFrom(fromDate);
            request.setTo(toDate);
            request.setReason(reason.trim());
            request.setStatus(RequestForLeave.STATUS_INPROGRESS); // Trạng thái Inprogress khi mới tạo
            
            // Lưu vào database
            RequestForLeaveDBContext db = new RequestForLeaveDBContext();
            db.insert(request);
            
            if (request.getId() > 0) {
                // Tạo thành công
                req.setAttribute("message", "Tạo đơn nghỉ phép thành công! Mã đơn: #" + request.getId());
                req.setAttribute("fromDate", null);
                req.setAttribute("toDate", null);
                req.setAttribute("reason", null);
                prepareFormData(req, user, request);
                req.getRequestDispatcher("/view/request/create.jsp").forward(req, resp);
            } else {
                // Lỗi khi tạo
                req.setAttribute("error", "Đã xảy ra lỗi khi tạo đơn nghỉ phép. Vui lòng thử lại!");
                prepareFormData(req, user, null);
                req.getRequestDispatcher("/view/request/create.jsp").forward(req, resp);
            }
        } catch (Exception ex) {
            // Xử lý lỗi hệ thống
            req.setAttribute("error", "Đã xảy ra lỗi hệ thống. Vui lòng thử lại sau!");
            prepareFormData(req, user, null);
            req.getRequestDispatcher("/view/request/create.jsp").forward(req, resp);
        }
    }
    
    private void prepareFormData(HttpServletRequest req, User user, RequestForLeave latestRequest) {
        Employee employee = user.getEmployee();
        req.setAttribute("currentUser", user);
        if (employee != null) {
            req.setAttribute("employeeName", employee.getName());
            Department dept = employee.getDept();
            req.setAttribute("employeeDeptName", dept != null ? dept.getName() : "Chưa cập nhật");
        } else {
            req.setAttribute("employeeName", "Không xác định");
            req.setAttribute("employeeDeptName", "Chưa cập nhật");
        }
        
        List<Role> roles = user.getRoles();
        req.setAttribute("userRoles", roles);
        String roleSummary = roles != null && !roles.isEmpty()
                ? roles.stream()
                        .map(Role::getName)
                        .filter(Objects::nonNull)
                        .distinct()
                        .collect(Collectors.joining(", "))
                : "Chưa được phân quyền";
        req.setAttribute("roleSummary", roleSummary);
        
        SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
        String todayStr = dateFormat.format(new Date());
        req.setAttribute("today", todayStr);
        
        Object fromAttr = req.getAttribute("fromDate");
        String fromDateValue = null;
        if (fromAttr instanceof String) {
            fromDateValue = (String) fromAttr;
        } else if (fromAttr != null) {
            fromDateValue = fromAttr.toString();
        }
        if (fromDateValue == null || fromDateValue.isBlank()) {
            req.setAttribute("fromDate", todayStr);
            fromDateValue = todayStr;
        }
        
        Object toAttr = req.getAttribute("toDate");
        String toDateValue = null;
        if (toAttr instanceof String) {
            toDateValue = (String) toAttr;
        } else if (toAttr != null) {
            toDateValue = toAttr.toString();
        }
        if (toDateValue == null || toDateValue.isBlank()) {
            req.setAttribute("toDate", fromDateValue);
        }
        
        Object reasonAttr = req.getAttribute("reason");
        if (reasonAttr == null) {
            req.setAttribute("reason", "");
        }
        
        if (latestRequest != null) {
            req.setAttribute("latestRequestId", latestRequest.getId());
            req.setAttribute("latestRequestStatus", latestRequest.getStatusName());
        }
    }
    
}
