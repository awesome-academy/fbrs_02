class BooksController < ApplicationController
  before_action :logged_in_user, except: %i(index show filter search_like search)
  before_action :load_book, :build_like, except: %i(index filter create search search_like)
  before_action :admin_user, except: %i(index show filter search_like)
  before_action :load_book_by_category, only: %i(show filter)

  def index
    @books = Book.newest
    @book_news = Book.newest.paginate page: params[:page],
      per_page: Settings.controllers.book.index_page
  end

  def show
    return unless @book.reviews
    @book.rate_points = @book.reviews.average(:rate)
  end

  def filter; end

  def search_like
    @like_book_ids = current_user.likes.pluck(:book_id)
    @search_like = Book.by_like_book(@like_book_ids)
  end

  def search
    @books = Book.by_author_title(params[:search])
  end

  private

  def book_params
    params.require(:book).permit :title, :content, :description, :author,
      :publisher, :rate_points, :number_pages, :category_id, :book_img
  end

  def build_like
    @like = @book.likes.new
  end

  def load_book
    @book = Book.find_by id: params[:id]
    return if @book
    flash[:danger] = t "controller.no_data_book"
    redirect_to books_path
  end

  def logged_in_user
    return if logged_in?
    store_location
    flash[:danger] = t "please_login"
    redirect_to login_path
  end

  def admin_user
    redirect_to(root_url) unless current_user.admin?
  end

  def load_book_by_category
    @books = Book.by_category(params[:category]).limit Settings.models.limit
  end
end
