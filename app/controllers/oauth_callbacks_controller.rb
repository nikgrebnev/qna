class OauthCallbacksController < Devise::OmniauthCallbacksController

  def github
    #render json: request.env['omniauth.auth']
    generic_callback('GitHub')
  end

  def vkontakte
    #render json: request.env['omniauth.auth']
    generic_callback('Vkontakte')
  end

  def google_oauth2
    #render json: request.env['omniauth.auth']
    generic_callback('Google')
  end

  def facebook
    #render json: request.env['omniauth.auth']
    generic_callback('Facebook')
  end

  def generic_callback( provider )
    @user = User.find_for_oauth(request.env['omniauth.auth'])
    if @user&.persisted?
      sign_in_and_redirect @user, event: :authentication
      set_flash_message(:notice, :success, kind: provider) if is_navigational_format?
    else
      redirect_to root_path, alert: 'Something wrong'
    end
  end
end