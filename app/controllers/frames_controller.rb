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
      flash.now.alert = "Images not added."
      render :new, status: :unprocessable_entity
    end
  end

  def bulk_new
    @article = Article.find(params[:article_id])
  end

  def bulk_create
    @article = Article.find(params[:article_id])
    @images = params[:media][:images].shift
    @frames_attributes = []

    # Build attributes for frame creation
    @images.each do |i|
      @frames_attributes << [display_type: "image", images: i]
    end

    if @atticle.update(@frames_attributes)
      redirect_to @article
    else
      flash.now.alert = "Images not added."
      render :bulk_new, status: :unprocessable_entity
    end
  end

  private

  def image_params
    params.require(:media).permit(images: [])
  end

  def frame_params
    params.require(:frame).permit(:display_type, :caption, images:[])
  end
end
