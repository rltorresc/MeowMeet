class SessionsController < ApplicationController
    before_action :logged_in?, only: [:new, :create]
    def create
        @user = User.find_by_credentials(user_params[:user_name], user_params[:password])
        if @user
            login!(@user)
        else
            flash[:alert] = 'Invalid credentials'
            redirect_to new_session_url
        end

    end

    def destroy
        logout!
        redirect_to new_session_url
    end

    def destroy_remote
        session = Session.find(params[:session_id])
        if session.user == current_user
            session.destroy
            if current_user
                redirect_to user_url(current_user)
            else
                redirect_to new_session_url
            end
        end
    end


    private
    def user_params
        params.require(:user).permit(:user_name, :password)
    end
end
