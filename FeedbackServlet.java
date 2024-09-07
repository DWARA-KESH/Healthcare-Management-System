import java.io.IOException;
import java.net.URLEncoder;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/submitFeedback")
public class FeedbackServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String feedback = request.getParameter("feedback");
        
        // Encode feedback before setting it as a cookie
        String encodedFeedback = URLEncoder.encode(feedback, "UTF-8");
        
        // Get the patient ID from the session attribute
        String pid =  request.getParameter("pid");
        
        // Check if the patient ID is not null
        if (pid != null) {
            // Create a cookie for feedback with patient ID as part of the name
            Cookie feedbackCookie = new Cookie("uname_" + pid, encodedFeedback);
            
            // Set cookie expiration time (e.g., 7 days)
            feedbackCookie.setMaxAge(7 * 24 * 60 * 60); // 7 days
            
            // Add cookie to the response
            response.addCookie(feedbackCookie);
        }
        
        // Redirect back to the feedback page or any other page as needed
        response.sendRedirect("patientfeedback.jsp");
    }
}

