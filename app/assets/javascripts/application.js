//= require jquery3
//= require popper
//= require rails-ujs
//= require_tree .
//= require cable
//= require cable/chatroom.js


// 通知アイコン中リストのドロップダウン処理
$(document).on('click',function(e) {
    if(!$(e.target).closest('#dropdown').length) {
      // 外側クリック
    $('#header-activities').removeClass("show");
    } else {
    // ターゲットのクリック
    if ($('#header-activities').hasClass('show')) {
        $('#header-activities').removeClass("show");
    } else {
        $('#header-activities').addClass("show");
    }}
});

function show_side() {
    document.getElementById('line-1').classList.toggle('line-1');
    document.getElementById('line-2').classList.toggle('line-2');
    document.getElementById('line-3').classList.toggle('line-3');
    document.getElementById('sp-nav').classList.toggle('in');
    document.getElementById('sp-nav').classList.toggle('disable-scroll');
    if ( document.getElementById('sp-nav').classList.contains('disable-scroll')) {
        // PCスクロール禁止
        document.addEventListener("mousewheel", scroll_control, { passive: false });
        // スマホタッチ操作禁止
        document.addEventListener("touchmove", scroll_control, { passive: false });
    } else {
        // PC禁止解除
        document.removeEventListener("mousewheel", scroll_control, { passive: false });
        document.removeEventListener("touchmove", scroll_control, { passive: false });
    }
}


