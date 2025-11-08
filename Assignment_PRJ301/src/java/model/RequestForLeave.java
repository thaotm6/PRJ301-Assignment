/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

import java.util.Date;

public class RequestForLeave extends BaseModel {
    // Constants cho trạng thái đơn
    public static final int STATUS_INPROGRESS = 0; // Inprogress - Chờ xử lý
    public static final int STATUS_APPROVED = 1;   // Approved - Đã duyệt
    public static final int STATUS_REJECTED = 2;   // Rejected - Đã từ chối
    
    private Employee createdBy;
    private Date createTime;
    private Date from;
    private Date to;
    private String reason;
    private Integer status; // 0: Inprogress, 1: Approved, 2: Rejected
    private Employee processedBy;
    private Date processedTime;
    private String processNote;
    
    /**
     * Lấy tên trạng thái dạng text
     */
    public String getStatusName() {
        if (status == null) {
            return "Chưa xác định";
        }
        switch (status) {
            case STATUS_INPROGRESS:
                return "Chờ xử lý";
            case STATUS_APPROVED:
                return "Đã duyệt";
            case STATUS_REJECTED:
                return "Đã từ chối";
            default:
                return "Chưa xác định";
        }
    }

    public Employee getCreatedBy() {
        return createdBy;
    }

    public void setCreatedBy(Employee createdBy) {
        this.createdBy = createdBy;
    }

    public Date getCreateTime() {
        return createTime;
    }

    public void setCreateTime(Date createTime) {
        this.createTime = createTime;
    }

    public Date getFrom() {
        return from;
    }

    public void setFrom(Date from) {
        this.from = from;
    }

    public Date getTo() {
        return to;
    }

    public void setTo(Date to) {
        this.to = to;
    }

    public String getReason() {
        return reason;
    }

    public void setReason(String reason) {
        this.reason = reason;
    }

    public Integer getStatus() {
        return status;
    }

    public void setStatus(Integer status) {
        this.status = status;
    }
    
    public Employee getProcessedBy() {
        return processedBy;
    }

    public void setProcessedBy(Employee processedBy) {
        this.processedBy = processedBy;
    }
    
    public Date getProcessedTime() {
        return processedTime;
    }

    public void setProcessedTime(Date processedTime) {
        this.processedTime = processedTime;
    }

    public String getProcessNote() {
        return processNote;
    }

    public void setProcessNote(String processNote) {
        this.processNote = processNote;
    }
    
    /**
     * Lấy tiêu đề hiển thị (rút gọn) dựa trên lý do nghỉ phép
     * @return chuỗi tiêu đề ngắn gọn, tối đa 60 ký tự
     */
    public String getDisplayTitle() {
        if (reason == null) {
            return "";
        }
        String trimmed = reason.trim();
        if (trimmed.length() <= 60) {
            return trimmed;
        }
        return trimmed.substring(0, 57) + "...";
    }
    
}


