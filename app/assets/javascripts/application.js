// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, or any plugin's
// vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
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