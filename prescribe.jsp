<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Prescribe Appointment</title>
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
    <style>
        body {
            background-color: #f0f8ff;
            background: linear-gradient(to right, #f0f8ff, #6CB4EE);
            overflow-x: hidden;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
            margin: 0;
        }

        .form-container {
            width: 400px;
            padding: 20px;
            border: 1px solid #ccc;
            border-radius: 5px;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
        }

        h1 {
            text-align: center;
            margin-bottom: 20px;
        }

        label {
            display: block;
            margin-bottom: 5px;
        }

        input[type="text"],
        textarea {
            width: 100%;
            padding: 8px;
            margin-bottom: 10px;
            border: 1px solid #ccc;
            border-radius: 4px;
            box-sizing: border-box;
        }

        button[type="submit"] {
            width: 100%;
            padding: 10px;
            background-color: #007bff;
            color: #fff;
            border: none;
            border-radius: 4px;
            cursor: pointer;
        }

        button[type="submit"]:hover {
            background-color: #0056b3;
        }
    </style>
</head>
<body>
    <div class="form-container">
        <h1>Prescribe</h1>
        <form id="prescribeForm">
            <input type="hidden" name="pid" value="<%= request.getParameter("pid") %>">
            <input type="hidden" name="apptid" value="<%= request.getParameter("apptid") %>">
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
                <textarea id="prescription" name="prescription" rows="4"></textarea>
            </div>
            <button type="submit">Submit</button>
        </form>
    </div>
    <script>
        $(document).ready(function() {
            $('#prescribeForm').submit(function(e) {
                e.preventDefault();

                var formData = $(this).serialize();

                // Send AJAX request to submit prescription
                $.ajax({
                    url: 'http://localhost/wtprojfiles/submit_prescription.php',
                    method: 'POST',
                    data: formData,
                    success: function(response) {
                        // Optionally handle success response
                        alert(response);
                        // Redirect to some page after successful submission
                        window.location.href = 'docinterface.jsp';
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
