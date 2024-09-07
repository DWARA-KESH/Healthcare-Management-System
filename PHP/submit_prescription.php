<?php
header("Access-Control-Allow-Origin: *");
// Allow POST requests
header("Access-Control-Allow-Methods: GET, POST");
// Allow content type header
header("Access-Control-Allow-Headers: Content-Type");
// Database connection
$servername = "localhost";
$username = "root";
$password = "";
$database = "patient_signup";

// Create connection
$conn = new mysqli($servername, $username, $password, $database);

// Check connection
if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}

// Retrieve prescription data from POST request
$pid = $_POST['pid'];
$apptid = $_POST['apptid'];
$disease = $_POST['disease'];
$allergy = $_POST['allergy'];
$prescription = $_POST['prescription'];

// Prepare SQL statement to retrieve appointment data
$selectSql = "SELECT docname, firstname, lastname, appointdate, appointtime FROM appointmenttable WHERE apptid = ?";
$selectStmt = $conn->prepare($selectSql);
$selectStmt->bind_param("i", $apptid);
// Execute SQL statement to retrieve appointment data
$selectStmt->execute();
$selectResult = $selectStmt->get_result();

// Check if appointment data retrieval was successful
if ($selectResult->num_rows > 0) {
    // Fetch appointment data
    $row = $selectResult->fetch_assoc();
    $docname = $row['docname'];
    $firstname = $row['firstname'];
    $lastname = $row['lastname'];
    $appointmentDate = $row['appointdate'];
    $appointmentTime = $row['appointtime'];
    
    // Close select statement
    $selectStmt->close();

    // Prepare SQL statement to insert prescription data into prestable
    $insertSql = "INSERT INTO prestable (doctor, pid, id, firstname, lastname, appointmentDate, appointmentTime, disease, allergy, prescription) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
$insertStmt = $conn->prepare($insertSql);
$insertStmt->bind_param("ssisssssss", $docname, $pid, $apptid, $firstname, $lastname, $appointmentDate, $appointmentTime, $disease, $allergy, $prescription);



    // Execute SQL statement to insert prescription data
    $insertResult = $insertStmt->execute();

    // Check if prescription data insertion was successful
    if ($insertResult) {
        // Prepare SQL statement to update status and docstatus to 0
        $updateSql = "UPDATE appointmenttable SET status = 0, docstatus = 0 WHERE apptid = ?";
        $updateStmt = $conn->prepare($updateSql);
        $updateStmt->bind_param("i", $apptid);

        // Execute SQL statement to update status and docstatus
        $updateResult = $updateStmt->execute();

        if ($updateResult) {
            echo "Prescription submitted successfully";
        } else {
            echo "Error updating status and docstatus: " . $conn->error;
        }
    } else {
        echo "Error inserting prescription data: " . $conn->error;
    }
} else {
    echo "No appointment found with ID: " . $apptid;
}

// Close connection
$conn->close();
?>
