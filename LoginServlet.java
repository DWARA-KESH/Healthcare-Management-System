import java.io.IOException;
import java.io.PrintWriter;
import java.io.*;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession; // Import HttpSession class

@WebServlet("/login")
public class LoginServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
        throws ServletException, IOException {
        
        String username = request.getParameter("username");
        String plainTextPassword = request.getParameter("password");
        
        String url = "jdbc:mysql://localhost:3306/patient_signup";
        String usernameDB = "root";
        String passwordDB = "";
        
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection conn = DriverManager.getConnection(url, usernameDB, passwordDB);
            String sql = "SELECT id,password FROM patients WHERE username = ?";
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setString(1, username);
            
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                String hashedPassword = PasswordHashing.hashPassword(plainTextPassword);
                String storedPassword = rs.getString("password");
                long pid = rs.getLong("id");

                if (hashedPassword.equals(storedPassword)) {
                    // Create session and store user information
                    HttpSession session = request.getSession();
                    session.setAttribute("username", username);
                    session.setAttribute("loggedInUser", username);
                    session.setAttribute("pid",pid);
                    response.sendRedirect("patientpage.jsp");
                } else {
                    response.sendRedirect("login.html?message=Invalid%20username%20or%20password.");
                }
            } else {
                response.sendRedirect("login.html?messagenotfound=User%20not%20found.%20Please%20register.");
            }
        } catch (ClassNotFoundException e) {
            response.getWriter().println("Error: MySQL JDBC driver not found");
        } catch (SQLException e) {
            response.getWriter().println("Database error: " + e.getMessage());
        }
    }
}
