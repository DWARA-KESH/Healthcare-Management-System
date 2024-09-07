<?php

header("Access-Control-Allow-Origin: *");
// Allow POST requests
header("Access-Control-Allow-Methods: POST");
// Allow content type header
header("Access-Control-Allow-Headers: Content-Type");

// Retrieve the appointment ID from the POST request
$appointmentId = $_POST['appointmentId'];

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

// Prepare and execute a query to update the appointment status to 0 (cancelled)
$sql = "UPDATE appointmenttable SET status = 0 WHERE apptid = ?";
$stmt = $conn->prepare($sql);
$stmt->bind_param("i", $appointmentId);
$stmt->execute();

// Check if the update was successful
if ($stmt->affected_rows > 0) {
    echo "Appointment cancelled successfully!";
} else {
    echo "Failed to cancel appointment.";
}

// Close connection
$stmt->close();
$conn->close();

?>
