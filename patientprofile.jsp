<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Patient Profile</title>
    <!-- Include Tailwind CSS -->
    <link href="https://cdn.jsdelivr.net/npm/tailwindcss@2.2.19/dist/tailwind.min.css" rel="stylesheet">
</head>
<style>
    body {
        background-color: #fef2f2;
        background: linear-gradient(to right, #fef2f2, #e4c2c1);
        overflow-x: hidden;
      }
      nav {
        background-color: #b6666f;
        z-index: 50;
        transition: opacity 0.5s;
      }
      nav.scrolled {
        opacity: 0;
      }
      input{
        background-color: grey;
      }
      .form-container {
        display: flex;
        justify-content: center;
        align-items: center;
      }
      .form-control {
        background-color: #ffffff;
        box-shadow: 0 15px 25px rgba(0, 0, 0, 0.6);
        width: 400px;
        padding: 25px;
        border-radius: 8px;
      }
      .form-control {
        margin: 20px;
        background-color: #ffffff;
        box-shadow: 0 15px 25px rgba(0, 0, 0, 0.6);
        width: 400px;
        display: flex;
        justify-content: center;
        flex-direction: column;
        gap: 10px;
        padding: 25px;
        border-radius: 8px;
      }
      .title {
        font-size: 28px;
        color: #b6666f;
        font-weight: 800;
      }
      .input-field {
        position: relative;
        width: 100%;
      }

      .input {
        margin-top: 15px;
        width: 100%;
        outline: none;
        border-radius: 8px;
        height: 45px;
        border: 1.5px solid #e4c2c1;
        background: transparent;
        padding-left: 10px;
      }
      .input:focus {
        border: 1.5px solid #b6666f;
      }
      .input-field .label {
        position: absolute;
        top: 25px;
        left: 15px;
        color: #e4c2c1;
        transition: all 0.3s ease;
        pointer-events: none;
        z-index: 2;
      }
      .input-field .input:focus ~ .label,
      .input-field .input:valid ~ .label {
        top: 5px;
        left: 5px;
        font-size: 12px;
        color: #b6666f;
        background-color: #ffffff;
        padding-left: 5px;
        padding-right: 5px;
      }
      .submit-btn {
        margin-top: 30px;
        height: 55px;
        background: #f2f2f2;
        border-radius: 11px;
        border: 0;
        outline: none;
        color: #ffffff;
        font-size: 18px;
        font-weight: 700;
        background: #b6666f;
        box-shadow: 0px 0px 0px 0px #ffffff, 0px 0px 0px 0px #000000;
        transition: all 0.3s cubic-bezier(0.15, 0.83, 0.66, 1);
        cursor: pointer;
      }

      .submit-btn:hover {
        box-shadow: 0px 0px 0px 2px #ffffff, 0px 0px 0px 4px #e4c2c1;
      }

      .title-container {
    display: flex;
    align-items: center;
}

.title {
    margin: 0; /* Remove default margin */
    flex: 1; /* Allow title to grow and take remaining space */
}

.bi-pencil-square {
    margin-left: 10px; /* Add some space between the title and icon */
}

</style>
<body class="bg-gray-100 flex items-center justify-center h-screen">


    <nav class="fixed top-0 left-0 w-full z-50">
      <div class="container mx-auto flex justify-between items-center py-4">
        <div class="flex items-center">
          <a href="#">
            <img
              src="./MQ.png"
              alt="Logo"
              class="h-8 mx-5"
              style="border-radius: 16px"
            />
          </a>
        </div>
        <div class="hidden md:flex items-center">
          <p style="color: #fef2f2;">Welcome <%= session.getAttribute("username") %></p>
          <a href="./patientpage.jsp" class="px-5 nav-link" style="color: #fef2f2;"><svg xmlns="http://www.w3.org/2000/svg" width="32" height="32" fill="currentColor" class="bi bi-x" viewBox="0 0 16 16">
  <path d="M4.646 4.646a.5.5 0 0 1 .708 0L8 7.293l2.646-2.647a.5.5 0 0 1 .708.708L8.707 8l2.647 2.646a.5.5 0 0 1-.708.708L8 8.707l-2.646 2.647a.5.5 0 0 1-.708-.708L7.293 8 4.646 5.354a.5.5 0 0 1 0-.708"/>
</svg>
          </a>
        </div>
      </div>
    </nav>

    <div class="form-container mt-10">
      <form class="form-control" action="./patientprofilesubmit.jsp" method="post">
        <div class="title-container">
            <p class="title">Patient Details</p>
            <button type="button" onclick="enableEditing()"><svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" class="bi bi-pencil-square" viewBox="0 0 16 16">
                <path d="M15.502 1.94a.5.5 0 0 1 0 .706L14.459 3.69l-2-2L13.502.646a.5.5 0 0 1 .707 0l1.293 1.293zm-1.75 2.456-2-2L4.939 9.21a.5.5 0 0 0-.121.196l-.805 2.414a.25.25 0 0 0 .316.316l2.414-.805a.5.5 0 0 0 .196-.12l6.813-6.814z"/>
                <path fill-rule="evenodd" d="M1 13.5A1.5 1.5 0 0 0 2.5 15h11a1.5 1.5 0 0 0 1.5-1.5v-6a.5.5 0 0 0-1 0v6a.5.5 0 0 1-.5.5h-11a.5.5 0 0 1-.5-.5v-11a.5.5 0 0 1 .5-.5H9a.5.5 0 0 0 0-1H2.5A1.5 1.5 0 0 0 1 2.5z"/>
            </svg></button>
        </div>
        <div class="input-field flex items-center">
            <input required="" class="input" type="text" id="firstname" name="firstname" disabled/>
            <label class="label" for="input" >Enter First Name</label>
                   
        </div>

        <div class="input-field flex items-center">
          <input required="" class="input" type="text" id="lastname" name="lastname" disabled/>
          <label class="label" for="input">Enter Last Name</label>
          
        </div>
        <div class="input-field flex items-center">
          <input required="" class="input" type="text" id="gender" name="gender" disabled/>
          <label class="label" for="input">Enter Gender</label>
          
        </div>
        <div class="input-field flex items-center">
          <input required="" class="input" type="text" id="age" name="age" disabled/>
          <label class="label" for="input">Enter Age</label>
          
        </div>
        <div class="input-field flex items-center">
          <input required="" class="input" type="text" name="address1" id="address1" disabled/>
          <label class="label" for="input">Address Line 1</label>
          
        </div>
        <div class="input-field flex items-center">
          <input required="" class="input" type="text" name="address2" id="address2" disabled/>
          <label class="label" for="input">Address Line 2</label>
          
        </div>
        <div class="input-field flex items-center">
          <input required="" class="input" type="text" name="phoneNumber" id="phoneNumber" disabled/>
          <label class="label" for="input">Phone number</label>
          
        </div>
        
        <button class="submit-btn">Submit</button>
        <p id="insertorupdate" style="color= #0000ff"></p>
      </form>
    </div>
    

<script>
    function enableEditing() {
    var inputFields = document.querySelectorAll('.input-field .input');

    inputFields.forEach(function(input) {
        input.disabled = !input.disabled;
    });
}

const urlParams = new URLSearchParams(window.location.search);
const message = urlParams.get("message");

if (message) {
    document.getElementById("insertorupdate").textContent = message;
}

document.addEventListener("DOMContentLoaded", function () {
    function getUrlParameter(name) {
        name = name.replace(/[\[]/, "\\[").replace(/[\]]/, "\\]");
        var regex = new RegExp("[\\?&]" + name + "=([^&#]*)");
        var results = regex.exec(location.search);
        return results === null ? "" : decodeURIComponent(results[1].replace(/\+/g, " "));
    }

    var firstname = getUrlParameter("firstname");
    var lastname = getUrlParameter("lastname");
    var gender = getUrlParameter("gender");
    var age = getUrlParameter("age");
    var address1 = getUrlParameter("address1");
    var address2 = getUrlParameter("address2");
    var phoneNumber= getUrlParameter("phoneNumber");

    if (firstname || lastname || gender || age || address1 || address2 || phoneNumber) {
        document.getElementById("firstname").value = firstname;
        document.getElementById("lastname").value = lastname;
        document.getElementById("gender").value = gender;
        document.getElementById("age").value = age;
        document.getElementById("address1").value = address1;
        document.getElementById("address2").value = address2;
        document.getElementById("phoneNumber").value = phoneNumber;
        document.getElementById("insertorupdate").value = "";

        var labels = document.querySelectorAll('.input-field .label');
        labels.forEach(function(label) {
            label.style.display = 'none';
        });
    }
});

</script>

</body>
</html>


