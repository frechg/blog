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
    @frames_attributes = []

    # Build attributes for frames from posted images
    image_params.each do |i|
      taken_date = Exiftool.new(i.to_path).to_hash[:date_time_original]
      puts "Originally taken on: " + taken_date.to_s
      @frames_attributes << [images: i]
    end

    # Create frames on parent article from attributes
    if @article.frames.create(@frames_attributes)
      redirect_to @article
    else
      flash.now.alert = "Images not added."
      render :bulk_new, status: :unprocessable_entity
    end
  end

  private

  def image_params
    images = params[:media][:images]

    if images.first == ""
      images.shift
    end

    return images
  end

  def frame_params
    params.require(:frame).permit(:caption, images:[])
  end
end
