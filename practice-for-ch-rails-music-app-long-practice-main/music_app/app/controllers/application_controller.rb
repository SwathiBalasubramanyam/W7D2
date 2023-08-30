class ApplicationController < ActionController::Base
    helper_method :current_user

    def current_user
        # find by gives nil if no matching records
        @current_user ||= User.find_by(session_token: session[:session_token])
    end

    def logged_in?
        !!current_user
    end

    def logged_out?
        !logged_in?
    end

    def login!(user)
        @current_user = user
        session[:session_token] = user.session_token
    end

    def logout!(user)
        user.reset_session_token!
        session[:session_token] = nil
    end

    def require_logged_in
        redirect_to new_sessions_url if logged_out?
    end

    def require_logged_out
        redirect_to user_url(@current_user) if logged_in?
    end
end
