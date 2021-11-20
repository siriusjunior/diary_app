//= require jquery3
//= require popper
//= require rails-ujs
//= require_tree .

// console.log("呼ばれてる？？？");

$(document).on('click',function(e) {
    if(!$(e.target).closest('#dropdown').length) {
      // 外側クリック
    $('#header-activities').removeClass("show");
    } else {
    // ターゲットのクリック
    if ($('#header-activities').hasClass('show')){
        $('#header-activities').removeClass("show");
    }else{
        $('#header-activities').addClass("show");
    }}
});