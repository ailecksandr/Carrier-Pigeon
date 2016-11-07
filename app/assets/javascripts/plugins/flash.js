var hide_flash = window.setTimeout(function(){
    $('.alert').fadeOut(2000);
}, 3500);

var main = function(){
    var hide = window.setTimeout(function(){
        $('.alert').fadeOut(2000);
    }, 2000);

    $(document).on('mouseover', '.alert', function(){
        window.clearTimeout(hide);
        $('.alert').stop().animate({opacity: '100'});
    });
    
    
    $(document).on('mouseout', '.alert', function(){
        hide = hide_flash;
    });
};

$(document).ready(main);

