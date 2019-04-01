module BooksHelper
  def load_categories_for_selectbox
    @categories = Category.sort_by_name.map{|c| [c.name, c.id]}
  end

  def load_categories
    Category.sort_by_name
  end

  def count_book
    Book.count
  end

  def count_user
    User.count
  end

  def count_like
    Like.count
  end
end
