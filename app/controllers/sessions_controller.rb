class SessionsController < Clearance::SessionsController
  def new
    @invite_token = params[:invite_token]
    render template: "sessions/new"
  end

  def create
    @user = authenticate(params)
    @invite = Invite.find_by(token: params[:invite_token]) unless !params[:invite_token]

    sign_in(@user) do |status|
      if status.success?
        if @invite && @invite.accept(@user)
          redirect_to @invite.article
        else
          redirect_back_or url_after_create
        end
      else
        flash.now.alert = status.failure_message
        render template: "sessions/new", status: :unauthorized
      end
    end
  end
end
