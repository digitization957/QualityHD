<%@ Page Title="Home Page" Language="C#" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="QualityHD._Default" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>QualityHD - HD FD Tracker</title>
    <link href="Content/bootstrap.min.css" rel="stylesheet" />
    <style>
        :root {
            --paper: #f6f3ec;
            --surface: #ffffff;
            --ink: #2a2e29;
            --ink-soft: #6f7568;
            --ink-faint: #9a9d8f;
            --line: #e6e1d2;

            --sage: #4f7c6c;
            --sage-tint: #e2ece6;
            --sage-glow: rgba(79, 124, 108, 0.16);
            --amber: #b8783a;
            --amber-tint: #f5e7d3;
            --moss: #5c8a52;
            --moss-tint: #e6efdf;
            --clay: #b4685a;
            --clay-tint: #f4e2dd;
            --sky: #3f6f9e;
            --sky-tint: #e2ebf3;

            --font-display: "Bahnschrift", "Segoe UI Variable Display", "Segoe UI Semibold", "Segoe UI", -apple-system, "Helvetica Neue", Arial, sans-serif;
            --font-body: "Segoe UI Variable Text", "Segoe UI", -apple-system, Roboto, "Helvetica Neue", Arial, sans-serif;
            --font-mono: "Cascadia Code", ui-monospace, Consolas, monospace;
        }
        * { -webkit-font-smoothing: antialiased; }
        body { background: var(--paper); font-family: var(--font-body); color: var(--ink); }
        .navbar { background: var(--surface) !important; border-bottom: 1px solid var(--line); padding-top: .6rem; padding-bottom: .6rem; }
        .navbar-brand { font-family: var(--font-display); font-weight: 600; letter-spacing: -0.01em; color: var(--ink) !important; display: flex; align-items: center; gap: 0.65rem; }
        .brand-mark { width: 32px; height: 32px; border-radius: 9px; background: var(--sage); color: #fff; font-family: var(--font-display); font-weight: 700; font-size: 0.85rem; display: flex; align-items: center; justify-content: center; }
        .role-chip { font-size: 0.7rem; font-weight: 600; letter-spacing: 0.04em; text-transform: uppercase; background: var(--sage-tint); color: var(--sage); padding: 0.32rem 0.7rem; border-radius: 100px; }
        h1, h2, h3, h5, .section-title { font-family: var(--font-display); }

        .stats-row { display: grid; grid-template-columns: repeat(4, 1fr); gap: .75rem; margin-bottom: 1rem; }
        @media (max-width: 820px) { .stats-row { grid-template-columns: repeat(2, 1fr); } }
        .stat-tile { background: var(--surface); border: 1px solid var(--line); border-radius: 12px; padding: .7rem 1rem; }
        .stat-tile__label { font-size: 0.7rem; font-weight: 600; letter-spacing: 0.04em; text-transform: uppercase; color: var(--ink-soft); margin-bottom: 0.25rem; }
        .stat-tile__value { font-family: var(--font-display); font-size: 1.35rem; font-weight: 700; letter-spacing: -0.01em; font-variant-numeric: tabular-nums; color: var(--ink); }
        .stat-tile__value.c-teal { color: var(--sage); }
        .stat-tile__value.c-gold { color: var(--amber); }
        .stat-tile__value.c-good { color: var(--moss); }

        .table-responsive { background: var(--surface); border-radius: 14px; border: 1px solid var(--line); max-height: calc(100vh - 260px); min-height: 220px; overflow-y: auto; }
        .table-light th { position: sticky; top: 0; z-index: 2; font-size: 0.68rem; letter-spacing: 0.07em; text-transform: uppercase; color: #000; font-weight: 700; background: var(--paper); border-bottom: 1px solid var(--line); }
        .table > :not(caption) > * > * { padding: .6rem .85rem; }
        .table-hover > tbody > tr:hover > * { background-color: var(--sage-tint); }
        .mono { font-family: var(--font-mono); font-variant-numeric: tabular-nums; color: var(--ink-soft); }
        .pill-plant { display: inline-block; font-size: 0.7rem; font-weight: 600; padding: 0.18rem 0.55rem; border-radius: 6px; background: var(--sky-tint); color: var(--sky); font-family: var(--font-mono); margin: 0 0.2rem 0.2rem 0; letter-spacing: 0.02em; }
        .pill-type { font-size: 0.7rem; font-weight: 600; padding: 0.18rem 0.55rem; border-radius: 100px; }
        .pill-type-reactive { background: var(--amber-tint); color: var(--amber); }
        .pill-type-proactive { background: var(--moss-tint); color: var(--moss); }

        .scope-group { position: relative; display: inline-flex; background: var(--paper); border: 1px solid var(--line); border-radius: 100px; padding: .2rem; gap: .15rem; }
        .scope-thumb { position: absolute; top: .2rem; bottom: .2rem; left: 0; border-radius: 100px; background: var(--surface); box-shadow: 0 1px 2px rgba(28,35,32,.08); transition: left 220ms cubic-bezier(.4,0,.2,1), width 220ms cubic-bezier(.4,0,.2,1); z-index: 0; }
        .scope-pill { position: relative; z-index: 1; border: none; background: transparent; color: var(--ink-soft); font-size: .78rem; font-weight: 500; padding: .3rem .8rem; border-radius: 100px; cursor: pointer; transition: color 160ms ease; }
        .scope-pill:hover { color: var(--ink); }
        .scope-pill.active { color: var(--sage); font-weight: 600; }

        tbody tr.row-clickable { cursor: pointer; }
        tbody tr.row-fade { transition: opacity 160ms ease; }

        /* User menu */
        .user-menu { position: relative; }
        .user-icon-btn { width: 36px; height: 36px; border-radius: 50%; background: var(--sage-tint); color: var(--sage); border: none; display: flex; align-items: center; justify-content: center; cursor: pointer; font-weight: 700; font-family: var(--font-display); font-size: .82rem; transition: filter 140ms ease; }
        .user-icon-btn:hover { filter: brightness(0.95); }
        .user-popover { position: absolute; top: calc(100% + 10px); right: 0; width: 270px; background: var(--surface); border: 1px solid var(--line); border-radius: 16px; box-shadow: 0 24px 60px -20px rgba(42,46,41,.3); padding: .85rem; opacity: 0; transform: translateY(-6px) scale(.98); pointer-events: none; transition: opacity 160ms ease, transform 160ms ease; z-index: 80; }
        .user-popover.show { opacity: 1; transform: translateY(0) scale(1); pointer-events: auto; }

        .user-popover__header { display: flex; align-items: center; gap: .7rem; padding: .3rem .35rem .7rem; }
        .user-popover__avatar { width: 42px; height: 42px; flex: none; border-radius: 12px; background: var(--sage); color: #fff; display: flex; align-items: center; justify-content: center; font-family: var(--font-display); font-weight: 700; font-size: .95rem; }
        .user-popover__identity { min-width: 0; }
        .user-popover__plant { font-family: var(--font-display); font-weight: 700; font-size: .98rem; color: var(--ink); letter-spacing: -0.01em; }
        .user-popover__role { font-size: .74rem; color: var(--ink-soft); margin-top: .1rem; }
        .user-popover__divider { height: 1px; background: var(--line); margin: 0 -.85rem; }

        .user-popover__row { display: flex; justify-content: space-between; align-items: center; gap: .75rem; padding: .7rem .35rem; }
        .user-popover__label { color: var(--ink-faint); font-size: .68rem; text-transform: uppercase; letter-spacing: .05em; font-weight: 600; }
        .user-popover__value { font-weight: 600; color: var(--ink-soft); font-family: var(--font-mono); font-size: .76rem; }
        .user-popover__logout { display: flex; align-items: center; justify-content: center; gap: .45rem; width: 100%; margin-top: .3rem; padding: .55rem; border-radius: 10px; border: 1px solid var(--clay-tint); background: var(--clay-tint); color: var(--clay); font-weight: 600; font-size: .85rem; cursor: pointer; transition: filter 140ms ease; }
        .user-popover__logout:hover { filter: brightness(0.97); }

        /* View item modal */
        .view-meta { display: flex; flex-direction: column; gap: .4rem; margin-bottom: 1.25rem; padding-bottom: 1rem; border-bottom: 1px solid var(--line); }
        .view-meta__top { display: flex; align-items: center; gap: .5rem; flex-wrap: wrap; }
        .view-meta__by { font-size: .78rem; color: var(--ink-faint); }
        .view-grid { display: grid; grid-template-columns: repeat(3, 1fr); gap: .6rem; margin-bottom: 1.25rem; }
        @media (max-width: 700px) { .view-grid { grid-template-columns: repeat(2, 1fr); } }
        .view-field { background: var(--paper); border: 1px solid var(--line); border-radius: 10px; padding: .55rem .7rem; }
        .view-field__label { font-size: .64rem; font-weight: 700; letter-spacing: .05em; text-transform: uppercase; color: var(--ink-faint); margin-bottom: .3rem; }
        .view-field__value { font-size: .86rem; font-weight: 500; color: var(--ink); }
        .view-block { margin-bottom: 1.25rem; }
        .view-block__label { font-size: .72rem; font-weight: 700; text-transform: uppercase; letter-spacing: .05em; color: var(--sage); margin-bottom: .4rem; }
        .view-block__text { font-size: .87rem; color: var(--ink); white-space: pre-wrap; line-height: 1.55; background: var(--paper); border: 1px solid var(--line); border-radius: 10px; padding: .65rem .8rem; }
        .view-orc-table { width: 100%; border-collapse: collapse; font-size: .82rem; border: 1px solid var(--line); border-radius: 10px; overflow: hidden; }
        .view-orc-table th { text-align: left; font-size: .64rem; font-weight: 700; text-transform: uppercase; letter-spacing: .05em; color: var(--ink-faint); background: var(--paper); border-bottom: 1px solid var(--line); padding: .55rem .65rem; }
        .view-orc-table td { padding: .55rem .65rem; border-bottom: 1px solid var(--line); vertical-align: top; color: var(--ink); }
        .view-orc-table tr:last-child td { border-bottom: none; }

        .section-title { font-weight: 600; font-size: 0.78rem; letter-spacing: 0.06em; text-transform: uppercase; margin-top: 1.25rem; margin-bottom: .65rem; padding-bottom: .4rem; border-bottom: 1px solid var(--line); color: var(--ink-soft); }
        .plant-block { background: var(--paper); border: 1px solid var(--line); border-radius: 10px; padding: .65rem; margin-bottom: .6rem; }
        .plant-block strong { font-family: var(--font-mono); font-size: .78rem; letter-spacing: .04em; color: var(--sage); }
        .required-mark { color: var(--clay); }

        /* Fixed-height textareas: content scrolls inside instead of growing the box */
        textarea.form-control { resize: none; overflow-y: auto; height: 4.4rem; }
        textarea.plant-details { height: 2.8rem; }
        .char-counter { display: block; text-align: right; font-size: .72rem; color: var(--ink-faint); margin-top: .2rem; }
        .char-counter.warn { color: var(--amber); }
        .char-counter.max { color: var(--clay); font-weight: 600; }

        .btn-primary { background: var(--sage); border-color: var(--sage); font-weight: 500; }
        .btn-primary:hover { filter: brightness(1.08); background: var(--sage); border-color: var(--sage); }
        .btn, .form-control, .form-select { border-radius: 8px; }
        .form-control:focus, .form-select:focus { border-color: var(--sage); box-shadow: 0 0 0 3px var(--sage-glow); }
        .modal-content { border-radius: 16px; border: 1px solid var(--line); }
        .card { border-radius: 14px; }

        .toast-confirm {
            position: fixed; right: 1.25rem; bottom: 1.25rem; z-index: 60;
            background: var(--ink); color: var(--paper); padding: 0.75rem 1.05rem; border-radius: 10px; font-size: 0.85rem;
            display: flex; align-items: center; gap: 0.6rem; box-shadow: 0 20px 60px -20px rgba(0,0,0,0.5);
            opacity: 0; transform: translateY(8px); transition: opacity 180ms ease, transform 180ms ease;
            pointer-events: none;
        }
        .toast-confirm.show { opacity: 1; transform: translateY(0); }
        .toast-confirm__dot { width: 7px; height: 7px; border-radius: 50%; background: var(--moss); flex: none; }

        @media (prefers-reduced-motion: reduce) { * { transition-duration: 1ms !important; } }
    </style>
</head>
<body>
    <nav class="navbar mb-3">
        <div class="container-fluid">
            <span class="navbar-brand"><span class="brand-mark">HD</span> QualityHD &mdash; HD FD Tracker</span>
            <span class="user-menu">
                <button type="button" class="user-icon-btn" id="btnUserMenu" aria-haspopup="true" aria-expanded="false" title="Account">U</button>
                <div class="user-popover" id="userPopover">
                    <div class="user-popover__header">
                        <span class="user-popover__avatar" id="popoverAvatar">U</span>
                        <div class="user-popover__identity">
                            <div class="user-popover__plant" id="popoverPlant">&mdash;</div>
                            <div class="user-popover__role" id="popoverRole">&mdash;</div>
                        </div>
                    </div>
                    <div class="user-popover__divider"></div>
                    <div class="user-popover__row">
                        <span class="user-popover__label">Session token</span>
                        <span class="user-popover__value" id="popoverToken">&mdash;</span>
                    </div>
                    <button type="button" id="btnLogout" class="user-popover__logout">
                        <svg width="15" height="15" viewBox="0 0 16 16" fill="none" xmlns="http://www.w3.org/2000/svg"><path d="M6 2H3.5A1.5 1.5 0 0 0 2 3.5v9A1.5 1.5 0 0 0 3.5 14H6" stroke="currentColor" stroke-width="1.4" stroke-linecap="round"/><path d="M10.5 11 14 8l-3.5-3M14 8H6" stroke="currentColor" stroke-width="1.4" stroke-linecap="round" stroke-linejoin="round"/></svg>
                        Log out
                    </button>
                </div>
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

        <div class="d-flex justify-content-between align-items-center mb-2 flex-wrap gap-2">
            <div class="d-flex align-items-center gap-2 flex-wrap">
                <h5 class="mb-0 me-2">Improvement Items</h5>
                <div class="scope-group" role="group" aria-label="Filter by plant" id="scopeGroup">
                    <span class="scope-thumb" id="scopeThumb"></span>
                    <button type="button" class="scope-pill active" data-scope="all">All</button>
                    <button type="button" class="scope-pill" data-scope="own">Own</button>
                    <button type="button" class="scope-pill" data-scope="assigned">Assigned</button>
                </div>
            </div>
            <div class="d-flex align-items-center gap-2">
                <input type="text" id="searchInput" class="form-control form-control-sm" style="width:220px;" placeholder="Search theme or plant…" />
                <button type="button" id="btnAddNew" class="btn btn-primary text-nowrap flex-shrink-0">+ Add New Item</button>
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
        <div class="modal-dialog modal-fullscreen-lg-down modal-xl modal-dialog-scrollable">
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
                                <textarea class="form-control char-limited" id="description" maxlength="250" required></textarea>
                                <span class="char-counter" data-counter-for="description">0 / 250</span>
                            </div>
                            <div class="col-12">
                                <label class="form-label">Analysis details <span class="required-mark">*</span></label>
                                <textarea class="form-control char-limited" id="analysisDetails" maxlength="250" required></textarea>
                                <span class="char-counter" data-counter-for="analysisDetails">0 / 250</span>
                            </div>
                            <div class="col-12">
                                <label class="form-label">Action / Improvement details <span class="required-mark">*</span></label>
                                <textarea class="form-control char-limited" id="actionDetails" maxlength="250" required></textarea>
                                <span class="char-counter" data-counter-for="actionDetails">0 / 250</span>
                                <div class="form-text">Put complete details of Improvement along with Implementation date &amp; Images.</div>
                            </div>

                            <div class="col-12">
                                <label class="form-label">HD Applicable Plants <span class="required-mark">*</span></label>
                                <div class="form-text mb-1">Select all applicable plants; if unsure, select all.</div>
                                <div class="d-flex flex-wrap gap-3" id="applicablePlantsGroup"></div>
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
                    </form>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                    <button type="button" id="btnSaveItem" class="btn btn-primary">Save</button>
                </div>
            </div>
        </div>
    </div>

    <!-- View Item Details Modal -->
    <div class="modal fade" id="viewItemModal" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog modal-lg modal-dialog-scrollable">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="viewTitle">HD Improvement Item</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body" id="viewBody">
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
