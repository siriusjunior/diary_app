module AjaxHelper
    def ajax_redirect_to(redirect_uri)
        { js: "window.location.replace('#{redirect_uri}');" }
    end
    # 想定している挙動とは違ったため保留
    # def ajax_flash(flash)
    #     { js: "$('#js-flash').html('hoo');" }
    # end
end
