class SessionsController < ApplicationController
    before_action :require_logged_in, only: :destroy
    before_action :require_logged_out, only: [:new, :create]

    def new
        render :new
    end

    def create
        up = user_params
        @user = User.find_by_credentials(up[:email], up[:password])
        if @user
            session[:session_token] = @user.reset_session_token!
            flash[:notice] = "Successfully logged in!!"
            redirect_to user_url(@user)
        else
            flash.now[:errors] = ["Couldn't find a user with the given credentials, pls try again"]
            render :new
        end
    end

    def destroy
        logout!(@current_user)
        redirect_to new_sessions_url
    end

    private
    def user_params
        params.require(:user).permit(:email, :password)
    end
end