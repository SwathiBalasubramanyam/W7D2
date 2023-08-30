class SessionsController < ApplicationController
    before_action :require_logged_in, only: :destroy
    before_action :require_logged_out, only: [:new, :create]

    def new
        render json: "Pls login in using the below form"
    end

    def create
        @user = User.find_by_credentials(params.require(:user).permit(:email, :password))
        if @user
            @user.reset_session_token!
            redirect_to user_url(@user)
        else
            render :new
        end
    end

    def destroy
        logout!
        redirect_to new_sessions_url
    end
end