/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package controller.request;

import controller.iam.BaseRequiredAuthorizationController;
import dal.RequestForLeaveDBContext;
import dal.RoleDBContext;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import model.Employee;
import model.RequestForLeave;
import model.iam.User;

@WebServlet(urlPatterns = "/request/review")
public class ReviewController extends BaseRequiredAuthorizationController {

    @Override
    protected void processPost(HttpServletRequest req, HttpServletResponse resp, User user) throws ServletException, IOException {
        ensureRolesLoaded(req, user);
        
        String ridParam = req.getParameter("rid");
        String decision = req.getParameter("decision");
        String note = req.getParameter("note");
        Integer rid = parseRequestId(ridParam);
        
        if (rid == null) {
            req.setAttribute("error", "Mã đơn không hợp lệ.");
            forwardWithRequest(req, resp, null, user, null);
            return;
        }
        
        RequestForLeave targetRequest = loadRequest(rid);
        if (targetRequest == null) {
            req.setAttribute("error", "Không tìm thấy đơn nghỉ phép.");
            forwardWithRequest(req, resp, null, user, null);
            return;
        }
        
        boolean isSupervisor = isSupervisorOf(user, targetRequest);
        boolean canAct = isSupervisor && targetRequest.getStatus() != null
                && targetRequest.getStatus() == RequestForLeave.STATUS_INPROGRESS;
        if (!canAct) {
            req.setAttribute("error", "Bạn không thể xử lý đơn này (có thể đã được xử lý hoặc bạn không có quyền).");
            forwardWithRequest(req, resp, targetRequest, user, targetRequest.getProcessNote());
            return;
        }
        
        if (decision == null || (!"approve".equalsIgnoreCase(decision) && !"reject".equalsIgnoreCase(decision))) {
            req.setAttribute("error", "Vui lòng chọn hành động hợp lệ.");
            req.setAttribute("noteInput", note);
            forwardWithRequest(req, resp, targetRequest, user, note);
            return;
        }
        String trimmedNote = note != null ? note.trim() : null;
        if ("reject".equalsIgnoreCase(decision) && (trimmedNote == null || trimmedNote.isEmpty())) {
            req.setAttribute("error", "Vui lòng nhập lý do khi từ chối đơn.");
            req.setAttribute("noteInput", note);
            forwardWithRequest(req, resp, targetRequest, user, note);
            return;
        }
        if (trimmedNote != null && trimmedNote.length() > 255) {
            req.setAttribute("error", "Ghi chú xử lý không được vượt quá 255 ký tự.");
            req.setAttribute("noteInput", note);
            forwardWithRequest(req, resp, targetRequest, user, note);
            return;
        }
        
        int newStatus = "approve".equalsIgnoreCase(decision)
                ? RequestForLeave.STATUS_APPROVED
                : RequestForLeave.STATUS_REJECTED;
        
        RequestForLeaveDBContext updateDb = new RequestForLeaveDBContext();
        boolean updated = updateDb.updateStatus(rid, newStatus,
                user.getEmployee() != null ? user.getEmployee().getId() : -1,
                (trimmedNote != null && !trimmedNote.isEmpty()) ? trimmedNote : null);
        
        if (!updated) {
            req.setAttribute("error", "Không thể cập nhật đơn nghỉ phép. Có thể đơn đã được xử lý trước đó.");
            req.setAttribute("noteInput", note);
        } else {
            req.setAttribute("success", newStatus == RequestForLeave.STATUS_APPROVED
                    ? "Đã duyệt đơn nghỉ phép thành công."
                    : "Đã từ chối đơn nghỉ phép.");
        }
        
        RequestForLeave refreshed = loadRequest(rid);
        req.setAttribute("noteInput", updated && refreshed != null ? refreshed.getProcessNote() : note);
        forwardWithRequest(req, resp, refreshed != null ? refreshed : targetRequest, user,
                updated && refreshed != null ? refreshed.getProcessNote() : note);
    }
    @Override
    protected void processGet(HttpServletRequest req, HttpServletResponse resp, User user) throws ServletException, IOException {
        ensureRolesLoaded(req, user);
        
        String ridParam = req.getParameter("rid");
        Integer rid = parseRequestId(ridParam);
        
        if (rid == null) {
            req.setAttribute("error", "Mã đơn không hợp lệ.");
            forwardWithRequest(req, resp, null, user, null);
            return;
        }
        
        RequestForLeave targetRequest = loadRequest(rid);
        if (targetRequest == null) {
            req.setAttribute("error", "Không tìm thấy đơn nghỉ phép.");
            forwardWithRequest(req, resp, null, user, null);
            return;
        }
        
        forwardWithRequest(req, resp, targetRequest, user, targetRequest.getProcessNote());
    }
    
    private void ensureRolesLoaded(HttpServletRequest req, User user) {
        if (user.getRoles().isEmpty()) {
            RoleDBContext roleDB = new RoleDBContext();
            user.setRoles(roleDB.getByUserId(user.getId()));
            req.getSession().setAttribute("auth", user);
        }
    }
    
    private Integer parseRequestId(String ridParam) {
        if (ridParam == null || ridParam.trim().isEmpty()) {
            return null;
        }
        try {
            return Integer.parseInt(ridParam);
        } catch (NumberFormatException ex) {
            return null;
        }
    }
    
    private RequestForLeave loadRequest(int rid) {
        RequestForLeaveDBContext db = new RequestForLeaveDBContext();
        return db.get(rid);
    }
    
    private boolean isSupervisorOf(User user, RequestForLeave request) {
        if (user == null || request == null || user.getEmployee() == null || request.getCreatedBy() == null) {
            return false;
        }
        Employee employee = user.getEmployee();
        if (employee.getId() == request.getCreatedBy().getId()) {
            return false;
        }
        RequestForLeaveDBContext db = new RequestForLeaveDBContext();
        return db.isSupervisor(employee.getId(), request.getCreatedBy().getId());
    }
    
    private void forwardWithRequest(HttpServletRequest req, HttpServletResponse resp,
            RequestForLeave targetRequest, User user, String noteValue) throws ServletException, IOException {
        
        boolean isSupervisor = targetRequest != null && isSupervisorOf(user, targetRequest);
        boolean canAct = targetRequest != null
                && targetRequest.getStatus() != null
                && targetRequest.getStatus() == RequestForLeave.STATUS_INPROGRESS
                && isSupervisor;
        
        req.setAttribute("currentUser", user);
        req.setAttribute("targetRequest", targetRequest);
        req.setAttribute("isSupervisor", isSupervisor);
        req.setAttribute("canAct", canAct);
        if (noteValue != null) {
            req.setAttribute("noteInput", noteValue);
        } else if (targetRequest != null) {
            req.setAttribute("noteInput", targetRequest.getProcessNote());
        }
        
        req.getRequestDispatcher("/view/request/review.jsp").forward(req, resp);
    }
    
}
