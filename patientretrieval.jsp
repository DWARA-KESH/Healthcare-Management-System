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

    String url = "jdbc:mysql://localhost:3306/patient_signup";
    String usernameDB = "root";
    String passwordDB = "";

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        Connection conn = DriverManager.getConnection(url, usernameDB, passwordDB);

        String retrieveSql = "SELECT * FROM patientprofile WHERE usern = ?";
        PreparedStatement retrieveStmt = conn.prepareStatement(retrieveSql);
        retrieveStmt.setString(1, username);
        
        ResultSet rs = retrieveStmt.executeQuery();
        if (rs.next()) {
            String firstname = rs.getString("firstname");
            String lastname = rs.getString("lastname");
            String gender = rs.getString("gender");
            String age = rs.getString("age");
            String address1 = rs.getString("address1");
            String address2 = rs.getString("address2");
            String phoneNumber = rs.getString("phonenum");
            
            String redirectURL = "patientprofile.jsp?firstname=" + URLEncoder.encode(firstname, "UTF-8") +"&lastname=" + URLEncoder.encode(lastname, "UTF-8") +"&gender=" + URLEncoder.encode(gender, "UTF-8") +"&age=" + URLEncoder.encode(age, "UTF-8") +"&address1=" + URLEncoder.encode(address1, "UTF-8") +"&address2=" + URLEncoder.encode(address2, "UTF-8") +"&phoneNumber=" + URLEncoder.encode(phoneNumber, "UTF-8");
            response.sendRedirect(redirectURL);
        } else {
            response.sendRedirect("patientprofile.jsp");
        }

        rs.close();
        retrieveStmt.close();
        conn.close();
    } catch (SQLException | ClassNotFoundException ex) {
        ex.printStackTrace();
    } catch (UnsupportedEncodingException ex) {
        ex.printStackTrace();
    }
%>
