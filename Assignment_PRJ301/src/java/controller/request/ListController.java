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
import java.util.ArrayList;
import model.RequestForLeave;
import model.iam.Feature;
import model.iam.Role;
import model.iam.User;

@WebServlet(urlPatterns = "/request/list")
public class ListController extends BaseRequiredAuthorizationController {

    @Override
    protected void processPost(HttpServletRequest req, HttpServletResponse resp, User user) throws ServletException, IOException {
        processGet(req, resp, user);
    }

    @Override
    protected void processGet(HttpServletRequest req, HttpServletResponse resp, User user) throws ServletException, IOException {
        // Load roles nếu chưa có
        if (user.getRoles().isEmpty()) {
            RoleDBContext roleDB = new RoleDBContext();
            user.setRoles(roleDB.getByUserId(user.getId()));
            req.getSession().setAttribute("auth", user);
        }
        
        boolean canViewSubordinates = false;
        boolean canReview = false;
        for (Role role : user.getRoles()) {
            if (!canViewSubordinates && (role.getId() == 1 || role.getId() == 2)) {
                canViewSubordinates = true;
            }
            if (!canReview) {
                for (Feature feature : role.getFeatures()) {
                    if ("/request/review".equalsIgnoreCase(feature.getUrl())) {
                        canReview = true;
                        break;
                    }
                }
            }
            if (canViewSubordinates && canReview) {
                break;
            }
        }
        // Lấy danh sách đơn
        RequestForLeaveDBContext db = new RequestForLeaveDBContext();
        ArrayList<RequestForLeave> requests;
        
        if (user.getEmployee() != null) {
            requests = db.getByEmployeeId(user.getEmployee().getId(), canViewSubordinates);
        } else {
            requests = new ArrayList<>();
        }
        
        // Set vào request để hiển thị trong view
        req.setAttribute("user", user);
        req.setAttribute("requests", requests);
        req.setAttribute("canViewSubordinates", canViewSubordinates);
        req.setAttribute("canReview", canReview);
        
        req.getRequestDispatcher("/view/request/list.jsp").forward(req, resp);
    }
    
}