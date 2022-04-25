class ArticlesController < ApplicationController
  before_action only: [:edit, :update, :destroy] do
    require_ownership(params[:id])
  end

  skip_before_action :require_login, only: [:show]

  def index
    @articles = current_user.articles.order(created_at: :desc).first(5)
  end

  def show
    @article = Article.find(params[:id])
    @frames = @article.frames.order(captured_at: :asc)

    render layout: "article"
  end

  def new
    @article = Article.new
    @article.frames.new
  end

  def create
    @article = Article.new(article_params)
    @article.users<< current_user

    if @article.save
        redirect_to @article
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @article = Article.find(params[:id])

    render layout: "article"
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
    params.require(:article)
      .permit(:title, :summary, :status,
              frames_attributes: [:id, :caption, :_destroy, images: []])
  end
end
