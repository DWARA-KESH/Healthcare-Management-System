<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html>
<head>
    <title>Show Prescription</title>
    <link href="https://cdn.jsdelivr.net/npm/tailwindcss@2.2.19/dist/tailwind.min.css" rel="stylesheet">
    <style>
        table {
            border-collapse: collapse;
            width: 50%;
            margin: auto;
        }
        th, td {
            border: 1px solid #ddd;
            padding: 8px;
            text-align: left;
            font-size: 30px;
        }
        body {
        background-color: #fef2f2;
        background: linear-gradient(to right, #fef2f2, #e4c2c1);
        overflow-x: hidden;
      }
      nav {
        background-color: #b6666f;
        z-index: 50;
        transition: opacity 0.5s;
      }
      nav.scrolled {
        opacity: 0;
      }
    </style>
</head>
<body>
<nav class="fixed top-0 left-0 w-full z-50">
      <div class="container mx-auto flex justify-between items-center py-4">
        <div class="flex items-center">
          <a href="#">
            <img
              src="./MQ.png"
              alt="Logo"
              class="h-8 mx-5"
              style="border-radius: 16px"
            />
          </a>
        </div>
        <div class="hidden md:flex items-center">
          <p style="color: #fef2f2;">Welcome <%= session.getAttribute("username") %></p>
          <a href="./patientpage.jsp" class="px-5 nav-link" style="color: #fef2f2;"><svg xmlns="http://www.w3.org/2000/svg" width="32" height="32" fill="currentColor" class="bi bi-x" viewBox="0 0 16 16">
  <path d="M4.646 4.646a.5.5 0 0 1 .708 0L8 7.293l2.646-2.647a.5.5 0 0 1 .708.708L8.707 8l2.647 2.646a.5.5 0 0 1-.708.708L8 8.707l-2.646 2.647a.5.5 0 0 1-.708-.708L7.293 8 4.646 5.354a.5.5 0 0 1 0-.708"/>
</svg>
          </a>
        </div>
      </div>
    </nav>
    
    <div class="p-20">
    <table>
        <tr>
            <th>Patient Examination</th>
            <th>Results</th>
        </tr>
        <% 
        // Get the apptid
        String apptid = request.getParameter("apptid");

        String url = "jdbc:mysql://localhost:3306/patient_signup";
        String username = "root";
        String password = "";

        try {
            // Establish database connection
            Connection conn = DriverManager.getConnection(url, username, password);

            // Prepare SQL statement to select prescription data using the apptid
            String sql = "SELECT * FROM prestable WHERE id = ?";
            PreparedStatement pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, apptid);

            // Execute the SQL query
            ResultSet rs = pstmt.executeQuery();

            // Display prescription data in table rows
            if (rs.next()) {
                out.println("<tr><td>Disease</td><td>" + rs.getString("disease") + "</td></tr>");
                out.println("<tr><td>Allergy</td><td>" + rs.getString("allergy") + "</td></tr>");
                out.println("<tr><td>Prescription</td><td>" + rs.getString("prescription") + "</td></tr>");
            } else {
                out.println("<tr><td colspan='2'>No prescription found for appointment ID: " + apptid + "</td></tr>");
            }

            // Close the resources
            rs.close();
            pstmt.close();
            conn.close();
        } catch (SQLException e) {
            out.println("<tr><td colspan='2'>Error: " + e.getMessage() + "</td></tr>");
        }
        %>
    </table>
    </div>
</body>
</html>
