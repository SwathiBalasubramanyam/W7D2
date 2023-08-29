class UsersController < ApplicationController

    def index
        @users = User.all()
        render json: @user
    end

    def show
        @user = User.find(params[:id])
        render json: @user
    end

    def create
        @user = User.new(params[:user])
        @user.save!
    end

    def update
        @user = User.find(params[:id])
        @user.update(params[:user])
        @user.save!
    end

    def destroy
        User.delete(params[:id])
    end
    
end
