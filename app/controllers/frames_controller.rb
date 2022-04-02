class FramesController < ApplicationController

  def new
    @article = Article.find(params[:article_id])
    @frame = @article.frames.new
  end

  def create
    @article = Article.find(params[:article_id])
    @frame = @article.frames.create(frame_params)

    if @frame.save
      redirect_to @article
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def frame_params
    params.require(:frame).permit(:display_type, :caption, images: [])
  end
end
