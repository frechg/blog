class FramesController < ApplicationController
  before_action  only: [:new, :create, :bulk_new, :bulk_create] do
    require_ownership(params[:article_id])
  end

  def new
    @article = Article.find(params[:article_id])
    @frame = @article.frames.new
  end

  def create
    @article = Article.find(params[:article_id])
    @frame = @article.frames.create(frame_params)

    images = params[:frame][:images]

    if images.first == ""
      images.shift
    end

    unless images.empty?
      oldest_date = Time.new

      images.each do |i|
        date = capture_date(i)
        if oldest_date > date
          oldest_date = date
        end
      end

      @frame.captured_at = oldest_date
    end

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
    @article.frames.create!(frames_attributes)
    redirect_to @article

  rescue ActiveRecord::RecordInvalid => invalid
    flash.now.alert = invalid.record.errors.full_messages.join(" ")
    render :bulk_new, status: :unprocessable_entity
  end

  private

  def frames_attributes
    images = image_params

    unless images.empty?
      attributes = []

      images.each do |i|
        scale_down(i)
        attributes << [captured_at: capture_date(i), images: i]
      end

      return attributes
    end
  end

  def scale_down(i)
    path = i.path

    ImageProcessing::MiniMagick.source(path)
      .resize_to_limit(1200,nil)
      .call(destination: path)
  end

  def capture_date(image)
    metadata = Exiftool.new(image.path).to_hash

    if metadata.include?(:sub_sec_date_time_original)
      date = metadata[:sub_sec_date_time_original].to_s
      capture_date = Time.parse(date)
    elsif metadata.include?(:create_date)
      date = metadata[:create_date].to_s
      capture_date = Time.strptime(date, "%Y:%m:%d %H:%M:%S")
    elsif metadata.include?(:file_modify_date)
      date = metadata[:file_modify_date].to_s
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
