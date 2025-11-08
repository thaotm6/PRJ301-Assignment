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