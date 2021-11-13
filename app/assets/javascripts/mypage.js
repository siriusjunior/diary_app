//= require jquery3
//= require popper
//= require rails-ujs

function previewFileWithId(selector) {
    const target = this.event.target;
    const file = target.files[0];
    // ファイルを読み込むためのインスタンスを生成
    const reader  = new FileReader()
    // ファイルリーダーで読み込んだら(onload)、要素のsrcをreaderのURLで書き換える;
    reader.onloadend = function () {
        selector.src = reader.result;
    }
    if (file) {
        // ファイル内容を取得したので、URLをファイルから取得してリーダーに格納
        reader.readAsDataURL(file);
    } else {
        selector.src = "";
    }
}
