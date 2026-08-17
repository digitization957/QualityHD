// DEMO MODE: token + plant are hardcoded dropdowns (no DB call) so this
// page works even when plant_master isn't reachable. Server still
// whitelists both values against the same lists in Login.aspx.cs.
var DEMO_TOKENS = ['DEMO-TOKEN-0001', 'DEMO-TOKEN-0002', 'DEMO-TOKEN-0003'];
var DEMO_PLANTS = ['NGP', 'ZHB', 'RDP', 'JPR', 'RJK', 'KND'];

$(function () {
    var $token = $('#ddlToken');
    $.each(DEMO_TOKENS, function (i, t) { $('<option>').val(t).text(t).appendTo($token); });

    var $plant = $('#ddlPlant');
    $.each(DEMO_PLANTS, function (i, p) { $('<option>').val(p).text(p).appendTo($plant); });

    $('#btnEnter').on('click', function () {
        var $btn = $(this).prop('disabled', true);
        $('#loginError').addClass('d-none').text('');

        $.ajax({
            type: 'POST',
            url: 'Login.aspx/GenerateToken',
            data: JSON.stringify({ token: $token.val(), plant: $plant.val() }),
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
