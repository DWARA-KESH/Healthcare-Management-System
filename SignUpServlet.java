import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/signup")
public class SignUpServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
        throws ServletException, IOException {

        String username = request.getParameter("username");
        String email = request.getParameter("email");
        String plainTextPassword = request.getParameter("password");
        
        String hashedPassword = PasswordHashing.hashPassword(plainTextPassword);
        
        String url = "jdbc:mysql://localhost:3306/patient_signup";
        String usernameDB = "root";
        String passwordDB = "";
        
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection conn = DriverManager.getConnection(url, usernameDB, passwordDB);
            
            // Check if the username already exists in the database
            String checkSql = "SELECT username FROM patients WHERE username = ?";
            PreparedStatement checkStmt = conn.prepareStatement(checkSql);
            checkStmt.setString(1, username);
            ResultSet rs = checkStmt.executeQuery();
            if (rs.next()) {
                // Username already exists, prompt user to choose a different one
                response.sendRedirect("signup.html?message=Username%20already%20exists.%20Please%20choose%20a%20different%20one.");
            } else {
                // Username doesn't exist, proceed with registration
                String insertSql = "INSERT INTO patients (username, email, password) VALUES (?, ?, ?)";
                PreparedStatement stmt = conn.prepareStatement(insertSql);
                stmt.setString(1, username);
                stmt.setString(2, email);
                stmt.setString(3, hashedPassword); // Store hashed password in the database
                
                int rowsAffected = stmt.executeUpdate();
                if (rowsAffected > 0) {
                    response.sendRedirect("login.html?username=" + username);
                } else {
                    response.getWriter().println("Error: User registration failed!");
                }
            }
            
            conn.close();
        } catch (ClassNotFoundException | SQLException e) {
            response.getWriter().println("Error: " + e.getMessage());
        }
    }
}
