$(".search-form a").on('click', function() {
    var token = $(this).parent().siblings('.panel-body').find('input[type=text]').val();
    var href = $(this).attr('href');
    var link = href + ((token.length != 0) ? ('/' + token) : token);
    $(this).attr('href', link);
});