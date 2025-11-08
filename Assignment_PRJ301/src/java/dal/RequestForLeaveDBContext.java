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
    /**
     * Lấy đơn xin nghỉ phép theo ID
     */
    @Override
    public RequestForLeave get(int id) {
        try {
            String sql = """
                         SELECT r.rid, r.created_by, r.create_time, r.[from], r.[to], r.reason, r.status,
                                r.processed_by, r.processed_time, r.process_note,
                                e.eid, e.ename,
                                p.eid AS processed_eid, p.ename AS processed_ename
                         FROM [RequestForLeave] r
                         INNER JOIN [Employee] e ON r.created_by = e.eid
                         LEFT JOIN [Employee] p ON r.processed_by = p.eid
                         WHERE r.rid = ?
                         """;
            PreparedStatement stm = connection.prepareStatement(sql);
            stm.setInt(1, id);
            ResultSet rs = stm.executeQuery();
            if (rs.next()) {
                RequestForLeave request = new RequestForLeave();
                request.setId(rs.getInt("rid"));
                request.setCreateTime(rs.getTimestamp("create_time"));
                request.setFrom(rs.getDate("from"));
                request.setTo(rs.getDate("to"));
                request.setReason(rs.getString("reason"));
                request.setStatus(rs.getInt("status"));
                request.setProcessedTime(rs.getTimestamp("processed_time"));
                request.setProcessNote(rs.getString("process_note"));
                
                int processedId = rs.getInt("processed_eid");
                if (!rs.wasNull()) {
                    Employee processedEmployee = new Employee();
                    processedEmployee.setId(processedId);
                    processedEmployee.setName(rs.getString("processed_ename"));
                    request.setProcessedBy(processedEmployee);
                }
                
                Employee employee = new Employee();
                employee.setId(rs.getInt("eid"));
                employee.setName(rs.getString("ename"));
                request.setCreatedBy(employee);
                
                return request;
            }
        } catch (SQLException ex) {
            Logger.getLogger(RequestForLeaveDBContext.class.getName()).log(Level.SEVERE, null, ex);
        } finally {
            closeConnection();
        }
        return null;
    }
     /**
     * Lấy danh sách đơn xin nghỉ phép của một nhân viên và tất cả cấp dưới (recursive)
     * @param employeeId ID của nhân viên
     * @param includeSubordinates true nếu muốn lấy cả đơn của cấp dưới
     * @return Danh sách đơn xin nghỉ phép
     */
    public ArrayList<RequestForLeave> getByEmployeeId(int employeeId, boolean includeSubordinates) {
        ArrayList<RequestForLeave> requests = new ArrayList<>();
        try {
            String sql;
            if (includeSubordinates) {
                // Lấy đơn của nhân viên và tất cả cấp dưới (recursive CTE)
                sql = """
                      WITH Subordinates AS (
                          SELECT eid FROM [Employee] WHERE eid = ?
                          UNION ALL
                          SELECT e.eid 
                          FROM [Employee] e
                          INNER JOIN Subordinates s ON e.supervisorid = s.eid
                      )
                      SELECT r.rid, r.created_by, r.create_time, r.[from], r.[to], r.reason, r.status,
                             r.processed_by, r.processed_time, r.process_note,
                             e.eid, e.ename,
                             p.eid AS processed_eid, p.ename AS processed_ename
                      FROM [RequestForLeave] r
                      INNER JOIN [Employee] e ON r.created_by = e.eid
                      LEFT JOIN [Employee] p ON r.processed_by = p.eid
                      WHERE r.created_by IN (SELECT eid FROM Subordinates)
                      ORDER BY r.create_time DESC
                      """;
            } else {
                // Chỉ lấy đơn của nhân viên
                sql = """
                      SELECT r.rid, r.created_by, r.create_time, r.[from], r.[to], r.reason, r.status,
                             r.processed_by, r.processed_time, r.process_note,
                             e.eid, e.ename,
                             p.eid AS processed_eid, p.ename AS processed_ename
                      FROM [RequestForLeave] r
                      INNER JOIN [Employee] e ON r.created_by = e.eid
                      LEFT JOIN [Employee] p ON r.processed_by = p.eid
                      WHERE r.created_by = ?
                      ORDER BY r.create_time DESC
                      """;
            }
            
            PreparedStatement stm = connection.prepareStatement(sql);
            stm.setInt(1, employeeId);
            ResultSet rs = stm.executeQuery();
            while (rs.next()) {
                RequestForLeave request = new RequestForLeave();
                request.setId(rs.getInt("rid"));
                request.setCreateTime(rs.getTimestamp("create_time"));
                request.setFrom(rs.getDate("from"));
                request.setTo(rs.getDate("to"));
                request.setReason(rs.getString("reason"));
                request.setStatus(rs.getInt("status"));
                request.setProcessedTime(rs.getTimestamp("processed_time"));
                request.setProcessNote(rs.getString("process_note"));
                
                int processedId = rs.getInt("processed_eid");
                if (!rs.wasNull()) {
                    Employee processedEmployee = new Employee();
                    processedEmployee.setId(processedId);
                    processedEmployee.setName(rs.getString("processed_ename"));
                    request.setProcessedBy(processedEmployee);
                }
                
                Employee employee = new Employee();
                employee.setId(rs.getInt("eid"));
                employee.setName(rs.getString("ename"));
                request.setCreatedBy(employee);
                
                requests.add(request);
            }
        } catch (SQLException ex) {
            Logger.getLogger(RequestForLeaveDBContext.class.getName()).log(Level.SEVERE, null, ex);
        } finally {
            closeConnection();
        }
        return requests;
    }
    /**
     * Lấy danh sách đơn xin nghỉ phép của một nhân viên (chỉ đơn của mình)
     */
    public ArrayList<RequestForLeave> getByEmployeeId(int employeeId) {
        return getByEmployeeId(employeeId, false);
    }
    
    /**
     * Cập nhật trạng thái của đơn nghỉ phép (Approve/Reject)
     * @param requestId mã đơn
     * @param newStatus trạng thái mới
     * @param processedById người xử lý
     * @param processNote ghi chú xử lý (có thể null)
     * @return true nếu cập nhật thành công
     */
    public boolean updateStatus(int requestId, int newStatus, int processedById, String processNote) {
        try {
            String sql = """
                         UPDATE [RequestForLeave]
                         SET [status] = ?,
                             [processed_by] = ?,
                             [processed_time] = GETDATE(),
                             [process_note] = ?
                         WHERE [rid] = ? AND [status] = ?
                         """;
            PreparedStatement stm = connection.prepareStatement(sql);
            stm.setInt(1, newStatus);
            if (processedById > 0) {
                stm.setInt(2, processedById);
            } else {
                stm.setNull(2, Types.INTEGER);
            }
            if (processNote != null) {
                stm.setString(3, processNote);
            } else {
                stm.setNull(3, Types.VARCHAR);
            }
            stm.setInt(4, requestId);
            stm.setInt(5, RequestForLeave.STATUS_INPROGRESS);
            
            int affectedRows = stm.executeUpdate();
            return affectedRows > 0;
        } catch (SQLException ex) {
            Logger.getLogger(RequestForLeaveDBContext.class.getName()).log(Level.SEVERE, null, ex);
        } finally {
            closeConnection();
        }
        return false;
    }
    