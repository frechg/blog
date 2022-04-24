class UsersController < Clearance::UsersController
  include InviteHelper

  def new
    @user = user_from_params
    @invite_token = params[:invite_token]
    render template: "users/new"
  end

  def create
    @user = user_from_params

    if @user.save
      sign_in @user

      if valid_invite?
        @invite = valid_invite?
        @invite.accept(@user)
        redirect_to @invite.article
      else
        redirect_back_or url_after_create
      end
    else
      render template: "users/new"
    end
  end

  def show
    @user = current_user
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
