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

// タグのインクリメンタルサーチ
$(function (){
    $('#search-form-input').on('keyup', function(){
        // 入力時の動作
        // エラー時のフォーム着色とボタンの属性値変更の判断
        var ErrFlg = false;
        // 検索フォームのカンマ入りワード
        var input = $("#search-form-input").val();
        // カンマを省いて入力フォーム配列化
        var arr = input.split(',');
        // 入力フォームの配列の重複除去
        var arr = arr.filter(function (x, i, self) {
            return self.indexOf(x) === i;
        });
        $.each(arr, function(key, value){
            //appleの場合はカウントアップさせる
            if( value.length > 5 ){
                $('#search-form__warn_length').show();
                $('#search-form__result').hide();
                ErrFlg = true;
            }else{
                $('#search-form__warn_length').hide();
                $('#search-form__result').show();
            }
        });
        // 重複除去配列は配列のままなのでカンマ区切りの文字列にして反映
        var ArrayStr = arr.join(',')
        $("#search-form-input").val( ArrayStr );
        // if (arr !== UniqArr){重複タグを通知するにはここを利用}
        if (arr.length > 5){
            $('#search-form__warn_count').show();
            $('#search-form__result').hide();
            ErrFlg = true
        }else{
            $('#search-form__warn_count').hide();
            $('#search-form__result').show();
        }
        // フォーム項目にエラーがあればエラーインターフェイス処理
        // if(ErrFlg === true){
        //     $('#profile-edit-btn').attr({'disabled':'disabled'});
        //     $("#search-form-input").addClass("warn");
        //     $("#search-form-input").removeClass("info");
        // }else if(ErrFlg === false){
        //     $("#search-form-input").addClass("info");
        //     $("#search-form-input").removeClass("warn");
        //     $('#profile-edit-btn').removeAttr('disabled');
        // }
        // 配列の最後を検索語とする
        var keyword = arr[arr.length-1];
        // 検索語句を探す際の重複除去した配列作成
        var serArr = arr.filter(i => keyword.indexOf(i))
        $.ajax({
            type: 'GET',                // HTTPメソッドはGETで
            url:  '/tags',             // /usersのURLに (これによりusersコントローラのindexアクションが起動)
            data: { keyword: keyword, arr: serArr },    // keyword: inputとフォーム配列を送信する,
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
                    appendNoTagMsgToHTML();   // ユーザーが見つからなければ「見つからない」を返す。
                }                
            }
        })
        .fail(function() {
            $('#search-form__result').empty();
            $('#search-form__result').append('<li>タグ検索に失敗しました</li>');// ユーザーが見つからなければ「見つからない」を返す。
            appendErrMsgToHTML();
        });
    });
    var search_list = $("#search-form__result");
    function appendTag(tag){
        var html = `<li class="pl-3" id="suggested-tag" data-tag-id="${tag.id}" data-tag-name="${tag.name}">${tag.name}</li>`;
                    search_list.append(html);
    }
    function appendNoTagMsgToHTML(){
        var html = `<li><span><i>このタグは登録されていません</i></span></li>`;
                    search_list.append(html);
    }
    function appendErrMsgToHTML(){
        var html = `<li><span><i>タグ検索に失敗しました</i></span></li>`;
                    search_list.append(html);
    }
});

$(document).on('click',function(e) {
    if(!$(e.target).closest('#suggested-tag').length) {
      // ターゲット要素の外側をクリックした時の操作
    $('#search-form__result').empty();
    } else {
    // ターゲット要素をクリックした時の操作
    //データ取得
    const tagName = $(e.target).closest('#suggested-tag').attr("data-tag-name");
    // const GetArray = $("#hidden-labels").val().split(',');
    var input = $("#search-form-input").val();
        var arr = input.split(',');
        // var keyword = arr[arr.length-1];
        arr[arr.length-1] = tagName;
        // クリック追加動作に重複配列除去
        var arr = arr.filter(function (x, i, self) {
            return self.indexOf(x) === i;
        });
    var ArrayStr = arr.join(',')
    $("#search-form-input").val( ArrayStr );
    $('#search-form__result').empty();
    }
});