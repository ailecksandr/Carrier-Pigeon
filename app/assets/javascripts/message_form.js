var new_message_form = $("form.new-message");

if (new_message_form.length != 0){
    new_message_form.on('submit', function(e) {
        var msg_body = $(this).find('textarea').val();
        var password = $(this).find('#message_password').val();
        var enc_msg = (msg_body != "") ? CryptoJS.AES.encrypt(msg_body, password).toString() : '';

        $(this).find('input[type=hidden]').val(enc_msg);
    });

    $(document).ready(function(){
        $('body').animate({ scrollTop: $('form.new-message').offset().top - 75 }, 1000);
    });
}

if ($('.message-panel').length != 0) {
    $(document).ready(function(){
        var hidden_fields = $('.message-panel input[type=hidden]');
        var msg_body = hidden_fields[0].value;
        var password = hidden_fields[1].value;
        var dec_msg = CryptoJS.AES.decrypt(msg_body, password).toString(CryptoJS.enc.Utf8);

        $('.message-panel textarea').val(dec_msg);
    })
}
