<?php
header("Access-Control-Allow-Origin: *");
// Allow POST requests
header("Access-Control-Allow-Methods: POST");
// Allow content type header
header("Access-Control-Allow-Headers: Content-Type");
// Retrieve pid and apptid from POST request
$pid = isset($_POST['pid']) ? $_POST['pid'] : '';
$apptid = isset($_POST['apptid']) ? $_POST['apptid'] : '';
?>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Prescribe Appointment</title>
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
</head>
<body>
    <h1>Prescribe Appointment</h1>
    <div>
        <p>Patient ID: <?php echo $pid; ?></p>
    </div>
    <form id="prescribeForm">
        <input type="hidden" name="pid" value="<?php echo $pid; ?>">
        <input type="hidden" name="apptid" value="<?php echo $apptid; ?>">
        <div>
            <label for="disease">Disease:</label>
            <input type="text" id="disease" name="disease" required>
        </div>
        <div>
            <label for="allergy">Allergy:</label>
            <input type="text" id="allergy" name="allergy" required>
        </div>
        <div>
            <label for="prescription">Prescription:</label>
            <textarea id="prescription" name="prescription" rows="4" required></textarea>
        </div>
        <button type="submit">Submit</button>
    </form>

    <script>
        $(document).ready(function() {
            $('#prescribeForm').submit(function(e) {
                e.preventDefault(); // Prevent default form submission

                // Serialize form data
                var formData = $(this).serialize();

                // Send AJAX request to submit prescription
                $.ajax({
                    url: 'submit_prescription.php',
                    method: 'POST',
                    data: formData,
                    success: function(response) {
                        // Optionally handle success response
                        console.log(response);
                        // Redirect to some page after successful submission
                        window.location.href = 'http://localhost:8080/wtproj/docinterface.jsp';
                    },
                    error: function(xhr, status, error) {
                        console.error('Error prescribing appointment:', error);
                        // Optionally handle error
                    }
                });
            });
        });
    </script>
</body>
</html>
