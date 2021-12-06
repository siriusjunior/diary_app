//= require jquery3
//= require popper
//= require rails-ujs
//= require_tree .
//= require_tree channels
//= require_tree channels/chatroom.js


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