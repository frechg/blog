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
      @frames_attributes << [captured_at: capture_date(i), images: i]
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

  def capture_date(image)
    metadata = Exiftool.new(image.path).to_hash

    if metadata.include?(:sub_sec_date_time_original)
      date = metadata[:sub_sec_date_time_original].to_s
      capture_date = Time.parse(date)
    elsif metadata.include?(:create_date)
      date = metadata[:create_date].to_s
      capture_date = Time.strptime(date, "%Y:%m:%d %H:%M:%S")
    elsif metadata.include?(:file_modify_date)
      date = metadate[:file_modify_date].to_s
      capture_date = Time.parse(date)
    else
      capture_date = Time.now
    end

    return capture_date
  end

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
