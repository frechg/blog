class ArticlesController < ApplicationController
  def index
    @articles = current_user.articles.order(created_at: :desc).first(5)
  end

  def show
    @article = Article.find(params[:id])
  end

  def new
    @article = Article.new
    @frame = Frame.new
  end

  def create
    @article = Article.new(article_params)
    @article.user = current_user
    @frame = Frame.new(frame_params)
    puts "Frame has images? #{@frame.images.first}"

    if @article.save
      @frame.article = @article

      if @frame.save
        redirect_to @article
      else
        @article.destroy
        render :new, status: :unprocessable_entity
      end
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @article = Article.find(params[:id])
  end

  def update
    @article = Article.find(params[:id])

    if @article.update(article_params)
      redirect_to @article
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @article = Article.find(params[:id])
    @article.destroy

    redirect_to root_path, status: :see_other
  end

  private

  def article_params
    params.require(:article).permit(:title, :body, :status)
  end

  def frame_params
    params.require(:frame).permit(:display_type, :caption, images: [])
  end
end
