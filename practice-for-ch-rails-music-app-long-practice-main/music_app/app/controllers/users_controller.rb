class UsersController < ApplicationController
    before_action :require_logged_in, only: :show
    before_action :require_logged_out, only: [:new, :create]

    def new
        render :new
    end

    def show
        @user = User.find(params[:id])
        render :show
    end

    def create
        @user = User.new(params.require(:user).permit(:email, :password))
        if @user.save
            login!(@user)
            flash.now[:notice] = "Successfully created user !!"
            render :show
        else
            flash.now[:errors] = @user.errors.full_messages
            render :new
        end
    end

end
