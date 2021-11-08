module SessionsHelper
    def store_location
        session[:return_to] = request.original_url if request.get?
    end
end