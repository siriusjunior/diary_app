//= require jquery3
//= require popper
//= require rails-ujs
//= require activestorage
//= require bootstrap-material-design/dist/js/bootstrap-material-design.js

function previewDiaryImageFile(preview){
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
        $('#preview').attr('src', reader.result);
    }
    
}