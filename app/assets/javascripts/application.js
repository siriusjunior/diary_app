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