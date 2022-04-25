namespace :article do
  task :sort_frames, [:article_id] => [:environment] do |task, args|
    article = Article.find(args.article_id)
    article.frames.each do |frame|
      image = frame.images.first
      date = image.blob.open { |f| MiniMagick::Image.open(f.path).exif["DateTimeOriginal"] }
      date = Time.strptime(date, "%Y:%m:%d %H:%M:%S")

      frame.captured_at = date

      if frame.save!
        puts "Frames sorted for article: " + article.title
      else
        puts "Frame sort failed."
      end
    end
  end
end
