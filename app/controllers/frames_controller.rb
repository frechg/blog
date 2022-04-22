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
    frame_date = Time.new
    image_blobs = []

    frame_params[:images].each do |i|
      unless i == ""
        # Create and modifiy a new image from the UploadedFile
        processed = process_image(i.path)

        # Create a new blob from the image
        blob = ActiveStorage::Blob.create_and_upload!(
          io: processed.tempfile.open,
          filename: i.original_filename.sub(/\.[^.]+\z/, ".#{processed.type}")
        )

        # Add the new blob to array for assignment
        image_blobs << blob

        # Find oldest date to set as frame date
        i_date = capture_date(i.path)
        frame_date = i_date if frame_date > i_date
      end
    end

    @frame = @article.frames.create(
      caption: frame_params[:caption],
      captured_at: frame_date,
      images: image_blobs
    )

    if @frame.save
      redirect_to @article
    else
      image_blobs.each { |blob| blob.destroy }
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
    image_uploads = image_params

    unless image_uploads.empty?
      attributes = []

      image_uploads.each do |i|
        # Create and modify a new image from the uploaded file
        processed = process_image(i.path)

        # Create a new blob from the image
        blob = ActiveStorage::Blob.create_and_upload!(
          io: processed.tempfile.open,
          filename: i.original_filename.sub(/\.[^.]+\z/, ".#{processed.type}")
        )

        attributes << [captured_at: capture_date(i.path), images: blob]
      end

      return attributes
    end
  end

  def process_image(img_path)
    processed = MiniMagick::Image.open(img_path)
    processed.resize("1200x")
    processed.format("jpeg")

    return processed
  end

  def capture_date(img_path)
    metadata = Exiftool.new(img_path).to_hash

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
