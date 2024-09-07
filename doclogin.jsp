<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Patient Login</title>
    <link href="https://cdn.jsdelivr.net/npm/tailwindcss@2.2.19/dist/tailwind.min.css" rel="stylesheet"/>
    <style>
      body {
        background-color: #f0f8ff;
        background: linear-gradient(to right, #f0f8ff, #6CB4EE);
        overflow-x: hidden;
      }
      nav {
        background-color: #1560BD;
        z-index: 50;
        transition: opacity 0.5s;
      }
      nav.scrolled {
        opacity: 0;
      }
      .form-container {
        display: flex;
        justify-content: center;
        align-items: center;
        height: 100vh;
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
        color: #1560BD;
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
        border: 1.5px solid #6CB4EE;
        background: transparent;
        padding-left: 10px;
      }
      .input:focus {
        border: 1.5px solid #6CB4EE;
      }
      .input-field .label {
        position: absolute;
        top: 25px;
        left: 15px;
        color: #6CB4EE;
        transition: all 0.3s ease;
        pointer-events: none;
        z-index: 2;
      }
      .input-field .input:focus ~ .label,
      .input-field .input:valid ~ .label {
        top: 5px;
        left: 5px;
        font-size: 12px;
        color: #6CB4EE;
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
        background: #1560BD;
        box-shadow: 0px 0px 0px 0px #ffffff, 0px 0px 0px 0px #6CB4EE;
        transition: all 0.3s cubic-bezier(0.15, 0.83, 0.66, 1);
        cursor: pointer;
      }

      .submit-btn:hover {
        box-shadow: 0px 0px 0px 2px #ffffff, 0px 0px 0px 4px #6CB4EE;
      }

      .pop {
        color: #6CB4EE;
      }
      .pop:hover {
        color: #000000;
      }
      .nav-link {
        color: #fff;
        text-decoration: none;
        padding: 0 20px;
        letter-spacing: 0.5px;
        position: relative;
        transition: 0.2s;
        gap: 8px;
      }

      .nav-link::after {
        content: "";
        position: absolute;
        left: 0;
        bottom: -5px;
        width: 0%;
        height: 2px;
        background-color: #312d2e;
        transition: 0.3s linear;
      }

      .nav-link:hover {
        color: #fff;
      }

      .nav-link:hover:after {
        width: 100%;
      }
    </style>
  </head>
  <body>
    <!-- Navbar -->
    <nav class="fixed top-0 left-0 w-full z-50">
      <div class="container mx-auto flex justify-between items-center py-4">
        <div class="flex items-center">
          <img src="./MQ.png" alt="Logo" class="h-8 mx-5" style="border-radius: 16px"/>
        </div>
        <div class="hidden md:flex items-center">
          <a href="./home.html" class="px-4 nav-link" style="color: #f0f8ff">Home</a>
          <a href="./login.html" class="px-4 nav-link" style="color: #f0f8ff">Patient Portal</a>
          <a href="#" class="px-4 nav-link" style="color: #f0f8ff">Doctor Portal</a>
          <a href="./home.html" class="px-4 nav-link" style="color: #f0f8ff">Contact</a>
        </div>
      </div>
    </nav>

    <div class="form-container">
      <form class="form-control" action="docLoginServlet" method="post">
        <p class="title">Secure Login</p>
        <div class="input-field">
          <input required="" class="input" type="text" name="username" id="username"/>
          <label class="label" for="input">Enter Username</label>
        </div>
        <div class="input-field">
          <input required="" class="input" type="email" name="email" id="email"/>
          <label class="label" for="input">Enter email</label>
        </div>
        <div class="input-field">
          <input required="" class="input" type="password" name="password" id="password"/>
          <label class="label" for="input">Enter Password</label>
        </div>
        <button class="submit-btn">Log In</button>
        <p id="invalid" style="color: red"></p>
      </form>
    </div>
    <script>
      window.onscroll = function () {
        scrollFunction();
      };

      function scrollFunction() {
        var nav = document.querySelector("nav");
        if (
          document.body.scrollTop > 50 ||
          document.documentElement.scrollTop > 50
        ) {
          nav.classList.add("scrolled");
        } else {
          nav.classList.remove("scrolled");
        }
      }

      const urlParams = new URLSearchParams(window.location.search);
      const message = urlParams.get("error");

      if (message) {
        document.getElementById("invalid").textContent = message;
      }
    </script>
  </body>
</html>
