require 'useragent'
class ApplicationController < ActionController::Base
    helper_method :current_user, :logged_in?
end

# Metodo para iniciar sesion
def login!(user)
    session_token = @user.reset_session_token!
    device = device_info
    Session.create(user_id: @user.id, session_token: session_token, device: device)
    session[:session_token] = session_token
    redirect_to user_url(@user)
end

# Metodo para cerrar sesion
def logout!
    if current_user
        Session.find_by(user_id: current_user.id, session_token: session[:session_token]).destroy
    end
end

# Metodo para obtener el usuario actual de la sesion
def current_user
    return nil unless session[:session_token]
    @current_user ||= Session.find_by(session_token: session[:session_token]).try(:user)
end

def logged_in?
    redirect_to new_session_url if current_user
end

def logged?
    redirect_to new_session_url unless current_user
end

# Metodo para establecer el usuario actual como variable de instancia
def set_current_user
    @current_user = current_user
end

# Metodo para obtener la informacion del dispositivo
def device_info
    user_agent = UserAgent.parse(request.env["HTTP_USER_AGENT"])
    @device_info = user_agent.platform  + " - " + user_agent.browser
end