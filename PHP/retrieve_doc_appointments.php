<?php
// Allow requests from any origin
header("Access-Control-Allow-Origin: *");
// Allow GET and POST requests
header("Access-Control-Allow-Methods: GET, POST");
// Allow content type header
header("Access-Control-Allow-Headers: Content-Type");

// Database connection and other script logic...
// Database connection
$servername = "localhost";
$username = "root";
$password = "";
$database = "patient_signup";

// Get docusername from AJAX request
$docusername = $_POST['docusername'];

// Create connection
$conn = new mysqli($servername, $username, $password, $database);

// Check connection
if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}

// SQL query to fetch appointment data for a specific doctor
$sql = "SELECT * FROM appointmenttable WHERE docname = ?";
$stmt = $conn->prepare($sql);
$stmt->bind_param("s", $docusername);
$stmt->execute();
$result = $stmt->get_result();

// Initialize an empty string to store appointment details HTML
$appointmentsHTML = "<table><tr><th>Appointment Date</th><th>Appointment Time</th><th>Patient Name</th><th>Age</th><th>Gender</th><th>Phone Number</th><th>Status</th><th>Prescribe</th></tr>";

// Check if appointments are found
if ($result->num_rows > 0) {
    // Fetch and display each appointment
    while($row = $result->fetch_assoc()) {
        $appointmentsHTML .= "<tr>";
        $appointmentsHTML .= "<td>" . $row["appointdate"] . "</td>";
        $appointmentsHTML .= "<td>" . $row["appointtime"] . "</td>";
        $appointmentsHTML .= "<td>" . $row["firstname"] . " " . $row["lastname"] . "</td>";
        $appointmentsHTML .= "<td>" . $row["age"] . "</td>";
        $appointmentsHTML .= "<td>" . $row["gender"] . "</td>";
        $appointmentsHTML .= "<td>" . $row["phonenum"] . "</td>";
        if ($row['status'] == 0 && $row['docstatus'] == 0) {
            $appointmentsHTML .= "<td>Patient Prescribed</td>";
            $appointmentsHTML .= "<td></td>"; // Empty cell for Prescribe
        } else if ($row["status"] == 0){
            $appointmentsHTML .= "<td>Cancelled by patient</td>";
            $appointmentsHTML .= "<td></td>"; // Empty cell for Prescribe
        } 
        else if($row["docstatus"] == 0){
            $appointmentsHTML .= "<td>Cancelled by you</td>";
            $appointmentsHTML .= "<td></td>"; // Empty cell for Prescribe
        } else {
            $appointmentsHTML .= "<td><button onclick='cancelAppointment(" . $row["apptid"] . ")'>Cancel</button></td>";
            $appointmentsHTML .= "<td><button onclick='prescribe(" . $row["pid"] . ", " . $row["apptid"] .  ")'>Prescribe</button></td>";
        }
        $appointmentsHTML .= "</tr>";
    }
} else {
    $appointmentsHTML .= "<tr><td colspan='8'>No appointments found</td></tr>";
}

$appointmentsHTML .= "</table>";

// Close connection
$stmt->close();
$conn->close();

// Return appointment details HTML
echo $appointmentsHTML;
?>
