<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Login.aspx.cs" Inherits="QualityHD.Login" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>QualityHD - App Launcher</title>
    <link href="Content/bootstrap.min.css" rel="stylesheet" />
    <style>
        body { background: #f2f4f7; height: 100vh; display: flex; align-items: center; justify-content: center; }
        .launcher-card { max-width: 460px; width: 100%; }
    </style>
</head>
<body>
    <div class="card shadow-sm launcher-card">
        <div class="card-body p-4">
            <h4 class="card-title mb-1">QualityHD</h4>
            <p class="text-muted small mb-4">Simulated App Launcher &rarr; this stands in for the real portal that redirects users here with a signed token &amp; role.</p>

            <div class="mb-3">
                <label for="txtToken" class="form-label">Token</label>
                <input type="text" id="txtToken" class="form-control" readonly />
            </div>

            <div class="mb-4">
                <label for="ddlRole" class="form-label">Role</label>
                <select id="ddlRole" class="form-select">
                    <option value="User" selected="selected">User</option>
                    <option value="Admin">Admin</option>
                </select>
            </div>

            <div id="loginError" class="alert alert-danger d-none small"></div>

            <button type="button" id="btnEnter" class="btn btn-primary w-100">Enter Application</button>
        </div>
    </div>

    <script src="Scripts/jquery-3.7.0.min.js"></script>
    <script src="Scripts/app/login.js"></script>
</body>
</html>
