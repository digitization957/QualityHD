<%@ Page Title="Home Page" Language="C#" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="QualityHD._Default" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>QualityHD - HD Improvement Log</title>
    <link href="Content/bootstrap.min.css" rel="stylesheet" />
    <style>
        :root {
            --teal: #0e5f57;
            --teal-soft: #e2efec;
            --teal-glow: rgba(14, 95, 87, 0.16);
            --gold: #b8791f;
            --gold-soft: #f7ecd8;
            --good: #2f7a4f;
            --good-soft: #e4f1e8;
            --ink-faint: #9aa39d;
            --line: #e1dfd6;
            --font-display: "Bahnschrift", "Segoe UI Variable Display", "Segoe UI", -apple-system, "Helvetica Neue", Arial, sans-serif;
            --font-body: "Segoe UI Variable Text", "Segoe UI", -apple-system, Roboto, "Helvetica Neue", Arial, sans-serif;
            --font-mono: "Cascadia Code", ui-monospace, Consolas, monospace;
        }
        body { background: #f3f2ee; font-family: var(--font-body); }
        .navbar { background: #fff !important; border-bottom: 1px solid var(--line); }
        .navbar-brand { font-family: var(--font-display); font-weight: 600; letter-spacing: -0.01em; color: #1c2320 !important; display: flex; align-items: center; gap: 0.6rem; }
        .brand-mark { width: 30px; height: 30px; border-radius: 8px; background: linear-gradient(155deg, var(--teal), #0a4841); color: #fff; font-family: var(--font-display); font-weight: 700; font-size: 0.85rem; display: flex; align-items: center; justify-content: center; }
        .role-chip { font-size: 0.72rem; font-weight: 600; letter-spacing: 0.03em; text-transform: uppercase; background: var(--teal-soft); color: var(--teal); padding: 0.3rem 0.65rem; border-radius: 100px; }
        h1, h2, h3, h5, .section-title { font-family: var(--font-display); }

        .stats-row { display: grid; grid-template-columns: repeat(4, 1fr); gap: 0.9rem; margin-bottom: 1.5rem; }
        @media (max-width: 820px) { .stats-row { grid-template-columns: repeat(2, 1fr); } }
        .stat-tile { background: #fff; border: 1px solid var(--line); border-radius: 12px; padding: 1rem 1.1rem; box-shadow: 0 1px 2px rgba(28,35,32,.04), 0 8px 24px -12px rgba(28,35,32,.12); }
        .stat-tile__label { font-size: 0.72rem; font-weight: 600; letter-spacing: 0.03em; color: #6b7570; margin-bottom: 0.35rem; }
        .stat-tile__value { font-family: var(--font-display); font-size: 1.6rem; font-weight: 700; letter-spacing: -0.01em; font-variant-numeric: tabular-nums; color: #1c2320; }
        .stat-tile__value.c-teal { color: var(--teal); }
        .stat-tile__value.c-gold { color: var(--gold); }
        .stat-tile__value.c-good { color: var(--good); }

        .table-responsive { background: #fff; border-radius: 12px; box-shadow: 0 1px 2px rgba(28,35,32,.04), 0 8px 24px -12px rgba(28,35,32,.12); }
        .table-light th { font-size: 0.68rem; letter-spacing: 0.06em; text-transform: uppercase; color: var(--ink-faint); }
        .mono { font-family: var(--font-mono); font-variant-numeric: tabular-nums; }
        .pill-plant { display: inline-block; font-size: 0.7rem; font-weight: 600; padding: 0.16rem 0.5rem; border-radius: 100px; background: #e6edf8; color: #3060a8; font-family: var(--font-mono); margin: 0 0.15rem 0.15rem 0; }
        .pill-type { font-size: 0.7rem; font-weight: 600; padding: 0.16rem 0.5rem; border-radius: 100px; }
        .pill-type-reactive { background: var(--gold-soft); color: var(--gold); }
        .pill-type-proactive { background: var(--good-soft); color: var(--good); }

        .section-title { font-weight: 600; font-size: 1.02rem; letter-spacing: -0.005em; margin-top: 1.5rem; margin-bottom: .35rem; border-bottom: none; padding-bottom: 0; color: #1c2320; }
        .plant-block { background: #faf9f6; border: 1px solid var(--line); border-radius: .5rem; padding: .75rem; margin-bottom: .75rem; }
        .required-mark { color: #dc3545; }

        .btn-primary { background: var(--teal); border-color: var(--teal); }
        .btn-primary:hover { filter: brightness(1.08); background: var(--teal); border-color: var(--teal); }
        .form-control:focus, .form-select:focus { border-color: var(--teal); box-shadow: 0 0 0 3px var(--teal-glow); }

        .toast-confirm {
            position: fixed; right: 1.25rem; bottom: 1.25rem; z-index: 60;
            background: #1c2320; color: #f3f2ee; padding: 0.75rem 1.05rem; border-radius: 10px; font-size: 0.85rem;
            display: flex; align-items: center; gap: 0.6rem; box-shadow: 0 20px 60px -20px rgba(0,0,0,0.5);
            opacity: 0; transform: translateY(8px); transition: opacity 180ms ease, transform 180ms ease;
            pointer-events: none;
        }
        .toast-confirm.show { opacity: 1; transform: translateY(0); }
        .toast-confirm__dot { width: 7px; height: 7px; border-radius: 50%; background: var(--good); flex: none; }

        @media (prefers-reduced-motion: reduce) { * { transition-duration: 1ms !important; } }
    </style>
</head>
<body>
    <nav class="navbar mb-4">
        <div class="container-fluid">
            <span class="navbar-brand"><span class="brand-mark">HD</span> QualityHD &mdash; HD Improvement Log</span>
            <span class="d-flex align-items-center">
                <span class="role-chip me-3" id="roleBadge">Role</span>
                <button type="button" id="btnLogout" class="btn btn-outline-secondary btn-sm">Logout</button>
            </span>
        </div>
    </nav>

    <div class="container-fluid">
        <div class="stats-row">
            <div class="stat-tile"><div class="stat-tile__label">Total items</div><div class="stat-tile__value" id="statTotal">0</div></div>
            <div class="stat-tile"><div class="stat-tile__label">Reactive</div><div class="stat-tile__value c-gold" id="statReactive">0</div></div>
            <div class="stat-tile"><div class="stat-tile__label">Proactive</div><div class="stat-tile__value c-good" id="statProactive">0</div></div>
            <div class="stat-tile"><div class="stat-tile__label">Plants covered</div><div class="stat-tile__value c-teal" id="statPlants">0</div></div>
        </div>

        <div class="d-flex justify-content-between align-items-center mb-3 flex-wrap gap-2">
            <h5 class="mb-0">Improvement Items</h5>
            <div class="d-flex align-items-center gap-2">
                <input type="text" id="searchInput" class="form-control form-control-sm" style="width:220px;" placeholder="Search theme or plant…" />
                <button type="button" id="btnAddNew" class="btn btn-primary">+ Add New Item</button>
            </div>
        </div>

        <div id="loadError" class="alert alert-danger d-none"></div>

        <div class="table-responsive">
            <table class="table table-hover align-middle mb-0">
                <thead class="table-light">
                    <tr>
                        <th>#</th>
                        <th>HD Theme</th>
                        <th>Type</th>
                        <th>Source Plant</th>
                        <th>Aggregate</th>
                        <th>Model Family</th>
                        <th>Issue Source</th>
                        <th>Cases</th>
                        <th>Category</th>
                        <th>Applicable Plants</th>
                        <th>Created By</th>
                        <th>Created At</th>
                    </tr>
                </thead>
                <tbody id="itemsBody">
                </tbody>
            </table>
        </div>
        <div id="emptyState" class="text-center text-muted py-5 d-none">No improvement items logged yet.</div>
    </div>

    <!-- Add New Item Modal -->
    <div class="modal fade" id="addItemModal" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog modal-fullscreen-lg-down modal-xl">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">Add New HD Improvement Item</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <div id="formError" class="alert alert-danger d-none"></div>
                    <form id="hdForm" novalidate>
                        <div class="section-title">Core Details</div>
                        <div class="row g-3">
                            <div class="col-md-6">
                                <label class="form-label">HD Theme <span class="required-mark">*</span></label>
                                <input type="text" class="form-control" id="hdTheme" maxlength="255" required />
                            </div>
                            <div class="col-md-3">
                                <label class="form-label">Improvement Type <span class="required-mark">*</span></label>
                                <select class="form-select" id="improvementType" required>
                                    <option value="">Select</option>
                                    <option>Reactive</option>
                                    <option>Proactive</option>
                                </select>
                            </div>
                            <div class="col-md-3">
                                <label class="form-label">HD Source Plant <span class="required-mark">*</span></label>
                                <select class="form-select" id="hdSourcePlant" required>
                                    <option value="">Select</option>
                                    <option>NGP</option><option>ZHB</option><option>RDP</option>
                                    <option>JPR</option><option>RJK</option><option>KND</option>
                                </select>
                            </div>

                            <div class="col-md-4">
                                <label class="form-label">Aggregate <span class="required-mark">*</span></label>
                                <select class="form-select" id="aggregateType" required>
                                    <option value="">Select</option>
                                    <option>Tractor</option><option>Transmission</option><option>Engine</option>
                                    <option>VTU Assembly</option><option>CV Assembly</option><option>Machine Shop</option>
                                    <option>Front Axle</option><option>PTCD</option><option>Paint Shop</option>
                                </select>
                            </div>
                            <div class="col-md-4">
                                <label class="form-label">Model Family <span class="required-mark">*</span></label>
                                <select class="form-select" id="modelFamily" required>
                                    <option value="">Select</option>
                                    <option>H1</option><option>H2</option><option>YT+</option><option>Novo</option>
                                    <option>OJA</option><option>JIVO</option><option>H3</option><option>H1R</option>
                                </select>
                            </div>
                            <div class="col-md-4">
                                <label class="form-label">Issue Source <span class="required-mark">*</span></label>
                                <select class="form-select" id="issueSource" required>
                                    <option value="">Select</option>
                                    <option>Domestic CVL</option><option>CLR</option><option>Traveler Card</option>
                                    <option>IO CVL</option><option>IO Field Issue</option><option>Proactive Improvement</option>
                                    <option>Gate Audit</option>
                                </select>
                            </div>

                            <div class="col-md-3">
                                <label class="form-label">Cases <span class="required-mark">*</span></label>
                                <input type="number" min="0" class="form-control" id="casesCount" required />
                                <div class="form-text">Nos of Cases reported in Current FY &amp; Last FY</div>
                            </div>
                            <div class="col-md-9">
                                <label class="form-label">Improvement Category <span class="required-mark">*</span></label>
                                <select class="form-select" id="improvementCategory" required>
                                    <option value="">Select</option>
                                    <option>Poka-Yoke</option><option>Process Improvement</option>
                                    <option>Supplier Process Improvement</option><option>Facility Improvement</option>
                                    <option>Part Standardisation</option><option>Design Improvement</option>
                                </select>
                            </div>

                            <div class="col-12">
                                <label class="form-label">Description of reported issue or Improvement <span class="required-mark">*</span></label>
                                <textarea class="form-control" id="description" rows="2" maxlength="4000" required></textarea>
                            </div>
                            <div class="col-12">
                                <label class="form-label">Analysis details <span class="required-mark">*</span></label>
                                <textarea class="form-control" id="analysisDetails" rows="2" maxlength="4000" required></textarea>
                            </div>
                            <div class="col-12">
                                <label class="form-label">Action / Improvement details <span class="required-mark">*</span></label>
                                <textarea class="form-control" id="actionDetails" rows="2" maxlength="4000" required></textarea>
                                <div class="form-text">Put complete details of Improvement along with Implementation date &amp; Images.</div>
                            </div>

                            <div class="col-12">
                                <label class="form-label">HD Applicable Plants <span class="required-mark">*</span></label>
                                <div class="form-text mb-1">Select all applicable plants; if unsure, select all.</div>
                                <div class="d-flex flex-wrap gap-3">
                                    <div class="form-check"><input class="form-check-input plant-check" type="checkbox" value="NGP" id="plantNGP"><label class="form-check-label" for="plantNGP">NGP</label></div>
                                    <div class="form-check"><input class="form-check-input plant-check" type="checkbox" value="ZHB" id="plantZHB"><label class="form-check-label" for="plantZHB">ZHB</label></div>
                                    <div class="form-check"><input class="form-check-input plant-check" type="checkbox" value="RDP" id="plantRDP"><label class="form-check-label" for="plantRDP">RDP</label></div>
                                    <div class="form-check"><input class="form-check-input plant-check" type="checkbox" value="JPR" id="plantJPR"><label class="form-check-label" for="plantJPR">JPR</label></div>
                                    <div class="form-check"><input class="form-check-input plant-check" type="checkbox" value="RJK" id="plantRJK"><label class="form-check-label" for="plantRJK">RJK</label></div>
                                    <div class="form-check"><input class="form-check-input plant-check" type="checkbox" value="KND" id="plantKND"><label class="form-check-label" for="plantKND">KND</label></div>
                                </div>
                            </div>

                            <div class="col-12">
                                <label class="form-label">Responsible persons for HD <span class="required-mark">*</span></label>
                                <input type="text" class="form-control" id="responsiblePersons" placeholder="name1@company.com, name2@company.com" required />
                                <div class="form-text">Comma-separated email addresses of Process/MFG/QA owners to notify.</div>
                            </div>

                            <div class="col-12">
                                <label class="form-label">Attachments</label>
                                <input type="file" class="form-control" id="attachmentFiles" multiple accept=".pdf,.png,.jpg,.jpeg,.doc,.docx,.xls,.xlsx" />
                                <div class="form-text">PDF, Office docs or images, up to 10 MB each.</div>
                                <div id="attachmentList" class="mt-2 small"></div>
                            </div>
                        </div>

                        <div class="section-title">Plant-wise ORC Tracking</div>
                        <div class="row g-3">
                            <div class="col-md-6" data-plant="ngp">
                                <div class="plant-block">
                                    <strong>NGP</strong>
                                    <div class="row g-2 mt-1">
                                        <div class="col-4">
                                            <label class="form-label small mb-0">ORC Status</label>
                                            <select class="form-select form-select-sm plant-status">
                                                <option>Open</option><option>R1</option><option>R2</option><option>Closed</option><option>Initiator</option><option>Not Applicable</option>
                                            </select>
                                        </div>
                                        <div class="col-4">
                                            <label class="form-label small mb-0">Target date</label>
                                            <input type="date" class="form-control form-control-sm plant-date" />
                                        </div>
                                        <div class="col-12">
                                            <label class="form-label small mb-0">HD details</label>
                                            <textarea class="form-control form-control-sm plant-details" rows="2"></textarea>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="col-md-6" data-plant="zhb">
                                <div class="plant-block">
                                    <strong>ZHB</strong>
                                    <div class="row g-2 mt-1">
                                        <div class="col-4"><label class="form-label small mb-0">ORC Status</label>
                                            <select class="form-select form-select-sm plant-status">
                                                <option>Open</option><option>R1</option><option>R2</option><option>Closed</option><option>Initiator</option><option>Not Applicable</option>
                                            </select>
                                        </div>
                                        <div class="col-4"><label class="form-label small mb-0">Target date</label><input type="date" class="form-control form-control-sm plant-date" /></div>
                                        <div class="col-12"><label class="form-label small mb-0">HD details</label><textarea class="form-control form-control-sm plant-details" rows="2"></textarea></div>
                                    </div>
                                </div>
                            </div>
                            <div class="col-md-6" data-plant="rdp">
                                <div class="plant-block">
                                    <strong>RDP</strong>
                                    <div class="row g-2 mt-1">
                                        <div class="col-4"><label class="form-label small mb-0">ORC Status</label>
                                            <select class="form-select form-select-sm plant-status">
                                                <option>Open</option><option>R1</option><option>R2</option><option>Closed</option><option>Initiator</option><option>Not Applicable</option>
                                            </select>
                                        </div>
                                        <div class="col-4"><label class="form-label small mb-0">Target date</label><input type="date" class="form-control form-control-sm plant-date" /></div>
                                        <div class="col-12"><label class="form-label small mb-0">HD details</label><textarea class="form-control form-control-sm plant-details" rows="2"></textarea></div>
                                    </div>
                                </div>
                            </div>
                            <div class="col-md-6" data-plant="jpr">
                                <div class="plant-block">
                                    <strong>JPR</strong>
                                    <div class="row g-2 mt-1">
                                        <div class="col-4"><label class="form-label small mb-0">ORC Status</label>
                                            <select class="form-select form-select-sm plant-status">
                                                <option>Open</option><option>R1</option><option>R2</option><option>Closed</option><option>Initiator</option><option>Not Applicable</option>
                                            </select>
                                        </div>
                                        <div class="col-4"><label class="form-label small mb-0">Target date</label><input type="date" class="form-control form-control-sm plant-date" /></div>
                                        <div class="col-12"><label class="form-label small mb-0">HD details</label><textarea class="form-control form-control-sm plant-details" rows="2"></textarea></div>
                                    </div>
                                </div>
                            </div>
                            <div class="col-md-6" data-plant="rjk">
                                <div class="plant-block">
                                    <strong>RJK</strong>
                                    <div class="row g-2 mt-1">
                                        <div class="col-4"><label class="form-label small mb-0">ORC Status</label>
                                            <select class="form-select form-select-sm plant-status">
                                                <option>Not Applicable</option><option>Open</option><option>R1</option><option>R2</option><option>Closed</option><option>Initiator</option>
                                            </select>
                                        </div>
                                        <div class="col-4"><label class="form-label small mb-0">Target date</label><input type="date" class="form-control form-control-sm plant-date" /></div>
                                        <div class="col-12"><label class="form-label small mb-0">HD details</label><textarea class="form-control form-control-sm plant-details" rows="2"></textarea></div>
                                    </div>
                                </div>
                            </div>
                            <div class="col-md-6" data-plant="knd">
                                <div class="plant-block">
                                    <strong>KND</strong>
                                    <div class="row g-2 mt-1">
                                        <div class="col-4"><label class="form-label small mb-0">ORC Status</label>
                                            <select class="form-select form-select-sm plant-status">
                                                <option>Not Applicable</option><option>Open</option><option>R1</option><option>R2</option><option>Closed</option><option>Initiator</option>
                                            </select>
                                        </div>
                                        <div class="col-4"><label class="form-label small mb-0">Target date</label><input type="date" class="form-control form-control-sm plant-date" /></div>
                                        <div class="col-12"><label class="form-label small mb-0">HD details</label><textarea class="form-control form-control-sm plant-details" rows="2"></textarea></div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </form>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                    <button type="button" id="btnSaveItem" class="btn btn-primary">Save</button>
                </div>
            </div>
        </div>
    </div>

    <div class="toast-confirm" id="toastConfirm"><span class="toast-confirm__dot"></span><span id="toastConfirmText">Saved</span></div>

    <script src="Scripts/jquery-3.7.0.min.js"></script>
    <script src="Scripts/bootstrap.bundle.min.js"></script>
    <script src="Scripts/app/default.js"></script>
</body>
</html>
