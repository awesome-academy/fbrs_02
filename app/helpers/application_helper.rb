module ApplicationHelper
  def full_title page_title
    base_title = I18n.t("title")
    if page_title.blank?
      base_title
    else
      page_title + " | " + base_title
    end
  end

  def select_roles
    User.roles.keys.map {|role| [role.titleize, role]}
  end

  def not_set_user_himself user
    current_user.admin? && user.id == current_user.id
  end
end
