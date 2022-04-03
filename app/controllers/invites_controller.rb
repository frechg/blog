class InvitesController < ApplicationController
  def new
    @article = Article.find(params[:article_id])
  end

  def create
    @article = Article.find(params[:article_id])
    @invite = @article.invites.new
    @invite.user = current_user

    if @invite.save
      redirect_to article_invite_path(@article, @invite)
    else
      flash.now[:error] = "Could not create invite link."
      redirect_to @article
    end
  end

  def show
    @article = Article.find(params[:article_id])
    @invite = Invite.find(params[:id])
  end
end
