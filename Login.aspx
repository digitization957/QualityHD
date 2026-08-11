<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Login.aspx.cs" Inherits="QualityHD.Login" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>QualityHD - App Launcher</title>
    <link href="Content/bootstrap.min.css" rel="stylesheet" />
    <style>
        :root {
            --teal: #0e5f57;
            --teal-soft: #e2efec;
            --teal-glow: rgba(14, 95, 87, 0.16);
            --gold: #b8791f;
            --font-display: "Bahnschrift", "Segoe UI Variable Display", "Segoe UI", -apple-system, "Helvetica Neue", Arial, sans-serif;
            --font-body: "Segoe UI Variable Text", "Segoe UI", -apple-system, Roboto, "Helvetica Neue", Arial, sans-serif;
            --font-mono: "Cascadia Code", ui-monospace, Consolas, monospace;
        }
        body {
            background:
                radial-gradient(640px 420px at 18% 8%, var(--teal-glow), transparent 60%),
                radial-gradient(520px 380px at 88% 92%, rgba(184, 121, 31, 0.10), transparent 60%),
                #f3f2ee;
            height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            font-family: var(--font-body);
        }
        .launcher-card { max-width: 440px; width: 100%; border: 1px solid #e1dfd6; border-radius: 18px; padding: 2rem 2rem 1.75rem; box-shadow: 0 20px 60px -20px rgba(28,35,32,0.35); }
        .brand-mark { width: 42px; height: 42px; border-radius: 11px; background: linear-gradient(155deg, var(--teal), #0a4841); color: #fff; font-family: var(--font-display); font-weight: 700; font-size: 1.05rem; display: flex; align-items: center; justify-content: center; margin-bottom: 1.1rem; letter-spacing: -0.02em; }
        .launcher-card__eyebrow { font-size: 0.72rem; font-weight: 600; letter-spacing: 0.09em; text-transform: uppercase; color: var(--gold); margin-bottom: 0.3rem; }
        .launcher-card__title { font-family: var(--font-display); font-size: 1.6rem; font-weight: 700; margin: 0; letter-spacing: -0.015em; }
        #txtToken { font-family: var(--font-mono); font-size: 0.82rem; background: #faf9f6; border-style: dashed; }
        .btn-primary { background: var(--teal); border-color: var(--teal); transition: filter 140ms ease; }
        .btn-primary:hover { filter: brightness(1.08); }
        .form-control:focus, .form-select:focus { border-color: var(--teal); box-shadow: 0 0 0 3px var(--teal-glow); }
    </style>
</head>
<body>
    <div class="card launcher-card">
        <div class="brand-mark">HD</div>
        <div class="launcher-card__eyebrow">Simulated App Launcher</div>
        <h4 class="launcher-card__title mb-2">QualityHD</h4>
        <div class="card-body p-0 mt-2">
            <p class="text-muted small mb-4">This stands in for the real portal that hands off a signed token &amp; role when a user launches this app.</p>

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
