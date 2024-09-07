<?php

header("Access-Control-Allow-Origin: *");
// Allow GET requests
header("Access-Control-Allow-Methods: GET");
// Allow content type header
header("Access-Control-Allow-Headers: Content-Type");
// Establish a connection to your database
$servername = "localhost";
$username = "root";
$password = "";
$dbname = "patient_signup";

// Create connection
$conn = new mysqli($servername, $username, $password, $dbname);

// Check connection
if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}

// Get the specialization from the request
$specialization = $_GET['specialization'];

// Prepare a SQL statement to fetch doctor names based on specialization
$sql = "SELECT docusername FROM docs WHERE spec = ?";

// Prepare and bind parameters
$stmt = $conn->prepare($sql);
$stmt->bind_param("s", $specialization);

// Execute the query
$stmt->execute();

// Get the result
$result = $stmt->get_result();

// Create an array to store doctor names
$doctorNames = array();

// Fetch doctor names from the result set
while ($row = $result->fetch_assoc()) {
    // Add the doctor username to the array
    $doctorNames[] = $row['docusername'];
}

// Close the statement and connection
$stmt->close();
$conn->close();

// Return the doctor names as JSON
echo json_encode($doctorNames);
?>
