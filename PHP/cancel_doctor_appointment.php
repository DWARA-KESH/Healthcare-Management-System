<?php
header("Access-Control-Allow-Origin: *");
// Allow GET requests
header("Access-Control-Allow-Methods: POST");
// Allow content type header
header("Access-Control-Allow-Headers: Content-Type");
// Database connection
$servername = "localhost";
$username = "root";
$password = "";
$database = "patient_signup";

// Get apptid from POST request
$apptid = $_POST['apptid'];

// Create connection
$conn = new mysqli($servername, $username, $password, $database);

// Check connection
if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}

// SQL query to update docstatus to 0 for the given apptid
$sql = "UPDATE appointmenttable SET docstatus = 0 WHERE apptid = ?";
$stmt = $conn->prepare($sql);
$stmt->bind_param("i", $apptid);

// Execute the update query
if ($stmt->execute()) {
    // Show success alert
    echo '<script>alert("Appointment canceled successfully");</script>';
} else {
    // Show error alert
    echo '<script>alert("Error canceling appointment: ' . $conn->error . '");</script>';
}

// Close statement and connection
$stmt->close();
$conn->close();
?>
