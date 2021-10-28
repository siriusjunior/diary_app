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

// 当初のダミーフィールドに読み込んだら表示させる設定
// lightpop2で画像プレビューを詳細にできるユーザービリティを優先したため上記コードを採用
// function previewDiaryImageFile(preview){
//     // inputタグの取得
//     const target = this.event.target;
//     // ファイル内容の取得
//     const file = target.files[0];
//     // ファイルを読み込むためのインスタンスを生成
//     const reader = new FileReader();
//     // ファイル内容を取得したので、URLをファイルから取得してリーダーに格納
//     if (file) {
//         reader.readAsDataURL(file);
//     }
//     // ファイルリーダーで読み込んだら(onload)、要素のsrcをreaderのURLで書き換える
//     reader.onloadend = function (){
//         $('#preview').attr('src', reader.result);
//     }
    
// }