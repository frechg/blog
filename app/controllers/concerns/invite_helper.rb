module InviteHelper
  def valid_invite?
    if params[:invite_token]
      @invite = Invite.find_by(token: params[:invite_token])
      if @invite && !@invite.expired?
        return @invite
      else
        return false
      end
    else
      return false
    end
  end
end
