$(function(){
    // ルームビューのid属性があれば購読手続きへ
    if($("#chatroom").length > 0) {
        // クライアントサイドのビュー要素を取得
        const chatroomId = $("#chatroom").data("chatroomId")
        const currentUserId = $("#chatroom").data("currentUserId")
        // サーバーサイドと連動してクライアントサイドで購読
        App.chatrooms = App.cable.subscriptions.create( { channel: "ChatroomChannel", chatroom_id: chatroomId }, {
            connected: function() {
                console.log("connected")
            },
            disconnected: function() {
                console.log("disconnected")
            },
            received: function(data){
                switch(data.type) {
                    case "create":
                        $('#message-box').append(data.html);
                        // 受信したパーシャル中のsenderId要素と表示中のルーム内のcurrentUserId要素を比較
                        if($(`#message-${ data.message.id }`).data("senderId") != currentUserId) {
                            // 自分の投稿でない購読者は編集ボタンを非表示に
                            $(`#message-${ data.message.id }`).find('.crud-area').hide()
                        }
                        if($(`#message-${ data.message.id }`).data("senderId") == currentUserId) {
                            // 投稿の購読者の場合は入力フィールドをクリア
                            $('.input-message-body').val('');
                        }
                        break;
                    case "update":
                        $(`#message-${ data.message.id }`).replaceWith(data.html);
                        // 受信したパーシャル中のsenderId要素と表示中のルーム内のcurrentUserId要素を比較
                        if($(`#message-${ data.message.id }`).data("senderId") != currentUserId ) {
                            // 自分の投稿でない購読者は編集ボタンを非表示に
                            $(`message-${ data.message.id }`).find('.crud-area').hide()
                        } else {
                            // 投稿の購読者の場合は編集モダールを非表示に
                            $("#message-edit-modal").modal('hide');
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