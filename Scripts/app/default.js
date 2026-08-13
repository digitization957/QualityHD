var jwt = sessionStorage.getItem('qhd_jwt');
var role = sessionStorage.getItem('qhd_role');
var plant = sessionStorage.getItem('qhd_plant');

if (!jwt) {
    window.location.href = 'Login.aspx';
}

// User menu popover: shows the signed-in token/role/plant, toggled off the
// avatar button instead of always-visible chips.
var jwtSubject = (jwt || '').split('.')[0] || '';
var plantInitials = (plant || 'U').slice(0, 2).toUpperCase();
$('#popoverToken').text(jwtSubject ? jwtSubject.slice(0, 10) + '…' : '—');
$('#popoverRole').text((role || 'User') + ' role');
$('#popoverPlant').text(plant ? plant + ' Plant' : '—');
$('#popoverAvatar').text(plantInitials);
$('#btnUserMenu').text(plantInitials);

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
    sessionStorage.removeItem('qhd_jwt');
    sessionStorage.removeItem('qhd_role');
    sessionStorage.removeItem('qhd_plant');
    window.location.href = 'Login.aspx';
});

function authAjax(options) {
    options.headers = $.extend({ 'Authorization': 'Bearer ' + jwt }, options.headers || {});
    return $.ajax(options).fail(function (xhr) {
        if (xhr.status === 401) {
            sessionStorage.removeItem('qhd_jwt');
            sessionStorage.removeItem('qhd_role');
            window.location.href = 'Login.aspx';
        }
    });
}

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

var allItems = [];
var searchTerm = '';
var scope = 'all';

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
    loadItems();
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

function renderItems(highlightId) {
    renderStats(allItems);

    var filtered = allItems.filter(function (item) {
        if (!searchTerm) return true;
        var hay = (item.hdTheme + ' ' + item.hdApplicablePlants + ' ' + item.hdSourcePlant).toLowerCase();
        return hay.indexOf(searchTerm) !== -1;
    });

    var $body = $('#itemsBody').empty();

    if (filtered.length === 0) {
        $('#emptyState').removeClass('d-none').text(
            allItems.length === 0 ? 'No items in this view.' : 'No items match your search.'
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

// Row click -> full read-only detail view in a modal.
$('#itemsBody').on('click', 'tr', function () {
    var id = $(this).data('id');
    openViewModal(id);
});

function fieldBlock(label, value) {
    return '<div class="view-field"><div class="view-field__label">' + escapeHtml(label) + '</div><div class="view-field__value">' + escapeHtml(value || '—') + '</div></div>';
}

function textBlock(label, value) {
    return '<div class="view-block"><div class="view-block__label">' + escapeHtml(label) + '</div><div class="view-block__text">' + escapeHtml(value || '—') + '</div></div>';
}

function openViewModal(id) {
    $('#viewTitle').text('Loading…');
    $('#viewBody').html('<div class="text-center text-muted py-4">Loading item…</div>');
    new bootstrap.Modal(document.getElementById('viewItemModal')).show();

    authAjax({
        type: 'POST',
        url: 'Default.aspx/GetItemDetails',
        data: JSON.stringify({ id: id }),
        contentType: 'application/json; charset=utf-8',
        dataType: 'json'
    }).done(function (response) {
        renderViewModal(response.d);
    }).fail(function (xhr) {
        var msg = 'Could not load item details.';
        try { msg = JSON.parse(xhr.responseText).Message || msg; } catch (e) { }
        $('#viewBody').html('<div class="alert alert-danger">' + escapeHtml(msg) + '</div>');
    });
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

function loadItems(highlightId) {
    var $body = $('#itemsBody').css('transition', 'opacity 140ms ease').css('opacity', 0.35);
    authAjax({
        type: 'POST',
        url: 'Default.aspx/GetItems',
        data: JSON.stringify({ scope: scope }),
        contentType: 'application/json; charset=utf-8',
        dataType: 'json'
    }).done(function (response) {
        allItems = response.d || [];
        $('#loadError').addClass('d-none');
        renderItems(highlightId);
    }).fail(function (xhr) {
        if (xhr.status !== 401) {
            $('#loadError').removeClass('d-none').text('Could not load items. Please refresh.');
        }
    }).always(function () {
        $body.css('opacity', 1);
    });
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

// Live char counter for every fixed-height, 250-char-capped textarea.
// Counter sits right after the textarea in the markup.
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

// Plant names are never hardcoded — always loaded from plant_master.tbl_Plant
// via GetPlants, and used to populate both the source-plant select and the
// applicable-plants checkboxes.
function loadPlantsForForm() {
    var $source = $('#hdSourcePlant');
    var $group = $('#applicablePlantsGroup');
    $source.find('option[value!=""]').remove();
    $group.empty();

    return authAjax({
        type: 'POST',
        url: 'Default.aspx/GetPlants',
        data: '{}',
        contentType: 'application/json; charset=utf-8',
        dataType: 'json'
    }).done(function (response) {
        var plants = response.d || [];
        $.each(plants, function (i, p) {
            $('<option>').val(p.name).text(p.name).appendTo($source);

            var checkId = 'plant-' + p.name;
            $('<div class="form-check">').append(
                $('<input class="form-check-input plant-check" type="checkbox">').attr({ value: p.name, id: checkId }),
                $('<label class="form-check-label">').attr('for', checkId).text(p.name)
            ).appendTo($group);
        });
        if (plants.length === 0) {
            $group.append('<div class="text-danger small">No plants found in plant_master.</div>');
        }
    }).fail(function () {
        $group.append('<div class="text-danger small">Could not load plants from plant_master.</div>');
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
        var formData = new FormData();
        formData.append('file', file);
        authAjax({
            type: 'POST',
            url: 'UploadHandler.ashx',
            data: formData,
            processData: false,
            contentType: false
        }).done(function (resp) {
            if (resp && resp.success) {
                uploadedAttachments.push(resp.storedName + '::' + resp.originalName);
                $('#attachmentList').append('<div>' + escapeHtml(resp.originalName) + '</div>');
            } else {
                $('#formError').removeClass('d-none').text((resp && resp.message) || 'Upload failed.');
            }
        }).fail(function (xhr) {
            var msg = 'Upload failed.';
            try { msg = JSON.parse(xhr.responseText).message || msg; } catch (e) { }
            $('#formError').removeClass('d-none').text(msg);
        });
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

    var payload = {
        item: {
            hdTheme: $('#hdTheme').val(),
            improvementType: $('#improvementType').val(),
            hdSourcePlant: $('#hdSourcePlant').val(),
            aggregateType: $('#aggregateType').val(),
            description: $('#description').val(),
            modelFamily: $('#modelFamily').val(),
            issueSource: $('#issueSource').val(),
            casesCount: $('#casesCount').val(),
            analysisDetails: $('#analysisDetails').val(),
            actionDetails: $('#actionDetails').val(),
            improvementCategory: $('#improvementCategory').val(),
            hdApplicablePlants: applicablePlants.join(','),
            responsiblePersons: $('#responsiblePersons').val(),
            attachments: uploadedAttachments.join(',')
        }
    };

    var $btn = $(this).prop('disabled', true);

    authAjax({
        type: 'POST',
        url: 'Default.aspx/SaveItem',
        data: JSON.stringify(payload),
        contentType: 'application/json; charset=utf-8',
        dataType: 'json'
    }).done(function (response) {
        bootstrap.Modal.getInstance(document.getElementById('addItemModal')).hide();
        var newId = response && response.d && response.d.id;
        loadItems(newId);
        showToast('HD item' + (newId ? ' #' + newId : '') + ' saved');
    }).fail(function (xhr) {
        var msg = 'Could not save item.';
        try { msg = JSON.parse(xhr.responseText).Message || msg; } catch (e) { }
        $('#formError').removeClass('d-none').text(msg);
    }).always(function () {
        $btn.prop('disabled', false);
    });
});

moveScopeThumb();
loadItems();
