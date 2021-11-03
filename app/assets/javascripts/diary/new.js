//= require jquery3
//= require popper
//= require rails-ujs
//= require activestorage
//= require bootstrap-material-design/dist/js/bootstrap-material-design.js

function previewDiaryImageFile(preview){
    var data = `<a id="preview_link" class="uploader__placeholder ml-1" data-lightbox="image-60" href=""><img id="preview" height="50" width="50" src=""></a>`
    // inputタグの取得
    const target = this.event.target;
    // ファイル内容の取得
    const file = target.files[0];
    // ファイルを読み込むためのインスタンスを生成
    const reader = new FileReader();
    // ファイル内容を取得したので、URLをファイルから取得してリーダーに格納
    if (file) {
        reader.readAsDataURL(file);
    }
    // ファイルリーダーで読み込んだら(onload)、要素のsrcをreaderのURLで書き換える
    reader.onloadend = function (){
        $('.uploader__placeholder').replaceWith(data);
        $('#preview_link').attr('href', reader.result);
        $('#preview').attr('src', reader.result);
    }
}

//フォームに入力されている文字数を数える
$(function (){
    // 処理（ページが読み込まれた時）
    //\nは"改行"に変換して2文字に、あくまでcountとして数値を扱う、オプションフラグgで文字列から\nを探し変換
    var count = $(".new-diary__textarea").text().replace(/\n/g, "ああ").length;
    //残り字数を計算
    var now_count = 500 - count;
    //文字数オーバーで文字色を赤
    if (count > 500) {
        $(".new-diary__js-text-count").css("color","red");
    }
    //残りの入力できる文字数を表示
    $(".new-diary__js-text-count").text( "残り" + now_count + "文字");
    // 処理（キーボードを押した時)
    $(".new-diary__textarea").on("keyup", function(){
    //フォームのvalueの文字数を数える
    var count = $(this).val().replace(/\n/g, "ああ").length;
    var now_count = 500 - count;
    if (count > 500) {
        $(".new-diary__js-text-count").css("color","red");
    } 
    else {
        $(".new-diary__js-text-count").css("color","black");
    }
        $(".new-diary__js-text-count").text( "残り" + now_count + "文字");
    });
});

// 挙動チェック
// $(window).load(function (){
//     alert('Hello JavaScript');
//     console.log("呼ばれてる？？？")
// });
// function js_alert(){
//     alert('Hello JavaScript');
// }
// $(function (){
//     console.log("呼ばれてる？？？")
//     document.getElementById('hello').textContent = "Hello JavaScript"
// });