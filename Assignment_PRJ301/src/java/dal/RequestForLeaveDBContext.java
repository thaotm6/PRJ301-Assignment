/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dal;

import java.sql.*;
import java.util.ArrayList;
import java.util.logging.Level;
import java.util.logging.Logger;
import model.RequestForLeave;
import model.Employee;

public class RequestForLeaveDBContext extends DBContext<RequestForLeave> {
    
    /**
     * Tạo mới đơn xin nghỉ phép
     * @param request Đơn xin nghỉ phép cần tạo (sẽ được set ID sau khi insert)
     */
    @Override
    public void insert(RequestForLeave request) {
        try {
            String sql = """
                         INSERT INTO [RequestForLeave] ([created_by], [create_time], [from], [to], [reason], [status])
                         VALUES (?, GETDATE(), ?, ?, ?, ?)
                         """;
            PreparedStatement stm = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            stm.setInt(1, request.getCreatedBy().getId());
            stm.setDate(2, new java.sql.Date(request.getFrom().getTime()));
            stm.setDate(3, new java.sql.Date(request.getTo().getTime()));
            stm.setString(4, request.getReason());
            stm.setInt(5, request.getStatus() != null ? request.getStatus() : RequestForLeave.STATUS_INPROGRESS);
            
            int affectedRows = stm.executeUpdate();
            if (affectedRows > 0) {
                ResultSet generatedKeys = stm.getGeneratedKeys();
                if (generatedKeys.next()) {
                    int rid = generatedKeys.getInt(1);
                    request.setId(rid);
                }
            }
        } catch (SQLException ex) {
            Logger.getLogger(RequestForLeaveDBContext.class.getName()).log(Level.SEVERE, null, ex);
        } finally {
            closeConnection();
        }
    }
    
    