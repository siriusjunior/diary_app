function show_comment_edit(){
    $('#comment-edit-form').addClass('d-block').removeClass('d-none');
}
function hide_comment_edit(){
    $('#comment-edit-form').addClass('d-none').removeClass('d-block');
    $('#error_messages').remove();
}