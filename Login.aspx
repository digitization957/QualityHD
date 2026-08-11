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
            --accent: #1d4e6b;
            --accent-soft: #e4edf1;
            --ease-settle: cubic-bezier(0.22, 1, 0.36, 1);
        }
        body {
            background: #edeee7;
            height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            font-family: -apple-system, "Segoe UI", Roboto, "Helvetica Neue", Arial, sans-serif;
            background-image:
                repeating-linear-gradient(0deg, rgba(29,78,107,0.05) 0 1px, transparent 1px 48px),
                repeating-linear-gradient(90deg, rgba(29,78,107,0.05) 0 1px, transparent 1px 48px);
        }
        .launcher-card { max-width: 440px; width: 100%; border: 1px solid #d3d6cc; border-radius: 10px; overflow: hidden; }
        .launcher-card__head { background: var(--accent); color: #fff; padding: 1.1rem 1.4rem; }
        .launcher-card__eyebrow { font-family: ui-monospace, Consolas, monospace; font-size: 0.68rem; letter-spacing: 0.12em; text-transform: uppercase; opacity: 0.85; }
        .launcher-card__title { font-size: 1.35rem; font-weight: 700; margin: 0.1rem 0 0; letter-spacing: -0.01em; }
        .launcher-card .card-body { padding: 1.5rem; }
        #txtToken { font-family: ui-monospace, Consolas, monospace; font-size: 0.85rem; background: #f5f6f1; border-style: dashed; }
        .btn-primary { background: var(--accent); border-color: var(--accent); transition: transform 120ms var(--ease-settle), filter 120ms var(--ease-settle); }
        .btn-primary:hover { filter: brightness(1.08); }
        .btn-primary:active { transform: scale(0.97); }
        .form-control:focus, .form-select:focus { border-color: var(--accent); box-shadow: 0 0 0 0.2rem var(--accent-soft); }
        @media (prefers-reduced-motion: reduce) { .btn-primary { transition-duration: 1ms; } }
    </style>
</head>
<body>
    <div class="card shadow-sm launcher-card">
        <div class="launcher-card__head">
            <div class="launcher-card__eyebrow">Simulated App Launcher</div>
            <h4 class="launcher-card__title">QualityHD</h4>
        </div>
        <div class="card-body">
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
