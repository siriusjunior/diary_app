class ApplicationController < ActionController::Base
    before_action :set_search_diaries_form
    add_flash_types :success, :info, :warning, :danger

    private
        def not_authenticated
            redirect_to login_path, danger: "ログインしてください"
        end

        def set_search_diaries_form
            @search_form = SearchPostsForm.new(search_post_params)
        end

        def search_post_params
            params.fetch(:q, {}).permit(:body)
        end
end
