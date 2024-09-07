<%@ page import="java.net.URLDecoder" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Patient Feedback</title>
    <link href="https://cdn.jsdelivr.net/npm/tailwindcss@2.2.19/dist/tailwind.min.css" rel="stylesheet"/>
    <style>
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
        .nav-link:hover .tooltip {
            opacity: 1;
        }
        #feed {
            color: #fef2f2;
        }
        #feed:hover {
            color: #e4c2c1;
        }
        .submit-btn {
            margin-top: 30px;
            height: 55px;
            background: #f2f2f2;
            border-radius: 11px;
            border: 0;
            outline: none;
            color: #ffffff;
            font-size: 18px;
            font-weight: 700;
            background: #b6666f;
            box-shadow: 0px 0px 0px 0px #ffffff, 0px 0px 0px 0px #000000;
            transition: all 0.3s cubic-bezier(0.15, 0.83, 0.66, 1);
            cursor: pointer;
        }
        .submit-btn:hover {
            box-shadow: 0px 0px 0px 2px #ffffff, 0px 0px 0px 4px #e4c2c1;
        }
    </style>
</head>
<body class="bg-gray-100">
<nav class="fixed top-0 left-0 w-full z-50">
    <div class="container mx-auto flex justify-between items-center py-4">
        <div class="flex items-center">
            <a href="#">
                <img src="./MQ.png" alt="Logo" class="h-8 mx-5" style="border-radius: 16px"/>
            </a>
        </div>
        <div class="hidden md:flex items-center">
            <p style="color: #fef2f2">
                <strong>Welcome <%= session.getAttribute("username") %></strong>
            </p>
            <a href="patientretrieval.jsp" class="px-5 nav-link relative" style="color: #fef2f2">
                <svg xmlns="http://www.w3.org/2000/svg" width="32" height="32" fill="currentColor" class="bi bi-person" viewBox="0 0 16 16">
                    <path d="M8 8a3 3 0 1 0 0-6 3 3 0 0 0 0 6m2-3a2 2 0 1 1-4 0 2 2 0 0 1 4 0m4 8c0 1-1 1-1 1H3s-1 0-1-1 1-4 6-4 6 3 6 4m-1-.004c-.001-.246-.154-.986-.832-1.664C11.516 10.68 10.289 10 8 10s-3.516.68-4.168 1.332c-.678.678-.83 1.418-.832 1.664z"/>
                </svg>
                <span class="tooltip absolute bg-gray-800 text-white text-xs rounded py-1 px-3 -mt-6 left-1/2 transform -translate-x-1/2 opacity-0 transition-opacity duration-300">
                    Profile
                </span>
            </a>
            <button id="logoutButton" class="pr-5 nav-link relative" style="color: #fef2f2" >
                <svg xmlns="http://www.w3.org/2000/svg" width="32" height="32" fill="currentColor" class="bi bi-box-arrow-right" viewBox="0 0 16 16">
                    <path fill-rule="evenodd" d="M10 12.5a.5.5 0 0 1-.5.5h-8a.5.5 0 0 1-.5-.5v-9a.5.5 0 0 1 .5-.5h8a.5.5 0 0 1 .5.5v2a.5.5 0 0 0 1 0v-2A1.5 1.5 0 0 0 9.5 2h-8A1.5 1.5 0 0 0 0 3.5v9A1.5 1.5 0 0 0 1.5 14h8a1.5 1.5 0 0 0 1.5-1.5v-2a.5.5 0 0 0-1 0z"/>
                    <path fill-rule="evenodd" d="M15.854 8.354a.5.5 0 0 0 0-.708l-3-3a.5.5 0 0 0-.708.708L14.293 7.5H5.5a.5.5 0 0 0 0 1h8.793l-2.147 2.146a.5.5 0 0 0 .708.708z"/>
                </svg>
                <span class="tooltip absolute bg-gray-800 text-white text-xs rounded py-1 px-3 -mt-6 left-1/2 transform -translate-x-1/2 opacity-0 transition-opacity duration-300">
                    Logout
                </span>
            </button>
            <a href="patientfeedback.jsp" class="pr-5 relative" id="feed" >Feedback</a>
        </div>
    </div>
</nav>

<div class="container pt-20 mx-auto px-4">
    <div class="bg-white rounded-lg shadow-md p-6">
        <h2 class="text-lg font-semibold mb-4">Patient's favourite doctor:</h2>
        <form id="feedbackForm" class="grid grid-cols-1 gap-4" action="submitFeedback" method="post">
            <div>
                <input type="hidden" id="pid" name="pid" value="<%= session.getAttribute("pid") %>">
                <label for="feedback" class="block mb-1">Doctor's name</label>
                <input type="text" id="feedback" name="feedback" class="block w-full border border-gray-300 rounded-md py-2 px-3 focus:outline-none focus:border-blue-500" required>
            </div>
            <div class="col-span-1">
                <button type="submit" class="submit-btn btn btn-primary w-full">Submit Feedback</button>
            </div>
        </form>
    </div>
</div>


<%-- Display previous favorite doctor if available --%>
<%
// Retrieve the patient ID from the session attribute
Long pid = (Long) session.getAttribute("pid");

Cookie[] cookies = request.getCookies();
if (cookies != null && pid != null) {
    for (Cookie cookie : cookies) {
        // Filter cookies based on patient ID
        if (cookie.getName().startsWith("feedback_" + pid)) {
            // Decode the cookie value
            String encodedDoctorName = cookie.getValue();
            String decodedDoctorName = URLDecoder.decode(encodedDoctorName, "UTF-8");
%>
<div class="mt-4">
    <div class="bg-white rounded-lg shadow-md p-6">
        <h2 class="text-lg font-semibold mb-4">Previous Favorite Doctor</h2>
        <p><strong>Your Previous Favorite Doctor:</strong> <%= decodedDoctorName %></p>
    </div>
</div>
<%
            break; // Break the loop once the favorite doctor is found
        }
    }
}
%>


<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
<script>
    document.getElementById("logoutButton").addEventListener("click", function() {
        // Make an AJAX request to invalidate the session
        var xhr = new XMLHttpRequest();
        xhr.open("POST", "logout", true);
        xhr.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");
        xhr.onreadystatechange = function() {
            if (xhr.readyState === 4 && xhr.status === 200) {
                // Session invalidated successfully, you can redirect to a login page or perform any other actions
                window.location.href = "login.html"; // Redirect to login page
            }
        };
        xhr.send();
    });
</script>
</body>
</html>
