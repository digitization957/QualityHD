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
            --paper: #f6f3ec;
            --surface: #ffffff;
            --ink: #2a2e29;
            --ink-soft: #6f7568;
            --line: #e6e1d2;
            --sage: #4f7c6c;
            --sage-tint: #e2ece6;
            --sage-glow: rgba(79, 124, 108, 0.16);
            --amber: #b8783a;
            --font-display: "Bahnschrift", "Segoe UI Variable Display", "Segoe UI Semibold", "Segoe UI", -apple-system, "Helvetica Neue", Arial, sans-serif;
            --font-body: "Segoe UI Variable Text", "Segoe UI", -apple-system, Roboto, "Helvetica Neue", Arial, sans-serif;
            --font-mono: "Cascadia Code", ui-monospace, Consolas, monospace;
        }
        body {
            background:
                radial-gradient(640px 420px at 18% 8%, var(--sage-glow), transparent 60%),
                radial-gradient(520px 380px at 88% 92%, rgba(184, 120, 58, 0.10), transparent 60%),
                var(--paper);
            height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            font-family: var(--font-body);
            color: var(--ink);
        }
        .launcher-card { max-width: 440px; width: 100%; background: var(--surface); border: 1px solid var(--line); border-radius: 18px; padding: 2rem 2rem 1.75rem; box-shadow: 0 20px 60px -20px rgba(42,46,41,0.18); }
        .brand-mark { width: 42px; height: 42px; border-radius: 11px; background: var(--sage); color: #fff; font-family: var(--font-display); font-weight: 700; font-size: 1.05rem; display: flex; align-items: center; justify-content: center; margin-bottom: 1.1rem; letter-spacing: -0.02em; }
        .launcher-card__eyebrow { font-size: 0.72rem; font-weight: 600; letter-spacing: 0.09em; text-transform: uppercase; color: var(--amber); margin-bottom: 0.3rem; }
        .launcher-card__title { font-family: var(--font-display); font-size: 1.6rem; font-weight: 700; margin: 0; letter-spacing: -0.015em; color: var(--ink); }
        #txtToken { font-family: var(--font-mono); font-size: 0.82rem; background: var(--paper); border-style: dashed; border-radius: 8px; }
        .btn-primary { background: var(--sage); border-color: var(--sage); transition: filter 140ms ease; border-radius: 8px; font-weight: 500; }
        .btn-primary:hover { filter: brightness(1.08); }
        .btn, .form-control, .form-select { border-radius: 8px; }
        .form-control:focus, .form-select:focus { border-color: var(--sage); box-shadow: 0 0 0 3px var(--sage-glow); }
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
                <label for="ddlToken" class="form-label">Token</label>
                <select id="ddlToken" class="form-select"></select>
            </div>

            <div class="mb-4">
                <label for="ddlPlant" class="form-label">Plant</label>
                <select id="ddlPlant" class="form-select"></select>
                <div class="form-text">Demo dropdown — stands in for the plant the real launcher resolves from your token.</div>
            </div>

            <div id="loginError" class="alert alert-danger d-none small"></div>

            <button type="button" id="btnEnter" class="btn btn-primary w-100">Enter Application</button>
        </div>
    </div>

    <script src="Scripts/jquery-3.7.0.min.js"></script>
    <script src="Scripts/app/login.js"></script>
</body>
</html>
