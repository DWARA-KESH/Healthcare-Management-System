<?php
// retrieve_appointment_data.php
header("Access-Control-Allow-Origin: *");
// Allow POST requests
header("Access-Control-Allow-Methods: POST");
// Allow content type header
header("Access-Control-Allow-Headers: Content-Type");
// Start the session to access session variables
session_start();

// Check if the user is logged in

// Assuming you're receiving the data via POST method
if ($_SERVER["REQUEST_METHOD"] === "POST") {
    // Retrieve the data sent from the form
    $pid = $_POST["pid"];
    $doctorSpecialization = $_POST["doctorSpecialization"];
    $doctorName = $_POST["doctorName"];
    $consultationFee = $_POST["consultationFee"];
    $appointmentDate = $_POST["appointmentDate"];
    $appointmentTime = $_POST["appointmentTime"];

    // Connect to the database
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

    // Check for conflicting appointments
    $sql_conflict_check = "SELECT * FROM appointmenttable WHERE docname = ? AND appointdate = ? AND appointtime = ? and status = 1 and docstatus = 1";
    $stmt_conflict_check = $conn->prepare($sql_conflict_check);
    $stmt_conflict_check->bind_param("sss", $doctorName, $appointmentDate, $appointmentTime);

    // Execute the query
    $stmt_conflict_check->execute();

    // Get the result
    $result_conflict_check = $stmt_conflict_check->get_result();

    // If there is a conflicting appointment, return an error
    if ($result_conflict_check->num_rows > 0) {
        echo json_encode(['error' => 'There is a conflicting appointment. Please choose a different time.']);
    } else {
        // Prepare SQL statement to retrieve patient details using the pid from session
        $sql_patient = "SELECT firstname, lastname, gender, age, phonenum FROM patientprofile WHERE pid = ?";
        $stmt_patient = $conn->prepare($sql_patient);
        $stmt_patient->bind_param("s", $pid);

        // Execute the query
        $stmt_patient->execute();

        // Get the result
        $result_patient = $stmt_patient->get_result();

        // Fetch patient details
        $patient_data = $result_patient->fetch_assoc();

        // Prepare SQL statement to insert appointment details into the appointment table
        $sql_insert_appointment = "INSERT INTO appointmenttable (pid, firstname, lastname, gender, age, phonenum, docspec, docname, docfare, appointdate, appointtime, status, docstatus)
                                   VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, 1, 1)";
        $stmt_insert_appointment = $conn->prepare($sql_insert_appointment);
        $stmt_insert_appointment->bind_param("sssssssssss", $pid, $patient_data['firstname'], $patient_data['lastname'], $patient_data['gender'], $patient_data['age'], $patient_data['phonenum'], $doctorSpecialization, $doctorName, $consultationFee, $appointmentDate, $appointmentTime);

        // Execute the insertion query
        if ($stmt_insert_appointment->execute()) {
            // If insertion successful, return success message
            echo json_encode(['success' => 'Appointment booked successfully!']);
        } else {
            // If insertion fails, return error message
            echo json_encode(['error' => 'Failed to book appointment']);
        }

        // Close prepared statements
        $stmt_patient->close();
        $stmt_insert_appointment->close();
    }

    // Close database connection
    $conn->close();
} else {
    // If the request method is not POST, return an error message
    echo json_encode(['error' => 'Only POST requests are allowed']);
}
?>
