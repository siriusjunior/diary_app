$(function(){
    // チャットルームの参加者モダール制御
    $('#js-chatroom-users').on('click',function(){
        $('#js-member-modal').fadeIn();
        $('.modal').addClass('disable-scroll');
        check_scroll()
        return false;
    });
    $('.js-modal-close').on('click',function(){
        $('.modal').removeClass('disable-scroll');
        $('.modal').fadeOut();
        check_scroll()
        return false;
    });
});

function check_scroll(){
    if ( $('.modal').hasClass('disable-scroll') ) {
        no_scroll();
    } else {
        return_scroll();
    }
}

function no_scroll() {
    // PCでのスクロール禁止
    document.addEventListener("mousewheel", scroll_control, { passive: false });
    // スマホでのタッチ操作でのスクロール禁止
    document.addEventListener("touchmove", scroll_control, { passive: false });
}
// スクロール禁止解除
function return_scroll() {
    // PCでのスクロール禁止解除
    document.removeEventListener("mousewheel", scroll_control, { passive: false });
    // スマホでのタッチ操作でのスクロール禁止解除
    document.removeEventListener('touchmove', scroll_control, { passive: false });
}
// スクロール関連メソッド
function scroll_control(event) {
    event.preventDefault();
}