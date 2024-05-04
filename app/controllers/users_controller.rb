class UsersController < ApplicationController
    before_action :logged_in?, only: [:new, :create]
    before_action :logged?, only: [:show]
    def new
        @user = User.new
    end

    def create 
        @user = User.new(user_params)
        if @user.save
            login!(@user)
        else
            flash[:alert] = @user.errors.full_messages.to_sentence
            redirect_to new_user_url
        end
    end

    def show
        @sessions = Session.where(user_id: current_user.id)
        render :show
    end

    private
    def user_params
        params.require(:user).permit(:user_name, :password)
    end
end
