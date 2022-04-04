class UsersController < Clearance::UsersController

  def new
    @user = user_from_params
    @invite_token = params[:invite_token]
    render template: "users/new"
  end

  def create
    @user = user_from_params
    @invite = Invite.find_by(token: params[:invite_token]) unless !params[:invite_token]

    if @user.save
      sign_in @user

      if @invite && @invite.accept(@user)
        redirect_to @invite.article
      else
        redirect_back_or url_after_create
      end
    else
      render template: "users/new"
    end
  end

  private

  def user_from_params
    email = user_params.delete(:email)
    password = user_params.delete(:password)
    user_name = user_params.delete(:user_name)

    Clearance.configuration.user_model.new(user_params).tap do |user|
      user.email = email
      user.password = password
      user.user_name = user_name end
  end
end
