$(function(){
    // ルームビューのid属性があれば購読手続きへ
    if($("#chatroom").length > 0) {
        // クライアントサイドのビュー要素を取得,各ルームのコンテキストよりここで購読
        const chatroomId = $("#chatroom").data("chatroomId")
        const currentUserId = $("#chatroom").data("currentUserId")
        // サーバーサイドと連動して購読,params値を渡す
        App.chatrooms = App.cable.subscriptions.create( { channel: "ChatroomChannel", chatroom_id: chatroomId }, {
            connected: function() {
                console.log("connected")
            },
            disconnected: function() {
                console.log("disconnected")
            },
            // controllerからbroadcastされるdata(json形式)
            received: function(data){
                switch(data.type) {
                    case "create":
                        $('#message-box').append(data.html);
                        // ここで購読者のビューを一斉操作,appendしたパーシャルのsenderId要素とルーム内のcurrentUserId要素を比較
                        if($(`#message-${ data.message.id }`).data("senderId") != currentUserId) {
                            // 自分の投稿でない購読者は送信者コンテキストのmessageパーシャルを加工
                            $(`#message-${ data.message.id }`).find('.message__container').removeClass('message__container_self')
                            $(`#message-${ data.message.id }`).find('.message__body').removeClass('message__body_self')
                            $(`#message-${ data.message.id }`).find('.message__icon').removeClass('message__icon_self')
                            // 自分の投稿でない購読者は該当メッセージを探し,編集ボタンを非表示に
                            $(`#message-${ data.message.id }`).find('.crud-area').addClass('d-none')
                        }
                        if($(`#message-${ data.message.id }`).data("senderId") == currentUserId) {
                            // 投稿の購読者の場合は入力フィールドをクリア
                            $('.input-message-body').val('');
                            // 投稿の購読者の場合は送信者コンテキストのmessageパーシャルを保持
                        }
                        break;
                    case "update":
                        // 過去の該当するmessageパーシャルを受信したパーシャルに置き換える
                        $(`#message-${ data.message.id }`).replaceWith(data.html);
                        // 受信したパーシャル中のsenderId要素と表示中のルーム内のcurrentUserId要素を比較
                        if($(`#message-${ data.message.id }`).data("senderId") != currentUserId ) {
                            // 自分の投稿でない購読者は送信者コンテキストのmessageパーシャルを加工
                            $(`#message-${ data.message.id }`).find('.message__container').removeClass('message__container_self')
                            $(`#message-${ data.message.id }`).find('.message__body').removeClass('message__body_self')
                            $(`#message-${ data.message.id }`).find('.message__icon').removeClass('message__icon_self')
                            // 自分の投稿でない購読者は該当メッセージを探し,編集ボタンを非表示に
                            $(`#message-${ data.message.id }`).find('.crud-area').addClass('d-none')
                        } 
                        if($(`#message-${ data.message.id }`).data("senderId") == currentUserId) {
                            // 投稿の購読者の場合は送信者コンテキストのmessageパーシャルを保持
                        }
                        break;
                    case "delete":
                        $(`#message-${ data.message.id }`).remove();
                        break;
                }
            },
        });
    }
})