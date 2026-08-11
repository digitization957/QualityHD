<%@ Page Title="Home Page" Language="C#" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="QualityHD._Default" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>QualityHD - HD Improvement Log</title>
    <link href="Content/bootstrap.min.css" rel="stylesheet" />
    <style>
        body { background: #f2f4f7; }
        .navbar-brand { font-weight: 600; }
        .table-responsive { background: #fff; border-radius: .5rem; }
        .section-title { font-weight: 600; margin-top: 1.25rem; margin-bottom: .5rem; border-bottom: 1px solid #dee2e6; padding-bottom: .25rem; }
        .plant-block { background: #f8f9fa; border: 1px solid #e9ecef; border-radius: .375rem; padding: .75rem; margin-bottom: .75rem; }
        .required-mark { color: #dc3545; }
    </style>
</head>
<body>
    <nav class="navbar navbar-dark bg-dark mb-4">
        <div class="container-fluid">
            <span class="navbar-brand">QualityHD - HD Improvement Log</span>
            <span class="d-flex align-items-center">
                <span class="badge bg-secondary me-3" id="roleBadge">Role</span>
                <button type="button" id="btnLogout" class="btn btn-outline-light btn-sm">Logout</button>
            </span>
        </div>
    </nav>

    <div class="container-fluid">
        <div class="d-flex justify-content-between align-items-center mb-3">
            <h5 class="mb-0">Improvement Items</h5>
            <button type="button" id="btnAddNew" class="btn btn-primary">+ Add New Item</button>
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

    <script src="Scripts/jquery-3.7.0.min.js"></script>
    <script src="Scripts/bootstrap.bundle.min.js"></script>
    <script src="Scripts/app/default.js"></script>
</body>
</html>
