class UsersController < ApplicationController
    before_action :require_logged_in, only: :show
    before_action :require_logged_out, only: [:new, :create]

    def new
        render json: "Welcome to create user page"
    end

    def show
        @user = User.find(params[:id])
        render json: @user
    end

    def create
        @user = User.new(params.require(:user).permit(:password, :email))
        if @user.save
            login!(@user)
            render json: @user
        else
            render json: @user.errors.full_messages, status: 422
        end
    end

end
