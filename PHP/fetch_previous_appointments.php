<?php

header("Access-Control-Allow-Origin: *");
// Allow GET requests
header("Access-Control-Allow-Methods: GET");
// Allow content type header
header("Access-Control-Allow-Headers: Content-Type");

// Retrieve the patient ID from the session or wherever it's stored
$pid = $_GET["pid"]; // Add code to retrieve the patient ID

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

// Prepare and execute a query to fetch canceled appointments for the specified pid with status 0 or docstatus 0
$sql = "SELECT * FROM appointmenttable WHERE pid = ? AND (status = 0 OR docstatus = 0)";
$stmt = $conn->prepare($sql);
$stmt->bind_param("s", $pid);
$stmt->execute();
$result = $stmt->get_result();

// Check if there are any canceled appointments
if ($result->num_rows > 0) {
    // Initialize an empty string to store appointment details HTML
    $cancelledAppointmentsHTML = "<table><tr><th>Appointment Date</th><th>Appointment Time</th><th>Doctor Name</th><th>Status</th></tr>";

    // Fetch and display each canceled appointment
    while ($row = $result->fetch_assoc()) {
        // Determine the status based on the values of 'status' and 'docstatus'
        if ($row['status'] == 0 && $row['docstatus'] == 0) {
            // Both patient and doctor cancelled
            $status = '<button onclick="showPrescription(' . $row['apptid'] . ')">Show Prescription</button>';
        } elseif ($row['status'] == 0) {
            // Cancelled by patient
            $status = "Cancelled by Patient";
        } elseif ($row['docstatus'] == 0) {
            // Cancelled by doctor
            $status = "Cancelled by Doctor";
        }

        $cancelledAppointmentsHTML .= "<tr>";
        $cancelledAppointmentsHTML .= "<td>" . $row['appointdate'] . "</td>";
        $cancelledAppointmentsHTML .= "<td>" . $row['appointtime'] . "</td>";
        $cancelledAppointmentsHTML .= "<td>" . $row['docname'] . "</td>";
        $cancelledAppointmentsHTML .= "<td>" . $status . "</td>";
        $cancelledAppointmentsHTML .= "</tr>";
    }

    $cancelledAppointmentsHTML .= "</table>";

    // Output the HTML for canceled appointments
    echo $cancelledAppointmentsHTML;
} else {
    // If no canceled appointments found, display a message
    echo "No canceled appointments found.";
}


// Close connection
$stmt->close();
$conn->close();

?>
