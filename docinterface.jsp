<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Patient Portal</title>
    <link href="https://cdn.jsdelivr.net/npm/tailwindcss@2.2.19/dist/tailwind.min.css" rel="stylesheet" />
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
</head>
<style>
    body {
        background-color: #f0f8ff;
        background: linear-gradient(to right, #f0f8ff, #6CB4EE);
        overflow-x: hidden;
      }
    nav {
        background-color: #1560BD;
        z-index: 50;
        transition: opacity 0.5s;
    }

    nav.scrolled {
        opacity: 0;
    }

    table {
        width: 100%;
        border-collapse: collapse;
    }

    th, td {
        border: 1px solid #ddd;
        padding: 8px;
        text-align: center;
    }

    th {
        background-color: #f2f2f2;
    }

    tr:nth-child(even) {
        background-color: #f2f2f2;
    }

    tr:hover {
        background-color: #ddd;
    }

    button {
        background-color: #4CAF50;
        color: white;
        padding: 8px 16px;
        border: none;
        cursor: pointer;
        border-radius: 4px;
    }

    button:hover {
        background-color: #45a049;
    }

    #appointmentsDiv {
        max-width: 800px; /* Adjust the maximum width as needed */
        margin: 0 auto; /* Center the appointmentsDiv horizontally */
        padding: 20px;
        margin-top: 8rem;
        border: 1px solid #ccc;
        border-radius: 8px;
        background-color: #fff;
    }

    /* Adjust the width of columns */
    th:nth-child(1),
    td:nth-child(1),
    th:nth-child(2),
    td:nth-child(2),
    th:nth-child(3),
    td:nth-child(3),
    th:nth-child(4),
    td:nth-child(4),
    th:nth-child(5),
    td:nth-child(5),
    th:nth-child(6),
    td:nth-child(6),
    th:nth-child(7),
    td:nth-child(7),
    th:nth-child(8),
    td:nth-child(8) {
        width: auto; /* Adjust the width as needed */
    }
</style>
<body class="bg-gray-100">
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
            <p style="color: #fef2f2">
                <strong>Welcome <%= session.getAttribute("docusername") %></strong>
            </p>
            <button id="logoutButton" class="px-5 nav-link relative" style="color: #fef2f2">
                <svg xmlns="http://www.w3.org/2000/svg" width="32" height="32" fill="currentColor" class="bi bi-box-arrow-right" viewBox="0 0 16 16">
                    <path fill-rule="evenodd" d="M10 12.5a.5.5 0 0 1-.5.5h-8a.5.5 0 0 1-.5-.5v-9a.5.5 0 0 1 .5-.5h8a.5.5 0 0 1 .5.5v2a.5.5 0 0 0 1 0v-2A1.5 1.5 0 0 0 9.5 2h-8A1.5 1.5 0 0 0 0 3.5v9A1.5 1.5 0 0 0 1.5 14h8a1.5 1.5 0 0 0 1.5-1.5v-2a.5.5 0 0 0-1 0z"/>
                    <path fill-rule="evenodd" d="M15.854 8.354a.5.5 0 0 0 0-.708l-3-3a.5.5 0 0 0-.708.708L14.293 7.5H5.5a.5.5 0 0 0 0 1h8.793l-2.147 2.146a.5.5 0 0 0 .708.708z"/>
                </svg>
                <span class="tooltip absolute bg-gray-800 text-white text-xs rounded py-1 px-3 -mt-6 left-1/2 transform -translate-x-1/2 opacity-0 transition-opacity duration-300">
                    Logout
                </span>
            </button>
        </div>
    </div>
</nav>

<div id="appointmentsDiv" class="bg-white rounded-lg shadow-md p-6 mt-10">
    <h2 class="text-lg font-semibold mb-4">Appointments</h2>
    <div id= "appointmentsDivInner"></div>
    <!-- AJAX content will be loaded here -->
</div>

<script>

    function prescribe(pid, apptid) {
    // Log the data being sent
    console.log('apptid:', apptid);

    // Redirect to the prescribe page
    window.location.href = 'prescribe.jsp?pid=' + pid + '&apptid=' + apptid;
}




function cancelAppointment(apptid) {
    // Confirm cancellation with the user
    if (confirm("Are you sure you want to cancel this appointment?")) {
        // Make AJAX request to cancel the appointment
        $.ajax({
            url: 'http://localhost/wtprojfiles/cancel_doctor_appointment.php', // URL of the PHP file to handle cancellation
            method: 'POST',
            data: { apptid: apptid }, // Send the appointment ID to the server
            success: function(response) {
                // Display success message
                alert("appointment cancelled successfully");
                 window.location.reload();
                // Refresh the appointments list after cancellation
                getAppointments();
            },
            error: function(xhr, status, error) {
                // Display error message
                alert("Error canceling appointment: " + error);
            }
        });
    }
}

    document.getElementById("logoutButton").addEventListener("click", function() {
        // Make an AJAX request to invalidate the session
        var xhr = new XMLHttpRequest();
        xhr.open("POST", "logout", true);
        xhr.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");
        xhr.onreadystatechange = function() {
            if (xhr.readyState === 4 && xhr.status === 200) {

                window.location.href = "doclogin.jsp";
            }
        };
        xhr.send();
    });

    $(document).ready(function() {
        // Get the doctor's username from session
        var docusername = "<%= session.getAttribute("docusername") %>";

        // Function to retrieve appointments using AJAX
        function getAppointments() {
            $.ajax({
                url: 'http://localhost/wtprojfiles/retrieve_doc_appointments.php',
                method: 'POST', // Change method to POST
                dataType: 'html', // Change dataType to HTML
                data: {
                    docusername: docusername
                },
                success: function(response) {
                    // Update appointmentsDiv with retrieved appointments HTML
                    $('#appointmentsDivInner').html(response);
                },
                error: function(xhr, status, error) {
                    console.error('Error fetching appointments:', error);
                }
            });
        }

        getAppointments();

    });
</script>
</body>
</html>
