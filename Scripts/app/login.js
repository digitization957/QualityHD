function generateFakeToken() {
    if (window.crypto && window.crypto.randomUUID) {
        return window.crypto.randomUUID();
    }
    return 'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'.replace(/[xy]/g, function (c) {
        var r = Math.random() * 16 | 0, v = c === 'x' ? r : (r & 0x3 | 0x8);
        return v.toString(16);
    });
}

function loadPlants() {
    var $select = $('#ddlPlant');
    $.ajax({
        type: 'POST',
        url: 'Login.aspx/GetPlants',
        data: '{}',
        contentType: 'application/json; charset=utf-8',
        dataType: 'json'
    }).done(function (response) {
        var plants = response.d || [];
        $select.empty();
        $.each(plants, function (i, p) {
            $('<option>').val(p.name).text(p.name).appendTo($select);
        });
        if (plants.length === 0) {
            $select.append('<option value="">No plants found</option>');
        }
    }).fail(function () {
        $select.empty().append('<option value="">Could not load plants</option>');
        $('#loginError').removeClass('d-none').text('Could not load plants from plant_master. Please refresh.');
    });
}

$(function () {
    $('#txtToken').val(generateFakeToken());
    loadPlants();

    $('#btnEnter').on('click', function () {
        var $btn = $(this).prop('disabled', true);
        $('#loginError').addClass('d-none').text('');

        $.ajax({
            type: 'POST',
            url: 'Login.aspx/GenerateToken',
            data: JSON.stringify({ token: $('#txtToken').val(), plant: $('#ddlPlant').val() }),
            contentType: 'application/json; charset=utf-8',
            dataType: 'json'
        }).done(function (response) {
            var result = response.d;
            sessionStorage.setItem('qhd_jwt', result.jwt);
            sessionStorage.setItem('qhd_role', result.role);
            sessionStorage.setItem('qhd_plant', result.plant);
            window.location.href = 'Default.aspx';
        }).fail(function (xhr) {
            var msg = 'Unable to sign in. Please try again.';
            try { msg = JSON.parse(xhr.responseText).Message || msg; } catch (e) { }
            $('#loginError').removeClass('d-none').text(msg);
            $btn.prop('disabled', false);
        });
    });
});
