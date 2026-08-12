var jwt = sessionStorage.getItem('qhd_jwt');
var role = sessionStorage.getItem('qhd_role');
var plant = sessionStorage.getItem('qhd_plant');

if (!jwt) {
    window.location.href = 'Login.aspx';
}

$('#roleBadge').text(role || 'User');
$('#plantBadge').text(plant || '');

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

$('.scope-pill').on('click', function () {
    scope = $(this).data('scope');
    $('.scope-pill').removeClass('active');
    $(this).addClass('active');
    loadItems();
});

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
        var $row = $('<tr>');
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

function loadItems(highlightId) {
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
    });
}

var uploadedAttachments = [];

function resetForm() {
    $('#hdForm')[0].reset();
    $('.plant-check').prop('checked', false);
    $('#formError').addClass('d-none').text('');
    $('#attachmentList').empty();
    uploadedAttachments = [];
}

$('#btnAddNew').on('click', function () {
    resetForm();
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

function collectPlantData(blockSelector) {
    var $block = $(blockSelector);
    return {
        status: $block.find('.plant-status').val(),
        details: $block.find('.plant-details').val(),
        date: $block.find('.plant-date').val()
    };
}

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

    var ngp = collectPlantData('[data-plant="ngp"]');
    var zhb = collectPlantData('[data-plant="zhb"]');
    var rdp = collectPlantData('[data-plant="rdp"]');
    var jpr = collectPlantData('[data-plant="jpr"]');
    var rjk = collectPlantData('[data-plant="rjk"]');
    var knd = collectPlantData('[data-plant="knd"]');

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

            ngpOrcStatus: ngp.status, ngpHdDetails: ngp.details, ngpTargetDate: ngp.date,
            zhbOrcStatus: zhb.status, zhbHdDetails: zhb.details, zhbTargetDate: zhb.date,
            rdpOrcStatus: rdp.status, rdpHdDetails: rdp.details, rdpTargetDate: rdp.date,
            jprOrcStatus: jpr.status, jprHdDetails: jpr.details, jprTargetDate: jpr.date,
            rjkOrcStatus: rjk.status, rjkHdDetails: rjk.details, rjkTargetDate: rjk.date,
            kndOrcStatus: knd.status, kndHdDetails: knd.details, kndTargetDate: knd.date,

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

loadItems();
