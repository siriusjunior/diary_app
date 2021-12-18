// フォロワー一覧、フォロー一覧にあるタグリンクの無効化
$(function(){
    $('#user-follower .tag').click(function(){
        return false;
    });
});
$(function(){
    $('#user-following .tag').click(function(){
        return false;
    });
});