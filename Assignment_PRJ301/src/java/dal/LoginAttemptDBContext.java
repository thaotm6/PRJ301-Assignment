/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dal;

import java.sql.*;
import java.util.ArrayList;
import java.util.logging.Level;
import java.util.logging.Logger;
import model.LoginAttempt;

public class LoginAttemptDBContext extends DBContext<LoginAttempt> {
    
    /**
     * Ghi log lần đăng nhập (thành công hoặc thất bại)
     * @param username Tên đăng nhập
     * @param ipAddress Địa chỉ IP
     * @param success true nếu thành công, false nếu thất bại
     * @param failureReason Lý do thất bại (nếu có)
     */
    public void logLoginAttempt(String username, String ipAddress, boolean success, String failureReason) {
        try {
            String sql = """
                         INSERT INTO [LoginAttempt] ([username], [attempt_time], [ip_address], [success], [failure_reason])
                         VALUES (?, GETDATE(), ?, ?, ?)
                         """;
            PreparedStatement stm = connection.prepareStatement(sql);
            stm.setString(1, username);
            stm.setString(2, ipAddress);
            stm.setBoolean(3, success);
            stm.setString(4, failureReason);
            stm.executeUpdate();
        } catch (SQLException ex) {
            Logger.getLogger(LoginAttemptDBContext.class.getName()).log(Level.SEVERE, null, ex);
        } finally {
            closeConnection();
        }
    }
    
    /**
     * Đếm số lần đăng nhập thất bại trong khoảng thời gian (ví dụ: 15 phút gần nhất)
     * @param username Tên đăng nhập
     * @param minutes Số phút gần nhất để kiểm tra
     * @return Số lần đăng nhập thất bại
     */
    public int countFailedAttempts(String username, int minutes) {
        try {
            String sql = """
                         SELECT COUNT(*) as count
                         FROM [LoginAttempt]
                         WHERE [username] = ? 
                         AND [success] = 0
                         AND [attempt_time] >= DATEADD(MINUTE, -?, GETDATE())
                         """;
            PreparedStatement stm = connection.prepareStatement(sql);
            stm.setString(1, username);
            stm.setInt(2, minutes);
            ResultSet rs = stm.executeQuery();
            if (rs.next()) {
                return rs.getInt("count");
            }
        } catch (SQLException ex) {
            Logger.getLogger(LoginAttemptDBContext.class.getName()).log(Level.SEVERE, null, ex);
        } finally {
            closeConnection();
        }
        return 0;
    }
    
    @Override
    public ArrayList<LoginAttempt> list() {
        throw new UnsupportedOperationException("Not supported yet.");
    }

    @Override
    public LoginAttempt get(int id) {
        throw new UnsupportedOperationException("Not supported yet.");
    }

    @Override
    public void insert(LoginAttempt model) {
        throw new UnsupportedOperationException("Not supported yet.");
    }

    @Override
    public void update(LoginAttempt model) {
        throw new UnsupportedOperationException("Not supported yet.");
    }

    @Override
    public void delete(LoginAttempt model) {
        throw new UnsupportedOperationException("Not supported yet.");
    }
}

