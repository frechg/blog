class FramesController < ApplicationController

  def create
    @article = Article.find(params[:article_id])
    @frame = @article.frames.create(frame_params)
    redirect_to edit_article_path(@article)
  end

  def update
    @article = Article.find(params[:article_id])
    @frame = Frame.find(params[:id])
    @frame.update(frame_params)
    redirect_to edit_article_path(@article)
  end

  def destroy
    @article = Article.find(params[:article_id])
    @frame = Frame.find(params[:id])
    @frame.destroy

    redirect_to edit_article_path(@article)
  end

  private

  def frame_params
    params.require(:frame).permit(:display_type, :caption, images: [])
  end
end
