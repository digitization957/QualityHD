// STANDALONE DEMO: no login, no server calls, no DB. All data lives in
// memory (allItems array) so this page can be opened and demoed anywhere.
// UI/behaviour mirrors Default.aspx + Scripts/app/default.js.

var DEMO_PLANTS = ['NGP', 'ZHB', 'RDP', 'JPR', 'RJK', 'KND'];
var CURRENT_PLANT = 'NGP'; // stands in for the logged-in user's plant (Own/Assigned filter)

function escapeHtml(value) {
    return $('<div>').text(value == null ? '' : value).html();
}

var toastTimer = null;
function showToast(text) {
    var $toast = $('#toastConfirm');
    $('#toastConfirmText').text(text);
    $toast.addClass('show');
    clearTimeout(toastTimer);
    toastTimer = setTimeout(function () { $toast.removeClass('show'); }, 2400);
}

$('#btnUserMenu').on('click', function (e) {
    e.stopPropagation();
    var showing = $('#userPopover').toggleClass('show').hasClass('show');
    $(this).attr('aria-expanded', showing);
});
$(document).on('click', function (e) {
    if (!$(e.target).closest('.user-menu').length) {
        $('#userPopover').removeClass('show');
        $('#btnUserMenu').attr('aria-expanded', false);
    }
});
$('#btnLogout').on('click', function () {
    seedItems();
    scope = 'all';
    searchTerm = '';
    $('#searchInput').val('');
    $('.scope-pill').removeClass('active').filter('[data-scope="all"]').addClass('active');
    moveScopeThumb();
    renderItems();
    showToast('Demo data reset');
});

var nextId = 1;
var allItems = [];
var searchTerm = '';
var scope = 'all';

function seedItems() {
    nextId = 1;
    allItems = [
        mkItem('Coolant leakage at VTU assembly joint', 'Reactive', 'NGP', 'VTU Assembly', 'H1', 'Domestic CVL', 6, 'Poka-Yoke', 'NGP,ZHB,RDP', 'User'),
        mkItem('Torque mismatch on front axle bolts', 'Proactive', 'ZHB', 'Front Axle', 'Novo', 'Proactive Improvement', 2, 'Process Improvement', 'ZHB,JPR', 'User'),
        mkItem('Paint shop surface defect - orange peel', 'Reactive', 'RDP', 'Paint Shop', 'H2', 'Traveler Card', 4, 'Facility Improvement', 'RDP,KND', 'User'),
        mkItem('Transmission gear noise during test run', 'Reactive', 'JPR', 'Transmission', 'YT+', 'IO Field Issue', 3, 'Design Improvement', 'JPR,NGP,RJK', 'User'),
        mkItem('Engine oil seal fitment improvement', 'Proactive', 'RJK', 'Engine', 'OJA', 'Gate Audit', 1, 'Part Standardisation', 'RJK', 'User'),
        mkItem('Machine shop dimensional variation - CV shaft', 'Reactive', 'KND', 'Machine Shop', 'JIVO', 'IO CVL', 5, 'Supplier Process Improvement', 'KND,NGP', 'User')
    ];
}

function mkItem(theme, type, sourcePlant, aggregate, model, issueSource, cases, category, applicablePlants, role) {
    return {
        id: nextId++,
        hdTheme: theme,
        improvementType: type,
        hdSourcePlant: sourcePlant,
        aggregateType: aggregate,
        description: theme + ' — reported during routine inspection.',
        modelFamily: model,
        issueSource: issueSource,
        casesCount: cases,
        analysisDetails: 'Root cause analysis pending demo entry.',
        actionDetails: 'Corrective action to be logged.',
        improvementCategory: category,
        hdApplicablePlants: applicablePlants,
        responsiblePersons: 'demo.owner@company.com',
        attachments: '',
        createdByRole: role,
        createdAt: new Date().toISOString().slice(0, 16).replace('T', ' '),
        plants: DEMO_PLANTS.map(function (p) {
            return { plant: p, status: p === sourcePlant ? 'Initiator' : 'Open', targetDate: null, details: null };
        })
    };
}

function moveScopeThumb() {
    var $active = $('.scope-pill.active');
    var $thumb = $('#scopeThumb');
    if (!$active.length || !$thumb.length) return;
    $thumb.css({ width: $active.outerWidth() + 'px', left: $active[0].offsetLeft + 'px' });
}

$('.scope-pill').on('click', function () {
    scope = $(this).data('scope');
    $('.scope-pill').removeClass('active');
    $(this).addClass('active');
    moveScopeThumb();
    renderItems();
});
$(window).on('resize', moveScopeThumb);

function renderStats(items) {
    $('#statTotal').text(items.length);
    $('#statReactive').text(items.filter(function (i) { return i.improvementType === 'Reactive'; }).length);
    $('#statProactive').text(items.filter(function (i) { return i.improvementType === 'Proactive'; }).length);
    var plantSet = {};
    items.forEach(function (i) { i.hdApplicablePlants.split(',').forEach(function (p) { plantSet[p] = true; }); });
    $('#statPlants').text(Object.keys(plantSet).length);
}

function scopedItems() {
    if (scope === 'own') return allItems.filter(function (i) { return i.hdSourcePlant === CURRENT_PLANT; });
    if (scope === 'assigned') return allItems.filter(function (i) {
        return i.hdSourcePlant !== CURRENT_PLANT && i.hdApplicablePlants.split(',').indexOf(CURRENT_PLANT) !== -1;
    });
    return allItems;
}

function renderItems(highlightId) {
    var scoped = scopedItems();
    renderStats(scoped);

    var filtered = scoped.filter(function (item) {
        if (!searchTerm) return true;
        var hay = (item.hdTheme + ' ' + item.hdApplicablePlants + ' ' + item.hdSourcePlant).toLowerCase();
        return hay.indexOf(searchTerm) !== -1;
    });

    var $body = $('#itemsBody').empty();

    if (filtered.length === 0) {
        $('#emptyState').removeClass('d-none').text(
            scoped.length === 0 ? 'No items in this view.' : 'No items match your search.'
        );
        return;
    }
    $('#emptyState').addClass('d-none');

    $.each(filtered, function (i, item) {
        var $row = $('<tr>').addClass('row-clickable').attr('data-id', item.id);
        if (highlightId && item.id === highlightId) { $row.addClass('row-enter'); }

        var typePillClass = item.improvementType === 'Reactive' ? 'pill-type-reactive' : 'pill-type-proactive';
        var $plants = $('<td>');
        $.each(item.hdApplicablePlants.split(','), function (i, p) {
            $('<span class="pill-plant">').text(p).appendTo($plants);
        });

        $row.append($('<td class="mono">').text(item.id));
        $row.append($('<td>').text(item.hdTheme));
        $row.append($('<td>').append($('<span class="pill-type ' + typePillClass + '">').text(item.improvementType)));
        $row.append($('<td class="mono">').text(item.hdSourcePlant));
        $row.append($('<td>').text(item.aggregateType));
        $row.append($('<td class="mono">').text(item.modelFamily));
        $row.append($('<td>').text(item.issueSource));
        $row.append($('<td class="mono">').text(item.casesCount));
        $row.append($('<td>').text(item.improvementCategory));
        $row.append($plants);
        $row.append($('<td>').text(item.createdByRole));
        $row.append($('<td class="mono">').text(item.createdAt));
        $body.append($row);
    });
}

$('#searchInput').on('input', function () {
    searchTerm = $(this).val().trim().toLowerCase();
    renderItems();
});

$('#itemsBody').on('click', 'tr', function () {
    var id = $(this).data('id');
    openViewModal(id);
});

function fieldBlock(label, value) {
    return '<div class="view-field"><div class="view-field__label">' + escapeHtml(label) + '</div><div class="view-field__value">' + escapeHtml((value === 0 ? 0 : value) || '—') + '</div></div>';
}

function textBlock(label, value) {
    return '<div class="view-block"><div class="view-block__label">' + escapeHtml(label) + '</div><div class="view-block__text">' + escapeHtml(value || '—') + '</div></div>';
}

function openViewModal(id) {
    var item = allItems.filter(function (i) { return i.id === id; })[0];
    if (!item) return;
    new bootstrap.Modal(document.getElementById('viewItemModal')).show();
    renderViewModal(item);
}

function renderViewModal(item) {
    $('#viewTitle').text('HD Item #' + item.id);

    var typePillClass = item.improvementType === 'Reactive' ? 'pill-type-reactive' : 'pill-type-proactive';
    var meta =
        '<div class="view-meta">' +
        '<div class="view-meta__top">' +
        '<span class="pill-type ' + typePillClass + '">' + escapeHtml(item.improvementType) + '</span>' +
        '<span class="pill-plant">Source: ' + escapeHtml(item.hdSourcePlant) + '</span>' +
        '</div>' +
        '<div class="view-meta__by">Logged by ' + escapeHtml(item.createdByRole) + ' &middot; ' + escapeHtml(item.createdAt) + '</div>' +
        '</div>';

    var theme = textBlock('HD Theme', item.hdTheme);

    var grid =
        '<div class="view-grid">' +
        fieldBlock('Aggregate', item.aggregateType) +
        fieldBlock('Model Family', item.modelFamily) +
        fieldBlock('Issue Source', item.issueSource) +
        fieldBlock('Cases', item.casesCount) +
        fieldBlock('Category', item.improvementCategory) +
        fieldBlock('Applicable Plants', item.hdApplicablePlants) +
        '</div>';

    var body =
        meta + theme + grid +
        textBlock('Description', item.description) +
        textBlock('Analysis details', item.analysisDetails) +
        textBlock('Action / Improvement details', item.actionDetails) +
        textBlock('Responsible persons', item.responsiblePersons) +
        textBlock('Attachments', item.attachments);

    var rows = '';
    $.each(item.plants, function (i, p) {
        rows += '<tr><td class="mono">' + escapeHtml(p.plant) + '</td>' +
            '<td>' + escapeHtml(p.status || '—') + '</td>' +
            '<td class="mono">' + escapeHtml(p.targetDate || '—') + '</td>' +
            '<td>' + escapeHtml(p.details || '—') + '</td></tr>';
    });

    body += '<div class="view-block"><div class="view-block__label">Plant-wise ORC Tracking</div>' +
        '<table class="view-orc-table"><thead><tr><th>Plant</th><th>Status</th><th>Target date</th><th>Details</th></tr></thead>' +
        '<tbody>' + rows + '</tbody></table></div>';

    $('#viewBody').html(body);
}

var uploadedAttachments = [];

function resetForm() {
    $('#hdForm')[0].reset();
    $('.plant-check').prop('checked', false);
    $('#formError').addClass('d-none').text('');
    $('#attachmentList').empty();
    uploadedAttachments = [];
    $('.char-limited').each(updateCharCounter);
}

function updateCharCounter() {
    var $ta = $(this);
    var max = parseInt($ta.attr('maxlength'), 10) || 250;
    var len = $ta.val().length;
    var $counter = $ta.next('.char-counter');
    $counter.text(len + ' / ' + max);
    $counter.toggleClass('max', len >= max);
    $counter.toggleClass('warn', len < max && len >= max - 20);
}

$(document).on('input', '.char-limited', updateCharCounter);

function loadPlantsForForm() {
    var $source = $('#hdSourcePlant');
    var $group = $('#applicablePlantsGroup');
    $source.find('option[value!=""]').remove();
    $group.empty();

    $.each(DEMO_PLANTS, function (i, p) {
        $('<option>').val(p).text(p).appendTo($source);

        var checkId = 'plant-' + p;
        $('<div class="form-check">').append(
            $('<input class="form-check-input plant-check" type="checkbox">').attr({ value: p, id: checkId }),
            $('<label class="form-check-label">').attr('for', checkId).text(p)
        ).appendTo($group);
    });
}

$('#btnAddNew').on('click', function () {
    resetForm();
    loadPlantsForForm();
    new bootstrap.Modal(document.getElementById('addItemModal')).show();
});

$('#attachmentFiles').on('change', function () {
    var files = this.files;
    if (!files.length) return;
    $.each(files, function (i, file) {
        uploadedAttachments.push('demo::' + file.name);
        $('#attachmentList').append('<div>' + escapeHtml(file.name) + '</div>');
    });
    $(this).val('');
});

$('#btnSaveItem').on('click', function () {
    $('#formError').addClass('d-none').text('');

    var form = document.getElementById('hdForm');
    if (!form.checkValidity()) {
        form.reportValidity();
        return;
    }

    var applicablePlants = $('.plant-check:checked').map(function () { return this.value; }).get();
    if (applicablePlants.length === 0) {
        $('#formError').removeClass('d-none').text('Please select at least one HD Applicable Plant.');
        return;
    }

    var newItem = mkItem(
        $('#hdTheme').val(),
        $('#improvementType').val(),
        $('#hdSourcePlant').val(),
        $('#aggregateType').val(),
        $('#modelFamily').val(),
        $('#issueSource').val(),
        parseInt($('#casesCount').val(), 10) || 0,
        $('#improvementCategory').val(),
        applicablePlants.join(','),
        'User'
    );
    newItem.description = $('#description').val();
    newItem.analysisDetails = $('#analysisDetails').val();
    newItem.actionDetails = $('#actionDetails').val();
    newItem.responsiblePersons = $('#responsiblePersons').val();
    newItem.attachments = uploadedAttachments.join(',');

    allItems.unshift(newItem);

    bootstrap.Modal.getInstance(document.getElementById('addItemModal')).hide();
    renderItems(newItem.id);
    showToast('HD item #' + newItem.id + ' saved');
});

seedItems();
moveScopeThumb();
renderItems();
