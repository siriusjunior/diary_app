//= require jquery3
//= require popper
//= require rails-ujs
//= require activestorage
//= require bootstrap-material-design/dist/js/bootstrap-material-design.js

function show_comment_edit(){
    $('#comment-edit-form').addClass('d-block').removeClass('d-none');
}
function hide_comment_edit(){
    $('#comment-edit-form').addClass('d-none').removeClass('d-block');
}