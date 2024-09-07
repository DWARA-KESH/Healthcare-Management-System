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

// Get the selected doctor name from the request
$doctorName = $_GET['doctorName'];

// Prepare a SQL statement to fetch the consultation fee based on the selected doctor name
$sql = "SELECT docFees FROM docs WHERE docusername = ?";

// Prepare and bind parameters
$stmt = $conn->prepare($sql);
$stmt->bind_param("s", $doctorName);

// Execute the query
$stmt->execute();

// Get the result
$result = $stmt->get_result();

// Fetch the consultation fee from the result set
if ($row = $result->fetch_assoc()) {
    $consultationFee = $row['docFees'];
} else {
    // If the doctor name is not found, set the fee to 0 or any default value
    $consultationFee = 0;
}

// Close the statement and connection
$stmt->close();
$conn->close();

// Return the consultation fee as plain text
echo $consultationFee;
?>
