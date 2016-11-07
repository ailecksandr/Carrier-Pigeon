var main = function() {
    $(".numeric").TouchSpin({
        min: 1,
        initval: 1,
        max: 100,
        step: 1,
        boostat: 5,
        maxboostedstep: 10,
        postfix: 'reviews'
    });
};

$(document).on('click', function(e) {
    var destroy_group = $('.destroy-type-group');
    var password = $('.password');
    var token = $('.token');
    if (destroy_group.length != 0 && !$.contains(destroy_group[0], e.target))
        $(".destroy-type-group label[for='message_destroy_type']").removeClass('selected');
    if (password.length != 0 && !$.contains(password[0], e.target))
        $(".password label[for='message_password']").removeClass('selected');
    if (token.length != 0 && !$.contains(token[0], e.target))
        $(".password label[for='message_token']").removeClass('selected');
});

$('.destroy-type-group')
    .on('focusin', function() {
        $(this).find("label[for='message_destroy_type']").addClass('selected');
    });

$('.password')
    .on('focusin', function() {
        $(this).find("label[for='message_password']").addClass('selected');
    });

$('.token')
    .on('focusin', function() {
        $(this).find("label[for='message_token']").addClass('selected');
    });

$('.radios input[type=radio]').on('change', function() {
    var id = $(this).attr('id');
    if (this.value == '0')
        $(".numeric").trigger('touchspin.updatesettings', {
            postfix: 'reviews',
            max: 100
        });
    else
        $(".numeric").trigger('touchspin.updatesettings', {
            postfix: 'hours',
            max: 24
        });
    $(this).siblings('.selected').removeClass('selected');
    $("label[for='"+id+"']").addClass('selected');
});


$('textarea')
    .on('focus', function() {
        var id = $(this).attr('id');
        $("label[for='"+id+"']").addClass('selected');
    })
    .on('blur', function() {
        var id = $(this).attr('id');
        $("label[for='"+id+"']").removeClass('selected');
    });

$('.password input[type=checkbox]').on('change', function() {
    if ($(this).prop('checked'))
        $(this).closest('.toggle').siblings('input').attr('type', 'text');
    else
        $(this).closest('.toggle').siblings('input').attr('type', 'password');
});

$('.numeric').on('change', function (e) {
    if ($(this).val().length == 0) $(this).val(1);
});

$(document).ready(main);