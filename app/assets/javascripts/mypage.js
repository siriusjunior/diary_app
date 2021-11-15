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

$(function (){
    // タグのインクリメンタルサーチ
    $('#search-form-input').on('keyup', function(){
        var input = $("#search-form-input").val();
        $.ajax({
            type: 'GET',                // HTTPメソッドはGETで
            url:  '/tags',             // /usersのURLに (これによりusersコントローラのindexアクションが起動)
            data: { keyword: input },    // keyword: inputを送信する
            dataType: 'json'            // サーバから値を返す際はjsonである
        })
        .done(function(tags){               // usersにjson形式のuser変数が代入される。複数形なので配列型で入ってくる
            if (input.length === 0) {         // フォームの文字列長さが0であれば、インクリメンタルサーチ結果を表示しない
                $('#search-form__result').empty();
            }
            else if (input.length !== 0){     // 値が等しくないもしくは型が等しくなければtrueを返す。
                $('#search-form__result').empty();
                if (tags.length !== 0){
                    tags.forEach(function(tag){ // users情報をひとつずつとりだしてuserに代入
                        appendTag(tag)
                    });
                }
                else {
                    $('#search-form__result').empty();
                    appendErrMsgToHTML();   // ユーザーが見つからなければ「見つからない」を返す。
                }                
            }
        })
        .fail(function() {
            $('#search-form__result').empty();
            $('#search-form__result').append('<li>追加されました</li>');// ユーザーが見つからなければ「見つからない」を返す。
            // appendErrMsgToHTML();
        });
    });

    var search_list = $("#search-form__result");
    function appendTag(tag){
        var html = `<li><span>${tag.name}</span></li>`;
                    search_list.append(html);
    }
    function appendErrMsgToHTML(){
        var html = `<li><span><i>このタグは登録されていません</i></span></li>`;
                    search_list.append(html);
    }
});
