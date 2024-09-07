<?php

header("Access-Control-Allow-Origin: *");
// Allow GET requests
header("Access-Control-Allow-Methods: GET");
// Allow content type header
header("Access-Control-Allow-Headers: Content-Type");

// Retrieve the pid from the GET request
$pid = $_GET['pid'];

$servername = "localhost";
$username_db = "root";
$password_db = "";
$dbname = "patient_signup";

// Create connection
$conn = new mysqli($servername, $username_db, $password_db, $dbname);

// Check connection
if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}

// Prepare and execute a query to fetch upcoming appointments for the specified pid with status 1
$sql = "SELECT * FROM appointmenttable WHERE pid = ? AND status = 1 AND docstatus = 1 AND appointdate >= CURDATE()";
$stmt = $conn->prepare($sql);
$stmt->bind_param("s", $pid);
$stmt->execute();
$result = $stmt->get_result();

// Check if there are any upcoming appointments
if ($result->num_rows > 0) {
    // Display the appointments in a table
    echo "<table border='1'>
            <tr>
                <th>Appointment Date</th>
                <th>Appointment Time</th>
                <th>Doctor Name</th>
                <th>Action</th>
            </tr>";

    // Fetch and display each appointment
    while ($row = $result->fetch_assoc()) {
        echo "<tr>";
        echo "<td>" . $row['appointdate'] . "</td>";
        echo "<td>" . $row['appointtime'] . "</td>";
        echo "<td>" . $row['docname'] . "</td>";
        echo "<td><button onclick='cancelAppointment(" . $row['apptid'] . ")'>Cancel</button></td>";
        echo "</tr>";
    }

    echo "</table>";
} else {
    // If no upcoming appointments found, display a message
    echo "No upcoming appointments found.";
}

// Close connection
$stmt->close();
$conn->close();

?>

<script>
    function cancelAppointment(appointmentId) {
        // Send AJAX request to update the appointment status to 0 (cancelled)
        $.ajax({
            type: "POST",
            url: "http://localhost/wtprojfiles/cancel_appointment.php",
            data: { appointmentId: appointmentId },
            success: function(response) {
                console.log("Appointment cancelled successfully!");
                // Refresh the page after cancelling the appointment
                location.reload();
            },
            error: function(xhr, status, error) {
                console.error("Failed to cancel appointment. Status code: " + xhr.status);
            }
        });
    }
</script>
