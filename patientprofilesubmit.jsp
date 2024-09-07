<%@ page import="java.sql.*" %>
<%@ page import="java.io.*" %>
<%@ page import="java.util.*" %>
<%@ page import="java.net.URLEncoder" %>


<%
    String username = null;
    Object usernameObj = session.getAttribute("username");
    if (usernameObj != null) {
        username = usernameObj.toString();
    }
    long pid = 0;
    Object pidObj = session.getAttribute("pid");
    if (pidObj != null) {
        if (pidObj instanceof Long) {
            pid = (Long) pidObj;
        }
    }
    out.println(pid);
    String firstName = request.getParameter("firstname");
    String lastName = request.getParameter("lastname");
    String gender = request.getParameter("gender");
    String age = request.getParameter("age");
    String address1 = request.getParameter("address1");
    String address2 = request.getParameter("address2");
    String phoneNumber = request.getParameter("phoneNumber");

    String url = "jdbc:mysql://localhost:3306/patient_signup";
    String usernameDB = "root";
    String passwordDB = "";

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        Connection conn = DriverManager.getConnection(url, usernameDB, passwordDB);

        String checkSql = "SELECT usern FROM patientprofile WHERE usern = ?";
        PreparedStatement checkStmt = conn.prepareStatement(checkSql);
        checkStmt.setString(1, username);
        ResultSet rs = checkStmt.executeQuery();
        if (rs.next()) {
            String updateSql = "UPDATE patientprofile SET firstname = ?, lastname = ?, gender = ?, age = ?, address1 = ?, address2 = ?, phonenum = ?, pid = ? WHERE usern = ?";
            PreparedStatement updateStmt = conn.prepareStatement(updateSql);
            updateStmt.setString(1, firstName);
            updateStmt.setString(2, lastName);
            updateStmt.setString(3, gender);
            updateStmt.setString(4, age);
            updateStmt.setString(5, address1);
            updateStmt.setString(6, address2);
            updateStmt.setString(7, phoneNumber);
            updateStmt.setLong(8, pid);
            updateStmt.setString(9, username);
            int rowsAffected = updateStmt.executeUpdate();
            if (rowsAffected > 0) {
                String message = "User updated successfully";
                String redirectUrl = "patientprofile.jsp?message=" + URLEncoder.encode(message, "UTF-8") + "&firstname=" + URLEncoder.encode(firstName, "UTF-8") + "&lastname=" + URLEncoder.encode(lastName, "UTF-8") + "&gender=" + URLEncoder.encode(gender, "UTF-8") + "&age=" + URLEncoder.encode(age, "UTF-8") + "&address1=" + URLEncoder.encode(address1, "UTF-8") + "&address2=" + URLEncoder.encode(address2, "UTF-8") + "&phoneNumber=" + URLEncoder.encode(phoneNumber, "UTF-8");
                response.sendRedirect(redirectUrl);
            } else {
                out.println("Error: User update failed!");
            }
        } else {
            String insertSql = "INSERT INTO patientprofile (firstname, lastname, gender, age, address1, address2, phonenum, usern, pid) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";
            PreparedStatement insertStmt = conn.prepareStatement(insertSql);
            
            insertStmt.setString(1, firstName);
            insertStmt.setString(2, lastName);
            insertStmt.setString(3, gender);
            insertStmt.setString(4, age);
            insertStmt.setString(5, address1);
            insertStmt.setString(6, address2);
            insertStmt.setString(7, phoneNumber);
            insertStmt.setString(8, username);
            insertStmt.setLong(9, pid);
            int rowsAffected = insertStmt.executeUpdate();
            if (rowsAffected > 0) {
                String message1 = "User inserted successfully";
                String redirect = "patientprofile.jsp?message=" + URLEncoder.encode(message1, "UTF-8") + "&firstname=" + URLEncoder.encode(firstName, "UTF-8") + "&lastname=" + URLEncoder.encode(lastName, "UTF-8") + "&gender=" + URLEncoder.encode(gender, "UTF-8") + "&age=" + URLEncoder.encode(age, "UTF-8") + "&address1=" + URLEncoder.encode(address1, "UTF-8") + "&address2=" + URLEncoder.encode(address2, "UTF-8") + "&phoneNumber=" + URLEncoder.encode(phoneNumber, "UTF-8");
                response.sendRedirect(redirect);
            } else {
                out.println("Error: User registration failed!");
            }
        }

        conn.close();
    } catch (ClassNotFoundException | SQLException e) {
        out.println("Error: " + e.getMessage());
    }
%>